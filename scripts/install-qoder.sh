#!/bin/bash
# Install Alibaba Qoder CLI

echo "Installing Alibaba Qoder CLI ..."

# 检查 npm 是否已安装
if ! command -v npm &> /dev/null; then
    echo "Error: please install Node.js and npm first."
    exit 1
fi

# 使用 npm 全局安装 Alibaba Qoder CLI
npm install -g @qoder-ai/qodercli

# 验证是否安装成功
if ! command -v qodercli &> /dev/null; then
    echo "Error: Alibaba Qoder CLI installation failed."
    exit 1
fi

echo "🎉🎉🎉 Alibaba Qoder CLI has been installed successfully!"
