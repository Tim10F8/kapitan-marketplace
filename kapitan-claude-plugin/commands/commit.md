---
description: Create well-formatted commits following Conventional Commits 1.0.0
---

# Commit Command

This command helps you create well-formatted commits following the Conventional Commits 1.0.0 specification.

## Usage

To create a commit, type:
```
/commit
```

Or with options:
```
/commit --no-verify
```

## What This Command Does

1. Unless specified with `--no-verify`, automatically runs pre-commit checks:
   - `pnpm lint` to ensure code quality
   - `pnpm build` to verify the build succeeds
   - `pnpm generate:docs` to update documentation (if applicable)
2. Checks which files are staged with `git status`
3. If no files are staged, automatically adds all modified and new files with `git add .`
4. Performs a `git diff --staged` to understand what changes are being committed
5. Analyzes the diff to determine if multiple distinct logical changes are present
6. If multiple distinct changes are detected, suggests breaking the commit into multiple smaller commits
7. For each commit, creates a commit message following the Conventional Commits 1.0.0 specification

## CRITICAL CONSTRAINT

**DO NOT add any Claude co-authorship footer to commits.** The commit message must contain only the conventional commit format without any AI attribution, co-authored-by lines, or similar footers indicating AI assistance.

## Conventional Commits 1.0.0 Specification

The commit message MUST be structured as follows:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Structural Elements

1. **type** (REQUIRED): A noun describing the category of change
2. **scope** (OPTIONAL): A noun in parentheses describing the section of the codebase affected
3. **description** (REQUIRED): A short summary of the code changes
4. **body** (OPTIONAL): Free-form text providing additional context
5. **footer(s)** (OPTIONAL): One or more footers following git trailer format

### Allowed Types

The following types are permitted:

| Type | Description |
|------|-------------|
| `feat` | A new feature (correlates with MINOR in SemVer) |
| `fix` | A bug fix (correlates with PATCH in SemVer) |
| `docs` | Documentation only changes |
| `style` | Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc) |
| `refactor` | A code change that neither fixes a bug nor adds a feature |
| `perf` | A code change that improves performance |
| `test` | Adding missing tests or correcting existing tests |
| `build` | Changes that affect the build system or external dependencies |
| `ci` | Changes to CI configuration files and scripts |
| `chore` | Other changes that don't modify src or test files |
| `revert` | Reverts a previous commit |

### Breaking Changes

Breaking changes MUST be indicated in one of two ways:

1. Add an exclamation mark immediately before the colon in the type/scope prefix:
   ```
   feat!: send an email to the customer when a product is shipped
   ```
   ```
   feat(api)!: send an email to the customer when a product is shipped
   ```

2. Include `BREAKING CHANGE:` in the footer:
   ```
   feat: allow provided config object to extend other configs

   BREAKING CHANGE: `extends` key in config file is now used for extending other config files
   ```

### Commit Message Rules

1. **Description**:
   - Use the imperative, present tense: "add" not "added" nor "adds"
   - Do not capitalize the first letter
   - No period (.) at the end
   - Keep under 72 characters

2. **Body**:
   - Separate from description with a blank line
   - Use to explain what and why vs. how
   - Wrap at 72 characters

3. **Footer**:
   - Separate from body with a blank line
   - Each footer consists of a word token, followed by `:<space>` or `<space>#` separator, followed by a string value
   - Use `-` in place of spaces in footer tokens (e.g., `Reviewed-by`)
   - Exception: `BREAKING CHANGE` may be used as a token (with space)

## Examples of Good Commit Messages

### Simple feature
```
feat: add user authentication endpoint
```

### Feature with scope
```
feat(auth): implement JWT token refresh mechanism
```

### Bug fix with body
```
fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.
```

### Breaking change with footer
```
feat: allow provided config object to extend other configs

BREAKING CHANGE: `extends` key in config file is now used for
extending other config files
```

### Breaking change with `!`
```
refactor!: drop support for Node 6
```

### Commit with multiple footers
```
fix: resolve memory leak in event handler

The event listener was not being properly removed on component
unmount, causing memory to accumulate over time.

Fixes #123
Reviewed-by: Jane Doe
```

### Documentation change
```
docs: update API documentation with new endpoints
```

### Refactoring
```
refactor(parser): simplify error handling logic
```

### Performance improvement
```
perf: improve database query performance by adding index
```

### Test addition
```
test: add unit tests for user service
```

### Build/dependency change
```
build: upgrade webpack to version 5
```

### CI change
```
ci: add automated release workflow
```

