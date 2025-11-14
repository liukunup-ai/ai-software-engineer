# AI Worker Node - 启动脚本 (Windows PowerShell)
# 用法: .\start.ps1 [OPTIONS]

param(
    [string]$Port = $env:PORT,
    [string]$Host = $env:HOST,
    [string]$RegisterURL = $env:REGISTER_URL,
    [string]$RegisterKey = $env:REGISTER_KEY,
    [string]$NodeName = $env:NODE_NAME,
    [switch]$NoReload,
    [switch]$Install,
    [switch]$TestMode,
    [switch]$Help
)

# 默认配置
if (-not $Port) { $Port = "8000" }
if (-not $Host) { $Host = "0.0.0.0" }
if (-not $RegisterURL) { $RegisterURL = "http://localhost:8001" }
if (-not $RegisterKey) { $RegisterKey = "please-input-your-key" }
if (-not $NodeName) { $NodeName = $env:COMPUTERNAME }

$Reload = -not $NoReload

# 颜色函数
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-Success {
    param([string]$Message)
    Write-ColorOutput "✓ $Message" -Color Green
}

function Write-Error {
    param([string]$Message)
    Write-ColorOutput "✗ $Message" -Color Red
}

function Write-Warning {
    param([string]$Message)
    Write-ColorOutput "⚠ $Message" -Color Yellow
}

function Write-Info {
    param([string]$Message)
    Write-ColorOutput $Message -Color Cyan
}

# 打印帮助信息
function Show-Help {
    Write-ColorOutput "AI Worker Node - 本地开发启动脚本" -Color Green
    Write-Host ""
    Write-ColorOutput "用法:" -Color Yellow
    Write-Host "    .\start-dev.ps1 [OPTIONS]"
    Write-Host ""
    Write-ColorOutput "选项:" -Color Yellow
    Write-Host "    -Port <PORT>              服务端口 (默认: 8000)"
    Write-Host "    -Host <HOST>              监听地址 (默认: 0.0.0.0)"
    Write-Host "    -RegisterURL <URL>        后端服务地址 (默认: http://localhost:8001)"
    Write-Host "    -RegisterKey <KEY>        注册密钥 (默认: default-key)"
    Write-Host "    -NodeName <NAME>          节点名称 (默认: 计算机名)"
    Write-Host "    -NoReload                 禁用自动重载"
    Write-Host "    -Install                  安装依赖后启动"
    Write-Host "    -TestMode                 测试模式(不注册到主节点)"
    Write-Host "    -Help                     显示此帮助信息"
    Write-Host ""
    Write-ColorOutput "环境变量:" -Color Yellow
    Write-Host "    PORT                      服务端口"
    Write-Host "    HOST                      监听地址"
    Write-Host "    REGISTER_URL              后端服务地址"
    Write-Host "    REGISTER_KEY              注册密钥"
    Write-Host "    NODE_NAME                 节点名称"
    Write-Host "    HEARTBEAT_INTERVAL        心跳间隔(秒)"
    Write-Host "    ALLOWED_COMMANDS          允许的命令白名单(逗号分隔)"
    Write-Host "    COMMAND_TIMEOUT           命令执行超时(秒)"
    Write-Host ""
    Write-ColorOutput "示例:" -Color Yellow
    Write-Host "    # 基本启动"
    Write-Host "    .\start.ps1"
    Write-Host ""
    Write-Host "    # 指定端口和后端地址"
    Write-Host "    .\start.ps1 -Port 9000 -RegisterURL http://192.168.1.100:8001"
    Write-Host ""
    Write-Host "    # 安装依赖后启动"
    Write-Host "    .\start.ps1 -Install"
    Write-Host ""
    Write-Host "    # 测试模式(不连接主节点)"
    Write-Host "    .\start.ps1 -TestMode"
    Write-Host ""
    Write-Host "    # 使用环境变量"
    Write-Host "    `$env:REGISTER_URL='http://localhost:8001'; .\start.ps1"
    Write-Host ""
    Write-ColorOutput "快捷方式:" -Color Yellow
    Write-Host "    启动主服务: " -NoNewline
    Write-ColorOutput ".\start.ps1" -Color Green
    Write-Host ""
}

