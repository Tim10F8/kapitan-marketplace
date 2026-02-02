# kapitan-marketplace

A Claude Code plugin marketplace providing commands, agents, skills, and MCP server configurations for enhanced development workflows.

## Features

| Feature | Description |
|---------|-------------|
| `/commit` | Create Conventional Commits 1.0.0 compliant commits with automatic diff analysis |
| `/status` | Check project status including git state, recent changes, and pending tasks |
| `code-reviewer` agent | Automated code review for quality, security, and performance |
| `mlx-dev` skill | Apple MLX development guide with critical API patterns and gotchas |
| MCP servers | Pre-configured git, context7, gitlab, and chrome-devtools integrations |

## Quick Install

Add this plugin as a git submodule to any project:

```bash
# Add plugin as submodule
git submodule add https://github.com/LuqDaMan/kapitan-marketplace.git .claude-plugins/kapitan

# Copy MCP config template to your project root
cp .claude-plugins/kapitan/templates/mcp-minimal.json .mcp.json

# (Optional) Customize .mcp.json for your project needs
```

For existing clones:

```bash
git submodule update --init --recursive
```

## Per-Project Configuration

The plugin separates **commands/skills** (always available) from **MCP servers** (project-specific). Configure MCP servers in your project's `.mcp.json`:

### Minimal Setup (Most Common)

For general development projects:

