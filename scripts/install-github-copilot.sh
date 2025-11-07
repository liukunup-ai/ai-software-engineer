#!/bin/bash
# Install GitHub Copilot CLI

set -e

echo "Installing GitHub Copilot CLI..."

# Install GitHub CLI first (required dependency)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install -y gh

# Install GitHub Copilot CLI extension
gh extension install github/gh-copilot

echo "GitHub Copilot CLI installed successfully!"
echo "Usage: gh copilot suggest 'your task here'"
echo "Note: You'll need to authenticate with 'gh auth login' first"