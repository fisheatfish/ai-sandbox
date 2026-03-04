# Contributing Guide

Thank you for wanting to contribute to this project! This document describes the best practices and the vision for future developments.

## Project Vision

**ai-sandbox** is a sandbox for quickly exploring AI tools (Gemini, Claude, Qwen, OpenCode) in a reproducible and observable environment.

### Guiding Principles

- **Simplicity**: Minimal configuration to get started quickly
- **Reproducibility**: Same environment on all machines
- **Observability**: Complete stack for monitoring experiments
- **Extensibility**: Easy to add new tools and services
- **Security**: Non-root user, no hardcoded credentials

## Best Practices

### Development Environment

#### Standard Setup with Docker Desktop

1. **Clone and setup**
   ```bash
   git clone <repo>
   cd ai-docker
   ```

2. **Launch the full environment**
   ```bash
   make launch
   ```

3. **Verify all services are up**
   ```bash
   docker-compose ps
   ```

#### Alternative Setup with Colima

If you use Colima instead of Docker Desktop:

**macOS**
```bash
# Make sure Colima is running
colima start

# Then proceed as above
git clone <repo>
cd ai-docker
make launch
```

**Linux**
```bash
# Start Colima
colima start

# Verify the connection
docker ps

# Then launch the project
git clone <repo>
cd ai-docker
make launch
```

**Colima Troubleshooting**

If volumes are not mounting correctly:
```bash
# Check Colima status
colima status

# Restart Colima
colima stop
colima start

# Restart containers
docker-compose restart
```

If Colima does not have enough resources:
```bash
# Edit the config (~/.colima/default/colima.yml)
# and increase cpu, memory, disk
colima edit

# Apply the changes
colima restart
```

#### Secrets Configuration

**Important**: Before launching the environment, configure your secrets in a dedicated `.env` file.

1. **Create the folder structure**:
   ```bash
   mkdir -p secrets
   ```

2. **Create the `.env` file**:
   ```bash
   cat > secrets/.env << EOF
   GITHUB_TOKEN=your_github_token_here
   EOF
   ```

3. **Checks**:
   - The `secrets/` folder is in `.gitignore`
   - The `.env` file will never be committed
   - Docker Compose automatically loads this file

### Service Modifications

- **Dockerfile**: Keep only essential installations
  - Always use specific versions (no `latest`)
  - Clean caches after apt-get/npm
  - Maintain the security layer (non-root user)

- **docker-compose.yml**:
  - Document each environment variable
  - Use consistent ports (4xxx = internal, 3xxx-9xxx = access)
  - Keep dependencies explicit (`depends_on`)

- **Configuration files**:
  - YAML: 2-space indentation
  - Comment optional configurations
  - Use separate files for each component (observability/)

### Code and Commits

#### Git Workflow: NO PUSH ON MAIN

**Important**: NEVER push directly to `main`. All changes must go through a **feature branch** and a **Pull Request**.

#### Standard Procedure

**1. Create a feature branch**

Create a branch with a descriptive name based on your feature:

```bash
git checkout -b feature/sandbox-postgres
```

Name examples:
- `feature/add-mcp-servers`: Adding new features
- `fix/prometheus-scrape`: Bug fix
- `docs/update-readme`: Documentation
- `chore/update-dependencies`: Maintenance

**2. Make your changes**

Modify the necessary files (Dockerfile, docker-compose.yml, configs, etc.)

**3. Commit with a clear message**

```bash
git add .
git commit -m "feat: add postgres service with healthcheck"
```

Recommended commit messages:
```
feat: add MCP server Claude support
fix: correct Prometheus endpoint
docs: update observability README
chore: update Ollama to latest
```

Format: Use the conventional format (feat:, fix:, docs:, chore:)

**4. Push your branch**

```bash
git push origin feature/sandbox-postgres
```

**5. Create a Pull Request (PR)**

- Go to GitHub
- Create a PR from your branch to `main`
- Clearly describe your changes
- Reference issues if applicable
- Wait for auto-merge after review/CI

**6. Update your local main**

Once your PR is merged:

```bash
git checkout main
git pull origin main
```

#### Pre-push Checklist

- [ ] Code tested locally with `docker-compose up`
- [ ] Clear and conventional commit messages
- [ ] README updated if necessary
- [ ] Environment variables documented
- [ ] No secrets or credentials in the code
- [ ] Docker images use specific versions
- [ ] No workspace files committed (`.gitignore` respected)

### Documentation

- Update the README if architecture changes
- Document new environment variables
- Explain technical choices in comments

