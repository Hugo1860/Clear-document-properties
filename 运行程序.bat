@echo off
title Windows文件属性管理器

echo 正在启动Windows文件属性管理器...
echo.

:: 检查Python是否安装
python --version >nul 2>&1
if errorlevel 1 (
    echo 错误: Python未安装或未添加到系统PATH
    echo 请先安装Python 3.7或更高版本
    pause
    exit /b 1
)

:: 检查依赖是否安装
python -c "import PIL, fitz, docx, win32com" >nul 2>&1
if errorlevel 1 (
    echo 正在安装必要的依赖包...
    pip install -r requirements.txt
    echo.
)

:: 运行程序
python file_properties_manager.py

if errorlevel 1 (
    echo.
    echo 程序运行出错，请检查错误信息
    pause
)

echo.
echo 程序已关闭
pause