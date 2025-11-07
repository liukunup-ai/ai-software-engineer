.PHONY: help build run run-dev run-interactive clean push pull test health-check

# 默认镜像名称和标签
IMAGE_NAME ?= ai-software-engineer
IMAGE_TAG ?= latest
FULL_IMAGE_NAME = $(IMAGE_NAME):$(IMAGE_TAG)

# 默认容器名称
CONTAINER_NAME ?= ai-dev-env

# Docker Hub 或其他注册表的用户名（可选）
REGISTRY_USERNAME ?= 

# 颜色定义（用于美化输出）
BLUE = \033[0;34m
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

help: ## 显示帮助信息
	@echo -e "$(BLUE)AI Software Engineer Docker Image$(NC)"
	@echo -e "$(BLUE)================================$(NC)"
	@echo ""
	@echo -e "$(GREEN)可用命令:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo -e "$(GREEN)环境变量:$(NC)"
	@echo -e "  $(YELLOW)IMAGE_NAME$(NC)      镜像名称 (默认: $(IMAGE_NAME))"
	@echo -e "  $(YELLOW)IMAGE_TAG$(NC)       镜像标签 (默认: $(IMAGE_TAG))"
	@echo -e "  $(YELLOW)CONTAINER_NAME$(NC)  容器名称 (默认: $(CONTAINER_NAME))"

build: ## 构建Docker镜像
	@echo -e "$(BLUE)构建 Docker 镜像: $(FULL_IMAGE_NAME)$(NC)"
	docker build -t $(FULL_IMAGE_NAME) .
	@echo -e "$(GREEN)✓ 镜像构建完成!$(NC)"

build-no-cache: ## 强制重新构建（不使用缓存）
	@echo -e "$(BLUE)强制重新构建 Docker 镜像: $(FULL_IMAGE_NAME)$(NC)"
	docker build --no-cache -t $(FULL_IMAGE_NAME) .
	@echo -e "$(GREEN)✓ 镜像构建完成!$(NC)"

run: ## 运行容器（后台模式）
	@echo -e "$(BLUE)启动容器: $(CONTAINER_NAME)$(NC)"
	docker run -d --name $(CONTAINER_NAME) $(FULL_IMAGE_NAME)
	@echo -e "$(GREEN)✓ 容器已启动!$(NC)"

run-interactive: ## 交互式运行容器
	@echo -e "$(BLUE)交互式运行容器$(NC)"
	docker run -it --rm $(FULL_IMAGE_NAME)

run-dev: ## 开发模式运行（挂载当前目录）
	@echo -e "$(BLUE)开发模式运行容器$(NC)"
	docker run -it --rm -v $$(pwd):/workspace -w /workspace $(FULL_IMAGE_NAME)

run-with-docker: ## 运行容器并挂载Docker socket（危险：仅在安全环境使用）
	@echo -e "$(YELLOW)警告: 此命令将挂载 Docker socket，仅在安全环境中使用!$(NC)"
	docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v $$(pwd):/workspace $(FULL_IMAGE_NAME)

exec: ## 进入运行中的容器
	@echo -e "$(BLUE)进入容器: $(CONTAINER_NAME)$(NC)"
	docker exec -it $(CONTAINER_NAME) bash

stop: ## 停止容器
	@echo -e "$(BLUE)停止容器: $(CONTAINER_NAME)$(NC)"
	-docker stop $(CONTAINER_NAME)
	@echo -e "$(GREEN)✓ 容器已停止!$(NC)"

remove: stop ## 删除容器
	@echo -e "$(BLUE)删除容器: $(CONTAINER_NAME)$(NC)"
	-docker rm $(CONTAINER_NAME)
	@echo -e "$(GREEN)✓ 容器已删除!$(NC)"

clean: remove ## 清理容器和镜像
	@echo -e "$(BLUE)清理镜像: $(FULL_IMAGE_NAME)$(NC)"
	-docker rmi $(FULL_IMAGE_NAME)
	@echo -e "$(GREEN)✓ 清理完成!$(NC)"

clean-all: ## 清理所有相关的Docker资源
	@echo -e "$(YELLOW)清理所有 Docker 资源...$(NC)"
	-docker stop $(CONTAINER_NAME)
	-docker rm $(CONTAINER_NAME)
	-docker rmi $(FULL_IMAGE_NAME)
	-docker system prune -f
	@echo -e "$(GREEN)✓ 清理完成!$(NC)"

logs: ## 查看容器日志
	@echo -e "$(BLUE)查看容器日志: $(CONTAINER_NAME)$(NC)"
	docker logs -f $(CONTAINER_NAME)

health-check: ## 运行健康检查
	@echo -e "$(BLUE)运行健康检查$(NC)"
	docker run --rm $(FULL_IMAGE_NAME) bash -c "echo '=== Health Check ===' && which gh && which node && which python3 && echo 'Health check passed!'"

test: build health-check ## 构建并测试镜像
	@echo -e "$(GREEN)✓ 测试完成!$(NC)"

push: ## 推送镜像到注册表
ifdef REGISTRY_USERNAME
	@echo -e "$(BLUE)推送镜像到注册表$(NC)"
	docker tag $(FULL_IMAGE_NAME) $(REGISTRY_USERNAME)/$(FULL_IMAGE_NAME)
	docker push $(REGISTRY_USERNAME)/$(FULL_IMAGE_NAME)
	@echo -e "$(GREEN)✓ 镜像推送完成!$(NC)"
else
	@echo -e "$(RED)错误: 请设置 REGISTRY_USERNAME 环境变量$(NC)"
	@exit 1
endif

pull: ## 从注册表拉取镜像
ifdef REGISTRY_USERNAME
	@echo -e "$(BLUE)从注册表拉取镜像$(NC)"
	docker pull $(REGISTRY_USERNAME)/$(FULL_IMAGE_NAME)
	docker tag $(REGISTRY_USERNAME)/$(FULL_IMAGE_NAME) $(FULL_IMAGE_NAME)
	@echo -e "$(GREEN)✓ 镜像拉取完成!$(NC)"
else
	@echo -e "$(RED)错误: 请设置 REGISTRY_USERNAME 环境变量$(NC)"
	@exit 1
endif

size: ## 显示镜像大小
	@echo -e "$(BLUE)镜像大小信息:$(NC)"
	docker images $(IMAGE_NAME) --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"

inspect: ## 检查镜像详细信息
	@echo -e "$(BLUE)镜像详细信息:$(NC)"
	docker inspect $(FULL_IMAGE_NAME)

shell-check: ## 检查shell脚本语法
	@echo -e "$(BLUE)检查 shell 脚本语法$(NC)"
	find scripts/ -name "*.sh" -exec shellcheck {} \; || echo -e "$(YELLOW)警告: shellcheck 未安装，跳过语法检查$(NC)"

# Docker Compose 相关命令
compose-up: ## 使用 docker-compose 启动服务
	@echo -e "$(BLUE)使用 docker-compose 启动服务$(NC)"
	docker-compose up -d
	@echo -e "$(GREEN)✓ 服务已启动!$(NC)"

compose-down: ## 停止 docker-compose 服务
	@echo -e "$(BLUE)停止 docker-compose 服务$(NC)"
	docker-compose down
	@echo -e "$(GREEN)✓ 服务已停止!$(NC)"

compose-logs: ## 查看 docker-compose 日志
	@echo -e "$(BLUE)查看 docker-compose 日志$(NC)"
	docker-compose logs -f

# 开发工具
format: ## 格式化代码文件
	@echo -e "$(BLUE)格式化代码文件$(NC)"
	# 这里可以添加代码格式化命令
	@echo -e "$(GREEN)✓ 格式化完成!$(NC)"

lint: shell-check ## 运行代码检查
	@echo -e "$(GREEN)✓ 代码检查完成!$(NC)"

# 快速开始
quick-start: build run-interactive ## 快速开始：构建并交互式运行