FROM node:20-slim

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Minimal dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    unzip \
    python3 python3-venv python3-pip \
 && rm -rf /var/lib/apt/lists/*

# Install uv (as root, in system PATH) for running serena mcp server and installing claude-monitor
RUN curl -LsSf https://astral.sh/uv/install.sh | \
    UV_INSTALL_DIR=/usr/local/bin INSTALLER_NO_MODIFY_PATH=1 sh \
 && chmod +x /usr/local/bin/uv /usr/local/bin/uvx

# Cleaning the cache, update npm, install MCP CLI tools and AI CLIs
RUN npm cache clean --force \
 && npm install -g npm@11.11.1 \
 && npm install -g backlog.md@1.42.0 \
 && curl -fsSL https://claude.ai/install.sh | bash

# Non-root user (security)
RUN useradd -m aiuser
USER aiuser
ENV PATH="/home/aiuser/.local/bin:${PATH}"

WORKDIR /workspace

# Environment
ENV HOME=/home/aiuser
ENV PATH="/home/aiuser/.local/bin:/usr/local/bin:${PATH}"
