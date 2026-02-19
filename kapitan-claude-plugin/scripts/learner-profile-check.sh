#!/bin/bash
# Stop command hook: Verify learner profile and ledger were written during
# leetcode-teacher sessions. Exit 2 to block stop if write-back is missing.
#
# Transcript JSONL schema (for grep patterns):
# Each line is one JSON object with top-level "type": "user"|"assistant"|"summary"
# Assistant tool use appears in message.content[] as:
#   {"type":"tool_use","name":"Write","input":{"file_path":"...","content":"..."}}
#   {"type":"tool_use","name":"Edit","input":{"file_path":"...","old_string":"...","new_string":"..."}}
#   {"type":"tool_use","name":"MultiEdit","input":{"file_path":"...",...}}
# Tool names for file writes: "Write", "Edit", "MultiEdit"
# A Read of the same file has "name":"Read" and will NOT be matched.
# Since each JSONL entry is a single line, tool name and file_path co-occur on the same line.

INPUT=$(cat)

# Guard against infinite loops
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false' 2>/dev/null)
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)
if [ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ]; then
  exit 0
fi

# Detect actual teaching — reference file reads only happen during active teaching,
# not from the SessionStart hook passively loading the profile into context.
REFS_READ=$(grep -E '"name"\s*:\s*"Read"' "$TRANSCRIPT" 2>/dev/null \
  | grep -c 'leetcode-teacher/references/' 2>/dev/null)
if [ "${REFS_READ:-0}" -eq 0 ]; then
  exit 0
fi

# Teaching requires multi-turn Socratic Q&A before reaching Step 8B/R7B.
# A session with fewer than 3 user messages hasn't progressed far enough.
USER_TURNS=$(grep -c '"type"\s*:\s*"user"' "$TRANSCRIPT" 2>/dev/null)
USER_TURNS=${USER_TURNS:-0}
if [ "$USER_TURNS" -lt 3 ]; then
  exit 0
fi

# Check both files were actually written (not just read/mentioned)
# Two-stage pipe: filter to write operations, then check for target file
PROFILE_WRITTEN=$(grep -E '"name"\s*:\s*"(Write|Edit|MultiEdit)"' "$TRANSCRIPT" 2>/dev/null | grep -c 'leetcode-teacher-profile' 2>/dev/null)
PROFILE_WRITTEN=${PROFILE_WRITTEN:-0}
LEDGER_WRITTEN=$(grep -E '"name"\s*:\s*"(Write|Edit|MultiEdit)"' "$TRANSCRIPT" 2>/dev/null | grep -c 'leetcode-teacher-ledger' 2>/dev/null)
LEDGER_WRITTEN=${LEDGER_WRITTEN:-0}

if [ "$PROFILE_WRITTEN" -gt 0 ] && [ "$LEDGER_WRITTEN" -gt 0 ]; then
  exit 0
elif [ "$PROFILE_WRITTEN" -gt 0 ]; then
  echo "Profile was updated but ledger was not. Append the missing ledger row for this session." >&2
  exit 2
elif [ "$LEDGER_WRITTEN" -gt 0 ]; then
  echo "Ledger was updated but profile was not. Update the profile session history and known weaknesses." >&2
  exit 2
else
  echo "This leetcode-teacher session ended without updating the learner profile or ledger. Complete Step 8B/R7B: write the ledger row first (source of truth), then update the profile. Both files at ~/.claude/." >&2
  exit 2
fi
