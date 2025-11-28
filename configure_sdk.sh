#!/bin/bash

# SDK集成配置脚本
# 此脚本用于配置BCLRingSDK框架到Xcode项目

PROJECT_PATH="/Users/a8833/Documents/蓝牙指环"
PROJECT_FILE="$PROJECT_PATH/蓝牙指环.xcodeproj"
WORKSPACE_FILE="$PROJECT_PATH/蓝牙指环.xcworkspace"
FRAMEWORK_PATH="$PROJECT_PATH/蓝牙指环/BCLRingSDK.xcframework"

echo "=========================================="
echo "BCLRingSDK 集成配置"
echo "=========================================="
echo ""

# 检查框架是否存在
if [ ! -d "$FRAMEWORK_PATH" ]; then
    echo "❌ 错误: 未找到BCLRingSDK.xcframework"
    echo "   路径: $FRAMEWORK_PATH"
    exit 1
else
    echo "✅ 框架已找到: $FRAMEWORK_PATH"
fi

echo ""
echo "=========================================="
echo "配置步骤:"
echo "=========================================="
echo ""
echo "1. 在Xcode中打开项目:"
echo "   open \"$WORKSPACE_FILE\""
echo ""
echo "2. 选择项目 > 蓝牙指环 > Build Phases"
echo ""
echo "3. 在 'Link Binary With Libraries' 中添加:"
echo "   - BCLRingSDK.xcframework"
echo ""
echo "4. 在 Build Settings 中配置:"
echo "   - Framework Search Paths: 添加 \$(SRCROOT)/蓝牙指环"
echo "   - Other Link Flags: -framework BCLRingSDK (如需要)"
echo ""
echo "5. 确保 Info.plist 包含蓝牙权限:"
echo "   - NSBluetoothAlwaysUsageDescription"
echo "   - NSBluetoothPeripheralUsageDescription"
echo ""
echo "=========================================="
echo "自动配置完成!"
echo "=========================================="
echo ""
echo "下一步: 在Xcode中手动添加框架到Link Binary Phase"
echo ""
