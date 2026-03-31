# ADR 004: Automated pipeline — GitHub issues to Claude Code

**Date:** 2026-03-25
**Status:** Proposed
**Deciders:** Gireg Roussel

---

## Context

The end goal of the multi-sandbox CLI is to automate development: when an issue appears on GitHub, a sandbox starts automatically, Claude Code works on it, and opens a PR.

Target flow:

```
GitHub Issue (labeled "claude")
        │
        ▼
   Trigger (webhook / polling / cron)
        │
        ▼
   aisb up worker-42 --branch fix/issue-42 --task <prompt built from issue>
        │
        ▼
   Claude Code works in the sandbox (isolated worktree)
        │
        ▼
   Claude commits + pushes + opens a PR linked to the issue
        │
        ▼
   Notification (Slack, GitHub comment, logs)
```

Constraints:
- The issue must contain enough context for Claude to work (title, description, labels)
- A trigger mechanism is needed (when to launch a sandbox)
- A feedback mechanism is needed (how to know if Claude succeeded or failed)
- Sandboxes must be able to push and create PRs (`GITHUB_TOKEN` required)
- Must avoid launching sandboxes in a loop on the same issue

---

## Options considered

### Option A: Dedicated CLI command + cron

A new `aisb watch` command that polls GitHub issues at regular intervals and launches sandboxes for new issues matching a filter (label, assignee, etc.).

```bash
# Launch the watcher as a daemon
aisb watch --repo owner/repo --label "claude" --interval 60s

# Or one-shot (for cron)
aisb process --repo owner/repo --label "claude"
```

How it works:
1. `gh issue list --label "claude" --state open --json number,title,body,labels`
2. For each unprocessed issue: `aisb up issue-{number} --branch fix/issue-{number} --task "{prompt}"`
3. Mark the issue as "in-progress" (label or comment)
4. When Claude finishes: verify the result, open the PR, comment on the issue

The prompt is built from a template:
```
You are working on issue #{number}: {title}

{body}

Context: {labels}

Instructions:
- Create a branch fix/issue-{number}
- Implement the solution
- Commit and push
- Open a PR with `gh pr create` linked to the issue (Fixes #{number})
```

| | |
|---|---|
| Pros | Autonomous, runs in background or via cron. No dependency on webhook infrastructure. Works with any GitHub repo (public or private with token). Polling is simple to debug. `aisb watch` can run in a container or on the host. |
| Cons | Polling latency (up to N seconds before detection). Consumes GitHub API calls (rate limit 5000/h with token). Requires local persistence to track which issues have already been processed (state file or GitHub label). |
| Complexity | Low |

### Option B: GitHub Webhook + lightweight HTTP server

A small HTTP server (FastAPI or similar) listens for GitHub webhooks on "issues.opened" or "issues.labeled" events and triggers `aisb up` in response.

```bash
aisb serve --port 8080 --secret <webhook-secret>
```

| | |
|---|---|
| Pros | Instant reaction to issue creation/labeling. No polling, no GitHub rate limit concerns. Clean event-driven architecture. |
| Cons | Requires an endpoint accessible from the Internet (ngrok, tunnel, or public server). Adds an HTTP server to maintain. Webhook security management (signature verification). More complex to deploy than a cron. Single point of failure if the server goes down. |
| Complexity | Medium |

### Option C: GitHub Actions as orchestrator

A GitHub Actions workflow listens for `issues.opened` / `issues.labeled` events, connects to the machine hosting the sandboxes (via SSH or self-hosted runner), and triggers `aisb up`.

```yaml
on:
  issues:
    types: [opened, labeled]
jobs:
  claude-sandbox:
    if: contains(github.event.issue.labels.*.name, 'claude')
    runs-on: self-hosted  # runner on the sandbox machine
    steps:
      - run: aisb up issue-${{ github.event.issue.number }} ...
```

| | |
|---|---|
| Pros | Instant reaction via native GitHub events. No server to host — GitHub handles the triggering. Logs and history in the repo's Actions tab. Native GitHub permissions (runner's GITHUB_TOKEN). |
| Cons | Requires a self-hosted runner on the machine with Docker and sandboxes. Runner latency (possible cold start). Strong coupling to GitHub Actions. Runner must have access to the Docker daemon and local repo. Not suitable if sandboxes run on a different machine than the runner. |
| Complexity | Medium |

---

## Addendum: issue lifecycle management

Regardless of the trigger, the lifecycle is the same:

```
Issue opened (label "claude")
  → aisb adds label "claude:in-progress" + comment "Sandbox worker-42 started"
  → Claude works
  → Success: PR opened, label "claude:done", comment with PR link
  → Failure: label "claude:failed", comment with error logs
  → aisb down worker-42 (cleanup sandbox + worktree)
```

Local state file (`$AISB_HOME/.state.json`) to avoid reprocessing an issue:
```json
{
  "owner/repo#42": {"status": "done", "pr": 57, "sandbox": "issue-42"},
  "owner/repo#43": {"status": "in-progress", "sandbox": "issue-43"}
}
```

---

## Decision

> To be completed by the team after discussion.

---

## References

- [GitHub REST API — Issues](https://docs.github.com/en/rest/issues)
- [GitHub Webhooks](https://docs.github.com/en/webhooks)
- [GitHub Actions — issue events](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#issues)
- [`gh` CLI](https://cli.github.com/)
- ADR-001 (CLI framework)
- ADR-002 (worktree isolation)
- ADR-003 (interaction modes)
