# ADR 001: Multi-sandbox CLI — language and framework choice

**Date:** 2026-03-25
**Status:** Proposed
**Deciders:** Gireg Roussel

---

## Context

ai-sandbox is currently a single Docker container managed via `docker-compose` and a `Makefile` (build/run/shell). To allow launching N sandboxes in parallel, each with its own Claude Code instance, a dedicated CLI is needed to orchestrate Docker containers, manage git worktrees, and provide a clear user interface.

The project already uses Python 3, Node.js 20, and has a Dockerfile based on `node:20-trixie-slim`. The CLI will be installed on the host machine (not inside the container).

Constraints:
- Must interact with the Docker API (create/start/stop containers, manage networks)
- Must execute git commands (worktree add/remove/list)
- Must display tables and visual feedback (sandbox list, statuses)
- Simple installation for a developer (ideally `uv add`)

---

## Options considered

### Option A: Python (Typer + Rich + Docker SDK)

Typer for CLI parsing with auto-completion and generated help, Rich for display (tables, spinners, colors), and the `docker` package (Docker SDK for Python) for container orchestration.

| | |
|---|---|
| Pros | Mature CLI ecosystem (Typer = native typing, auto-complete, auto-generated help). Docker SDK Python maps 1:1 to Docker Engine API, no need to shell out. Rich provides tables, progress bars and live displays. Already in the project stack (Python 3 installed). Trivial installation via uv. |
| Cons | Startup performance (~100-200ms for a Python script). Requires a Python environment on the host machine. Binary distribution less straightforward than a compiled language. |
| Complexity | Low |

### Option B: Go (Cobra + Docker client)

Cobra for the CLI framework, the official Go Docker client, and packages like `tablewriter` for display.

| | |
|---|---|
| Pros | Single binary, zero installation dependencies. Near-instant startup. Docker is written in Go, the client is native. Cobra is the standard (used by kubectl, gh, docker CLI). |
| Cons | Go is not in the current project stack. Longer development time for an orchestration CLI (Go boilerplate vs Python conciseness). Rich display (tables, colors) requires more effort than with Rich. Requires a Go toolchain for development. |
| Complexity | Medium |

### Option C: Shell script (Bash)

Bash script using `docker` and `git` commands directly with functions for each subcommand.

| | |
|---|---|
| Pros | Zero additional dependencies. Direct calls to docker and git. Quick prototype for simple cases. |
| Cons | Quickly becomes unmaintainable with networking, volume, label, and worktree logic. No robust error handling. No formatted tables or auto-generated help. Manual argument parsing. No practical unit testing. |
| Complexity | High (at scale) |

---

## Decision

> To be completed by the team after discussion.

---

## References

- [Typer documentation](https://typer.tiangolo.com/)
- [Rich documentation](https://rich.readthedocs.io/)
- [Docker SDK for Python](https://docker-py.readthedocs.io/)
- [Cobra (Go CLI)](https://cobra.dev/)
