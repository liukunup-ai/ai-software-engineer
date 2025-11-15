"""
AI Software Engineer Worker Node
"""

import asyncio
import logging
import os
import socket
import time
import uuid
from contextlib import asynccontextmanager
from typing import List, Optional

import httpx
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel


# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("ai-software-engineer.log"),
        logging.StreamHandler()  # 同时输出到控制台
    ]
)


# 命令配置
ALLOWED_COMMANDS = set(c.strip() for c in os.getenv("ALLOWED_COMMANDS", "echo,date,ls").split(",") if c.strip())  # 允许的命令列表
DEFAULT_TIMEOUT = float(os.getenv("COMMAND_TIMEOUT", "15"))  # 执行超时时间（秒）

# 启动模式
# - standalone 独立容器
# - worker     从节点（默认）
NODE_MODE = os.getenv("NODE_MODE", "worker").lower()

# 后端配置（仅在 worker 模式下需要）
REGISTER_URL = os.getenv("REGISTER_URL", "http://localhost:8000")  # 注册地址
REGISTER_KEY = os.getenv("REGISTER_KEY", "please-input-your-key")  # 注册密钥
NODE_NAME = os.getenv("NODE_NAME", socket.gethostname())  # 从节点名称
NODE_HOST = os.getenv("NODE_HOST", "127.0.0.1")  # 主机地址
NODE_DESC = os.getenv("NODE_DESC", "Worker Node")  # 从节点描述
NODE_TAGS = os.getenv("NODE_TAGS", "worker")  # 从节点标签
HEARTBEAT_INTERVAL = float(os.getenv("HEARTBEAT_INTERVAL", "30"))  # 心跳间隔（秒）

# 全局状态
node_id: Optional[uuid.UUID] = None
heartbeat_task: Optional[asyncio.Task] = None


# 注册节点
async def register() -> Optional[uuid.UUID]:
    """
    向主节点注册当前节点

    Returns:
        节点 ID，注册失败返回 None
    """
    global node_id

    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            response = await client.post(
                f"{REGISTER_URL}/api/v1/nodes/register",
                json={
                    "name": NODE_NAME,
                    "host": NODE_HOST,
                    "register_key": REGISTER_KEY,
                    "desc": NODE_DESC,
                    "tags": NODE_TAGS if NODE_TAGS else None,
                },
            )
            response.raise_for_status()
            data = response.json()
            node_id = (uuid.UUID(data["id"]) if isinstance(data["id"], str) else data["id"])
            logging.info(f"✅ 成功注册到主节点: {REGISTER_URL}, 节点ID: {node_id}")
            return node_id
    except Exception as e:
        logging.error(f"❌ 注册失败: {e}")
        return None


# 发送心跳
async def heartbeat() -> None:
    """向主节点发送心跳"""
    global node_id

    if not node_id:
        logging.warning("⚠️ 节点未注册，跳过心跳")
        return

    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            response = await client.post(
                f"{REGISTER_URL}/api/v1/nodes/heartbeat",
                json={
                    "node_id": str(node_id),
                    "register_key": REGISTER_KEY,
                },
            )
            response.raise_for_status()
            logging.info(f"💓 心跳发送成功, 节点ID: {node_id}, 当前时间: {time.strftime('%Y-%m-%d %H:%M:%S')}")
    except Exception as e:
        logging.error(f"❌ 心跳发送失败: {e}")


async def heartbeat_loop() -> None:
    """定时发送心跳的后台任务"""
    # 等待初始注册完成
    await asyncio.sleep(5)

    while True:
        await heartbeat()
        await asyncio.sleep(HEARTBEAT_INTERVAL)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    应用启动和关闭时的生命周期管理

    根据 NODE_MODE 决定是否启动 Worker 功能
      - standalone 仅提供容器环境
      - worker     注册到主节点并启动心跳任务
    """
    global heartbeat_task

    # 启动阶段
    if NODE_MODE == "standalone":
        logging.info("🚀 启动模式: Standalone (独立容器)")
        logging.info(f"📦 节点名称: {NODE_NAME}")
        logging.info("🔧 仅提供容器环境")
    else:
        logging.info("🚀 启动模式: Worker (从节点)")
        logging.info(f"🏭 节点名称: {NODE_NAME} ({NODE_HOST})")
        logging.info(f"📡 后端地址: {REGISTER_URL}")

        # 注册节点
        await register()
        # 启动心跳任务
        heartbeat_task = asyncio.create_task(heartbeat_loop())
        logging.info(f"💓 心跳任务已启动 (心跳间隔: {HEARTBEAT_INTERVAL} 秒)")

    yield

    # 关闭阶段
    if heartbeat_task:
        heartbeat_task.cancel()
        try:
            await heartbeat_task
        except asyncio.CancelledError:
            pass
    logging.info("👋 节点已关闭")


class CommandRequest(BaseModel):
    """命令执行请求"""
    command: str
    args: List[str] = []


class CommandResult(BaseModel):
    """命令执行结果"""
    command: str
    args: List[str]
    exit_code: int
    stdout: str
    stderr: str
    duration_ms: int


app = FastAPI(
    title="AI Software Engineer Worker Node",
    description="支持 Standalone 和 Worker 两种模式的 AI 编程助手后端服务",
    version="0.2.0",
    lifespan=lifespan,
)


@app.get("/healthz")
async def healthz():
    """
    健康检查接口

    返回服务状态、允许的命令列表、节点信息等
    """
    return {
        "status": "ok",
        "mode": NODE_MODE,
        "name": NODE_NAME,
        "node_id": str(node_id) if node_id else None,
        "registered": node_id is not None,
        "register_url": REGISTER_URL if NODE_MODE == "worker" else None,
        "allowed_commands": sorted(list(ALLOWED_COMMANDS)),
    }


@app.post("/execute", response_model=CommandResult)
async def execute_command(payload: CommandRequest):
    """
    执行接收到的命令

    Args:
        payload: 命令请求 (包含命令和参数)

    Returns:
        命令执行结果 (包含退出码、stdout、stderr和执行时间)

    Raises:
        HTTPException: 命令不在白名单、执行超时或其他错误
    """
    # 验证命令
    if not payload.command:
        raise HTTPException(status_code=400, detail="command 不能为空")
    if payload.command not in ALLOWED_COMMANDS:
        raise HTTPException(
            status_code=400,
            detail=f"命令 '{payload.command}' 不在白名单中",
        )

    # 执行命令
    start = time.time()
    try:
        proc = await asyncio.create_subprocess_exec(
            payload.command,
            *payload.args,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
        )

        try:
            stdout, stderr = await asyncio.wait_for(
                proc.communicate(),
                timeout=DEFAULT_TIMEOUT,
            )
        except asyncio.TimeoutError:
            proc.kill()
            await proc.wait()
            raise HTTPException(status_code=408, detail="命令执行超时")
            
    except FileNotFoundError:
        raise HTTPException(
            status_code=404,
            detail="命令未找到，请检查容器或系统中是否已安装",
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"执行失败: {type(e).__name__}: {e}",
        )

    # 返回结果
    duration_ms = int((time.time() - start) * 1000)
    return CommandResult(
        command=payload.command,
        args=payload.args,
        exit_code=proc.returncode or 0,
        stdout=stdout.decode(errors="replace"),
        stderr=stderr.decode(errors="replace"),
        duration_ms=duration_ms,
    )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8008, reload=False)
