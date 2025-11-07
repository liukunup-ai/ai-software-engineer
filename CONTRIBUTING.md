# 贡献指南

感谢您对 AI Software Engineer Docker Image 项目的兴趣！我们欢迎所有形式的贡献。

## 🚀 快速开始

1. Fork 此仓库
2. 克隆您的 fork 到本地
3. 安装依赖（Docker）
4. 创建功能分支
5. 进行更改
6. 测试您的更改
7. 提交 Pull Request

## 📋 开发环境设置

### 前置要求

- Docker 20.10+
- Docker Compose 2.0+
- Make (可选，用于简化命令)
- Git

### 本地开发

```bash
# 克隆仓库
git clone https://github.com/liukunup-ai/ai-software-engineer.git
cd ai-software-engineer

# 构建和运行
./dev.sh setup
./dev.sh dev
```

## 🔧 项目结构

```
ai-software-engineer/
├── Dockerfile              # 主Docker镜像
├── docker-compose.yml      # Docker Compose配置
├── Makefile                # 构建自动化
├── scripts/                # 安装脚本
│   ├── install-*.sh        # 各工具安装脚本
│   └── entrypoint.sh       # 容器入口脚本
├── .github/                # GitHub Actions
├── dev.sh                  # 开发助手脚本
└── docs/                   # 文档
```

## 🎯 贡献类型

### 🐛 Bug 修复
- 在 Issues 中报告 bug
- 提供重现步骤
- 包含系统信息
- 提交修复的 PR

### ✨ 新功能
- 先在 Issues 中讨论
- 遵循项目架构
- 添加适当的测试
- 更新文档

### 📚 文档改进
- 修复错别字
- 改进说明
- 添加使用示例
- 翻译文档

### 🔧 工具集成
- 添加新的 AI CLI 工具
- 改进现有工具集成
- 优化安装脚本

## 📝 编码规范

### Shell 脚本
- 使用 `#!/bin/bash`
- 设置 `set -e` 用于错误处理
- 添加注释说明功能
- 使用 shellcheck 检查语法

### Dockerfile
- 使用多阶段构建（如适用）
- 最小化镜像层数
- 正确设置用户权限
- 清理临时文件

### 文档
- 使用中文或英文
- 保持格式一致
- 包含代码示例
- 更新相关文档

## 🧪 测试

### 本地测试
```bash
# 构建测试
make test

# 运行特定测试
./dev.sh test

# 手动测试
make run-interactive
```

### CI/CD
- GitHub Actions 自动运行
- 包含构建测试
- 安全扫描
- 代码质量检查

## 📤 提交 Pull Request

### PR 标题格式
- `feat: 添加新功能描述`
- `fix: 修复bug描述`
- `docs: 文档更新描述`
- `refactor: 重构描述`

### PR 描述模板
```markdown
## 变更类型
- [ ] Bug 修复
- [ ] 新功能
- [ ] 文档更新
- [ ] 重构
- [ ] 其他

## 描述
简要描述您的更改...

## 测试
- [ ] 本地测试通过
- [ ] CI 测试通过
- [ ] 手动测试完成

## 截图（如适用）
...

## 检查清单
- [ ] 代码遵循项目规范
- [ ] 自测试通过
- [ ] 文档已更新
- [ ] 无新的警告
```

## 🔍 代码审查

### 审查标准
- 代码质量
- 安全性
- 性能影响
- 文档完整性
- 测试覆盖

### 反馈处理
- 及时响应审查意见
- 友善讨论技术问题
- 根据反馈改进代码

## 🎉 认可贡献者

我们会在以下地方认可贡献者：
- README.md 中的贡献者列表
- 发布说明中的致谢
- GitHub Discussions 中的特殊感谢

## 📞 获取帮助

如果您需要帮助或有疑问：

1. 查看现有的 [Issues](https://github.com/liukunup-ai/ai-software-engineer/issues)
2. 创建新的 Issue
3. 在 [Discussions](https://github.com/liukunup-ai/ai-software-engineer/discussions) 中讨论
4. 发送邮件至项目维护者

## 📜 行为准则

请遵循我们的行为准则：
- 保持尊重和包容
- 建设性的反馈
- 协作而非对立
- 帮助他人学习

感谢您的贡献！🙏