---
name: effort-tracking
description: Estimate development man-hours across one or more git repositories. Use when the user says a feature is done, asks to estimate effort, or wants to log man-hours for a release or date range.
version: 1.0.0
author: opencode
type: skill
category: development
tags:
  - effort
  - man-hours
  - tracking
  - estimation
  - cross-repo
---

# Effort Tracking Skill

> **Purpose**: Estimate development man-hours by scanning git history across one or more repositories, then append a structured entry to the centralized effort log.

---

## When to Use

- User says a feature is done / shipped / merged
- User asks "how many hours did X take?"
- User tags a version or merges a release branch
- User asks to estimate effort for a date range

---

## Known Repositories

These are the primary GoGoBoard repos. The user may specify others — always ask if unsure.

| Repo | Path | Language |
|---|---|---|
| gogo-firmware | `~/Developer/gogoboard-7.x/gogo-firmware` | C++ (ESP32) |
| gogo-logo-compiler | `~/Developer/gogo-logo-compiler` | Python |
| gogo-code | `~/Developer/gogo-code` | JavaScript (Vue) |

## Centralized Effort Log

Append all entries to: **`~/.config/opencode/effort-log.md`**

Detailed methodology reference: `~/Developer/gogoboard-7.x/gogo-firmware/.claude/knowledge/development-effort.md`

---

## Workflow

### Step 1: Determine Scope

Ask the user (if not already clear):
- **Which repos** are involved? (may be just one, or multiple)
- **What range?** Either:
  - Tag-based: `version-X.Y.Z..version-A.B.C` (preferred when tags exist)
  - Date-based: `--after="YYYY-MM-DD" --before="YYYY-MM-DD"`
  - Branch-based: `main..feature/foo`

### Step 2: Gather Git Metrics

For **each** involved repo, collect:

```bash
REPO="path/to/repo"

# Commits and date range
git -C "$REPO" rev-list START..END --count
git -C "$REPO" log START -1 --format='%ai'
git -C "$REPO" log END -1 --format='%ai'

# Diff stats
git -C "$REPO" diff --shortstat START..END

# Active days
git -C "$REPO" log START..END --format='%ad' --date=format:'%Y-%m-%d' | sort -u | wc -l

# Commits per day (burst pattern)
git -C "$REPO" log START..END --format='%ad' --date=format:'%Y-%m-%d' | sort | uniq -c | sort -rn

# Commit hour distribution (work pattern)
git -C "$REPO" log START..END --format='%ad' --date=format:'%H' | sort | uniq -c | sort -rn

# Authors
git -C "$REPO" shortlog -sne START..END

# Commit messages (for feature categorization)
git -C "$REPO" log START..END --format='%h|%ai|%s'

# Files by extension
git -C "$REPO" diff --name-only START..END | sed 's/.*\.//' | sort | uniq -c | sort -rn
```

For **date-based ranges** (cross-repo, no shared tags):
```bash
git -C "$REPO" log --after="YYYY-MM-DD" --before="YYYY-MM-DD" --format='%h|%ai|%s'
git -C "$REPO" log --after="YYYY-MM-DD" --before="YYYY-MM-DD" --shortstat
```

### Step 3: Estimate with Three-Method Triangulation

Use all three methods and take the consensus range:

#### Method 1: Active-Days

```
active_commit_days × avg_hours_per_day × overhead_multiplier
```

- **active_commit_days**: unique days with ≥1 commit (across all repos, deduplicated)
- **avg_hours_per_day**: estimate from commit timestamp spread per day. Typical: 4–8 hrs
- **overhead_multiplier**: accounts for non-commit work

| Domain | Overhead Multiplier | Why |
|---|---|---|
| Embedded C++ (firmware) | 1.3–1.5× | Hardware debug, oscilloscope, datasheets, serial testing |
| Python (compiler/tools) | 1.1–1.2× | REPL testing, design iteration |
| JavaScript (webapp) | 1.1–1.2× | Browser testing, CSS iteration |

#### Method 2: Feature-Weighted

