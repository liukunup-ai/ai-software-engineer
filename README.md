# AI Software Engineer

一个集成多种AI编程助手CLI工具的Docker镜像，基于Ubuntu构建。

## 🚀 特性

这个Docker镜像包含以下AI编程助手CLI工具：

- **GitHub Copilot CLI** - GitHub官方的AI编程助手命令行界面
- **Cursor CLI** - AI驱动的代码编辑器命令行工具
- **ByteDance Trae CLI** - 字节跳动的AI代码助手
- **Alibaba Qoder CLI** - 阿里巴巴的AI代码助手

## 📦 包含的工具

### 系统工具
- Ubuntu 22.04 LTS
- Node.js 20.x
- Python 3.11
- Git
- curl, wget, vim, nano 等常用工具

### AI编程工具
- **GitHub Copilot CLI**: `gh copilot suggest "your task"`
- **Qoder CLI**: `qoder help`
- **Cursor CLI**: `cursor help`
- **Trae CLI**: `trae help`

## 🛠 构建和使用

### 构建镜像

```bash
# 克隆仓库
git clone https://github.com/liukunup-ai/ai-software-engineer.git
cd ai-software-engineer

# 构建Docker镜像
docker build -t ai-software-engineer .

# 或使用make命令
make build
```

### 运行容器

```bash
# 交互式运行
docker run -it --rm ai-software-engineer

# 挂载当前目录
docker run -it --rm -v $(pwd):/workspace ai-software-engineer

# 运行特定命令
docker run --rm ai-software-engineer gh copilot suggest "create a Python function"
```

### 使用Docker Compose

```bash
# 启动开发环境
docker-compose up -d

# 进入容器
docker-compose exec aidev bash
```

## 🔧 配置

### GitHub Copilot 设置
容器启动后，需要先认证GitHub：

```bash
gh auth login
```

然后就可以使用GitHub Copilot CLI：

```bash
# 获取代码建议
gh copilot suggest "create a REST API with Python Flask"

# 解释命令
gh copilot explain "docker run -it --rm -v \$(pwd):/app ubuntu bash"
```

### 其他工具配置
- **Qoder**: 根据阿里巴巴官方文档配置
- **Cursor**: 访问 https://cursor.sh/ 了解更多
- **Trae**: 根据字节跳动官方文档配置

## 📂 项目结构

```
ai-software-engineer/
├── Dockerfile              # 主Docker镜像定义
├── docker-compose.yml      # Docker Compose配置
├── Makefile                # 构建自动化脚本
├── scripts/                # 安装脚本目录
│   ├── install-github-copilot.sh
│   ├── install-qoder.sh
│   ├── install-cursor.sh
│   ├── install-trae.sh
│   └── entrypoint.sh       # 容器入口脚本
├── .dockerignore           # Docker忽略文件
└── README.md              # 项目文档
```

## 🔍 健康检查

容器启动时会自动运行健康检查，显示所有工具的安装状态。

## ⚠️ 注意事项

1. **GitHub Copilot**: 需要有效的GitHub Copilot订阅
2. **网络访问**: 某些工具需要网络连接进行认证和使用
3. **存储空间**: 镜像包含多个工具，确保有足够的存储空间
4. **更新**: 定期重新构建镜像以获取最新版本的工具

## 🤝 贡献

欢迎提交Issue和Pull Request来改进这个项目！

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件。

## 🔗 相关链接

- [GitHub Copilot](https://github.com/features/copilot)
- [Alibaba Qoder](https://www.alibabacloud.com/product/qoder)
- [Cursor](https://cursor.sh/)
- [ByteDance Trae](https://www.bytedance.com/)