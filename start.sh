#!/bin/bash
# 启动脚本
# 用法: ./start.sh [OPTIONS]

set -euo pipefail

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 默认配置
HOST=${HOST:-0.0.0.0}
PORT=${PORT:-8007}
RELOAD=${RELOAD:-true}
REGISTER_URL=${REGISTER_URL:-http://localhost:8000}
REGISTER_KEY=${REGISTER_KEY:-key}
NODE_NAME=${NODE_NAME:-$(hostname)}

# 打印帮助信息
print_help() {
    cat << EOF
${GREEN}AI Software Engineer - 启动脚本${NC}

${YELLOW}用法:${NC}
    $0 [OPTIONS]

${YELLOW}选项:${NC}
    -H, --host HOST           监听地址 (默认: 0.0.0.0)
    -p, --port PORT           服务端口 (默认: 8007)
    -b, --register URL        后端服务地址 (默认: http://localhost:8000)
    -k, --key KEY             注册密钥 (默认: key)
    -n, --name NAME           节点名称 (默认: 主机名)
    --no-reload               禁用自动重载
    --install                 安装依赖后启动
    --test-mode               测试模式(不注册到主节点)
    -h, --help                显示此帮助信息

${YELLOW}环境变量:${NC}
    PORT                      服务端口
    HOST                      监听地址
    REGISTER_URL              后端服务地址
    REGISTER_KEY              注册密钥
    NODE_NAME                 节点名称
    HEARTBEAT_INTERVAL        心跳间隔(秒)
    ALLOWED_COMMANDS          允许的命令白名单(逗号分隔)
    COMMAND_TIMEOUT           命令执行超时(秒)

${YELLOW}示例:${NC}
    # 基本启动
    $0

    # 指定端口和后端地址
    $0 -p 9000 -b http://192.168.1.8:8000

    # 安装依赖后启动
    $0 --install

    # 测试模式(不连接主节点)
    $0 --test-mode

    # 使用环境变量
    REGISTER_URL=http://127.0.0.1:8000 REGISTER_KEY=key $0

${YELLOW}快捷方式:${NC}
    启动服务: ${GREEN}./start.sh${NC}
EOF
}

# 检查 Python
check_python() {
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}错误: 未找到 python3${NC}"
        echo -e "${YELLOW}请先安装 Python 3.12 或更高版本${NC}"
        exit 1
    fi

    PYTHON_VERSION=$(python3 --version | awk '{print $2}')
    echo -e "${GREEN}✓ Python 版本: ${PYTHON_VERSION}${NC}"
}

# 检查并安装依赖
check_dependencies() {
    echo -e "${YELLOW}检查依赖...${NC}"

    if ! python3 -c "import fastapi" &> /dev/null; then
        echo -e "${YELLOW}⚠ FastAPI 未安装${NC}"
        return 1
    fi

    if ! python3 -c "import httpx" &> /dev/null; then
        echo -e "${YELLOW}⚠ httpx 未安装${NC}"
        return 1
    fi

    if ! python3 -c "import uvicorn" &> /dev/null; then
        echo -e "${YELLOW}⚠ Uvicorn 未安装${NC}"
        return 1
    fi

    echo -e "${GREEN}✓ 所有依赖已安装${NC}"
    return 0
}

# 安装依赖
install_dependencies() {
    echo -e "${YELLOW}正在安装依赖...${NC}"

    if [ -f "requirements.txt" ]; then
        python3 -m pip install -r requirements.txt
        echo -e "${GREEN}✓ 依赖安装完成${NC}"
    else
        echo -e "${RED}错误: 未找到 requirements.txt${NC}"
        exit 1
    fi
}

# 检查端口是否被占用
check_port() {
    if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${RED}错误: 端口 $PORT 已被占用${NC}"
        echo -e "${YELLOW}使用以下命令查看占用进程:${NC}"
        echo -e "  lsof -i :$PORT"
        echo -e "${YELLOW}或使用不同端口:${NC}"
        echo -e "  $0 -p 9000"
        exit 1
    fi
}

# 获取本机IP地址
get_local_ip() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "127.0.0.1"
    else
        # Linux
        hostname -I 2>/dev/null | awk '{print $1}' || echo "127.0.0.1"
    fi
}