```json
{
  "mcpServers": {
    "git": {
      "command": "uvx",
      "args": ["mcp-server-git"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

### Full Stack Web Development

Add chrome-devtools for browser automation and debugging:

```json
{
  "mcpServers": {
    "git": {
      "command": "uvx",
      "args": ["mcp-server-git"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"]
    }
  }
}
```

### GitLab Projects

Add GitLab MCP server for API access:

```json
{
  "mcpServers": {
    "git": {
      "command": "uvx",
      "args": ["mcp-server-git"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "gitlab": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-gitlab"],
      "env": {
        "GITLAB_PERSONAL_ACCESS_TOKEN": "${GITLAB_PERSONAL_ACCESS_TOKEN}"
      }
    }
  }
}
```

## Config Templates

Ready-to-use templates are available in `templates/`:

| Template | Use Case |
|----------|----------|
| `mcp-minimal.json` | Git + context7 (most projects) |
| `mcp-all.json` | All MCP servers enabled |
| `mcp-web.json` | Web development with chrome-devtools |

Copy the template that matches your needs:

```bash
cp .claude-plugins/kapitan/templates/mcp-minimal.json .mcp.json
```

## Environment Variables

| Variable | Required For | Description |
|----------|--------------|-------------|
| `GITLAB_PERSONAL_ACCESS_TOKEN` | gitlab MCP | GitLab API access token |

## Feature Reference

### Commands

**`/commit`** - Create well-formatted commits following Conventional Commits 1.0.0:
- Analyzes staged changes and suggests appropriate commit type/scope
- Detects multiple logical changes and suggests splitting commits
- Supports `--no-verify` to skip pre-commit checks

**`/status`** - Check current project status:
- Git status and recent changes
- Pending tasks and issues overview

### Agents

**`code-reviewer`** - Reviews code for:
- Best practices and coding standards
- Security vulnerabilities
- Performance implications
- Refactoring opportunities

### Skills

**`mlx-dev`** - Apple MLX development expertise:
- Critical API differences from PyTorch/NumPy
- Lazy evaluation patterns with mx.eval
- Array indexing gotchas (lists must be mx.array, slices create copies)
- NHWC format for Conv2d, __call__ not forward()
- Memory optimization and quantization patterns
- Complete reference docs for common tasks

## Structure

```
kapitan-marketplace/
├── kapitan-claude-plugin/
│   ├── .claude-plugin/
│   │   └── plugin.json          # Plugin metadata (required)
│   ├── commands/                # Slash commands (.md files)
│   │   ├── commit.md
│   │   └── status.md
│   ├── agents/                  # Subagent definitions (.md files)
│   │   └── code-reviewer.md
│   ├── skills/                  # Skills (subdirectories with SKILL.md)
│   │   ├── mlx-dev/
│   │   │   ├── SKILL.md
│   │   │   ├── references/
│   │   │   └── scripts/
│   │   └── example-skill/
│   ├── hooks/
│   │   └── hooks.json           # Event handler configuration
│   ├── scripts/                 # Helper scripts
│   └── .mcp.json                # MCP server definitions
└── templates/
    ├── mcp-minimal.json
    ├── mcp-all.json
    └── mcp-web.json
```

---

## Extending the Plugin

All components are auto-discovered by Claude Code. Create files in the appropriate directories and they'll be available immediately.

### Adding a New Skill

Skills provide domain-specific knowledge and guidance. Create a subdirectory with a `SKILL.md` file:

```bash
mkdir -p kapitan-claude-plugin/skills/my-skill/{references,examples,scripts}
```

**`kapitan-claude-plugin/skills/my-skill/SKILL.md`:**

```markdown
---
name: my-skill
description: When to use this skill - Claude uses this to decide activation
version: 1.0.0
---

# My Skill

Instructions and guidance content...

## Key Concepts
...

## Examples
...
```

The `description` field is critical - Claude uses it to determine when to activate the skill contextually.

### Adding a New Command

Commands are slash commands users invoke directly. Create a `.md` file in `commands/`:

**`kapitan-claude-plugin/commands/my-command.md`:**

```markdown
---
description: Brief description shown in /help
allowed-tools: Read, Write, Bash(git:*)
argument-hint: [filename] [options]
model: sonnet
---

# My Command

Instructions for what this command does...

## Arguments
- `$1` - First argument
- `$2` - Second argument
- `$ARGUMENTS` - All arguments as string

## File References
Use @path/to/file to include file contents

## Bash Execution
Use !`command here` to execute bash inline
```

**Frontmatter options:**
| Field | Description |
|-------|-------------|
| `description` | Shown in help (required) |
| `allowed-tools` | Restrict available tools |
| `argument-hint` | Usage hint for arguments |
| `model` | Override model (sonnet, opus, haiku) |

### Adding a New Agent

Agents are specialized subagents for specific tasks. Create a `.md` file in `agents/`:

**`kapitan-claude-plugin/agents/my-agent.md`:**

```markdown
---
name: my-agent
description: Use this agent when [conditions]. Examples:

<example>
Context: User wants to refactor authentication code
user: "Can you review the auth module?"
assistant: "I'll use the code-reviewer agent to analyze..."
<commentary>
Triggered because user requested code review
</commentary>
</example>

model: inherit
color: blue
tools: ["Read", "Write", "Grep", "Glob"]
---

You are a specialized agent for [purpose]...

**Your Core Responsibilities:**
1. First responsibility
2. Second responsibility

**Analysis Process:**
Step-by-step workflow...

**Output Format:**
What to return...
```

**Frontmatter options:**
| Field | Description |
|-------|-------------|
| `name` | Agent identifier |
| `description` | When to trigger (with examples) |
| `model` | Model to use (inherit, sonnet, opus, haiku) |
| `color` | Display color |
| `tools` | Array of allowed tools |

### Adding MCP Servers

MCP servers provide external tool integrations. Add to `kapitan-claude-plugin/.mcp.json`:

```json
{
  "mcpServers": {
    "my-server": {
      "command": "npx",
      "args": ["-y", "my-mcp-server@latest"],
      "env": {
        "API_KEY": "${MY_API_KEY}"
      }
    }
  }
}
```

**Tips:**
- Use `${CLAUDE_PLUGIN_ROOT}` for paths relative to plugin directory
- Use `${ENV_VAR}` for environment variable injection
- Servers auto-start when the plugin loads

Don't forget to update `templates/mcp-all.json` and document any required environment variables.

### Adding Hooks

Hooks execute commands on Claude Code events. Edit `kapitan-claude-plugin/hooks/hooks.json`:

```json
{
  "description": "Plugin automation hooks",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Verify task completion."
          }
        ]
      }
    ]
  }
}
```

**Hook events:** `PreToolUse`, `PostToolUse`, `Stop`, `SessionStart`

**Hook types:**
- `command` - Execute a shell command
- `prompt` - Inject a prompt to Claude

---

## After Making Changes

```bash
# In the plugin directory
git add .
git commit -m "feat: add my-new-feature"
git push
```

In projects using the submodule:
```bash
git submodule update --remote
```

## License

MIT
