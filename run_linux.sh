#!/bin/bash

# Linux文件属性管理器运行脚本

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# 检查虚拟环境
check_venv() {
    if [[ ! -d "venv" ]]; then
        print_info "检测到虚拟环境未创建，开始安装..."
        chmod +x install_linux.sh
        ./install_linux.sh
    fi
}

# 主程序
main() {
    echo "========================================"
    echo "Linux文件属性管理器"
    echo "========================================"
    
    check_venv
    
    print_info "正在启动程序..."
    source venv/bin/activate
    python file_properties_manager_crossplatform.py
    
    print_success "程序已退出"
}

main "$@"