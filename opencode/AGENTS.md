# OpenCode CLI Agent Instructions

> This file is loaded by **opencode** (not Claude Code).
> The active CLI tool is opencode — do not assume Claude Code conventions,
> paths, or behaviors.

# Path Compatibility: ~/.config/Claude → ~/.config/opencode

Anthropic's API injects a server-side Claude Code system prompt that
references `~/.config/Claude/` paths. These paths don't exist — our
files live under `~/.config/opencode/`. A symlink bridges the gap:

```bash
# If ~/.config/Claude does not exist, create the symlink:
# ln -s ~/.config/opencode ~/.config/Claude
```

**Why this matters**: subagents (e.g., ContextScout) receive the
Anthropic-injected paths and fail to resolve context files without it.
This is NOT an OpenCode bug — it's Anthropic's server-side injection
using hardcoded Claude Code paths.

**Verify**: `ls -la ~/.config/Claude` should show `-> ~/.config/opencode`

# Code Intelligence

Prefer LSP over Grep/Glob/Read for code navigation:
- `goToDefinition` / `goToImplementation` to jump to source
- `findReferences` to see all usages across the codebase
- `workspaceSymbol` to find where something is defined
- `documentSymbol` to list all symbols in a file
- `hover` for type info without reading the file
- `incomingCalls` / `outgoingCalls` for call hierarchy

Before renaming or changing a function signature, use
`findReferences` to find all call sites first.

Use Grep/Glob only for text/pattern searches (comments,
strings, config values) where LSP doesn't help.

After writing or editing code, check LSP diagnostics before
moving on. Fix any type errors or missing imports immediately.

# Context Mode (Token-Efficient Output Processing)

Always prefer context-mode MCP tools (`ctx_execute`, `ctx_batch_execute`,
`ctx_execute_file`) over raw Bash when the command output is likely to be
large or you only need to extract specific information from it.

These rules are NOT optional — they protect your context window from
flooding. A single unrouted command can dump 56 KB into context and
waste the entire session.

## Blocked commands — do NOT attempt these

### curl / wget — BLOCKED
Any shell command containing `curl` or `wget` will be intercepted and
blocked by the context-mode plugin. Do NOT retry.
Instead use:
- `context-mode_ctx_fetch_and_index(url, source)` to fetch and index web pages
- `context-mode_ctx_execute(language: "javascript", code: "const r = await fetch(...)")` to run HTTP calls in sandbox

### Inline HTTP — BLOCKED
Any shell command containing `fetch('http`, `requests.get(`, `requests.post(`,
`http.get(`, or `http.request(` will be intercepted and blocked. Do NOT retry with shell.
Instead use:
- `context-mode_ctx_execute(language, code)` to run HTTP calls in sandbox — only stdout enters context

### Direct web fetching — BLOCKED
Do NOT use any direct URL fetching tool. Use the sandbox equivalent.
Instead use:
- `context-mode_ctx_fetch_and_index(url, source)` then `context-mode_ctx_search(queries)` to query the indexed content

## Redirected tools — use sandbox equivalents

### Shell (>20 lines output)
Shell is ONLY for: `git`, `mkdir`, `rm`, `mv`, `cd`, `ls`, `npm install`,
`pip install`, and other short-output commands.
For everything else, use:
- `context-mode_ctx_batch_execute(commands, queries)` — run multiple commands + search in ONE call
- `context-mode_ctx_execute(language: "shell", code: "...")` — run in sandbox, only stdout enters context

### File reading (for analysis)
If you are reading a file to **edit** it → reading is correct (edit needs content in context).
If you are reading to **analyze, explore, or summarize** → use
`context-mode_ctx_execute_file(path, language, code)` instead.
Only your printed summary enters context.

### grep / search (large results)
Search results can flood context. Use
`context-mode_ctx_execute(language: "shell", code: "grep ...")`
to run searches in sandbox. Only your printed summary enters context.

## Tool selection hierarchy

1. **GATHER**: `ctx_batch_execute(commands, queries)` — Primary tool. Runs all commands, auto-indexes output, returns search results. ONE call replaces 30+ individual calls.
2. **FOLLOW-UP**: `ctx_search(queries: ["q1", "q2", ...])` — Query indexed content. Pass ALL questions as array in ONE call.
3. **PROCESSING**: `ctx_execute(language, code)` | `ctx_execute_file(path, language, code)` — Sandbox execution. Only stdout enters context.
4. **WEB**: `ctx_fetch_and_index(url, source)` then `ctx_search(queries)` — Fetch, chunk, index, query. Raw HTML never enters context.
5. **INDEX**: `ctx_index(content, source)` — Store content in FTS5 knowledge base for later search.

## When to use context-mode

- **Build / compile output** — use `ctx_execute` with an `intent` like
  "compilation errors warnings build success" so only the relevant
  sections enter context.
- **Serial monitor / debug logs** — log sessions can be very large;
  use `ctx_execute` or `ctx_execute_file` with a targeted `intent`
  to surface only errors, warnings, or specific log tags.
- **Test runner output** — same pattern: run tests via `ctx_execute`,
  search for failures.
- **Git log / diff** — when reviewing long histories or large diffs,
  `ctx_batch_execute` with queries keeps context small.
