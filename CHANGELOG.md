# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- MCP (Model Context Protocol) support for GitHub in Claude
- Configuration section for MCP in README.md
- Secrets management with dedicated `secrets/` folder and `.env` file
- Mermaid diagram for architecture visualization
- Documentation links to official GitHub MCP server guides

### Changed
- Updated architecture section with interactive Mermaid diagram
- Enhanced README.md with MCP configuration and secrets setup
- Improved CONTRIBUTING.md with MCP and secrets configuration guidelines

### Security
- Added `secrets/` folder to `.gitignore` to prevent accidental commits of sensitive data
- Enhanced security documentation for API keys and tokens

## [1.0.0] - 2025-12-22

### Added
- Initial release of AI Sandbox
- Docker Compose setup with ai-sandbox, Ollama, OpenTelemetry Collector, Prometheus, and Grafana
- Node.js environment with Gemini CLI, Claude CLI, and Qwen CLI pre-installed
- Volume mounts for workspace, Claude data, and Gemini data persistence
- Telemetry configuration for OpenTelemetry integration
- Complete observability stack with Prometheus and Grafana
- Documentation in README.md and CONTRIBUTING.md
- Git ignore rules for sensitive data and build artifacts

### Infrastructure
- Multi-platform Docker setup (Docker Desktop and Colima support)
- Volume persistence for LLM models, Grafana data, and Prometheus data
- Environment variable configuration for API keys and services
- Health checks and service dependencies in docker-compose.yml

### Documentation
- Comprehensive README with installation, usage, and architecture
- Contributing guidelines with development setup and best practices
- Troubleshooting guides for common issues