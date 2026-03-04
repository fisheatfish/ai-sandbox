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
# Where to store persistent data (workspace, CLI config)
SANDBOX_DATA_DIR=/path/to/your/sandbox-data

# Folder containing a .env file with your API keys
SANDBOX_SECRETS_DIR=/path/to/your/secrets
```

### 2. Configure secrets

Create a `.env` file inside your secrets directory with your API keys:

```bash
mkdir -p $SANDBOX_SECRETS_DIR

cat > $SANDBOX_SECRETS_DIR/.env << EOF
GITHUB_TOKEN=your_github_token_here
EOF
```

### 3. Create workspace and build

```bash
mkdir -p $(grep SANDBOX_DATA_DIR .env | cut -d= -f2)/workspace
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
| [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) | MCP configuration, observability, architecture, troubleshooting |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Git workflow, PR checklist |

## License

This project is licensed under the [MIT License](LICENSE).
