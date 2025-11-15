#!/bin/bash
# Install GitHub Copilot CLI

echo "Installing GitHub Copilot CLI ..."

# 检查 npm 是否已安装
if ! command -v npm &> /dev/null; then
    echo "Error: please install Node.js and npm first."
    exit 1
fi

# 使用 npm 全局安装 GitHub Copilot CLI
npm install -g @github/copilot

# 验证是否安装成功
if ! command -v copilot &> /dev/null; then
    echo "Error: GitHub Copilot CLI installation failed."
    exit 1
fi

echo "🎉🎉🎉 GitHub Copilot CLI has been installed successfully!"
