#!/bin/bash
# Install OpenCode CLI

echo "Installing OpenCode CLI ..."

# 检查 npm 是否已安装
if ! command -v npm &> /dev/null; then
    echo "Error: please install Node.js and npm first."
    exit 1
fi

# 使用 npm 全局安装 OpenCode CLI
npm install -g opencode-ai

# 验证是否安装成功
if ! command -v opencode &> /dev/null; then
    echo "Error: OpenCode CLI installation failed."
    exit 1
fi

echo "🎉🎉🎉 OpenCode CLI has been installed successfully!"
