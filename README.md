# AI Software Engineer

<div align="center">

[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.110+-009688?logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![Python](https://img.shields.io/badge/Python-3.11+-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Ready-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**集成多种 AI 编程助手的智能工作节点**

支持独立运行和集群部署 | 安全的命令执行 | 完整的 API 服务

[快速开始](#-快速开始) • [功能特性](#-功能特性) • [部署指南](#-部署方式) • [API 文档](#-api-文档) • [配置说明](#-配置)

</div>

---

## 📖 简介

AI Software Engineer 是一个基于 Docker 的智能工作节点，集成了多种主流 AI 编程助手工具，并提供 FastAPI 后端服务用于安全地执行白名单命令。

### 核心特性

- 🎯 **双模式运行**: Standalone（独立）和 Worker（集群）两种模式
- 🔒 **安全执行**: 基于白名单的命令执行机制
- 🚀 **开箱即用**: 一键启动脚本，快速部署
- 📊 **完整监控**: 健康检查、心跳上报、状态追踪
- ☸️ **云原生**: 支持 Docker、Docker Compose、Kubernetes
- 🤖 **AI 集成**: GitHub Copilot、Qoder、Cursor、Trae 等工具

---

## 🎯 快速开始

### 前置要求

- Docker 20.10+
- (可选) Docker Compose 2.0+
- (可选) Kubernetes 1.20+

### 1️⃣ Standalone 模式（推荐用于开发/测试）

最简单的方式，无需任何依赖即可运行：

```bash
# 克隆仓库
git clone https://github.com/liukunup-ai/ai-software-engineer.git
cd ai-software-engineer

# 一键启动
./start-standalone.sh
```

或使用 Docker 命令：

```bash
docker run -d \
  --name ai-worker \
  -e WORKER_MODE=standalone \
  -p 8000:8000 \
  ai-software-engineer:latest
```

访问服务：
- API 文档: http://localhost:8000/docs
- 健康检查: http://localhost:8000/health

### 2️⃣ Worker 模式（推荐用于生产环境）

作为从节点接入集群：

```bash
# 配置后端地址和密钥
export BACKEND_URL=http://master-node:8001
export REGISTRATION_KEY=your-secret-key

# 启动单个节点
./start-worker.sh

# 或启动多个节点
./start-worker.sh 1  # 端口 8001
./start-worker.sh 2  # 端口 8002
./start-worker.sh 3  # 端口 8003
```

---

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
    <td align="center"><b>Alibaba Qoder</b><br/>阿里云代码助手</td>
  </tr>
  <tr>
    <td align="center"><b>Cursor</b><br/>AI 代码编辑器</td>
    <td align="center"><b>ByteDance Trae</b><br/>字节跳动助手</td>
  </tr>
</table>

### 技术栈

- **基础镜像**: Ubuntu 24.04 LTS
- **运行时**: Python 3.11 + Node.js 22.x
- **框架**: FastAPI 0.110+ + Uvicorn
- **HTTP 客户端**: httpx 0.27+
- **容器化**: Docker + Docker Compose
- **编排**: Kubernetes (可选)

---

## 📦 包含的工具

### 系统工具
```bash
├── Ubuntu 24.04 LTS
├── Python 3.11
├── Node.js 22.x
├── Git
├── curl, wget
├── vim, nano
└── 其他常用 CLI 工具
```

### AI 编程助手
```bash
# GitHub Copilot
gh copilot suggest "your task"
gh copilot explain "complex command"

# Alibaba Qoder
qoder help

# Cursor
cursor help

# ByteDance Trae
trae help
```

---

## 🛠 部署方式

### 方式 1: 快速启动脚本

```bash
# Standalone 模式
./start-standalone.sh

# Worker 模式
export BACKEND_URL=http://master:8001
export REGISTRATION_KEY=secret
./start-worker.sh
```

### 方式 2: Docker 命令

```bash
# Standalone
docker run -d \
  --name ai-standalone \
  -e WORKER_MODE=standalone \
  -e ALLOWED_COMMANDS=echo,date,ls,python3,node \
  -p 8000:8000 \
  ai-software-engineer:latest

# Worker
docker run -d \
  --name ai-worker \
  -e WORKER_MODE=worker \
  -e BACKEND_URL=http://master:8001 \
  -e REGISTRATION_KEY=your-key \
  -e NODE_NAME=worker-1 \
  -e NODE_IP=auto \
  -p 8000:8000 \
  ai-software-engineer:latest
```

### 方式 3: Docker Compose

```yaml
version: '3.8'

services:
  ai-worker:
    build: .
    environment:
      WORKER_MODE: standalone
      ALLOWED_COMMANDS: echo,date,ls,pwd,python3,node
      LOG_LEVEL: info
    ports:
      - "8000:8000"
    restart: unless-stopped
```

```bash
docker-compose up -d
```

### 方式 4: Kubernetes

```bash
# 部署
kubectl apply -f k8s-deployment.yaml

# 扩容
kubectl scale deployment ai-worker --replicas=10

# 查看状态
kubectl get pods -l app=ai-worker
```

详细配置参见 [k8s-deployment.yaml](./k8s-deployment.yaml)

---

## 🔨 构建镜像

### 本地构建

```bash
# 克隆仓库
git clone https://github.com/liukunup-ai/ai-software-engineer.git
cd ai-software-engineer

# 构建镜像
docker build -t ai-software-engineer:latest .

# 或使用 Make
make build
```

### 自定义构建

```bash
# 指定镜像名称和标签
docker build -t myorg/ai-worker:v1.0 .

# 使用构建参数
docker build \
  --build-arg PYTHON_VERSION=3.11 \
  --build-arg NODE_VERSION=22 \
  -t ai-software-engineer:custom .
```

---

---

## � API 文档

### 端点列表

| 方法 | 路径 | 描述 | 认证 |
|------|------|------|------|
| `GET` | `/health` | 健康检查，返回节点状态 | 否 |
| `POST` | `/execute` | 执行白名单命令 | 否 |
| `GET` | `/docs` | Swagger API 文档 | 否 |

### 健康检查

```bash
curl http://localhost:8000/health
```

响应示例：
```json
{
  "status": "ok",
  "mode": "standalone",
  "node_name": "dev-node",
  "node_id": null,
  "registered": false,
  "backend_url": null,
  "allowed_commands": ["date", "echo", "ls", "pwd"]
}
```

### 执行命令

```bash
# 执行 echo 命令
curl -X POST http://localhost:8000/execute \
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
  "duration_ms": 12
}
```

### 错误处理

```json
// 命令不在白名单
{
  "detail": "命令 'rm' 不在白名单中"
}

// 命令执行超时
{
  "detail": "命令执行超时"
}

// 命令未找到
{
  "detail": "命令未找到，请检查容器或系统中是否已安装"
}
```

### Swagger 文档

访问 http://localhost:8000/docs 查看完整的交互式 API 文档。

---

## ⚙️ 配置

### 环境变量

#### 通用配置

| 变量 | 说明 | 默认值 | 必需 |
|------|------|--------|------|
| `WORKER_MODE` | 运行模式 (`standalone`/`worker`) | `worker` | 否 |
| `NODE_NAME` | 节点名称 | 主机名 | 否 |
| `ALLOWED_COMMANDS` | 允许的命令白名单（逗号分隔） | `echo,date,ls` | 否 |
| `CMD_TIMEOUT` | 命令执行超时（秒） | `15` | 否 |
| `HOST` | 监听地址 | `0.0.0.0` | 否 |
| `PORT` | 监听端口 | `8000` | 否 |
| `LOG_LEVEL` | 日志级别 | `info` | 否 |

#### Worker 模式专用

| 变量 | 说明 | 默认值 | 必需 |
|------|------|--------|------|
| `BACKEND_URL` | 主节点地址 | `http://localhost:8001` | 是 |
| `REGISTRATION_KEY` | 注册密钥 | `default-key` | 是 |
| `NODE_IP` | 节点 IP（可设为 `auto`） | `127.0.0.1` | 是 |
| `NODE_DESCRIPTION` | 节点描述 | `AI Software Engineer Worker Node` | 否 |
| `NODE_TAGS` | 节点标签（逗号分隔） | 空 | 否 |
| `HEARTBEAT_INTERVAL` | 心跳间隔（秒） | `30` | 否 |
| `WAIT_FOR_BACKEND` | 等待后端就绪 | `false` | 否 |

### 配置示例

```bash
# .env 文件
WORKER_MODE=worker
BACKEND_URL=http://192.168.1.100:8001
REGISTRATION_KEY=my-secret-key-2024
NODE_NAME=worker-prod-01
NODE_IP=auto
NODE_DESCRIPTION=Production Worker Node
NODE_TAGS=production,gpu,high-memory
HEARTBEAT_INTERVAL=30
ALLOWED_COMMANDS=echo,date,ls,pwd,cat,python3,node,npm,git
CMD_TIMEOUT=30
LOG_LEVEL=info
```

---

---

## 📂 项目结构

```
ai-software-engineer/
├── 📄 Dockerfile                    # Docker 镜像定义
├── 📄 docker-compose.yml            # Docker Compose 配置
├── 📄 docker-entrypoint.sh          # 容器入口脚本
├── 📄 Makefile                      # 构建自动化
├── 📄 requirements.txt              # Python 依赖
│
├── 📁 app/                          # FastAPI 应用
│   └── main.py                      # 主程序入口
│
├── 📁 scripts/                      # 安装脚本
│   ├── install-github-copilot.sh
│   ├── install-alibaba-qoder.sh
│   ├── install-cursor.sh
│   ├── install-tencent-codebuddy.sh
│   └── entrypoint.sh
│
├── 🚀 start-standalone.sh           # Standalone 模式启动
├── 🚀 start-worker.sh               # Worker 模式启动
├── 🧪 test-modes.sh                 # 模式测试脚本
│
├── 📁 docs/                         # 文档
│   ├── WORKER_MODES.md              # 模式详细说明
│   ├── QUICK_START.md               # 快速开始指南
│   └── IMPLEMENTATION_SUMMARY.md    # 实现总结
│
├── ☸️ k8s-deployment.yaml           # Kubernetes 部署配置
├── 📄 .env.example                  # 环境变量示例
└── 📄 README.md                     # 项目文档（本文件）
```

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

- **Qoder**: 访问 [阿里云 Qoder](https://www.alibabacloud.com/product/qoder)
- **Cursor**: 访问 [Cursor 官网](https://cursor.sh/)
- **Trae**: 参考字节跳动官方文档

### 开发模式

```bash
# 启动开发环境（代码热加载）
docker run -it --rm \
  -e WORKER_MODE=standalone \
  -e RELOAD=true \
  -v $(pwd)/app:/app/app \
  -p 8000:8000 \
  ai-software-engineer:latest

# 查看日志
docker logs -f ai-worker
```

### 生产部署

```bash
# 使用 Kubernetes
kubectl apply -f k8s-deployment.yaml
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
echo, date, ls, pwd, cat, python3, node, npm, git status
```

❌ **禁止的命令**:
```bash
rm, shutdown, reboot, curl, wget, apt, yum, systemctl
```

### 最佳实践

1. **最小权限**: 使用非 root 用户运行容器
2. **网络隔离**: 使用 Docker 网络隔离
3. **资源限制**: 设置 CPU 和内存限制
4. **密钥管理**: 使用 Kubernetes Secrets 管理敏感信息
5. **日志审计**: 启用命令执行日志记录

### Docker 安全选项

```bash
docker run -d \
  --name ai-worker \
  --user 1000:1000 \
  --read-only \
  --security-opt=no-new-privileges \
  --cpus=2 \
  --memory=4g \
  -e WORKER_MODE=standalone \
  -p 8000:8000 \
  ai-software-engineer:latest
```

---

## 🧪 测试

### 运行测试

```bash
# 自动化测试两种模式
./test-modes.sh

# 单独测试 Standalone
docker run --rm \
  -e WORKER_MODE=standalone \
  -p 18000:8000 \
  ai-software-engineer:latest

# 测试 API
curl http://localhost:18000/health
curl -X POST http://localhost:18000/execute \
  -H "Content-Type: application/json" \
  -d '{"command": "echo", "args": ["test"]}'
```

### 健康检查

```bash
# 容器健康状态
docker ps --filter "name=ai-worker" --format "table {{.Names}}\t{{.Status}}"

# API 健康检查
curl http://localhost:8000/health | jq
```

---

## 📊 监控和日志

### 查看日志

```bash
# Docker
docker logs -f ai-worker
docker logs --tail 100 ai-worker

# Kubernetes
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

**症状**: 日志显示 `❌ 注册到后端失败`

**解决方案**:
```bash
# 检查后端连接
curl $BACKEND_URL/health

# 验证配置
docker logs ai-worker | grep "后端地址"

# 启用等待后端
docker run -d \
  -e WAIT_FOR_BACKEND=true \
  ...
```

#### 2. 命令执行被拒绝

**症状**: API 返回 `命令不在白名单中`

**解决方案**:
```bash
# 添加命令到白名单
docker run -d \
  -e ALLOWED_COMMANDS=echo,date,ls,your-command \
  ...
```

#### 3. 容器启动失败

**症状**: 容器不断重启

**解决方案**:
```bash
# 查看详细日志
docker logs ai-worker

# 检查端口占用
lsof -i :8000

# 使用不同端口
docker run -d -p 8001:8000 ...
```

---

## 📚 文档资源

- 📖 [快速开始指南](./QUICK_START.md) - 常用命令和示例
- 📖 [启动模式详解](./WORKER_MODES.md) - 完整配置说明
- 📖 [实现总结](./IMPLEMENTATION_SUMMARY.md) - 技术细节
- 📖 [API 文档](http://localhost:8000/docs) - Swagger 交互式文档

---

## 🤝 贡献指南

欢迎贡献代码、报告问题或提出改进建议！

### 开发流程

```bash
# 1. Fork 项目
# 2. 创建特性分支
git checkout -b feature/amazing-feature

# 3. 提交更改
git commit -m "Add amazing feature"

# 4. 推送到分支
git push origin feature/amazing-feature

# 5. 创建 Pull Request
```

### 代码规范

- Python: 遵循 PEP 8
- Shell: 使用 ShellCheck 检查
- Docker: 遵循最佳实践
- 提交信息: 使用语义化提交

---

## ⚠️ 注意事项

1. **AI 工具授权**: GitHub Copilot 等工具需要有效订阅
2. **网络要求**: 部分工具需要互联网连接
3. **存储空间**: 镜像约 2-3 GB，确保足够空间
4. **定期更新**: 重新构建镜像以获取最新工具版本
5. **安全风险**: 严格控制命令白名单，避免安全漏洞

---

## 📄 许可证

本项目采用 [MIT License](LICENSE) 开源协议。

---

## 🔗 相关链接

### 官方网站
- [GitHub Copilot](https://github.com/features/copilot)
- [Alibaba Qoder](https://www.alibabacloud.com/product/qoder)
- [Cursor](https://cursor.sh/)
- [FastAPI](https://fastapi.tiangolo.com/)

### 技术文档
- [Docker 文档](https://docs.docker.com/)
- [Kubernetes 文档](https://kubernetes.io/docs/)
- [Python 文档](https://docs.python.org/3/)

---

<div align="center">

**如果这个项目对你有帮助，请给个 ⭐ Star 支持一下！**

Made with ❤️ by [liukunup](https://github.com/liukunup-ai)

</div>