#!/bin/bash

# Linux文件属性管理器安装脚本
# 支持Ubuntu、Debian、CentOS、Fedora等主流Linux发行版

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检测Linux发行版
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    elif [ -f /etc/redhat-release ]; then
        DISTRO="rhel"
    else
        DISTRO="unknown"
    fi
    print_info "检测到Linux发行版: $DISTRO"
}

# 检查Python
check_python() {
    print_info "检查Python环境..."
    
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
    elif command -v python &> /dev/null; then
        PYTHON_CMD="python"
    else
        print_error "未检测到Python"
        print_info "安装Python:"
        case $DISTRO in
            ubuntu|debian)
                sudo apt update && sudo apt install python3 python3-pip
                ;;
            centos|rhel|fedora)
                sudo yum install python3 python3-pip || sudo dnf install python3 python3-pip
                ;;
            arch)
                sudo pacman -S python python-pip
                ;;
            *)
                print_error "请手动安装Python 3.7+"
                exit 1
                ;;
        esac
    fi
    
    PYTHON_VERSION=$($PYTHON_CMD -c "import sys; print(sys.version_info[:2])")
    print_success "检测到Python版本: $PYTHON_VERSION"
}

# 安装系统依赖
install_system_deps() {
    print_info "安装系统依赖..."
    
    case $DISTRO in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y python3-dev python3-tk python3-pil python3-pil.imagetk
            ;;
        centos|rhel|fedora)
            sudo yum install -y python3-devel python3-tkinter || \
            sudo dnf install -y python3-devel python3-tkinter
            ;;
        arch)
            sudo pacman -S --needed python tk
            ;;
    esac
}

# 安装Python依赖
install_dependencies() {
    print_info "正在安装依赖包..."
    
    # 创建虚拟环境
    if [[ ! -d "venv" ]]; then
        $PYTHON_CMD -m venv venv
    fi
    
    source venv/bin/activate
    
    # 升级pip
    pip install --upgrade pip
    
    # 安装依赖
    pip install -r requirements_macos.txt
    
    print_success "依赖包安装完成"
}

# 主程序
main() {
    echo "========================================"
    echo "Linux文件属性管理器安装脚本"
    echo "========================================"
    echo
    
    detect_distro
    check_python
    install_system_deps
    install_dependencies
    
    echo
    print_success "安装完成！"
    print_info "使用方法:"
    print_info "1. 激活虚拟环境: source venv/bin/activate"
    print_info "2. 运行程序: python file_properties_manager_crossplatform.py"
    print_info "3. 或使用快捷运行: ./run_linux.sh"
    echo
    
    read -p "是否立即启动程序? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        source venv/bin/activate
        python file_properties_manager_crossplatform.py
    fi
}

main "$@"