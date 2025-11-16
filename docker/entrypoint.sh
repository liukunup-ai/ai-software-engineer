#!/bin/bash

# Exit immediately if a command exits with a non-zero status,
# if an undefined variable is used, or if any command in a pipeline fails.
set -euo pipefail

# 默认环境变量
export HOST="${HOST:-0.0.0.0}"         # 监听地址
export PORT="${PORT:-8007}"            # 监听端口
export LOG_LEVEL="${LOG_LEVEL:-info}"  # 日志级别
export RELOAD="${RELOAD:-false}"       # 是否热重载

# 将 NODE_PORT 设置为与 PORT 相同
export NODE_PORT="${NODE_PORT:-${PORT}}"

# 根据 RELOAD 变量设置热重载标志
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
