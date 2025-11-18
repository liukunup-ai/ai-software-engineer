#!/bin/bash
# Install Claude Code

echo "Installing Claude Code ..."

# 检查 npm 是否已安装
if ! command -v npm &> /dev/null; then
    echo "Error: please install Node.js and npm first."
    exit 1
fi

# 使用 npm 全局安装 Claude Code
npm install -g @anthropic-ai/claude-code

# 验证是否安装成功
if ! command -v claude &> /dev/null; then
    echo "Error: Claude Code installation failed."
    exit 1
fi

echo "🎉🎉🎉 Claude Code has been installed successfully!"
