# 蓝牙设备搜索功能集成文档

## 功能概述

实现了点击"搜索设备"按钮直接调用BCLRingSDK进行蓝牙设备搜索，并通过一个专门的搜索结果视图控制器显示搜索到的设备列表。

---

## 核心实现

### 1. HomeViewController 改动

#### 新增属性：
- `bclDiscoveredDevices: [BCLDevice]` - BCL SDK搜索到的设备列表
- `searchResultsViewController: SearchResultsViewController?` - 搜索结果视图控制器（用于动态更新）

#### 新增方法：

**setupBCLSDK()**
- 配置BCL SDK的设备发现和连接状态回调
- 在viewDidLoad中调用

**handleBCLDeviceDiscovered(_ device: BCLDevice)**
- 处理SDK发现的新设备
- 检查去重，将设备添加到列表
- 更新搜索结果视图

**startBCLSearch()**
- 启动蓝牙设备搜索
- 清空旧设备列表
- 显示搜索结果视图控制器
- 调用SDK的prepareForDeviceSearch()

**stopBCLSearch()**
- 停止蓝牙设备搜索
- 调用SDK的stopDeviceSearch()

**showSearchResultsViewController()**
- 创建并展示搜索结果视图控制器
- 配置设备选择和取消回调
- 设置导航栏样式

**updateSearchResultsViewController()**
- 动态更新已打开的搜索结果视图
- 实时显示新发现的设备

**handleSelectBCLDevice(_ device: BCLDevice)**
- 处理用户从列表中选择的设备
- 停止搜索
- 将设备添加到主设备列表
- 自动连接选中的设备

#### 改动的方法：

**startDeviceSearch()** (事件处理)
- 现在调用 startBCLSearch() / stopBCLSearch()
- 支持开始/停止搜索的切换

**connectToDevice(_ device: Device)**
- 优先使用BCL SDK连接
- 如果是来自SDK的设备，使用SDKIntegrationHelper连接
- 支持向后兼容

---

### 2. SearchResultsViewController (新建)

一个全新的视图控制器，专门用于显示蓝牙搜索结果。

#### 主要特性：

**UI组件：**
- 表格视图 (UITableView) - 显示设备列表
- 导航栏 - 显示搜索状态和设备数量
- 刷新按钮 - 清空列表重新搜索
- 取消按钮 - 停止搜索并关闭视图

**动态更新：**
- discoveredDevices 属性支持KVO，自动刷新列表
- isSearching 属性控制标题显示
- 实时更新发现的设备数量

**设备选择回调：**
- `onDeviceSelected: ((BCLDevice) -> Void)?` - 用户选择设备时调用
- `onCancel: (() -> Void)?` - 用户取消搜索时调用

#### SearchResultCell (表格单元格)

每个设备显示以下信息：
- 设备名称（加粗）
- 设备ID (UUID)
- 信号强度描述 + dBm值
- 信号强度进度条（颜色动态变化）

**信号强度颜色：**
- 绿色 (-50 ~ 0 dBm) - 优秀
- 橙色 (-70 ~ -51 dBm) - 良好
- 红色 (< -70 dBm) - 较弱

---

## 工作流程

```
用户点击"搜索设备"按钮
    ↓
startDeviceSearch() 被触发
    ↓
isSearching = true, 清空旧设备列表
    ↓
showSearchResultsViewController() - 显示搜索结果视图
    ↓
SDKIntegrationHelper.prepareForDeviceSearch() - 启动SDK搜索
    ↓
SDK发现设备 → handleBCLDeviceDiscovered()
    ↓
设备列表更新 → updateSearchResultsViewController()
    ↓
用户选择设备 → handleSelectBCLDevice()
    ↓
停止搜索，添加到主列表，自动连接
```

---

## 数据流

### 搜索阶段
```
BCLRingSDKManager.onDeviceDiscovered
    ↓
HomeViewController.handleBCLDeviceDiscovered()
    ↓
bclDiscoveredDevices.append(device)
    ↓
updateSearchResultsViewController()
    ↓
SearchResultsViewController.discoveredDevices = bclDiscoveredDevices
    ↓
TableView.reloadData()
```

