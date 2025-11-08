# AI Software Engineer Dockerfile
# Base on Ubuntu with multiple AI coding assistants CLI tools
FROM ubuntu:24.04

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
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Copy installation scripts and set execute permissions
COPY scripts/ /opt/scripts/
RUN chmod +x /opt/scripts/*.sh

# Install AI coding assistants CLI tools
RUN    bash /opt/scripts/install-github-copilot.sh \
    && bash /opt/scripts/install-cursor.sh \
    && bash /opt/scripts/install-qoder.sh \
    && bash /opt/scripts/install-codebuddy.sh

# Set up healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD /bin/bash -c "command -v npm >/dev/null || exit 1"

# Set entrypoint
ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
