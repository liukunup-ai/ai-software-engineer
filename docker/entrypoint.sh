#!/bin/bash

# Exit immediately if a command exits with a non-zero status,
# if an undefined variable is used, or if any command in a pipeline fails.
set -euo pipefail

# 启动参数
export HOST="${HOST:-0.0.0.0}"         # 服务监听地址
export PORT="${PORT:-8010}"            # 服务端口
export LOG_LEVEL="${LOG_LEVEL:-info}"  # 日志级别
export RELOAD="${RELOAD:-false}"       # 是否热重载

# 组装 uvicorn 选项
reload_flag=""
if [[ "$RELOAD" == "true" ]]; then
  reload_flag="--reload"
fi

# 激活虚拟环境
if [[ -f .venv/bin/activate ]]; then
    . .venv/bin/activate
fi

# 启动服务
exec uvicorn main:app \
    --host "${HOST}" --port "${PORT}" \
    --log-level "${LOG_LEVEL}" \
    ${reload_flag}