### Chore
```
chore: update .gitignore to exclude build artifacts
```

### Revert
```
revert: feat: add user authentication endpoint

This reverts commit abc1234.
```

## Guidelines for Splitting Commits

When analyzing the diff, consider splitting commits based on these criteria:

1. **Different concerns**: Changes to unrelated parts of the codebase
2. **Different types of changes**: Mixing features, fixes, refactoring, etc.
3. **File patterns**: Changes to different types of files (e.g., source code vs documentation)
4. **Logical grouping**: Changes that would be easier to understand or review separately
5. **Size**: Very large changes that would be clearer if broken down

### Example of Split Commits

If a single diff contains:
- New type definitions
- Updated documentation
- Dependency updates
- New tests

Suggest splitting into:
```
feat(types): add new API type definitions

docs: update API documentation for new endpoints

chore(deps): update package dependencies

test: add unit tests for new API endpoints
```

## Command Options

- `--no-verify`: Skip running the pre-commit checks (lint, build, generate:docs)

## Workflow

1. **Check for staged files**
   ```bash
   git status --porcelain
   ```

2. **If no files staged, stage all changes**
   ```bash
   git add .
   ```

3. **Get the diff for analysis**
   ```bash
   git diff --staged
   ```

4. **Analyze the diff**:
   - Identify what files changed
   - Understand the nature of changes
   - Determine appropriate type(s)
   - Identify appropriate scope(s)
   - Check for breaking changes

5. **If multiple logical changes detected**:
   - Unstage all files: `git reset HEAD`
   - Stage files for first logical commit: `git add <files>`
   - Create first commit
   - Repeat for remaining changes

6. **Create the commit**
   ```bash
   git commit -m "<type>[optional scope]: <description>"
   ```

   Or for commits with body/footer:
   ```bash
   git commit -m "<type>[optional scope]: <description>" -m "<body>" -m "<footer>"
   ```

## Important Notes

- By default, pre-commit checks will run to ensure code quality
- If these checks fail, ask if the user wants to proceed anyway or fix issues first

### Handling Pre-commit Hooks During Merge Commits

**Problem**: When resolving merge conflicts, pre-commit hooks may fail and modify files repeatedly. Each retry may cause:

1. Linting tools (e.g., ruff) to fail and modify files
2. Formatters to modify files
3. Exit with error, requiring re-staging

If you use a separate commit tool or `git commit -m "..."` after hooks finally pass, you may create a **regular commit instead of a merge commit**.

**Why This Matters**: A proper merge commit has two parents:

```
parent 1: abc1234  (your branch's previous HEAD)
parent 2: def5678  (origin/dev - the branch being merged)
```

A broken commit will only have one parent:

```
parent 1: abc1234  (your branch's previous HEAD)
parent 2: ❌ missing!
```

Without the second parent, Git doesn't know that the source branch was merged. The remote (e.g., GitLab/GitHub) will see those commits as still "missing" from your branch.

**The Fix**: The `.git/MERGE_HEAD` file persists during an in-progress merge (pointing to the branch being merged). Running `git commit --no-edit` properly concludes the merge with both parents recorded.

**Best Practice**: When pre-commit hooks fail during a merge:

1. Fix the lint/format issues
2. Stage the files with `git add`
3. Run `git commit --no-edit` to let Git conclude the merge naturally with proper parent tracking

**Do NOT** use `git commit -m "..."` or external commit tools during an active merge - this may lose the merge parent reference
- If specific files are already staged, only commit those files
- If no files are staged, automatically stage all modified and new files
- Always review the diff to ensure the message accurately describes the changes
- Before committing, review the diff to identify if multiple commits would be more appropriate
- If suggesting multiple commits, help stage and commit the changes separately
- **NEVER add Claude co-authorship or AI attribution footers to any commit**

## What NOT to Include

The following should NEVER appear in commit messages:

- Emojis
- `Co-authored-by: Claude` or any AI attribution
- `Generated by AI` or similar disclaimers
- Any footer indicating AI assistance
- Periods at the end of the description line
- Capitalized first letter in description
- Past tense verbs in description

## Validation Checklist

Before creating each commit, verify:

- [ ] Type is one of the allowed types
- [ ] Description uses imperative, present tense
- [ ] Description starts with lowercase letter
- [ ] Description has no trailing period
- [ ] Description is under 72 characters
- [ ] Body (if present) is separated by blank line
- [ ] Footer (if present) is separated by blank line
- [ ] Breaking changes are properly indicated
- [ ] No emojis anywhere in the message
- [ ] No AI attribution or co-authorship footer
