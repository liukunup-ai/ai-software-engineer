#!/bin/bash
# Install Claude Code CLI

echo "Installing Claude Code CLI ..."

# 使用官方安装脚本安装 Claude Code CLI
curl -fsSL https://claude.ai/install.sh | bash

# Add ~/.local/bin to your PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 创建软链接
ln -sf "$HOME/.local/bin/claude-code" /usr/local/bin/claude-code

# 验证是否安装成功
if ! command -v claude-code &> /dev/null; then
    echo "Error: Claude Code CLI installation failed."
    exit 1
fi

echo "🎉🎉🎉 Claude Code CLI has been installed successfully!"