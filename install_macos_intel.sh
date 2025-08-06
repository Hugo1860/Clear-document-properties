#!/bin/bash

# Intel Mac专用安装脚本
# 解决Intel架构下的兼容性问题

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

# 检测架构
detect_architecture() {
    ARCH=$(uname -m)
    if [[ "$ARCH" == "arm64" ]]; then
        print_info "检测到Apple Silicon (ARM64)架构"
        IS_ARM=true
    elif [[ "$ARCH" == "x86_64" ]]; then
        print_info "检测到Intel (x86_64)架构"
        IS_ARM=false
    else
        print_warning "未知架构: $ARCH，按Intel架构处理"
        IS_ARM=false
    fi
}

# 检查Python版本
check_python() {
    print_info "检查Python环境..."
    
    # 优先使用python3.9-3.11版本，Intel Mac兼容性更好
    for PYTHON_CMD in python3.11 python3.10 python3.9 python3; do
        if command -v "$PYTHON_CMD" &> /dev/null; then
            PYTHON_VERSION=$($PYTHON_CMD -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
            print_success "检测到Python: $PYTHON_CMD (版本: $PYTHON_VERSION)"
            break
        fi
    done
    
    if [[ -z "$PYTHON_CMD" ]]; then
        print_error "未检测到Python，请先安装Python 3.7+"
        print_info "Intel Mac推荐安装方式:"
        print_info "1. 访问 https://www.python.org/downloads/macos/"
        print_info "2. 下载Intel架构的Python安装包"
        print_info "3. 或使用Homebrew: arch -x86_64 brew install python@3.11"
        exit 1
    fi
}

# 检查pip
check_pip() {
    print_info "检查pip..."
    
    if [[ "$PYTHON_CMD" == *"3.11"* ]]; then
        PIP_CMD="pip3.11"
    elif [[ "$PYTHON_CMD" == *"3.10"* ]]; then
        PIP_CMD="pip3.10"
    elif [[ "$PYTHON_CMD" == *"3.9"* ]]; then
        PIP_CMD="pip3.9"
    else
        PIP_CMD="pip3"
    fi
    
    print_success "使用pip命令: $PIP_CMD"
}

# Intel Mac专用依赖安装
install_intel_dependencies() {
    print_info "正在安装Intel Mac专用依赖包..."
    
    # 升级pip
    $PIP_CMD install --upgrade pip setuptools wheel
    
    # 安装基础依赖
    $PIP_CMD install Pillow>=9.0.0
    $PIP_CMD install python-docx>=0.8.11
    
    # Intel Mac PyMuPDF安装策略
    if [[ "$IS_ARM" == false ]]; then
        print_info "Intel架构下安装PyMuPDF..."
        
        # 尝试多种安装方式
        if ! $PIP_CMD install PyMuPDF>=1.20.0; then
            print_warning "标准安装失败，尝试从源码安装..."
            
            # 安装编译依赖
            if command -v brew &> /dev/null; then
                print_info "使用Homebrew安装编译依赖..."
                brew install mupdf-tools swig
            fi
            
            # 尝试从源码安装
            $PIP_CMD install PyMuPDF --no-binary PyMuPDF || {
                print_error "PyMuPDF安装失败"
                print_info "替代方案: 使用旧版本"
                $PIP_CMD install PyMuPDF==1.19.6
            }
        fi
    else
        # ARM架构使用标准安装
        $PIP_CMD install PyMuPDF>=1.20.0
    fi
    
    # 安装macOS特定依赖
    $PIP_CMD install pyobjc-framework-Cocoa>=8.0.0
    
    print_success "Intel Mac依赖包安装完成"
}

# 创建虚拟环境
create_venv() {
    if [[ ! -d "venv_intel" ]]; then
        print_info "创建Intel专用虚拟环境..."
        $PYTHON_CMD -m venv venv_intel
        print_success "虚拟环境已创建"
    else
        print_info "Intel虚拟环境已存在"
    fi
}

# 验证安装
validate_installation() {
    print_info "验证Intel Mac安装..."
    
    source venv_intel/bin/activate
    
    python -c "
import sys
import platform
print(f'Python版本: {sys.version}')
print(f'架构: {platform.machine()}')

try:
    from PIL import Image
    print('✓ Pillow安装成功')
except ImportError as e:
    print(f'✗ Pillow安装失败: {e}')
    sys.exit(1)

try:
    import fitz
    print('✓ PyMuPDF安装成功')
except ImportError as e:
    print(f'✗ PyMuPDF安装失败: {e}')
    sys.exit(1)

try:
    import docx
    print('✓ python-docx安装成功')
except ImportError as e:
    print(f'✗ python-docx安装失败: {e}')
    sys.exit(1)

print('✓ 所有Intel Mac依赖验证通过')
"
    
    if [[ $? -eq 0 ]]; then
        print_success "Intel Mac安装验证成功"
    else
        print_error "安装验证失败"
        exit 1
    fi
}

# 主程序
main() {
    echo "========================================"
    echo "Intel Mac文件属性管理器安装脚本"
    echo "========================================"
    echo
    
    detect_architecture
    check_python
    check_pip
    
    create_venv
    source venv_intel/bin/activate
    install_intel_dependencies
    validate_installation
    
    echo
    print_success "Intel Mac安装完成！"
    print_info "使用方法:"
    print_info "1. 激活虚拟环境: source venv_intel/bin/activate"
    print_info "2. 运行程序: python file_properties_manager_crossplatform.py"
    print_info "3. 或使用快捷运行: ./run_macos_intel.sh"
    echo
    
    read -p "是否立即启动程序? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        python file_properties_manager_crossplatform.py
    fi
}

# 运行主程序
main "$@"