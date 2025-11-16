# 快速开始指南

欢迎使用 AI Software Engineer 项目！本项目集成多种 AI 编程助手 CLI 工具，并内置一个安全的 FastAPI 后端服务。

---

## 1. 环境准备

建议使用 Python 3.11+，并安装 Docker 以便体验全部功能。

### 克隆仓库
```bash
git clone https://github.com/liukunup-ai/ai-software-engineer.git
cd ai-software-engineer
```

### 创建虚拟环境并安装依赖
```bash
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

---

## 2. 启动 FastAPI 后端服务

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### 健康检查
```bash
curl -X GET http://127.0.0.1:8000/health
```

### 执行白名单命令
```bash
curl -X POST http://127.0.0.1:8000/run \
  -H 'Content-Type: application/json' \
  -d '{"command":"echo","args":["hello","world"]}'
```

---

## 3. Docker 镜像与容器

### 构建镜像
```bash
docker build -t ai-software-engineer .
```

### 运行容器
```bash
docker run -it --rm ai-software-engineer
```

### 挂载当前目录
```bash
docker run -it --rm -v $(pwd):/workspace ai-software-engineer
```

---

## 4. 命令白名单与安全

- 默认允许命令：`echo`, `date`, `ls`
- 可通过环境变量自定义：
  ```bash
  export ALLOWED_COMMANDS="echo,date,ls"
  export CMD_TIMEOUT=10  # 单位：秒
  ```
- 强烈建议仅允许安全、无副作用的命令。

---

## 5. 常见问题

- **命令不在白名单**：请检查 `ALLOWED_COMMANDS` 环境变量。
- **依赖未安装**：请确保已激活虚拟环境并安装 requirements.txt。
- **端口冲突**：如 8000 被占用，可修改 `uvicorn` 启动参数。

---

## 6. 贡献与反馈

欢迎通过 Issue 或 Pull Request 参与项目改进！

---

## 7. 相关链接

- [GitHub Copilot](https://github.com/features/copilot)
- [Alibaba Qoder](https://www.alibabacloud.com/product/qoder)
- [Cursor](https://cursor.sh/)
- [ByteDance Trae](https://www.bytedance.com/)

---

如需英文版或更详细文档，请查阅 `README.md`。
