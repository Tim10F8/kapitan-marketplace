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
git submodule add https://github.com/luqman-haqeem/kapitan-marketplace.git .claude-plugins/kapitan

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
│   │   └── plugin.json          # Plugin metadata
│   ├── commands/
│   │   ├── commit.md            # /commit command
│   │   └── status.md            # /status command
│   ├── agents/
│   │   └── code-reviewer.md     # Code review agent
│   ├── skills/
│   │   ├── mlx-dev/             # MLX development skill
│   │   └── example-skill/       # Template skill
│   ├── hooks/
│   │   └── hooks.json           # Git hooks configuration
│   ├── scripts/
│   │   └── python-lint.sh       # Linting script
│   └── .mcp.json                # Default MCP configuration
└── templates/
    ├── mcp-minimal.json         # Minimal MCP config
    ├── mcp-all.json             # All servers enabled
    └── mcp-web.json             # Web development config
```

## License

MIT
