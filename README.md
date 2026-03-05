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

Edit `.env` with two paths:

```dotenv
# Root directory for sandbox data (workspace, CLI config)
SANDBOX_WORKSPACE=/path/to/your/sandbox-workspace

# Directory containing a .env file with your API keys (GITHUB_TOKEN, etc.)
# This directory MUST be outside any repository where you run an AI coding
# assistant, so that secrets are never exposed to or leaked by the agent.
SANDBOX_SECRETS_DIR=/path/to/your/secrets
```

### 2. Configure secrets

Create a `.env` file inside your secrets directory with your API keys.
Keep this directory **outside** of any git repository to prevent AI coding assistants from accessing your credentials:

```bash
mkdir -p $SANDBOX_SECRETS_DIR

cat > $SANDBOX_SECRETS_DIR/.env << EOF
GITHUB_TOKEN=your_github_token_here
EOF
```

### 3. Create workspace and build

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

## Security Considerations

Before using this tool, be aware of the following:

- **Secrets in container environment**: The `env_file` directive injects API keys into the container's environment variables. Any process running inside the container (including AI agents) can read them via `env` or `/proc`. Keep `SANDBOX_SECRETS_DIR` **outside** any repository the AI assistant can access, and only include the minimum required keys.
- **No resource limits**: Containers have no CPU/memory limits by default. Consider adding `deploy.resources.limits` in `docker-compose.yml` for production use.
- **No network isolation**: All services share the default Docker network. The AI sandbox container can reach Ollama, Prometheus, and Grafana directly.
- **Grafana default credentials**: The Grafana instance uses `admin/admin`. Change these if exposing the stack beyond localhost.
- **Ollama runs as root**: The official Ollama image runs as root by default.

## TODO / Roadmap

- [ ] Package and publish the Docker image to a container registry (GHCR / Docker Hub)
- [ ] Add container resource limits (CPU/memory) to `docker-compose.yml`
- [ ] Network isolation: separate internal services from the AI sandbox
- [ ] Support injecting secrets via Docker secrets instead of `env_file`
- [ ] Harden Grafana default credentials via environment variables
- [ ] Add a startup script to automate git config inside the container
- [ ] Support additional AI coding tools (Codex, Gemini CLI, etc.)

## License

This project is licensed under the [MIT License](LICENSE).
