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

Edit `.env` and set your local paths:

```dotenv
AI_DOCKER_BASE=/path/to/this/project
AI_SECRETS_BASE=/path/to/your/secrets
AWS_PROFILE=default
AWS_REGION=us-east-1
```

### 2. Configure secrets

```bash
mkdir -p $AI_SECRETS_BASE

cat > $AI_SECRETS_BASE/.env << EOF
GITHUB_TOKEN=your_github_token_here
EOF
```

### 3. Create workspace and build

```bash
mkdir -p workspace
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
