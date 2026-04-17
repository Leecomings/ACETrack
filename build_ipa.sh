#!/bin/bash
# ACETrack - 构建未签名 IPA 供爱思助手签名安装
# 使用方法: ./build_ipa.sh

set -e

echo "========================================="
echo "  ACETrack - 构建未签名 IPA"
echo "========================================="

cd "$(dirname "$0")"

# 1. 获取依赖
echo ""
echo "[1/4] 获取依赖..."
flutter pub get

# 2. 构建 iOS (无签名)
echo ""
echo "[2/4] 构建 iOS (无签名)..."
flutter build ios --release --no-codesign

# 3. 创建 IPA
echo ""
echo "[3/4] 打包 IPA..."
BUILD_DIR="build/ios/iphoneos"
IPA_DIR="build/ipa_temp"
OUTPUT_DIR="build"

rm -rf "$IPA_DIR"
mkdir -p "$IPA_DIR/Payload"

# 复制 Runner.app 到 Payload
cp -r "$BUILD_DIR/Runner.app" "$IPA_DIR/Payload/"

# 打包为 IPA
IPA_NAME="ACETrack-$(date +%Y%m%d_%H%M%S).ipa"
cd "$IPA_DIR"
zip -r -q "$OLDPWD/$OUTPUT_DIR/$IPA_NAME" Payload/
cd "$OLDPWD"

# 清理临时目录
rm -rf "$IPA_DIR"

# 4. 完成
IPA_PATH="$OUTPUT_DIR/$IPA_NAME"
FILE_SIZE=$(du -h "$IPA_PATH" | cut -f1)

echo ""
echo "========================================="
echo "  构建完成!"
echo "========================================="
echo ""
echo "IPA 路径: $IPA_PATH"
echo "文件大小: $FILE_SIZE"
echo ""
echo "后续步骤:"
echo "  1. 打开爱思助手"
echo "  2. 连接 iPhone"
echo "  3. 点击「应用游戏」→「导入安装」"
echo "  4. 选择上面的 IPA 文件"
echo "  5. 爱思助手会自动签名并安装"
echo ""
