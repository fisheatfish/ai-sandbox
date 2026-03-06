# AI Sandbox

A Docker sandbox for developers who want to explore and experiment with AI coding tools like **Claude Code** in an isolated, reproducible environment.

## What's Inside

- **ai-sandbox**: Node.js 20 container with Claude Code CLI pre-installed
- **Ollama**: Local LLM support for open-source models
- **Observability stack**: OpenTelemetry Collector, Prometheus, and Grafana

## Prerequisites

- **Docker and Docker Compose** installed ([Docker Desktop](https://www.docker.com/products/docker-desktop) or [Colima](https://github.com/abiosoft/colima))
- API keys for the AI tools you want to use

## Quick Start

### 1. Configure environment variables

```bash
cp .example.env .env
```

Edit `.env` with your workspace path and API keys:

```dotenv
# Root directory for sandbox data (workspace, CLI config)
SANDBOX_WORKSPACE=/path/to/your/sandbox-workspace

# API keys (optional — add only what you need)
# GITHUB_TOKEN=your_github_token_here
```

> **Security Warning — Read Before Adding API Keys**
>
> Any secret you put in `.env` will be accessible to the AI agents running inside the container. The LLM can read environment variables, files, and shell history. To protect yourself:
>
> - **Set expiration dates** on all API keys and tokens
> - **Rotate keys regularly** (e.g., weekly or after each session)
> - **Use fine-grained tokens** with the minimum required permissions
> - **Set spending limits / cost barriers** on API accounts to prevent runaway costs
> - **Never reuse production keys** — create dedicated keys for the sandbox
> - **Revoke keys immediately** if you suspect they have been compromised
>
> The `.env` file is gitignored to prevent accidental commits, but the AI agent inside the container **will** have access to these values at runtime.

### 2. Create workspace and build

```bash
mkdir -p $(grep SANDBOX_WORKSPACE .env | cut -d= -f2)/workspace
docker build -t ai-sandbox .
```

### 4. Start services

```bash
docker-compose up -d
docker exec -it ai-sandbox bash
```

## Interfaces

| Service | URL |
|---------|-----|
| Grafana | http://localhost:3000 |
| Prometheus | http://localhost:9090 |
| Ollama | http://localhost:11434 |

## Quick Access Alias

Add this alias to your `~/.bashrc` or `~/.zshrc` to quickly start the sandbox and navigate to a project:

```bash
alias ai-sandbox="cd /path/to/ai-sandbox/ && docker-compose up -d --build && docker exec -it ai-sandbox bash"
```

> Replace `/path/to/ai-sandbox/` with the actual path to your local clone.

## Using the CLI

```bash
# From inside the ai-sandbox container
claude --help
```

## Documentation

| Document | Contents |
|----------|----------|
| [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) | MCP configuration, autonomous git push, observability, architecture, troubleshooting |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Git workflow, PR checklist |

## TODO / Roadmap

- [ ] Package and publish the Docker image to a container registry (GHCR / Docker Hub)
- [ ] Add a startup script to automate git config inside the container
- [ ] Support additional AI coding tools (Codex, Gemini CLI, etc.)

## License

This project is licensed under the [MIT License](LICENSE).
