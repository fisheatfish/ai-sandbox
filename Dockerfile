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


# Cleaning the cache
RUN npm cache clean --force

# Update npm to the latest version
RUN npm install -g npm@11.7.0

# Install MCP CLI tools globally
RUN npm install -g backlog.md

# Install AI CLIs
# RUN npm install -g @google/gemini-cli@latest
# RUN npm install -g opencode-ai
RUN curl -fsSL https://claude.ai/install.sh | bash

# Non-root user (security)
RUN useradd -m aiuser
USER aiuser
ENV PATH="/home/aiuser/.local/bin:${PATH}"

WORKDIR /workspace

# Environment
ENV HOME=/home/aiuser
ENV PATH="/home/aiuser/.local/bin:/bun/bin:/usr/local/bin:${PATH}"

