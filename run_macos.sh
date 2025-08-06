#!/bin/bash

# macOS文件属性管理器启动脚本

set -e

# 设置颜色
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}启动macOS文件属性管理器...${NC}"

# 检查虚拟环境
if [[ -d "venv" ]]; then
    echo -e "${BLUE}激活虚拟环境...${NC}"
    source venv/bin/activate
else
    echo -e "${BLUE}检测到未安装环境，开始安装...${NC}"
    chmod +x install_macos.sh
    ./install_macos.sh
    exit 0
fi

# 运行程序
python file_properties_manager_crossplatform.py