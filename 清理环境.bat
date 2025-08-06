@echo off
title 文件属性管理器 - 清理工具
color 0c

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
echo    Windows文件属性管理器 - 清理工具
echo ================================================
echo.
echo 此工具将清理以下内容：
echo 1. 删除虚拟环境
echo 2. 清理pip缓存
echo 3. 卸载相关依赖包
echo.

set /p confirm=确定要清理吗? (y/n): 
if /i not "%confirm%"=="y" (
    echo 已取消清理
    pause
    exit /b
)

:: 删除虚拟环境
if exist "venv" (
    echo 正在删除虚拟环境...
    rmdir /s /q venv
    echo ✓ 虚拟环境已删除
)

:: 卸载依赖包
echo 正在卸载依赖包...
pip uninstall -y Pillow PyMuPDF python-docx pywin32

:: 清理pip缓存
echo 正在清理pip缓存...
pip cache purge >nul 2>&1

echo.
echo 清理完成！
echo 如需重新安装，请运行：一键安装.bat
pause