Categorize each commit/feature and estimate individually:

| Complexity | Hours | Examples |
|---|---|---|
| Trivial | 1–3 | Typo fix, config change, version bump |
| Low | 3–8 | Bug fix, small UI tweak, single-file change |
| Medium | 8–20 | New opcode, sensor integration, API endpoint |
| High | 20–40 | USB stack, protocol redesign, architecture refactor |
| Very High | 40–80 | New subsystem, cross-cutting feature, platform migration |

Sum all features = total estimate.

#### Method 3: Lines-Based (sanity check only)

```
net_source_lines ÷ productivity_rate = coding_hours
coding_hours ÷ coding_fraction = total_hours
```

| Domain | Lines/hour | Coding fraction |
|---|---|---|
| Embedded C++ | 20–40 | 30–40% |
| Python | 30–60 | 40–50% |
| JavaScript/Vue | 40–80 | 40–50% |

**Use only as a sanity check** — lines-based is the least reliable method.

### Step 4: Assess AI Contribution

If AI tools were used (Claude Code, Copilot, OpenCode, etc.), estimate the split:

| Work Type | Typical AI % |
|---|---|
| Documentation / knowledge files | 80–90% |
| Refactoring (pattern-based) | 40–50% |
| Code review / cleanup | 50–60% |
| Feature implementation (guided) | 20–30% |
| Architecture / design decisions | 0–10% |
| Hardware testing / debugging | 0–5% |

Report:
- **Human hours**: time developer actually spent (directing AI, reviewing, testing, thinking)
- **AI-equivalent hours**: how much additional human time the AI saved

### Step 5: Append to Effort Log

Add entry to `~/.config/opencode/effort-log.md` using this template:

```markdown
### [Feature or Version Label]

- **Feature:** [Brief description of what was built]
- **Date range:** YYYY-MM-DD → YYYY-MM-DD (N calendar days)
- **Repos involved:** [list repos and their role]
- **Commits:** N (repo1) + N (repo2) + ...
- **Files changed:** N
- **Lines:** +N / −N (net +/−N)
- **Active days:** N
- **Estimated human hours:** N–N hrs
- **AI-assisted:** ~N% [brief description of AI role]
- **Notes:** [Key decisions, challenges, anything notable]
```

### Step 6: Report to User

Show a concise summary table with:
- Raw metrics per repo
- Triangulated estimate range
- AI contribution breakdown (if applicable)
- The entry that was appended to the log

---

## Examples

### Single Repo, Tag-Based

User: "version 3.2.1 is done, estimate the effort since 3.1.0"

```bash
git -C ~/Developer/gogoboard-7.x/gogo-firmware log version-3.1.0..version-3.2.1 --format='%h|%ai|%s'
git -C ~/Developer/gogoboard-7.x/gogo-firmware diff --shortstat version-3.1.0..version-3.2.1
```

### Cross-Repo, Date-Based

User: "the keyboard feature is shipped, started around Feb 1"

```bash
for REPO in \
  ~/Developer/gogoboard-7.x/gogo-firmware \
  ~/Developer/gogo-logo-compiler \
  ~/Developer/gogo-code; do
  echo "=== $(basename $REPO) ==="
  git -C "$REPO" log --after="2026-02-01" --before="2026-03-01" --oneline | wc -l
  git -C "$REPO" log --after="2026-02-01" --before="2026-03-01" --shortstat | tail -1
done
```

### Asking Without Logging

User: "how many hours do you think the display rework took?"

→ Run the analysis and show the estimate, but **don't append to the log** unless the user confirms.

---

## Tips

- **Deduplicate active days** across repos — if the same date has commits in both firmware and compiler, count it once
- **Watch for merge commits** — they inflate commit counts but represent no work. Filter with `--no-merges` when counting
- **Burst days ≠ more hours** — a day with 8 commits might be 6 hours of focused work, not 8× a normal day
- **Ask about collaboration** — if the user worked with others, only count their own commits (`--author="name"`)
- **Preview before appending** — always show the effort entry to the user before writing it to the log