- **Any CLI command whose output may exceed ~20 lines** — prefer
  `ctx_execute` over Bash to avoid flooding context with raw text.

## How to use effectively

1. **Always set `intent`** — a short phrase describing what you care
   about (e.g., "failing tests", "error warning", "motor ramp log").
   This triggers BM25 indexing so you can search later without
   re-running the command.
2. **Use `ctx_batch_execute`** when you need to run multiple commands
   and search across all their output in one round trip.
3. **Use `ctx_execute_file`** for reading large log files, CSV, JSON,
   or data files — the file content stays in the sandbox and only
   your printed summary enters context.
4. **Use `ctx_search`** after indexing to drill into specific sections
   without re-running commands.

## When Bash is still appropriate

- Short, deterministic commands (e.g., `mkdir`, `git add`, `git commit`)
- File mutations that need real shell execution
- Interactive or stateful shell operations
- Commands whose full output is needed in context (< 20 lines)

## Common patterns

```
# Build check — index output, then search for errors
ctx_execute(language="shell", code="pio run 2>&1",
            intent="compilation errors warnings build success")
ctx_search(queries=["error warning", "SUCCESS FAILED"])

# Serial log capture — run with timeout, search for tags
ctx_execute(language="shell", code="timeout 10 pio device monitor 2>&1",
            intent="motor ramp brownout error crash")

# Multi-command + search in one shot
ctx_batch_execute(
  commands=[
    {label: "Build", command: "pio run 2>&1"},
    {label: "Git status", command: "git status"},
    {label: "Git diff", command: "git diff --stat"}
  ],
  queries=["build error warning", "modified files", "SUCCESS FAILED"]
)

# Large file analysis — file stays in sandbox
ctx_execute_file(path="debug.log", language="python",
  code='lines = FILE_CONTENT.split("\\n")\nfor l in lines:\n  if "error" in l.lower() or "ramp" in l.lower(): print(l)',
  intent="error ramp motor")
```

## Output constraints

- Keep responses under 500 words.
- Write artifacts (code, configs, PRDs) to FILES — never return them
  as inline text. Return only: file path + 1-line description.
- When indexing content, use descriptive source labels so others can
  `search(source: "label")` later.

## ctx commands

| Command | Action |
|---------|--------|
| `ctx stats` | Call the `stats` MCP tool and display the full output verbatim |
| `ctx doctor` | Call the `doctor` MCP tool, run the returned shell command, display as checklist |
| `ctx upgrade` | Call the `upgrade` MCP tool, run the returned shell command, display as checklist |

# Subagent Delegation

Use the Task tool to delegate work to specialized subagents.
Pick the right agent for the job.

## Primary Agents (Core)

These are the two main orchestration agents. They handle
most tasks directly or delegate to subagents as needed.

| Agent | Role | Use when |
|-------|------|----------|
| `OpenAgent` | Universal orchestrator | General tasks, questions, workflow coordination, any domain |
| `OpenCoder` | Coding orchestrator | Complex coding, architecture, multi-file refactoring |

**OpenAgent** follows: Analyze → Discover (ContextScout) → Approve → Execute → Validate → Summarize.
Uses ContextScout proactively to discover project context before any work.

**OpenCoder** follows: Discover → Propose → Approve → Init Session → Plan (TaskManager) → Execute (parallel batches) → Validate.
Designed for multi-component features with dependency-aware parallel execution.

## Subagents

### Discovery & Context
| Agent | Use when |
|-------|----------|
| `ContextScout` | Discover internal context files before execution |
| `ExternalScout` | Fetch current docs for external libraries/frameworks |
| `ContextOrganizer` | Organize and generate context files |

### Code Execution
| Agent | Use when |
|-------|----------|
| `CoderAgent` | Execute individual coding subtasks |
| `BuildAgent` | Type checking, build validation |
| `TestEngineer` | Write tests, TDD workflow |
| `CodeReviewer` | Post-implementation review, security, edge cases |

### Planning & Documentation
| Agent | Use when |
|-------|----------|
| `TaskManager` | Break complex features into atomic subtasks with dependencies |
| `DocWriter` | Generate documentation |

### Specialists
| Agent | Use when |
|-------|----------|
| `OpenFrontendSpecialist` | Design systems, themes, animations, UI |
| `OpenDevopsSpecialist` | CI/CD, infrastructure as code, deployment |

### Built-in (always available)
| Agent | Use when |
|-------|----------|
| `explore` | Finding files, searching code, answering "where is X?" |
| `general` | Multi-step research, parallel investigation |

Project-specific specialist agents (e.g., `Embedded Firmware Engineer`)
should be defined in the project's own config, not here.

## Delegation tips

- **Gather context first, then delegate.** Use `explore` agents to
  collect relevant code before sending to a specialist. Include the
  gathered context in the specialist's prompt so it doesn't re-read
  files unnecessarily.
- **Be explicit about read-only vs. write.** Tell the agent whether
  it should analyze only or also make changes.
- **Specify the deliverable.** Tell the agent exactly what to return
  (e.g., "return the full source of function X", "return a list of
  all callers with file paths and line numbers").
- **Use `task_id` to resume.** If you need follow-up from the same
  agent, pass the previous `task_id` to continue its session.