# 检查 Python
function Test-Python {
    Write-Info "检查 Python 环境..."
    
    if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
        if (-not (Get-Command python3 -ErrorAction SilentlyContinue)) {
            Write-Error "未找到 Python"
            Write-Warning "请先安装 Python 3.12 或更高版本"
            Write-Host "下载地址: https://www.python.org/downloads/"
            exit 1
        }
        $pythonCmd = "python3"
    } else {
        $pythonCmd = "python"
    }
    
    $pythonVersion = & $pythonCmd --version
    Write-Success "Python 版本: $pythonVersion"
    
    return $pythonCmd
}

# 检查依赖
function Test-Dependencies {
    param([string]$PythonCmd)
    
    Write-Info "检查依赖..."
    
    $missingPackages = @()
    
    # 检查 FastAPI
    & $PythonCmd -c "import fastapi" 2>$null
    if ($LASTEXITCODE -ne 0) {
        $missingPackages += "FastAPI"
    }
    
    # 检查 httpx
    & $PythonCmd -c "import httpx" 2>$null
    if ($LASTEXITCODE -ne 0) {
        $missingPackages += "httpx"
    }
    
    # 检查 Uvicorn
    & $PythonCmd -c "import uvicorn" 2>$null
    if ($LASTEXITCODE -ne 0) {
        $missingPackages += "Uvicorn"
    }
    
    if ($missingPackages.Count -gt 0) {
        Write-Warning "缺少以下依赖: $($missingPackages -join ', ')"
        return $false
    }
    
    Write-Success "所有依赖已安装"
    return $true
}

# 安装依赖
function Install-Dependencies {
    param([string]$PythonCmd)
    
    Write-Info "正在安装依赖..."
    
    if (-not (Test-Path "requirements.txt")) {
        Write-Error "未找到 requirements.txt"
        exit 1
    }
    
    & $PythonCmd -m pip install -r requirements.txt
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "依赖安装完成"
    } else {
        Write-Error "依赖安装失败"
        exit 1
    }
}

# 检查端口
function Test-Port {
    param([int]$PortNumber)
    
    $connection = Get-NetTCPConnection -LocalPort $PortNumber -ErrorAction SilentlyContinue
    
    if ($connection) {
        Write-Error "端口 $PortNumber 已被占用"
        Write-Warning "使用以下命令查看占用进程:"
        Write-Host "  Get-Process -Id (Get-NetTCPConnection -LocalPort $PortNumber).OwningProcess"
        Write-Warning "或使用不同端口:"
        Write-Host "  .\start.ps1 -Port 9000"
        exit 1
    }
}

# 获取本机 IP
function Get-LocalIP {
    $ip = (Get-NetIPAddress -AddressFamily IPv4 | 
           Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.254.*" } | 
           Select-Object -First 1).IPAddress
    
    if (-not $ip) {
        $ip = "127.0.0.1"
    }
    
    return $ip
}