## Current MCP Configuration

### MCP GitHub for Claude

The project currently supports MCP (Model Context Protocol) GitHub to extend Claude's capabilities.

#### Data Structure

- **`ai-cli-data/` folder**: Contains persisted MCP configuration and AI CLI data
  - Automatically mounted as a volume in `docker-compose.yml`
  - **Important**: This folder is in `.gitignore` to avoid pushing secrets
  - Configuration is saved in `.claude.json`

#### Installing an MCP

1. Create the `ai-cli-data` folder (if not already done)
2. Launch the container: `make shell`
3. Install the GitHub MCP:
   ```bash
   claude mcp add --transport http github \
     "https://api.githubcopilot.com/mcp" \
     -H "Authorization: Bearer $GITHUB_TOKEN"
   ```

#### Security

- Never commit the `ai-cli-data/` folder
- Use personal GitHub tokens with minimal permissions
- Verify that `.gitignore` contains `ai-cli-data/`

## Future Roadmap

### Phase 1: Full MCP Servers Support

**MCP** (Model Context Protocol) provides standardization for AI tools.

#### Planned Tasks

1. **Claude MCP Configuration**
   - Add MCP server support for Claude in the Dockerfile
   - Create an `mcp-servers/` folder with configurations
   - Integrate standard servers: `git`, `github`, `web-search`, etc.

   ```dockerfile
   # To add to the Dockerfile
   RUN npm install -g @anthropic-ai/mcp
   COPY mcp-servers/ /workspace/mcp-servers/
   ```

2. **Gemini MCP Configuration** (if available)
   - Follow Google's MCP developments
   - Implement adapters if needed

3. **MCP Servers Structure**
   ```
   mcp-servers/
   ├── git/
   │   ├── config.json
   │   └── README.md
   ├── github/
   │   ├── config.json
   │   └── README.md
   ├── web-search/
   │   ├── config.json
   │   └── README.md
   └── README.md (index of all servers)
   ```

### Phase 2: Advanced Observability

- **Distributed traces**: Uncomment the `traces` sections in `otel-collector-config.yaml`
  - Add Tempo for trace storage
  - Integrate Jaeger UI for visualization

- **Centralized logs**: Uncomment the `logs` sections
  - Add Loki for storage
  - Integrate into Grafana

- **Pre-configured dashboards**:
  - AI metrics dashboard (tokens, latency, costs)
  - Service health dashboard
  - Request traces dashboard

### Phase 3: Advanced Integration

- **Support for multiple AI APIs**:
  - OpenAI (ChatGPT, GPT-4)
  - Hugging Face
  - Mistral AI
  - LLaMA via Ollama

- **Testing framework**:
  - Integration tests for each CLI
  - Performance benchmarks
  - Output validation

- **Complete examples**:
  - Example projects for each AI
  - Reusable patterns
  - Integrated Jupyter notebooks

### Phase 4: Production Readiness

- **Enhanced security**:
  - Secrets management (Vault/Doppler)
  - Network policies
  - Audit logging

- **Performance**:
  - Docker image optimization
  - Optimized cache for Ollama
  - Configurable resource limits

- **CI/CD**:
  - GitHub Actions for tests
  - Security scanning (trivy, snyk)
  - Automatic versioning

## PR Checklist

- [ ] Code tested locally with `make launch`
- [ ] Clear and conventional commit messages
- [ ] README updated if necessary
- [ ] Environment variables documented
- [ ] No secrets or credentials in the code
- [ ] Docker images use specific versions
- [ ] No workspace files committed (`.gitignore` respected)

## Reporting a Bug

Create an issue with:
- Clear description of the bug
- Steps to reproduce
- Expected vs. actual result
- Output of `docker-compose ps`

## Suggesting an Improvement

Create a discussion or issue with:
- Description of the improvement
- Use case / context
- Proposed solution (if applicable)

## Questions?

Feel free to open an issue or discussion for clarification.

---

## Detailed Roadmap (next steps)

| Phase | Task | Priority | Estimated |
|-------|------|----------|-----------|
| 1 | Claude MCP Servers config | High | 2-3d |
| 1 | CLI integration tests | High | 1-2d |
| 2 | Distributed traces (Tempo) | Medium | 2-3d |
| 2 | Centralized logs (Loki) | Medium | 2-3d |
| 3 | OpenAI support | Medium | 1-2d |
| 3 | Examples and documentation | Low | 3-5d |
| 4 | Secrets management | Low | 2-3d |

---

**Thank you for your contribution!**
