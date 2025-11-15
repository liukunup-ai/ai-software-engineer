#!/bin/bash
# Install OpenAI Codex CLI

echo "Installing OpenAI Codex CLI ..."

# 检查 npm 是否已安装
if ! command -v npm &> /dev/null; then
    echo "Error: please install Node.js and npm first."
    exit 1
fi

# 使用 npm 全局安装 OpenAI Codex CLI
npm install -g @openai/codex

# 验证是否安装成功
if ! command -v codex &> /dev/null; then
    echo "Error: OpenAI Codex CLI installation failed."
    exit 1
fi

echo "🎉🎉🎉 OpenAI Codex CLI has been installed successfully!"