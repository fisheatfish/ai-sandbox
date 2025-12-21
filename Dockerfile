FROM node:20-slim

# Dépendances minimales
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    python3 python3-venv python3-pip \
 && rm -rf /var/lib/apt/lists/*

# Installation des CLIs IA
RUN npm install -g @google/gemini-cli
RUN npm install -g @anthropic-ai/claude-code
RUN npm install -g @qwen-code/qwen-code@latest

# Utilisateur non-root (sécurité)
RUN useradd -m aiuser
USER aiuser
WORKDIR /workspace

# Environnement
ENV HOME=/home/aiuser
