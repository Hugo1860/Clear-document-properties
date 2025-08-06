# Intel Mac文件属性管理器使用说明

## 问题描述
在Intel架构的Mac电脑上，可能会遇到以下问题：
- PyMuPDF安装失败
- 依赖包架构不兼容
- 程序无法启动

## 解决方案

### 方法1：使用Intel专用安装脚本
```bash
# 1. 为Intel Mac安装脚本添加执行权限
chmod +x install_macos_intel.sh

# 2. 运行Intel专用安装
./install_macos_intel.sh

# 3. 使用Intel专用运行脚本
chmod +x run_macos_intel.sh
./run_macos_intel.sh
```

### 方法2：手动安装（如果方法1失败）
```bash
# 1. 创建Intel专用虚拟环境
python3 -m venv venv_intel
source venv_intel/bin/activate

# 2. 升级pip
pip install --upgrade pip setuptools wheel

# 3. 安装基础依赖
pip install Pillow>=9.0.0
pip install python-docx>=0.8.11
pip install pyobjc-framework-Cocoa>=8.0.0

# 4. 安装PyMuPDF（Intel架构）
# 如果标准安装失败，尝试以下命令：
pip install PyMuPDF==1.19.6  # 使用稳定版本

# 5. 验证安装
python -c "
import platform
from PIL import Image
import fitz
import docx
print('✅ 所有依赖安装成功')
print(f'架构: {platform.machine()}')
print(f'Python: {platform.python_version()}')
"
```

### 方法3：使用Rosetta 2（M1/M2 Mac运行Intel版本）
如果需要在Apple Silicon Mac上运行Intel版本：

```bash
# 使用Rosetta 2运行
arch -x86_64 python3 -m venv venv_intel
arch -x86_64 ./install_macos_intel.sh
```

## 常见问题解决

### PyMuPDF安装失败
```bash
# 安装编译工具
brew install mupdf-tools swig

# 重新安装
pip install --no-binary PyMuPDF PyMuPDF
```

### 权限问题
```bash
# 给所有脚本添加执行权限
chmod +x *.sh
```

### Python版本问题
确保使用Python 3.7-3.11版本，Intel Mac推荐使用：
- Python 3.9（最稳定）
- Python 3.10
- Python 3.11

## 验证安装成功
运行以下命令检查：
```bash
./run_macos_intel.sh
```

## 技术支持
如果以上方法都无法解决问题：
1. 检查Python版本：python3 --version
2. 检查系统架构：uname -m
3. 查看错误日志，联系技术支持

## 文件说明
- `install_macos_intel.sh` - Intel专用安装脚本
- `run_macos_intel.sh` - Intel专用运行脚本
- `venv_intel/` - Intel专用虚拟环境目录