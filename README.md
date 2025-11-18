# AI Software Engineer

<div align="center">

[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.110+-009688?logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![Python](https://img.shields.io/badge/Python-3.12+-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![Node.js](https://img.shields.io/badge/Node.js-22.x-339933?logo=node.js&logoColor=white)](https://nodejs.org/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Ready-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**集成多种 AI 编程助手的智能工作节点**

支持独立运行和集群部署 | 安全的命令执行 | 完整的 API 服务

[快速开始](#-快速开始) • [功能特性](#-功能特性) • [部署指南](#-部署方式) • [API 文档](#-api-文档) • [配置说明](#-配置)

</div>

---

## 📖 简介

AI Software Engineer 是一个基于 Docker 的智能工作节点，集成了多种主流 AI 编程助手 CLI 工具，并提供 FastAPI 后端服务用于安全地执行白名单命令。

### 核心特性

- 🎯 **双模式运行**: Standalone（独立）和 Worker（集群）两种模式
- 🔒 **安全执行**: 基于白名单的命令执行机制
- 🚀 **开箱即用**: 一键启动脚本，快速部署
- 📊 **完整监控**: 健康检查、心跳上报、状态追踪
- ☸️ **云原生**: 支持 Docker、Docker Compose、Kubernetes
- 🤖 **AI 集成**: GitHub Copilot、OpenAI Codex、Cursor、Alibaba Qoder、Tencent Codebuddy 等工具
- 🔧 **灵活配置**: 支持按需安装 AI 工具，减少镜像体积

---

## 🎯 快速开始

### 前置要求

- Docker 20.10+
- (可选) Docker Compose 2.0+
- (可选) Kubernetes 1.20+
- (可选) Python 3.12+ (本地开发)

### 1️⃣ 本地开发模式

使用 Python 虚拟环境运行：

```bash
# 克隆仓库
git clone https://github.com/liukunup-ai/ai-software-engineer.git
cd ai-software-engineer

# 创建虚拟环境并安装依赖
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt

# 启动服务（使用启动脚本）
./start.sh

# 或直接使用 uvicorn
cd app
uvicorn main:app --host 0.0.0.0 --port 8007 --reload
```

访问服务：
- API 文档: http://localhost:8007/docs
- 健康检查: http://localhost:8007/healthz

### 2️⃣ Docker 容器模式

#### Standalone 模式（独立容器）

```bash
# 使用 Makefile 构建并运行
make build
make run

# 或使用 Docker 命令
docker build -f docker/Dockerfile -t ai-software-engineer:latest .
docker run -d \
  --name ai-worker \
  -e NODE_MODE=standalone \
  -p 8007:8007 \
  ai-software-engineer:latest
```

#### Worker 模式（集群节点）

```bash
# 配置环境变量
export REGISTER_URL=http://master-node:8000
export REGISTER_KEY=your-secret-key
export NODE_NAME=worker-01

# 使用启动脚本
./start.sh --register http://master-node:8000 --key your-secret-key

# 或使用 Docker Compose
docker-compose up -d
```

---

## 🚀 功能特性

### 运行模式

| 模式 | 用途 | 特点 | 适用场景 |
|------|------|------|----------|
| **Standalone** | 独立容器 | 无需后端，快速启动 | 开发、测试、单机部署 |
| **Worker** | 集群节点 | 自动注册，心跳上报 | 生产环境、分布式部署 |

### 集成的 AI 工具

<table>
  <tr>
    <td align="center"><b>GitHub Copilot</b><br/>官方 AI 编程助手</td>
    <td align="center"><b>OpenAI Codex</b><br/>OpenAI 代码模型</td>
    <td align="center"><b>Claude Code</b><br/>Anthropic Claude 助手</td>
  </tr>
  <tr>
    <td align="center"><b>Cursor</b><br/>AI 代码编辑器</td>
    <td align="center"><b>Alibaba Qoder</b><br/>阿里云代码助手</td>
    <td align="center"><b>Tencent Codebuddy</b><br/>腾讯代码助手</td>
  </tr>
  <tr>
    <td align="center" colspan="3"><b>OpenCode</b><br/>开源代码生成工具</td>
  </tr>
</table>

### 技术栈

- **基础镜像**: Ubuntu 24.04 LTS
- **运行时**: Python 3.12 + Node.js 22.x
- **框架**: FastAPI 0.110+ + Uvicorn
- **HTTP 客户端**: httpx 0.27+
- **容器化**: Docker + Docker Compose + Docker CLI
- **编排**: Kubernetes (可选)

---

## 📦 包含的工具

### 系统工具
```bash
├── Ubuntu 24.04 LTS
├── Python 3.12
├── Node.js 22.x
├── Docker CLI
├── Git
├── curl, wget
├── vim, tree
└── 其他常用 CLI 工具
```

### AI 编程助手
```bash
# GitHub Copilot (可选安装)
gh copilot suggest "your task"
gh copilot explain "complex command"

# OpenAI Codex (可选安装)
codex help

# Claude Code (可选安装)
claude-code help

# Cursor (可选安装)
cursor help

# Alibaba Qoder (可选安装)
qoder help

# Tencent Codebuddy (可选安装)
tencent-codebuddy help

# OpenCode (可选安装)
opencode help
```

> **注意**: AI 工具默认全部安装。可通过构建参数控制按需安装，减少镜像体积。

---

## 🛠 部署方式

### 方式 1: 快速启动脚本

```bash
# 本地开发（不使用 Docker）
./start.sh

# 使用 Makefile（Docker）
make build
make run

# 自定义参数
./start.sh --port 8080 --register http://master:8000 --key secret
```

### 方式 2: Docker 命令

```bash
# Standalone
docker run -d \
  --name ai-standalone \
  -e NODE_MODE=standalone \
  -e ALLOWED_COMMANDS=echo,date,ls,python3,node \
  -p 8007:8007 \
  ai-software-engineer:latest

# Worker
docker run -d \
  --name ai-worker \
  -e NODE_MODE=worker \
  -e REGISTER_URL=http://master:8000 \
  -e REGISTER_KEY=your-key \
  -e NODE_NAME=worker-1 \
  -e NODE_HOST=192.168.1.100 \
  -e NODE_PORT=8007 \
  -p 8007:8007 \
  ai-software-engineer:latest
```

### 方式 3: Docker Compose

```yaml
version: '3.8'

services:
  ai-software-engineer:
    image: ai-software-engineer:latest
    container_name: ai-software-engineer
    restart: unless-stopped
    ports:
      - "8007:8007"
    environment:
      NODE_MODE: worker  # 或 standalone
      REGISTER_URL: http://localhost:8000
      REGISTER_KEY: key
      NODE_NAME: ai-software-engineer
      NODE_HOST: 127.0.0.1
      NODE_PORT: 8007
      HEARTBEAT_INTERVAL: 30
      ALLOWED_COMMANDS: echo,date,ls
      COMMAND_TIMEOUT: 15
```

```bash
docker-compose -f docker/docker-compose.yml up -d
```

### 方式 4: Kubernetes

```bash
# 部署
kubectl apply -f docker/k8s-deployment.yaml

# 扩容
kubectl scale deployment ai-worker --replicas=10

# 查看状态
kubectl get pods -l app=ai-worker
```

详细配置参见 [k8s-deployment.yaml](./docker/k8s-deployment.yaml)

---

## 🔨 构建镜像

### 使用 Makefile（推荐）

```bash
# 查看所有可用命令
make help

# 构建完整镜像（包含所有 AI 工具）
make build

# 强制重新构建（不使用缓存）
make build-no-cache

# 构建最小化镜像（仅必要工具）
make build-minimal
```

### 自定义构建

```bash
# 指定镜像名称和标签
make build IMAGE_NAME=myorg/ai-worker IMAGE_TAG=v1.0

# 选择性安装 AI 工具
docker build \
  --build-arg INSTALL_GITHUB_COPILOT=true \
  --build-arg INSTALL_OPENAI_CODEX=false \
  --build-arg INSTALL_CURSOR=false \
  --build-arg INSTALL_ALIBABA_QODER=true \
  -f docker/Dockerfile \
  -t ai-software-engineer:custom .

# 指定 Python 和 Node.js 版本
docker build \
  --build-arg PYTHON_VERSION=3.12 \
  --build-arg NODE_VERSION=22.x \
  -f docker/Dockerfile \
  -t ai-software-engineer:latest .
```

---

## 📡 API 文档

### 端点列表

| 方法 | 路径 | 描述 | 认证 |
|------|------|------|------|
| `GET` | `/healthz` | 健康检查，返回节点状态 | 否 |
| `POST` | `/execute` | 执行白名单命令 | 否 |
| `POST` | `/config/commands` | 更新命令白名单（运行时） | 否 |
| `POST` | `/config/timeout` | 更新命令超时（运行时） | 否 |
| `GET` | `/docs` | Swagger API 文档 | 否 |
| `GET` | `/redoc` | ReDoc API 文档 | 否 |

### 健康检查

```bash
curl http://localhost:8007/healthz
```

响应示例（Standalone 模式）：
```json
{
  "status": "healthy",
  "mode": "standalone",
  "node_name": "dev-node",
  "allowed_commands": ["echo", "date", "ls", "python3"],
  "command_timeout": 15.0
}
```

响应示例（Worker 模式）：
```json
{
  "status": "healthy",
  "mode": "worker",
  "node_name": "worker-01",
  "node_id": "123e4567-e89b-12d3-a456-426614174000",
  "register_url": "http://master:8000",
  "allowed_commands": ["echo", "date", "ls", "python3"],
  "command_timeout": 15.0
}
```

### 执行命令

```bash
# 执行 echo 命令
curl -X POST http://localhost:8007/execute \
  -H "Content-Type: application/json" \
  -d '{
    "command": "echo",
    "args": ["Hello", "World"]
  }'
```

响应示例：
```json
{
  "command": "echo",
  "args": ["Hello", "World"],
  "exit_code": 0,
  "stdout": "Hello World\n",
  "stderr": "",
  "duration_ms": 12.5
}
```

### 运行时配置更新

```bash
# 更新命令白名单
curl -X POST http://localhost:8007/config/commands \
  -H "Content-Type: application/json" \
  -d '{
    "commands": ["echo", "date", "ls", "pwd", "python3", "node"]
  }'

# 更新命令超时
curl -X POST http://localhost:8007/config/timeout \
  -H "Content-Type: application/json" \
  -d '{
    "timeout": 30.0
  }'
```

### 错误处理

```json
// 命令不在白名单
{
  "detail": "Command 'rm' is not allowed"
}

// 命令执行失败
{
  "detail": "Command 'invalid_cmd' not found"
}
{
  "detail": "命令执行超时"
}

// 命令未找到
{
  "detail": "命令未找到，请检查容器或系统中是否已安装"
```

### Swagger 文档

访问 http://localhost:8007/docs 查看完整的交互式 API 文档。

---

## ⚙️ 配置

### 环境变量

#### 通用配置

| 变量 | 说明 | 默认值 | 必需 |
|------|------|--------|------|
| `NODE_MODE` | 运行模式 (`standalone`/`worker`) | `worker` | 否 |
| `NODE_NAME` | 节点名称 | 主机名 | 否 |
| `ALLOWED_COMMANDS` | 允许的命令白名单（逗号分隔） | `echo,date,ls` | 否 |
| `COMMAND_TIMEOUT` | 命令执行超时（秒） | `15` | 否 |
| `HOST` | 监听地址 | `0.0.0.0` | 否 |
| `PORT` | 监听端口 | `8007` | 否 |
| `LOG_LEVEL` | 日志级别 | `info` | 否 |
| `RELOAD` | 热重载（开发模式） | `false` | 否 |
| `AISE_ENV` | 环境标识 | `dev` | 否 |

#### Worker 模式专用

| 变量 | 说明 | 默认值 | 必需 |
|------|------|--------|------|
| `REGISTER_URL` | 主节点地址 | `http://localhost:8000` | 是 |
| `REGISTER_KEY` | 注册密钥 | `key` | 是 |
| `NODE_HOST` | 节点主机地址 | 自动检测 | 否 |
| `NODE_PORT` | 节点端口 | `8007` | 否 |
| `NODE_DESC` | 节点描述 | `AI-Software-Engineer` | 否 |
| `NODE_TAGS` | 节点标签（逗号分隔） | `worker,ai` | 否 |
| `HEARTBEAT_INTERVAL` | 心跳间隔（秒） | `30` | 否 |

### 配置示例

```bash
# .env 文件（Worker 模式）
NODE_MODE=worker
REGISTER_URL=http://192.168.1.100:8000
REGISTER_KEY=my-secret-key-2024
NODE_NAME=worker-prod-01
NODE_HOST=192.168.1.101
NODE_PORT=8007
NODE_DESC=Production Worker Node
NODE_TAGS=production,gpu,high-memory
HEARTBEAT_INTERVAL=30
ALLOWED_COMMANDS=echo,date,ls,pwd,cat,python3,node,npm,git
COMMAND_TIMEOUT=30
LOG_LEVEL=info
AISE_ENV=production

# .env 文件（Standalone 模式）
NODE_MODE=standalone
NODE_NAME=dev-node
ALLOWED_COMMANDS=echo,date,ls,pwd,python3,node
COMMAND_TIMEOUT=15
PORT=8007
LOG_LEVEL=debug
RELOAD=true
AISE_ENV=dev
```

---

## 📂 项目结构

```
ai-software-engineer/
├── 📄 README.md                     # 项目文档（本文件）
├── 📄 GETTING_STARTED.zh-CN.md      # 快速开始指南
├── 📄 LICENSE                       # 开源许可证
├── 📄 Makefile                      # 构建自动化
├── 📄 requirements.txt              # Python 依赖
├── 🚀 start.sh                      # 启动脚本
├── 🚀 start.ps1                     # PowerShell 启动脚本
│
├── 📁 app/                          # FastAPI 应用
│   ├── __init__.py
│   └── main.py                      # 主程序入口
│
├── 📁 docker/                       # Docker 相关文件
│   ├── Dockerfile                   # Docker 镜像定义
│   ├── docker-compose.yml           # Docker Compose 配置
│   ├── entrypoint.sh                # 容器入口脚本
│   ├── k8s-deployment.yaml          # Kubernetes 部署配置
│   ├── .env.example                 # 环境变量示例
│   └── 📁 scripts/                  # AI 工具安装脚本
│       ├── install-github-copilot.sh
│       ├── install-openai-codex.sh
│       ├── install-claude-code.sh
│       ├── install-cursor.sh
│       ├── install-opencode.sh
│       ├── install-alibaba-qoder.sh
│       └── install-tencent-codebuddy.sh
│
└── 📁 docs/                         # 文档目录（预留）
```

## 🎓 使用教程

### AI 工具配置

#### GitHub Copilot

```bash
# 进入容器
docker exec -it ai-worker bash

# 认证 GitHub
gh auth login

# 使用 Copilot
gh copilot suggest "create a REST API with Python FastAPI"
gh copilot explain "docker run -it --rm -v \$(pwd):/app ubuntu bash"
---

## 🎓 使用教程

### AI 工具配置

#### GitHub Copilot

```bash
# 进入容器
docker exec -it ai-worker bash

# 认证 GitHub
gh auth login

# 使用 Copilot
gh copilot suggest "create a REST API with Python FastAPI"
gh copilot explain "docker run -it --rm -v \$(pwd):/app ubuntu bash"
```

#### 其他工具

- **OpenAI Codex**: 参考 [OpenAI 文档](https://platform.openai.com/docs/)
- **Claude Code**: 访问 [Anthropic 官网](https://www.anthropic.com/)
- **Cursor**: 访问 [Cursor 官网](https://cursor.sh/)
- **Alibaba Qoder**: 访问 [阿里云 Qoder](https://www.alibabacloud.com/product/qoder)
- **Tencent Codebuddy**: 参考腾讯云官方文档
- **OpenCode**: 参考项目 GitHub 仓库

### 开发模式

```bash
# 本地开发（热重载）
./start.sh --no-reload=false

# 或使用 Docker（代码热加载）
docker run -it --rm \
  -e NODE_MODE=standalone \
  -e RELOAD=true \
  -v $(pwd)/app:/app \
  -p 8007:8007 \
  ai-software-engineer:latest

# 查看日志
docker logs -f ai-worker
tail -f ai-software-engineer.log
```

### 生产部署

```bash
# 使用 Kubernetes
kubectl apply -f docker/k8s-deployment.yaml
kubectl get pods -w

# 扩容到 10 个副本
kubectl scale deployment ai-worker --replicas=10

# 滚动更新
kubectl set image deployment/ai-worker \
  worker=ai-software-engineer:v2.0

# 查看状态
kubectl rollout status deployment/ai-worker
```

---

## 🔒 安全建议

### 命令白名单

⚠️ **重要**: 严格控制 `ALLOWED_COMMANDS`，仅包含安全命令

✅ **推荐的命令**:
```bash
echo, date, ls, pwd, cat, python3, node, npm, git status, docker ps
```

❌ **禁止的命令**:
```bash
rm, shutdown, reboot, dd, mkfs, fdisk
```

⚠️ **谨慎使用**:
```bash
curl, wget, apt, yum  # 仅在必要时添加
```

### 最佳实践

1. **最小权限**: 使用非 root 用户运行容器
2. **网络隔离**: 使用 Docker 网络隔离
3. **资源限制**: 设置 CPU 和内存限制
4. **密钥管理**: 使用环境变量或 Kubernetes Secrets
5. **日志审计**: 启用命令执行日志记录
6. **定期更新**: 及时更新基础镜像和依赖

### Docker 安全选项

```bash
docker run -d \
  --name ai-worker \
  --user 1000:1000 \
  --read-only \
  --security-opt=no-new-privileges \
  --cpus=2 \
  --memory=4g \
  -e NODE_MODE=standalone \
  -p 8007:8007 \
  ai-software-engineer:latest
```

---

## 🧪 测试

### 手动测试

```bash
# 测试 Standalone 模式
./start.sh --test-mode

# 测试健康检查
curl http://localhost:8007/healthz

# 测试命令执行
curl -X POST http://localhost:8007/execute \
  -H "Content-Type: application/json" \
  -d '{"command": "echo", "args": ["test"]}'

# 测试配置更新
curl -X POST http://localhost:8007/config/commands \
  -H "Content-Type: application/json" \
  -d '{"commands": ["echo", "date", "ls", "pwd"]}'
```

### 容器测试

```bash
# 构建并测试
make build
make run
make health-check

# 查看容器状态
docker ps --filter "name=ai-worker"
```

---

## 📊 监控和日志

### 查看日志

```bash
# 本地开发日志
tail -f ai-software-engineer.log

# Docker 容器日志
docker logs -f ai-worker
docker logs --tail 100 ai-worker

# Kubernetes 日志
kubectl logs -f deployment/ai-worker
kubectl logs -l app=ai-worker --tail=100
```

### 监控指标

```bash
# 容器资源使用
docker stats ai-worker

# Kubernetes 资源使用
kubectl top pods -l app=ai-worker
```

---

## 🔧 故障排除

### 常见问题

#### 1. Worker 模式无法注册

**症状**: 日志显示 `❌ 注册失败`

**解决方案**:
```bash
# 检查后端连接
curl $REGISTER_URL/healthz

# 验证配置
docker logs ai-worker | grep "后端地址"

# 检查网络连接
docker exec ai-worker curl -v $REGISTER_URL/healthz
```

#### 2. 命令执行被拒绝

**症状**: API 返回 `Command 'xxx' is not allowed`

**解决方案**:
```bash
# 方法1: 重启时添加命令到白名单
docker run -d \
  -e ALLOWED_COMMANDS=echo,date,ls,your-command \
  ...

# 方法2: 运行时更新白名单
curl -X POST http://localhost:8007/config/commands \
  -H "Content-Type: application/json" \
  -d '{"commands": ["echo", "date", "ls", "your-command"]}'
  -d '{"commands": ["echo", "date", "ls", "your-command"]}'
```

#### 3. 容器启动失败

**症状**: 容器不断重启

**解决方案**:
```bash
# 查看详细日志
docker logs ai-worker

# 检查端口占用
lsof -i :8007

# 使用不同端口
docker run -d -p 8008:8007 ...
```

#### 4. 端口冲突

**症状**: `Error: address already in use`

**解决方案**:
```bash
# 查找占用端口的进程
lsof -i :8007
netstat -anp | grep 8007

# 修改启动端口
./start.sh --port 8008
```

---

## 📚 文档资源

- 📖 [快速开始指南](./GETTING_STARTED.zh-CN.md) - 入门教程
- 📖 [Makefile 命令](./Makefile) - 构建和部署命令
- 📖 [API 文档](http://localhost:8007/docs) - Swagger 交互式文档
- 📖 [ReDoc 文档](http://localhost:8007/redoc) - 美化的 API 文档

---

## 🤝 贡献指南

欢迎贡献代码、报告问题或提出改进建议！

### 开发流程

```bash
# 1. Fork 项目
# 2. 克隆仓库
git clone https://github.com/your-username/ai-software-engineer.git

# 3. 创建特性分支
git checkout -b feature/amazing-feature

# 4. 提交更改
git commit -m "feat: Add amazing feature"

# 5. 推送到分支
git push origin feature/amazing-feature

# 6. 创建 Pull Request
```

### 代码规范

- **Python**: 遵循 PEP 8 规范
- **Shell**: 使用 ShellCheck 检查
- **Docker**: 遵循 Docker 最佳实践
- **提交信息**: 使用语义化提交 (feat/fix/docs/style/refactor/test/chore)

### 提交类型

- `feat`: 新功能
- `fix`: 修复 Bug
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建/工具链相关

---

## ⚠️ 注意事项

1. **AI 工具授权**: GitHub Copilot、OpenAI Codex 等工具需要有效订阅
2. **网络要求**: 部分工具需要互联网连接才能使用
3. **存储空间**: 完整镜像约 2-3 GB，最小化镜像约 1 GB
4. **定期更新**: 建议定期重新构建镜像以获取最新工具版本
5. **安全风险**: 严格控制命令白名单，避免执行危险命令
6. **日志管理**: 生产环境建议使用日志收集系统
7. **资源限制**: 生产环境建议设置容器资源限制

---

## 📄 许可证

本项目采用 [MIT License](LICENSE) 开源协议。

---

## 🔗 相关链接

### 官方网站
- [GitHub Copilot](https://github.com/features/copilot)
- [OpenAI Platform](https://platform.openai.com/)
- [Anthropic Claude](https://www.anthropic.com/)
- [Cursor](https://cursor.sh/)
- [Alibaba Qoder](https://www.alibabacloud.com/product/qoder)
- [FastAPI](https://fastapi.tiangolo.com/)

### 技术文档
- [Docker 文档](https://docs.docker.com/)
- [Kubernetes 文档](https://kubernetes.io/docs/)
- [Python 文档](https://docs.python.org/3/)
- [Node.js 文档](https://nodejs.org/docs/)

### 项目相关
- [GitHub 仓库](https://github.com/liukunup-ai/ai-software-engineer)
- [问题反馈](https://github.com/liukunup-ai/ai-software-engineer/issues)
- [更新日志](https://github.com/liukunup-ai/ai-software-engineer/releases)

---

<div align="center">

**如果这个项目对你有帮助，请给个 ⭐ Star 支持一下！**

Made with ❤️ by [liukunup](https://github.com/liukunup-ai)

</div>