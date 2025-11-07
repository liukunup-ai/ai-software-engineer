# AI Software Engineer Docker Image
# Based on Ubuntu with multiple AI coding assistants CLI tools
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV NODE_VERSION=20
ENV PYTHON_VERSION=3.11

# Set up working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    sudo \
    build-essential \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    unzip \
    zip \
    vim \
    nano \
    tree \
    htop \
    jq \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (required for many CLI tools)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - \
    && apt-get install -y nodejs

# Create scripts directory
RUN mkdir -p /app/scripts

# Copy installation scripts
COPY scripts/ /app/scripts/
RUN chmod +x /app/scripts/*.sh

# Install GitHub Copilot CLI
RUN /app/scripts/install-github-copilot.sh

# Install Alibaba Qoder CLI
RUN /app/scripts/install-qoder.sh

# Install Cursor CLI
RUN /app/scripts/install-cursor.sh

# Install ByteDance Trae CLI
RUN /app/scripts/install-trae.sh

# Create a non-root user
RUN useradd -m -s /bin/bash aidev \
    && echo "aidev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to non-root user
USER aidev
WORKDIR /home/aidev

# Copy entrypoint script
COPY scripts/entrypoint.sh /app/scripts/entrypoint.sh
USER root
RUN chmod +x /app/scripts/entrypoint.sh
USER aidev

# Set up shell environment
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc \
    && echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc

# Expose common ports (can be overridden)
EXPOSE 3000 8000 8080

# Set entrypoint
ENTRYPOINT ["/app/scripts/entrypoint.sh"]
CMD ["bash"]