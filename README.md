# AI Sandbox

A complete Docker sandbox for developers who want to explore and experiment with modern AI tools: **Gemini**, **Claude**, and **Qwen**.

## Objective

This repository provides an isolated, pre-configured, and reproducible development environment to:
- Experiment with the APIs and CLIs of Google Gemini, Anthropic Claude, and Alibaba Qwen
- Develop AI applications without polluting your local machine
- Test complex configurations and integrations
- Benefit from full observability of your experiments

## Contents

### Main Services

- **ai-sandbox**: Main Node.js 20 container with Gemini, Claude, Qwen, and opencode-ai CLIs pre-installed
- **Ollama**: Local LLM model support (for open-source models)
- **OpenTelemetry Collector**: Centralized metrics and traces collection
- **Prometheus**: Metrics storage and querying
- **Grafana**: Metrics visualization and dashboards

**Cloud Integration:**
- **AWS Bedrock**: Access to AWS foundation models via opencode-ai

### Tools Installed in ai-sandbox

```dockerfile
- Node.js 20
- @google/gemini-cli (Gemini CLI)
- @anthropic-ai/claude-code (Claude CLI)
- @qwen-code/qwen-code (Qwen CLI)
- opencode-ai (AI Framework with AWS Bedrock integration)
- Git
- Python 3 + pip
- curl
```

## Quick Start

### Prerequisites

- **Docker and Docker Compose** installed
- API keys for Gemini and/or Claude configured
- **(Optional)** AWS access with locally configured credentials to use opencode-ai with Bedrock

#### Option 1: Docker Desktop (Recommended)

- **macOS**: https://www.docker.com/products/docker-desktop
- **Linux**: https://docs.docker.com/engine/install/
- **Windows**: https://www.docker.com/products/docker-desktop (with WSL 2)

#### Option 2: Colima (Open Source Alternative)

If you cannot install Docker Desktop, **Colima** is an excellent lightweight open-source alternative.

### Launch the Environment

#### 0. Configure environment variables (first time only)

This project uses environment variables for local paths to adapt to different configurations. You need to create a `.env` file at the project root:

**Step 1: Copy the template file**

```bash
cp .example.env .env
```

**Step 2: Edit the `.env` file**

Open the created `.env` file and replace the values with your local absolute paths:

```dotenv
# Absolute path to the project root directory
AI_DOCKER_BASE=/Users/your_username/Documents/Projects/ai-docker

# Absolute path to the directory containing your secrets and API keys
AI_SECRETS_BASE=/Users/your_username/Documents/Secrets/ai-docker
```

**Security**: The `.env` file is automatically ignored by Git. Never share this file as it may contain sensitive information.

#### Configure your secrets and API keys

Also create a `secrets` folder at the path specified in `AI_SECRETS_BASE` to store your API keys:

```bash
# Create the secrets folder
mkdir -p $AI_SECRETS_BASE

# Create a .env file with your API keys
cat > $AI_SECRETS_BASE/.env << EOF
# API keys for AI tools
GITHUB_TOKEN=your_github_token_here
EOF
```

#### opencode-ai Configuration with AWS Bedrock

This project integrates **opencode-ai**, an AI framework connected to **AWS Bedrock**.

**Required configuration:**

The `ai-cli-data/.config/opencode/` folder contains the `opencode.json` file to configure the Bedrock connection:

```bash
# The file is located here:
ai-cli-data/.config/opencode/opencode.json
```

**Configuration:**

Edit the `ai-cli-data/.config/opencode/opencode.json` file and replace the values:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "amazon-bedrock": {
      "options": {
        "region": "your_aws_region",
        "profile": "your_aws_profile"
      }
    }
  }
}
```

**Parameters:**
- `region`: AWS region where Bedrock is available (e.g., `eu-west-3`, `us-east-1`)
- `profile`: Locally configured AWS profile (defined in `~/.aws/credentials`)

**AWS Configuration:**

Make sure you have configured your AWS CLI:

```bash
# Configure your AWS credentials
aws configure --profile your_profile

# Verify your configuration
aws sts get-caller-identity --profile your_profile
```

#### 1. Create the workspace folder (first time only)

Before launching the services, create a `workspace` folder at the project root. This is where you will put all your AI projects:

```bash
# From the project root
mkdir -p workspace
```

This folder will be automatically mounted as a volume in the `ai-sandbox` container at `/workspace`. You can access it and create your projects there.

#### 2. Build the image (first time only)

The first time you launch the environment, you need to build the `ai-sandbox` Docker image:

```bash
docker build -t ai-sandbox .
```

This step is only needed on first use or after changes to the Dockerfile.

#### 3. Start the services

```bash
docker-compose up -d
```

This starts all services. To enter the ai-sandbox container:

```bash
docker exec -it ai-sandbox bash
```

### Convenient Alias (Optional)

To simplify container access, create an `ai-sandbox` alias that launches the environment and enters the container in a single command.

#### For Bash

Add this line to your `~/.bashrc` file:

```bash
alias ai-sandbox='cd ~/Documents/ai-docker && docker-compose up -d && docker exec -it ai-sandbox bash'
```

Then reload the configuration:

```bash
source ~/.bashrc
```

#### For Zsh

Add this line to your `~/.zshrc` file:

```bash
alias ai-sandbox='cd ~/Documents/ai-docker && docker-compose up -d && docker exec -it ai-sandbox bash'
```

Then reload the configuration:

```bash
source ~/.zshrc
```

#### Usage

Then simply type:

```bash
ai-sandbox
```

And you will automatically be:
1. In the correct project directory
2. All services (Ollama, Prometheus, Grafana, etc.) will be started
3. Connected to the ai-sandbox container

**Tip**: Adjust the path `~/Documents/Projects/ai-docker` to your own installation path if different.

## Quick Usage

### Access the Interfaces

- **Grafana** (dashboards): http://localhost:3000
- **Prometheus** (metrics): http://localhost:9090
- **Ollama** (local LLMs): http://localhost:11434

### Use the AI CLIs

```bash
# From the ai-sandbox container

# Gemini
gemini --help

# Claude
claude-code --help

# Qwen
qwen-code --help

# opencode-ai (AWS Bedrock)
opencode --help
```

## Full Documentation

| Document | Contents |
|----------|----------|
| [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) | MCP configuration, architecture, detailed setup, troubleshooting |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Contribution guide, Git workflow, best practices, roadmap |

For more details, see the [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) which covers:
- MCP configuration for Claude + GitHub
- Detailed observability (OpenTelemetry, Prometheus, Grafana)
- Advanced configuration
- Use cases (Gemini, Claude, Qwen, Ollama)
- Troubleshooting

## Contributing

To contribute to this project, see [CONTRIBUTING.md](CONTRIBUTING.md) which explains:
- Git workflow (feature branches, PRs, etc.)
- Best practices
- Future roadmap

## FAQ

**How do I add an API key?**
Create a `.env` file at the root and load it in docker-compose.yml.

**How do I persist my data between sessions?**
The `/workspace` folder is automatically mounted as a volume.

**How do I monitor my experiments?**
Enable telemetry in docker-compose.yml and use Grafana.

**Need help?** See the [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md#troubleshooting).

## License

This project is licensed under the [MIT License](LICENSE).

---

**Ready?** Run `docker-compose up -d` and start exploring AI!
