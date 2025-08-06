@echo off
title 配置Python国内镜像源
color 0a

echo.
echo ================================================
echo    配置Python国内镜像源（永久生效）
echo ================================================
echo.

:: 检查Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python未安装
    pause
    exit /b
)

echo 正在配置国内镜像源...
echo.

:: 配置清华大学镜像源为默认
echo 配置清华大学镜像源...
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip config set global.trusted-host pypi.tuna.tsinghua.edu.cn

echo.
echo ✅ 配置完成！
echo 📋 当前配置：
pip config list

echo.
echo 🎉 现在所有pip安装都会自动使用国内源
pause