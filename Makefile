.PHONY: help build run run-dev run-interactive clean push pull test health-check

# 默认镜像名称和标签
IMAGE_NAME ?= ai-software-engineer
IMAGE_TAG ?= latest
FULL_IMAGE_NAME = $(IMAGE_NAME):$(IMAGE_TAG)

# 默认容器名称
CONTAINER_NAME ?= aise-worker-node

# Docker Hub 或其他注册表的用户名（可选）
REGISTRY_USERNAME ?= 

# 颜色定义（用于美化输出）
BLUE = \033[0;34m
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

help: ## 显示帮助信息
	@echo "$(BLUE)AI Software Engineer Docker Image$(NC)"
	@echo "$(BLUE)=================================$(NC)"
	@echo ""
	@echo "$(GREEN)可用命令:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(GREEN)环境变量:$(NC)"
	@echo "  $(YELLOW)IMAGE_NAME$(NC)      镜像名称 (默认: $(IMAGE_NAME))"
	@echo "  $(YELLOW)IMAGE_TAG$(NC)       镜像标签 (默认: $(IMAGE_TAG))"
	@echo "  $(YELLOW)CONTAINER_NAME$(NC)  容器名称 (默认: $(CONTAINER_NAME))"

build: ## 构建镜像
	@echo "$(BLUE)构建 Docker 镜像: $(FULL_IMAGE_NAME)$(NC)"
	docker build -f docker/Dockerfile -t $(FULL_IMAGE_NAME) .
	@echo "$(GREEN)✓ 镜像构建完成!$(NC)"

build-no-cache: ## 强制重新构建（不使用缓存）
	@echo "$(BLUE)强制重新构建 Docker 镜像: $(FULL_IMAGE_NAME)$(NC)"
	docker build --no-cache -f docker/Dockerfile -t $(FULL_IMAGE_NAME) .
	@echo "$(GREEN)✓ 镜像构建完成!$(NC)"

run: ## 运行容器（后台模式）
	@echo "$(BLUE)启动容器: $(CONTAINER_NAME)$(NC)"
	docker run -d -e REGISTER_URL="http://192.168.101.168:8000" -e REGISTER_KEY="zgCdSL9imWQhl9L9xZPeK1U_eprXqeAzKEs99jSHUZ0" -e NODE_HOST="192.168.101.168" -e TZ=Asia/Shanghai --restart unless-stopped --name $(CONTAINER_NAME) $(FULL_IMAGE_NAME)
	@echo "$(GREEN)✓ 容器已启动!$(NC)"

run-interactive: ## 交互式运行容器
	@echo "$(BLUE)交互式运行容器$(NC)"
	docker run -it --rm -e REGISTER_URL="http://192.168.101.168:8000" -e REGISTER_KEY="zgCdSL9imWQhl9L9xZPeK1U_eprXqeAzKEs99jSHUZ0" -e NODE_HOST="192.168.101.168" -e TZ=Asia/Shanghai $(FULL_IMAGE_NAME)

exec: ## 进入运行中的容器
	@echo "$(BLUE)进入容器: $(CONTAINER_NAME)$(NC)"
	docker exec -it $(CONTAINER_NAME) bash

stop: ## 停止容器
	@echo "$(BLUE)停止容器: $(CONTAINER_NAME)$(NC)"
	-docker stop $(CONTAINER_NAME)
	@echo "$(GREEN)✓ 容器已停止!$(NC)"

remove: stop ## 删除容器
	@echo "$(BLUE)删除容器: $(CONTAINER_NAME)$(NC)"
	-docker rm $(CONTAINER_NAME)
	@echo "$(GREEN)✓ 容器已删除!$(NC)"

clean: remove ## 清理容器和镜像
	@echo "$(BLUE)清理镜像: $(FULL_IMAGE_NAME)$(NC)"
	-docker rmi $(FULL_IMAGE_NAME)
	@echo "$(GREEN)✓ 清理完成!$(NC)"

logs: ## 查看容器日志
	@echo "$(BLUE)查看容器日志: $(CONTAINER_NAME)$(NC)"
	docker logs -f $(CONTAINER_NAME)

shellcheck: ## 检查shell脚本语法
	@echo "$(BLUE)检查 shell 脚本语法$(NC)"
	find docker/ -name "*.sh" -exec shellcheck {} \; || echo -e "$(YELLOW)警告: shellcheck 未安装，跳过语法检查$(NC)"

# 快速开始
quick-start: build run
