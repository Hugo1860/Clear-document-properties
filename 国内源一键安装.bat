@echo off
title 文件属性管理器 - 国内源一键安装
color 0a

echo.
echo ================================================
echo    文件属性管理器 - 国内源一键安装
echo ================================================
echo.

:: 检查Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python未安装，请先安装Python 3.7+
    pause
    exit /b
)

echo ✅ 检测到Python环境
echo.
echo 📦 正在使用国内镜像源安装依赖...

:: 使用清华大学镜像源
pip install Pillow PyMuPDF python-docx pywin32 -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn

if %errorlevel% neq 0 (
    echo.
    echo ❌ 安装失败，尝试阿里云镜像...
    pip install Pillow PyMuPDF python-docx pywin32 -i https://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
)

if %errorlevel% neq 0 (
    echo.
    echo ❌ 仍然失败，请检查网络连接
    echo 💡 解决方案：
    echo 1. 关闭VPN/代理软件
    echo 2. 以管理员身份运行
    echo 3. 查看Windows国内源安装说明.txt
    pause
    exit /b
)

echo.
echo ✅ 安装成功！
echo 🚀 正在启动程序...
timeout /t 2 >nul
python file_properties_manager.py