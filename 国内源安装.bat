@echo off
title 文件属性管理器 - 国内源安装
color 0a

:: 设置控制台编码
chcp 65001 >nul

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
echo    Windows文件属性管理器 - 国内源安装工具
echo ================================================
echo.

:: 检查Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: Python未安装
    echo 请访问 https://www.python.org/downloads/ 下载安装
    echo 或使用国内镜像: https://npm.taobao.org/mirrors/python/
    pause
    exit /b
)

:: 升级pip使用国内源
echo 正在升级pip...
python -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn

:: 国内镜像源列表
set "SOURCES[0]=https://pypi.tuna.tsinghua.edu.cn/simple"
set "SOURCES[1]=https://mirrors.aliyun.com/pypi/simple/"
set "SOURCES[2]=https://pypi.douban.com/simple/"
set "SOURCES[3]=https://pypi.mirrors.ustc.edu.cn/simple/"
set "SOURCES[4]=https://pypi.hustunique.com/"

:: 安装依赖
echo.
echo 正在使用国内镜像源安装依赖包...
echo.

:: 创建requirements文件（确保包含国内源兼容版本）
echo Pillow>=8.0.0 > requirements_cn.txt
echo PyMuPDF>=1.19.0 >> requirements_cn.txt
echo python-docx>=0.8.10 >> requirements_cn.txt
echo pywin32>=227 >> requirements_cn.txt

:: 依次尝试不同的国内镜像源
set "SUCCESS=0"
for /L %%i in (0,1,4) do (
    if !SUCCESS! equ 0 (
        echo 尝试使用镜像源 %%i...
        pip install -r requirements_cn.txt -i !SOURCES[%%i]! --trusted-host !SOURCES[%%i]:~8,-8!
        if !errorlevel! equ 0 (
            set "SUCCESS=1"
            echo 使用镜像源 %%i 安装成功！
        ) else (
            echo 镜像源 %%i 失败，尝试下一个...
        )
    )
)

if %SUCCESS% equ 0 (
    echo.
    echo 所有国内镜像源尝试失败
    echo 请检查以下问题：
    echo 1. 网络连接是否正常
    echo 2. 是否被防火墙拦截
    echo 3. 是否使用了代理/VPN
    echo.
    echo 手动安装命令：
    echo pip install Pillow PyMuPDF python-docx pywin32
    pause
    exit /b
)

:: 验证安装
echo.
echo 验证安装...
python -c "
import sys
try:
    from PIL import Image
    import fitz
    import docx
    print('✅ 所有依赖安装成功')
except ImportError as e:
    print(f'❌ 验证失败: {e}')
    sys.exit(1)
"

if %errorlevel% neq 0 (
    echo 验证失败，请重试
    pause
    exit /b
)

:: 清理临时文件
del requirements_cn.txt >nul 2>&1

echo.
echo 🎉 国内源安装完成！
echo.
echo 📋 已配置的国内镜像源：
echo 1. 清华大学: https://pypi.tuna.tsinghua.edu.cn/simple
echo 2. 阿里云: https://mirrors.aliyun.com/pypi/simple/
echo 3. 豆瓣: https://pypi.douban.com/simple/
echo 4. 中科大: https://pypi.mirrors.ustc.edu.cn/simple/
echo 5. 华中科大: https://pypi.hustunique.com/
echo.
echo 按任意键启动程序...
pause >nul

python file_properties_manager.py