# 打印横幅
function Show-Banner {
    Write-Host ""
    Write-ColorOutput @"
__        __         _             _   _           _      
\ \      / /__  _ __| | _____ _ __| \ | | ___   __| | ___ 
 \ \ /\ / / _ \| '__| |/ / _ \ '__|  \| |/ _ \ / _` |/ _ \
  \ V  V / (_) | |  |   <  __/ |  | |\  | (_) | (_| |  __/
   \_/\_/ \___/|_|  |_|\_\___|_|  |_| \_|\___/ \__,_|\___|
                                                                          
"@ -Color Cyan
    Write-Host ""
}

# 启动服务
function Start-Service {
    param(
        [string]$PythonCmd,
        [string]$Host,
        [string]$Port,
        [bool]$Reload,
        [string]$RegisterURL,
        [string]$RegisterKey,
        [string]$NodeName,
        [string]$NodeIP
    )
    
    $reloadFlag = if ($Reload) { "--reload" } else { "" }
    
    Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -Color Green
    Write-ColorOutput "🚀 启动 AI Worker Node 服务" -Color Green
    Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -Color Green
    Write-ColorOutput "配置信息:" -Color Cyan
    Write-Host "  监听地址: " -NoNewline
    Write-ColorOutput "${Host}:${Port}" -Color Green
    Write-Host "  后端地址: " -NoNewline
    Write-ColorOutput $RegisterURL -Color Green
    Write-Host "  节点名称: " -NoNewline
    Write-ColorOutput $NodeName -Color Green
    Write-Host "  节点 IP: " -NoNewline
    Write-ColorOutput $NodeIP -Color Green
    Write-Host "  自动重载: " -NoNewline
    Write-ColorOutput $Reload -Color Green
    Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -Color Green
    Write-ColorOutput "访问地址:" -Color Yellow
    Write-Host "  本地: " -NoNewline
    Write-ColorOutput "http://localhost:${Port}" -Color Green
    Write-Host "  网络: " -NoNewline
    Write-ColorOutput "http://${NodeIP}:${Port}" -Color Green
    Write-Host "  健康检查: " -NoNewline
    Write-ColorOutput "http://localhost:${Port}/healthz" -Color Green
    Write-Host "  API 文档: " -NoNewline
    Write-ColorOutput "http://localhost:${Port}/docs" -Color Green
    Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -Color Green
    Write-ColorOutput "按 Ctrl+C 停止服务" -Color Yellow
    Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -Color Green
    Write-Host ""
    
    # 设置环境变量
    $env:BACKEND_URL = $RegisterURL
    $env:REGISTRATION_KEY = $RegisterKey
    $env:NODE_NAME = $NodeName
    $env:NODE_IP = $NodeIP
    if ($env:HEARTBEAT_INTERVAL) { }
    if ($env:ALLOWED_COMMANDS) { }
    if ($env:CMD_TIMEOUT) { }
    
    # 启动服务
    if ($reloadFlag) {
        & $PythonCmd -m uvicorn app.main:app --host $Host --port $Port $reloadFlag
    } else {
        & $PythonCmd -m uvicorn app.main:app --host $Host --port $Port
    }
}

# 主程序
if ($Help) {
    Show-Help
    exit 0
}

# 显示横幅
Show-Banner

# 检查 Python
$pythonCmd = Test-Python

# 处理依赖
if ($Install) {
    Install-Dependencies -PythonCmd $pythonCmd
} else {
    $depsInstalled = Test-Dependencies -PythonCmd $pythonCmd
    
    if (-not $depsInstalled) {
        Write-Warning "是否现在安装依赖? (Y/N)"
        $response = Read-Host
        
        if ($response -eq 'Y' -or $response -eq 'y') {
            Install-Dependencies -PythonCmd $pythonCmd
        } else {
            Write-Error "缺少必要依赖"
            Write-Warning "请运行: .\start-dev.ps1 -Install"
            exit 1
        }
    }
}

# 检查端口
Test-Port -PortNumber ([int]$Port)

# 获取本机 IP
$nodeIP = Get-LocalIP

# 测试模式
if ($TestMode) {
    Write-Warning "测试模式: 将不会连接到主节点"
    $RegisterURL = "http://localhost:9999"  # 不存在的地址
}

# 启动服务
try {
    Start-Service -PythonCmd $pythonCmd `
                  -Host $Host `
                  -Port $Port `
                  -Reload $Reload `
                  -RegisterURL $RegisterURL `
                  -RegisterKey $RegisterKey `
                  -NodeName $NodeName `
                  -NodeIP $nodeIP
} catch {
    Write-Error "服务启动失败: $_"
    exit 1
}
