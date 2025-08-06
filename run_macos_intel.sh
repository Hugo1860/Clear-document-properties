#!/bin/bash

# Intel Mac专用启动脚本

set -e

# 设置颜色
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}启动Intel Mac文件属性管理器...${NC}"

# 检测架构
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    echo -e "${BLUE}检测到Intel (x86_64)架构${NC}"
elif [[ "$ARCH" == "arm64" ]]; then
    echo -e "${YELLOW}警告: 在ARM Mac上运行Intel脚本，可能性能不佳${NC}"
fi

# 检查Intel专用虚拟环境
if [[ -d "venv_intel" ]]; then
    echo -e "${BLUE}激活Intel专用虚拟环境...${NC}"
    source venv_intel/bin/activate
elif [[ -d "venv" ]]; then
    echo -e "${YELLOW}使用标准虚拟环境...${NC}"
    source venv/bin/activate
else
    echo -e "${YELLOW}检测到未安装环境，开始Intel专用安装...${NC}"
    chmod +x install_macos_intel.sh
    ./install_macos_intel.sh
    exit 0
fi

# 验证Python和依赖
echo -e "${BLUE}验证环境...${NC}"
python -c "
import platform
print(f'Python版本: {platform.python_version()}')
print(f'架构: {platform.machine()}')

try:
    import fitz
    print('✓ PyMuPDF可用')
except ImportError as e:
    print(f'✗ PyMuPDF不可用: {e}')
    exit(1)
"

# 运行程序
echo -e "${GREEN}启动程序...${NC}"
python file_properties_manager_crossplatform.py