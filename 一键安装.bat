@echo off
title 文件属性管理器 - 一键安装
color 0a

:: 检查管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 需要管理员权限，正在请求...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~f0 %*' -Verb RunAs"
    exit /b
)

cls
echo.
echo ================================================
echo    Windows文件属性管理器 - 一键安装工具
echo ================================================
echo.

:: 检查Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: Python未安装
    echo 请访问 https://www.python.org/downloads/ 下载安装
    pause
    exit /b
)

:: 安装依赖
echo 正在安装依赖包...
echo.

:: 使用国内镜像源
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn

if %errorlevel% neq 0 (
    echo 安装失败，尝试其他镜像源...
    pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
)

if %errorlevel% neq 0 (
    echo 仍然失败，使用官方源...
    pip install -r requirements.txt
)

if %errorlevel% neq 0 (
    echo 安装失败，请检查网络连接
    pause
    exit /b
)

echo.
echo 安装完成！
echo 按任意键启动程序...
pause >nul

python file_properties_manager.py