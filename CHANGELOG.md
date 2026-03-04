# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-22

### Added
- Initial open-source release of AI Sandbox
- Docker Compose setup with ai-sandbox, Ollama, OpenTelemetry Collector, Prometheus, and Grafana
- Node.js environment with Claude Code CLI pre-installed
- Volume mounts for workspace and CLI data persistence
- Telemetry configuration for OpenTelemetry integration
- Complete observability stack with Prometheus and Grafana
- MCP (Model Context Protocol) support for GitHub and Context7
- Documentation: README, DEVELOPER_GUIDE, CONTRIBUTING

### Infrastructure
- Multi-platform Docker setup (Docker Desktop and Colima support)
- Volume persistence for LLM models, Grafana data, and Prometheus data
- Environment variable configuration for API keys and services
- Non-root container user for security
