# macOS文件属性管理器使用说明

## 系统要求

- **操作系统**: macOS 10.12 (Sierra) 或更高版本
- **Python版本**: Python 3.7 或更高版本
- **内存要求**: 至少2GB RAM
- **磁盘空间**: 100MB可用空间

## 安装方法

### 方法1: 使用安装脚本（推荐）

1. **打开终端** (Terminal)
2. **导航到程序目录**:
   ```bash
   cd /path/to/your/program/directory
   ```

3. **赋予脚本执行权限**:
   ```bash
   chmod +x install_macos.sh run_macos.sh
   ```

4. **运行安装脚本**:
   ```bash
   ./install_macos.sh
   ```

### 方法2: 手动安装

1. **安装Python**（如果尚未安装）:
   ```bash
   # 使用Homebrew安装（推荐）
   brew install python
   
   # 或从官网下载安装
   # https://www.python.org/downloads/macos/
   ```

2. **创建虚拟环境**:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **安装依赖**:
   ```bash
   pip install -r requirements_macos.txt
   ```

4. **运行程序**:
   ```bash
   python file_properties_manager_crossplatform.py
   ```

### 方法3: 使用Homebrew一键安装

```bash
# 安装Homebrew（如果尚未安装）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装Python
brew install python

# 然后按照方法2的步骤进行
```

## 使用方法

### 启动程序

```bash
# 方法1: 使用启动脚本
./run_macos.sh

# 方法2: 手动启动
source venv/bin/activate
python file_properties_manager_crossplatform.py
```

### 支持的文件格式

| 文件类型 | 扩展名 | 支持功能 |
|---------|--------|----------|
| JPEG图片 | .jpg, .jpeg | 查看/清除EXIF |
| PNG图片 | .png | 查看/清除属性 |
| GIF图片 | .gif | 查看/清除属性 |
| BMP图片 | .bmp | 查看/清除属性 |
| PDF文档 | .pdf | 查看/清除元数据 |
| Word文档 | .docx | 查看/清除文档属性 |
| Word文档 | .doc | 仅查看（不支持清除） |

### macOS特定功能

1. **Finder集成**: 支持通过拖拽文件到程序窗口
2. **Spotlight搜索**: 支持搜索文件元数据
3. **Quick Look**: 支持文件预览
4. **Retina显示**: 支持高分辨率显示

## 常见问题

### Q: 程序无法启动怎么办？

**A**: 检查以下步骤：
1. 确保已安装Python 3.7+
2. 检查终端权限：
   ```bash
   chmod +x install_macos.sh run_macos.sh
   ```
3. 检查依赖安装：
   ```bash
   source venv/bin/activate
   pip list
   ```

### Q: 如何处理.doc文件？

**A**: macOS对.doc文件支持有限：
- **查看属性**: 支持基本信息查看
- **清除属性**: 仅支持.docx格式
- **建议**: 将.doc转换为.docx格式

### Q: 如何卸载程序？

**A**: 删除整个程序文件夹即可，或使用清理脚本：

```bash
# 删除虚拟环境
rm -rf venv

# 删除Python缓存
find . -name "__pycache__" -type d -exec rm -rf {} +
find . -name "*.pyc" -delete
```

### Q: 如何更新程序？

**A**: 
1. 下载新版本文件
2. 备份重要数据
3. 运行安装脚本重新安装依赖

## 高级配置

### 创建桌面快捷方式

```bash
# 创建Automator应用
cat > "文件属性管理器.app/Contents/MacOS/文件属性管理器" << 'EOF'
#!/bin/bash
cd "$(dirname "$0")/../../.."
./run_macos.sh
EOF

chmod +x "文件属性管理器.app/Contents/MacOS/文件属性管理器"
```

### 添加到Dock

1. 打开程序
2. 在Dock中右键程序图标
3. 选择"保留在Dock中"

### 命令行使用

```bash
# 直接处理文件
python file_properties_manager_crossplatform.py /path/to/file

# 批量处理（未来版本支持）
python file_properties_manager_crossplatform.py /path/to/folder
```

## 技术支持

- **Homebrew**: https://brew.sh/
- **Python**: https://www.python.org/downloads/macos/
- **问题反馈**: 查看程序错误日志或联系开发者