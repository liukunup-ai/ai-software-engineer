#!/bin/bash
# Install Cursor CLI

echo "Installing Cursor CLI ..."

# 使用官方安装脚本安装 Cursor CLI
curl https://cursor.com/install -fsS | bash

# Add ~/.local/bin to your PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 创建软链接
ln -sf "$HOME/.local/bin/cursor-agent" /usr/local/bin/cursor-agent

# 验证是否安装成功
if ! command -v qodercli &> /dev/null; then
    echo "Error: Alibaba Qoder CLI installation failed."
    exit 1
fi

echo "🎉🎉🎉 Cursor CLI has been installed successfully!"
