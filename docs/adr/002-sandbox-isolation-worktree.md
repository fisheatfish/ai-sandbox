# ADR 002: Sandbox isolation — workspace strategy

**Date:** 2026-03-25
**Status:** Proposed
**Deciders:** Gireg Roussel

---

## Context

To run N Claude Code instances in parallel on the same project, each sandbox needs its own working copy. Without isolation, one sandbox's changes overwrite another's.

The system must also manage shared infrastructure (ollama, observability) without duplicating it per sandbox, and provide each container with a distinct aiuser home for Claude Code configuration.

Target architecture:
- N `ai-sandbox` containers on a shared Docker network
- Shared services (ollama, otel-collector, prometheus, grafana) started once
- Each sandbox mounts an isolated workspace and a persistent home

---

## Options considered

### Option A: Git worktree per sandbox

Each sandbox receives a dedicated git worktree. `git worktree add` creates a lightweight working copy pointing to a specific branch, without duplicating git history.

```
aisb up worker1 --branch feat/auth
# → git worktree add $AISB_HOME/worker1/workspace feat/auth
# → docker run ... -v $AISB_HOME/worker1/workspace:/workspace
```

On destruction, `git worktree remove` cleans up the copy (unless `--keep` is used).

| | |
|---|---|
| Pros | Full working directory isolation without duplicating the repo. Each sandbox works on its own branch, no conflicts. Near-instant creation (no clone). Commits and pushes are immediately visible from the main repo. Native git mechanism, no additional tooling. |
| Cons | A worktree cannot checkout the same branch as another worktree (git constraint). Requires the repo to be a git repository (not an arbitrary folder). The main repo must be accessible from the host. |
| Complexity | Low |

### Option B: Full repo copy per sandbox

Each sandbox receives a `git clone` or `cp -r` of the repo into a dedicated folder.

| | |
|---|---|
| Pros | Total isolation, no branch constraints. Works with any folder, not just git repos. Each copy is independent. |
| Cons | Git history duplicated on each clone (slow for large repos). Disk consumption proportional to the number of sandboxes. Changes are not linked to the main repo — requires push/pull to synchronize. No centralized visibility on branch state. |
| Complexity | Low |

### Option C: Shared volume with per-container branch checkout

All sandboxes mount the same volume, each runs `git checkout` on its branch inside the container.

| | |
|---|---|
| Pros | Zero disk duplication. Single mount point to manage. |
| Cons | Guaranteed conflicts if two sandboxes modify files simultaneously. `git checkout` in a shared folder corrupts other sandboxes' working trees. Requires a complex locking system. Incompatible with parallel work, which defeats the project's purpose. |
| Complexity | High |

---

## Addendum: shared infrastructure

Regardless of workspace choice, shared services are managed via a separate `docker-compose.infra.yml`:
- Ollama, otel-collector, prometheus, grafana started once on the `aisb-net` network
- Each sandbox container joins this same network
- Sandboxes reach ollama via `ollama:11434`, otel via `otel-collector:4317`

---

## Decision

> To be completed by the team after discussion.

---

## References

- [git-worktree documentation](https://git-scm.com/docs/git-worktree)
- [Docker networking](https://docs.docker.com/network/)
- Existing `docker-compose.yml` (services to extract)