# 启动服务
start_service() {
    local reload_flag=""
    if [ "$RELOAD" = true ]; then
        reload_flag="--reload"
    fi

    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🚀 启动 AI Software Engineer Worker Node 服务${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}配置信息:${NC}"
    echo -e "  监听地址: ${GREEN}${HOST}:${PORT}${NC}"
    echo -e "  后端地址: ${GREEN}${REGISTER_URL}${NC}"
    echo -e "  节点名称: ${GREEN}${NODE_NAME}${NC}"
    echo -e "  节点地址: ${GREEN}${NODE_HOST}${NC}"
    echo -e "  自动重载: ${GREEN}${RELOAD}${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}访问地址:${NC}"
    echo -e "  本地: ${GREEN}http://localhost:${PORT}${NC}"
    echo -e "  网络: ${GREEN}http://${NODE_HOST}:${PORT}${NC}"
    echo -e "  健康检查: ${GREEN}http://localhost:${PORT}/healthz${NC}"
    echo -e "  接口文档: ${GREEN}http://localhost:${PORT}/docs${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}按 Ctrl+C 停止服务${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # 导出环境变量
    export REGISTER_URL
    export REGISTER_KEY
    export NODE_NAME
    export NODE_HOST
    export HEARTBEAT_INTERVAL
    export ALLOWED_COMMANDS
    export COMMAND_TIMEOUT
    
    # 启动服务
    python3 -m uvicorn app.main:app \
        --host "$HOST" \
        --port "$PORT" \
        $reload_flag
}

# 解析命令行参数
INSTALL_DEPS=false
TEST_MODE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        -H|--host)
            HOST="$2"
            shift 2
            ;;
        -b|--backend)
            REGISTER_URL="$2"
            shift 2
            ;;
        -k|--key)
            REGISTER_KEY="$2"
            shift 2
            ;;
        -n|--name)
            NODE_NAME="$2"
            shift 2
            ;;
        --no-reload)
            RELOAD=false
            shift
            ;;
        --install)
            INSTALL_DEPS=true
            shift
            ;;
        --test-mode)
            TEST_MODE=true
            shift
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        *)
            echo -e "${RED}错误: 未知参数 $1${NC}"
            print_help
            exit 1
            ;;
    esac
done

# 主流程
echo -e "${BLUE}"
cat << "EOF"
__        __         _             _   _           _      
\ \      / /__  _ __| | _____ _ __| \ | | ___   __| | ___ 
 \ \ /\ / / _ \| '__| |/ / _ \ '__|  \| |/ _ \ / _` |/ _ \
  \ V  V / (_) | |  |   <  __/ |  | |\  | (_) | (_| |  __/
   \_/\_/ \___/|_|  |_|\_\___|_|  |_| \_|\___/ \__,_|\___|
                                                                          
EOF
echo -e "${NC}"

# 检查 Python
check_python

# 安装依赖
if [ "$INSTALL_DEPS" = true ]; then
    install_dependencies
else
    if ! check_dependencies; then
        echo -e "${YELLOW}是否现在安装依赖? (y/n)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            install_dependencies
        else
            echo -e "${RED}错误: 缺少必要依赖${NC}"
            echo -e "${YELLOW}请运行: $0 --install${NC}"
            exit 1
        fi
    fi
fi

# 检查端口
check_port

# 获取本机 IP
NODE_HOST=${NODE_HOST:-$(get_local_ip)}

# 测试模式
if [ "$TEST_MODE" = true ]; then
    echo -e "${YELLOW} 测试模式: 将不会连接到主节点${NC}"
    REGISTER_URL="http://localhost:9999"  # 不存在的地址
fi

# 启动服务
start_service
