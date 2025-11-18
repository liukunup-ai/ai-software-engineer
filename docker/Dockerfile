# AI Software Engineer Dockerfile
# Base on Ubuntu with multiple AI coding assistants CLI tools
ARG UBUNTU_VERSION=24.04
FROM ubuntu:$UBUNTU_VERSION

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    git \
    curl \
    wget \
    vim \
    tree \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
ARG NODE_VERSION=22.x
RUN curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install AI coding assistants CLI tools
COPY docker/scripts/ /usr/local/scripts/

# Add ARGs for controlling CLI installations
ARG INSTALL_GITHUB_COPILOT=true
ARG INSTALL_OPENAI_CODEX=true
ARG INSTALL_CURSOR=true
ARG INSTALL_OPENCODE=true
ARG INSTALL_CLAUDE_CODE=true
ARG INSTALL_ALIBABA_QODER=true
ARG INSTALL_TENCENT_CODEBUDDY=true

RUN chmod +x /usr/local/scripts/*.sh \
    && if [ "$INSTALL_GITHUB_COPILOT" = "true" ]; then bash /usr/local/scripts/install-github-copilot.sh; fi \
    && if [ "$INSTALL_OPENAI_CODEX" = "true" ]; then bash /usr/local/scripts/install-openai-codex.sh; fi \
    && if [ "$INSTALL_CURSOR" = "true" ]; then bash /usr/local/scripts/install-cursor.sh; fi \
    && if [ "$INSTALL_OPENCODE" = "true" ]; then bash /usr/local/scripts/install-opencode.sh; fi \
    && if [ "$INSTALL_CLAUDE_CODE" = "true" ]; then bash /usr/local/scripts/install-claude-code.sh; fi \
    && if [ "$INSTALL_ALIBABA_QODER" = "true" ]; then bash /usr/local/scripts/install-alibaba-qoder.sh; fi \
    && if [ "$INSTALL_TENCENT_CODEBUDDY" = "true" ]; then bash /usr/local/scripts/install-tencent-codebuddy.sh; fi

# Install Python
ARG PYTHON_VERSION=3.12
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y \
    python$PYTHON_VERSION \
    python${PYTHON_VERSION}-venv \
    && rm -rf /var/lib/apt/lists/* && \
    ln -sf /usr/bin/python${PYTHON_VERSION} /usr/local/bin/python3 && \
    ln -sf /usr/bin/python3 /usr/bin/python

# Copy application files and install Python dependencies
WORKDIR /app
COPY app/ .
COPY requirements.txt .
COPY docker/entrypoint.sh .
RUN python -m venv .venv && \
    . .venv/bin/activate && \
    pip install --upgrade pip -i https://mirrors.aliyun.com/pypi/simple && \
    python --version && \
    pip install --no-cache-dir -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple

EXPOSE 8007

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8007/healthz || exit 1

ENTRYPOINT [ "./entrypoint.sh" ]