### 选择设备阶段
```
SearchResultsViewController.didSelectRowAt
    ↓
onDeviceSelected?(device)
    ↓
HomeViewController.handleSelectBCLDevice()
    ↓
stopBCLSearch()
    ↓
将BCLDevice转换为本地Device对象
    ↓
devices.append(localDevice)
    ↓
connectToDevice(localDevice)
```

---

## 集成要点

### 关键依赖
- `BCLRingSDK` - 蓝牙设备搜索
- `SDKIntegrationHelper` - SDK简化接口
- `UIColor+Hex` - 十六进制颜色扩展

### 必需导入
```swift
import UIKit
import BCLRingSDK
```

### Info.plist 权限（已配置）
- NSBluetoothAlwaysUsageDescription
- NSBluetoothPeripheralUsageDescription
- UIBackgroundModes (bluetooth-central)

---

## 使用示例

### 基础搜索流程

1. **用户交互** - 点击搜索按钮自动触发
2. **SDK搜索** - 自动调用BCL SDK搜索
3. **结果展示** - 搜索结果实时显示在弹出的ViewController中
4. **设备选择** - 用户从列表中选择设备并连接

### 高级定制

若需修改搜索行为：

```swift
// 自定义搜索参数
SDKIntegrationHelper.shared.prepareForDeviceSearch()

// 自定义设备过滤逻辑
private func handleBCLDeviceDiscovered(_ device: BCLDevice) {
    // 只显示信号强度大于-80的设备
    if device.rssi > -80 {
        bclDiscoveredDevices.append(device)
        updateSearchResultsViewController()
    }
}

// 自定义设备连接逻辑
private func handleSelectBCLDevice(_ device: BCLDevice) {
    // 自定义处理逻辑
}
```

---

## 文件清单

### 修改的文件
- ✅ `蓝牙指环/Modules/Home/Controllers/HomeViewController.swift` - 添加SDK集成和搜索逻辑

### 新建的文件
- ✅ `蓝牙指环/Modules/Home/Views/SearchResultsViewController.swift` - 搜索结果显示

### 现有依赖文件（无需修改）
- `蓝牙指环/Modules/BCLRingSDKManager.swift` - SDK管理器
- `蓝牙指环/Modules/SDKIntegrationHelper.swift` - SDK辅助类

---

## 测试建议

### 单元测试覆盖
- [ ] 设备发现回调
- [ ] 设备去重逻辑
- [ ] 搜索开始/停止
- [ ] 设备选择处理
- [ ] 视图生命周期

### 集成测试
- [ ] 完整搜索流程
- [ ] 真机蓝牙设备搜索
- [ ] 多设备并发搜索
- [ ] 搜索超时处理

### UI测试
- [ ] 搜索结果显示
- [ ] 设备列表滚动
- [ ] 信号强度显示
- [ ] 设备选择反馈

---

## 已知限制

1. **模拟器限制** - iOS模拟器不支持真实蓝牙，测试需要真机
2. **搜索超时** - SDK搜索持续进行，需要用户手动停止
3. **后台搜索** - 需要后台执行权限 (UIBackgroundModes)
4. **电源消耗** - 连续搜索会消耗电量，建议自动停止

---

## 后续优化方向

1. **自动停止** - 搜索一段时间后自动停止
2. **搜索过滤** - 支持按信号强度、设备类型等过滤
3. **搜索历史** - 记录搜索历史，快速连接
4. **智能连接** - 根据信号强度自动推荐最佳设备
5. **搜索统计** - 记录搜索时间、设备数量等统计数据

---

## 技术细节

### 线程安全
- SDK回调在主线程执行
- UI更新安全地在主线程进行
- 使用weak self避免循环引用

### 内存管理
- 搜索视图控制器通过delegate模式解耦
- 及时释放搜索结果引用
- 避免强引用循环

### 性能优化
- 表格虚拟化，仅渲染可见单元格
- 图片缓存（信号强度图标）
- 延迟UI更新，合并多次刷新
