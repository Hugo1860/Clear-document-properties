#!/bin/bash

# macOS文件属性管理器安装脚本
# 支持macOS 10.12+系统

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的信息
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

# 检查系统版本
check_macos_version() {
    if [[ $(sw_vers -productVersion | cut -d. -f1-2) < "10.12" ]]; then
        print_error "需要macOS 10.12或更高版本"
        exit 1
    fi
}

# 检查Python版本
check_python() {
    print_info "检查Python环境..."
    
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
    elif command -v python &> /dev/null; then
        PYTHON_CMD="python"
    else
        print_error "未检测到Python，请先安装Python 3.7+"
        print_info "安装方式:"
        print_info "1. 访问 https://www.python.org/downloads/"
        print_info "2. 或使用Homebrew: brew install python"
        exit 1
    fi
    
    PYTHON_VERSION=$($PYTHON_CMD -c "import sys; print(sys.version_info[:2])")
    print_success "检测到Python版本: $PYTHON_VERSION"
}

# 检查pip
check_pip() {
    print_info "检查pip..."
    
    if command -v pip3 &> /dev/null; then
        PIP_CMD="pip3"
    elif command -v pip &> /dev/null; then
        PIP_CMD="pip"
    else
        print_error "未检测到pip"
        exit 1
    fi
    
    print_success "检测到pip: $PIP_CMD"
}

# 安装依赖
install_dependencies() {
    print_info "正在安装依赖包..."
    
    # 升级pip
    $PIP_CMD install --upgrade pip
    
    # 安装依赖
    $PIP_CMD install -r requirements_macos.txt
    
    print_success "依赖包安装完成"
}

# 创建虚拟环境
create_venv() {
    if [[ ! -d "venv" ]]; then
        print_info "创建虚拟环境..."
        $PYTHON_CMD -m venv venv
        print_success "虚拟环境已创建"
    else
        print_info "虚拟环境已存在"
    fi
}

# 验证安装
validate_installation() {
    print_info "验证安装..."
    
    source venv/bin/activate
    
    python -c "
import sys
try:
    from PIL import Image
    import fitz
    import docx
    print('✓ 所有依赖验证通过')
except ImportError as e:
    print(f'✗ 验证失败: {e}')
    sys.exit(1)
"
    
    if [[ $? -eq 0 ]]; then
        print_success "安装验证成功"
    else
        print_error "安装验证失败"
        exit 1
    fi
}

# 主程序
main() {
    echo "========================================"
    echo "macOS文件属性管理器安装脚本"
    echo "========================================"
    echo
    
    check_macos_version
    check_python
    check_pip
    
    create_venv
    source venv/bin/activate
    install_dependencies
    validate_installation
    
    echo
    print_success "安装完成！"
    print_info "使用方法:"
    print_info "1. 激活虚拟环境: source venv/bin/activate"
    print_info "2. 运行程序: python file_properties_manager.py"
    print_info "3. 或使用快捷运行: ./run_macos.sh"
    echo
    
    read -p "是否立即启动程序? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        python file_properties_manager.py
    fi
}

# 运行主程序
main "$@"