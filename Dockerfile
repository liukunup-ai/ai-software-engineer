# AI Software Engineer Dockerfile
# Base on Ubuntu with multiple AI coding assistants CLI tools
ARG UBUNTU_VERSION=24.04
FROM ubuntu:$UBUNTU_VERSION

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    git \
    vim \
    tree \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
ARG NODEJS_VERSION=22.x
RUN curl -fsSL https://deb.nodesource.com/setup_$NODEJS_VERSION | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install AI coding assistants CLI tools
COPY scripts/ /opt/scripts/
RUN chmod +x /opt/scripts/*.sh \
    && bash /opt/scripts/install-github-copilot.sh \
    && bash /opt/scripts/install-openai-codex.sh \
    && bash /opt/scripts/install-cursor.sh \
    && bash /opt/scripts/install-alibaba-qoder.sh \
    && bash /opt/scripts/install-tencent-codebuddy.sh

# Set up healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD /bin/bash -c "command -v npm >/dev/null || exit 1"

# Set entrypoint
ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
