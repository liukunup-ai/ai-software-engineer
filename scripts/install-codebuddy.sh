#!/bin/bash
# Install Tencent AI CodeBuddy CLI

echo "Installing Tencent AI CodeBuddy CLI ..."

# 检查 npm 是否已安装
if ! command -v npm &> /dev/null; then
    echo "Error: please install Node.js and npm first."
    exit 1
fi

# 使用 npm 全局安装 Tencent AI CodeBuddy CLI
npm install -g @tencent-ai/codebuddy-code

# 验证是否安装成功
if ! command -v codebuddy &> /dev/null; then
    echo "Error: Tencent AI CodeBuddy CLI installation failed."
    exit 1
fi

echo "🎉🎉🎉 Tencent AI CodeBuddy CLI has been installed successfully!"
