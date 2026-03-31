# ADR 003: Sandbox interaction modes

**Date:** 2026-03-25
**Status:** Proposed
**Deciders:** Gireg Roussel

---

## Context

Once N sandboxes are running in parallel, the user needs to interact with them. Two use cases emerge:
- **Exploration/debug**: the user wants a shell inside a sandbox to launch Claude manually, inspect files, or debug.
- **Autonomous tasks**: the user wants to assign a task to Claude and monitor progress without intervention, while other sandboxes keep working.

The question is which mode(s) the CLI should support and how they fit together.

---

## Options considered

### Option A: Interactive mode only

The CLI only offers `aisb exec <name>` which opens a bash shell in the container. The user launches Claude manually.

```bash
aisb up worker1 --branch feat/auth
aisb exec worker1
aiuser@worker1:/workspace$ claude
```

| | |
|---|---|
| Pros | Simple to implement (wrapper around `docker exec -it`). User retains full control. No task assignment logic in the CLI. |
| Cons | Does not allow autonomous parallel work — user must open one terminal per sandbox. No centralized tracking of what each Claude is doing. No batch mode to launch N tasks at once. |
| Complexity | Trivial |

### Option B: Headless mode only

The CLI launches Claude with a task via `--task` at startup. The user monitors progress via `aisb logs`.

```bash
aisb up worker1 --branch feat/auth --task "Refactor the auth module"
aisb logs worker1 --follow
```

| | |
|---|---|
| Pros | Enables true autonomous parallel work. User launches N sandboxes with N tasks and monitors. Natural batch mode support (`--tasks file.txt`). Centralized tracking via `aisb ls` (shows current task). |
| Cons | No way to intervene mid-task. If Claude needs clarification, no way to respond. Debugging is difficult without a shell. |
| Complexity | Low |

### Option C: Both modes combined

The CLI supports both:
- `aisb exec <name>` for interactive mode (bash shell)
- `--task "..."` on `aisb up` for headless mode
- `aisb logs <name> --follow` to monitor headless mode

The mode is determined at launch: without `--task` = interactive (container waits), with `--task` = headless (Claude starts automatically). `aisb ls` displays each sandbox's mode.

```bash
# Headless
aisb up worker1 --branch feat/auth --task "Refactor auth"

# Interactive
aisb up worker2 --branch feat/api
aisb exec worker2

# Dashboard
aisb ls
# NAME     BRANCH      STATUS   MODE
# worker1  feat/auth   running  task: Refactor auth
# worker2  feat/api    running  interactive
```

Possible extensions:
- `--count N` to spawn N auto-named sandboxes (worker-1, worker-2, ...)
- `--tasks file.txt` for batch assignment (one task per line)
- `OTEL_RESOURCE_ATTRIBUTES=aisb.name=worker1` for per-sandbox tracking in Grafana

| | |
|---|---|
| Pros | Covers all use cases. User chooses the mode suited to the situation. Allows mixed workflows (some sandboxes autonomous, others interactive). Batch mode enables launching N tasks in one command. |
| Cons | More code to maintain (two execution paths). The `up` command has more flags. Requires managing Claude's lifecycle in the container (process management). |
| Complexity | Medium |

---

## Decision

> To be completed by the team after discussion.

---

## References

- [Claude Code CLI --task flag](https://docs.anthropic.com/en/docs/claude-code)
- Existing `docker-compose.yml` (ai-sandbox service)
- ADR-001 (CLI framework choice)
- ADR-002 (workspace isolation)
