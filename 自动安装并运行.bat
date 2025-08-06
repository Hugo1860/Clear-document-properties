@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title Windows文件属性管理器 - 自动安装运行

:: 设置颜色
set "color_info=96"
set "color_success=92"
set "color_warning=93"
set "color_error=91"
set "color_reset=0"

:: 清屏并显示标题
cls
echo.
echo [\033[96m Windows文件属性管理器 \033[0m]
echo [\033[96m 自动安装与运行工具 \033[0m]
echo.

:: 检查管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [\033[93m⚠\033[0m] 需要管理员权限以获得最佳体验
    echo [\033[93m⚠\033[0m] 请以管理员身份重新运行此程序
    echo.
    pause
    exit /b 1
)

:: 检查Python安装
echo [\033[96m🔍\033[0m] 正在检查Python环境...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [\033[91m✗\033[0m] 未检测到Python环境
    echo.
    echo [\033[96m📥\033[0m] 正在为您安装Python...
    
    :: 尝试从Microsoft Store安装Python
    echo [\033[96m📦\033[0m] 打开Microsoft Store安装Python...
    start ms-windows-store://pdp/?ProductId=9NRWMJP3717K
    echo [\033[93m⏳\033[0m] 请在Microsoft Store中完成Python安装后重新运行此程序
    echo.
    pause
    exit /b 1
)

:: 获取Python版本
for /f "tokens=2" %%i in ('python --version') do set python_version=%%i
echo [\033[92m✓\033[0m] 检测到Python %python_version%

:: 检查pip
echo [\033[96m🔍\033[0m] 正在检查pip...
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [\033[91m✗\033[0m] 未检测到pip
    echo [\033[96m📥\033[0m] 正在安装pip...
    python -m ensurepip --upgrade
)
echo [\033[92m✓\033[0m] pip已就绪

:: 创建虚拟环境
echo.
echo [\033[96m📁\033[0m] 正在设置虚拟环境...
if not exist "venv" (
    python -m venv venv
    echo [\033[92m✓\033[0m] 虚拟环境已创建
) else (
    echo [\033[92m✓\033[0m] 虚拟环境已存在
)

:: 激活虚拟环境
call venv\Scripts\activate.bat

:: 升级pip
echo [\033[96m🔄\033[0m] 正在升级pip...
python -m pip install --upgrade pip >nul 2>&1

:: 检查并安装依赖
echo.
echo [\033[96m📦\033[0m] 正在检查依赖包...

:: 逐个检查依赖
set "packages=Pillow PyMuPDF python-docx pywin32"
set "missing_packages="

for %%p in (%packages%) do (
    python -c "import %%p" >nul 2>&1
    if !errorlevel! neq 0 (
        set "missing_packages=!missing_packages! %%p"
    )
)

:: 安装缺失的依赖
if not "!missing_packages!"=="" (
    echo [\033[93m⚠\033[0m] 发现缺失的依赖包:!missing_packages!
    echo [\033[96m📥\033[0m] 正在安装依赖包...
    
    :: 使用国内镜像源加速下载
    echo [\033[96m🌏\033[0m] 使用国内镜像源加速下载...
    pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --timeout 30 --retries 3
    
    if %errorlevel% neq 0 (
        echo [\033[91m✗\033[0m] 依赖安装失败，尝试备用镜像源...
        pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ --timeout 30 --retries 3
    )
    
    if %errorlevel% neq 0 (
        echo [\033[91m✗\033[0m] 依赖安装失败，尝试官方源...
        pip install -r requirements.txt --timeout 60 --retries 3
    )
    
    if %errorlevel% neq 0 (
        echo [\033[91m✗\033[0m] 依赖安装失败，请检查网络连接
        echo [\033[93m💡\033[0m] 建议：手动运行 'pip install -r requirements.txt'
        pause
        exit /b 1
    )
    
    echo [\033[92m✓\033[0m] 依赖包安装完成
) else (
    echo [\033[92m✓\033[0m] 所有依赖包已就绪
)

:: 验证安装
echo.
echo [\033[96m✅\033[0m] 正在验证安装...
python -c "
try:
    from PIL import Image
    import fitz
    import docx
    import win32com.client
    print('[\033[92m✓\033[0m] 所有依赖验证通过')
except ImportError as e:
    print(f'[\033[91m✗\033[0m] 验证失败: {e}')
    exit(1)
"

if %errorlevel% neq 0 (
    echo [\033[91m✗\033[0m] 验证失败，请重新运行安装程序
    pause
    exit /b 1
)

:: 启动程序
echo.
echo [\033[92m🚀\033[0m] 正在启动Windows文件属性管理器...
echo [\033[96m📂\033[0m] 程序路径: %cd%\file_properties_manager.py
echo.
timeout /t 2 >nul

python file_properties_manager.py

:: 程序结束后的处理
if %errorlevel% neq 0 (
    echo.
    echo [\033[91m✗\033[0m] 程序运行出错
    echo [\033[93m💡\033[0m] 建议：
    echo    1. 检查文件权限
    echo    2. 确保文件未被占用
    echo    3. 以管理员身份重新运行
    pause
)

echo.
echo [\033[96m👋\033[0m] 感谢使用Windows文件属性管理器
echo.
pause