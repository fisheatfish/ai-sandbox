FROM node:20-slim

# Minimal dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    unzip \
    python3 python3-venv python3-pip \
 && rm -rf /var/lib/apt/lists/*


# Install uv (as root, in system PATH) for running serena mcp server and installing claude-monitor
RUN curl -LsSf https://astral.sh/uv/install.sh | \
    UV_INSTALL_DIR=/usr/local/bin INSTALLER_NO_MODIFY_PATH=1 sh \
 && chmod +x /usr/local/bin/uv /usr/local/bin/uvx || true

# BUN for OpenCode AWS SDK (fix BunInstallFailedError)
RUN curl -fsSL https://bun.sh/install | bash -s "bun-v1.1.30" && \
    mv /root/.bun /bun && \
    ln -s /bun/bin/bun /usr/local/bin/bun && \
    chmod 755 /bun/bin/bun
ENV BUN_INSTALL=/bun
ENV PATH="/bun/bin:${PATH}"


# Cleaning the cach 
RUN npm cache clean --force

# Update npm to the latest version


RUN npm install -g npm@11.7.0

# Install AI CLIs
RUN npm install -g @google/gemini-cli@latest
RUN npm install -g @qwen-code/qwen-code@latest
RUN npm install -g opencode-ai
RUN npm install -g backlog.md

# Install Claude CLI
RUN curl -fsSL https://claude.ai/install.sh | bash

# Non-root user (security)
RUN useradd -m aiuser
USER aiuser
# Install claude code usage monitoring from https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor
ENV PATH="/home/aiuser/.local/bin:${PATH}"
RUN uv tool install claude-monitor --force

WORKDIR /workspace

# Environment
ENV HOME=/home/aiuser
ENV PATH="/home/aiuser/.local/bin:/bun/bin:/usr/local/bin:${PATH}"

