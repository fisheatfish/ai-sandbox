FROM node:20-slim

# Dépendances minimales
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    python3 python3-venv python3-pip \
 && rm -rf /var/lib/apt/lists/*


# Installation de uv (en root, dans PATH système) uv is for running serena mcp server and installing claude-monitor
RUN curl -LsSf https://astral.sh/uv/install.sh | \
    UV_INSTALL_DIR=/usr/local/bin INSTALLER_NO_MODIFY_PATH=1 sh \
 && chmod +x /usr/local/bin/uv /usr/local/bin/uvx || true


# Update npm to the latest version

RUN npm install -g npm@11.7.0

# Installation des CLIs IA
RUN npm install -g @google/gemini-cli@latest
RUN npm install -g @anthropic-ai/claude-code@latest
RUN npm install -g @qwen-code/qwen-code@latest

# Utilisateur non-root (sécurité)
RUN useradd -m aiuser
USER aiuser
# Install claude code usage monitoring from https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor
RUN uv tool install claude-monitor --force

WORKDIR /workspace

# Environnement
ENV HOME=/home/aiuser
ENV PATH="/home/aiuser/.local/bin:${PATH}"

