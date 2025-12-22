# 网络请求封装使用指南

## 概述

本项目提供了完整的网络请求封装，包括：
- `NetworkManager`: 基础网络请求管理器
- `APIService`: API 接口服务类
- `DataModels`: 数据模型定义
- `ResponseModels`: 响应模型定义

## 快速开始

### 1. 设置认证 Token

```swift
// 登录成功后设置 Token
NetworkManager.shared.setAuthToken("your_token_here")
```

### 2. 调用 API 接口

```swift
// 使用 APIService 调用接口
APIService.shared.getDeviceList { result in
    switch result {
    case .success(let data):
        print("设备列表: \(data)")
    case .failure(let error):
        print("错误: \(error.localizedDescription)")
    }
}
```

## 使用示例

### 设备管理

```swift
// 获取设备列表
APIService.shared.getDeviceList { result in
    switch result {
    case .success(let tableData):
        print("设备总数: \(tableData.total ?? 0)")
        if let devices = tableData.rows {
            // 处理设备列表
        }
    case .failure(let error):
        print("获取设备列表失败: \(error)")
    }
}

// 新增设备
let device = Device(
    deviceNo: "DEV001",
    deviceName: "智能健康手环",
    deviceType: "手环",
    deviceLinkJson: "{\"mac\":\"AA:BB:CC:DD:EE:FF\"}",
    hardwareVersion: "HW_V1.0",
    softwareVersion: "1.0.0",
    status: "0",
    userId: 100
)

APIService.shared.addDevice(device) { result in
    switch result {
    case .success(let response):
        if response.isSuccess {
            print("设备添加成功")
        } else {
            print("错误: \(response.msg)")
        }
    case .failure(let error):
        print("添加设备失败: \(error)")
    }
}
```

### 健康数据管理

```swift
// 新增心率记录
let heartrate = Heartrate(
    deviceId: 1,
    heartRateValue: 75,
    measureTime: "2024-01-01T12:00:00",
    userId: 100
)

APIService.shared.addHeartrate(heartrate) { result in
    switch result {
    case .success(let response):
        if response.isSuccess {
            print("心率记录添加成功")
        }
    case .failure(let error):
        print("添加心率记录失败: \(error)")
    }
}

// 查询心率记录（日）
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd"
let dateString = dateFormatter.string(from: Date())

APIService.shared.getDailyHeartrate(deviceId: 1, date: dateString) { result in
    switch result {
    case .success(let response):
        if let heartrates = response.data {
            print("今日心率记录数: \(heartrates.count)")
        }
    case .failure(let error):
        print("查询心率记录失败: \(error)")
    }
}
```

### 社区功能

```swift
// 发布推文
let tweet = Tweet(
    title: "我的健康数据",
    content: "今天的心率很稳定",
    userId: 100,
    tweetType: "user",
    publishStatus: "published"
)

APIService.shared.addUserTweet(tweet) { result in
    switch result {
    case .success(let response):
        if let tweet = response.data {
            print("推文发布成功，ID: \(tweet.id ?? 0)")
        }
    case .failure(let error):
        print("发布推文失败: \(error)")
    }
}

// 查看最新推文
APIService.shared.getLatestTweets(userId: 100, size: 10) { result in
    switch result {
    case .success(let response):
        if let data = response.data {
            // 处理推文数据
        }
    case .failure(let error):
        print("获取推文失败: \(error)")
    }
}
```

### 认证

```swift
// 微信登录
let wxLoginBody = WxLoginBody(
    code: "wechat_code",
    encryptedData: nil,
    encryptedIv: nil
)

APIService.shared.wxLogin(wxLoginBody) { result in
    switch result {
    case .success(let response):
        if response.isSuccess {
            // 从响应中提取 token 并保存
            // NetworkManager.shared.setAuthToken(token)
        }
    case .failure(let error):
        print("微信登录失败: \(error)")
    }
}
```

## 错误处理

所有接口都返回 `Result<T, NetworkError>`，可以使用 switch 语句处理：

```swift
APIService.shared.getDeviceList { result in
    switch result {
    case .success(let data):
        // 处理成功情况
        break
    case .failure(let error):
        switch error {
        case .unauthorized:
            // 未授权，跳转到登录页
            break
        case .networkError(let underlyingError):
            // 网络错误
            print("网络错误: \(underlyingError)")
        case .apiError(let statusCode, let message):
            // API 错误
            print("API 错误 [\(statusCode)]: \(message)")
        default:
            print("其他错误: \(error.localizedDescription)")
        }
    }
}
```

## 注意事项

1. **认证 Token**: 所有接口都需要认证，登录成功后记得设置 Token
2. **日期格式**: 建议使用 ISO 8601 格式（如：`2024-01-01` 或 `2024-01-01T12:00:00`）
3. **线程安全**: 所有回调都在主线程执行，可以直接更新 UI
4. **错误处理**: 建议统一处理错误，特别是 401 未授权错误

## 文件结构

```
Modules/Network/
├── NetworkManager.swift      # 网络请求管理器
├── APIService.swift          # API 接口服务
├── DataModels.swift          # 数据模型
├── ResponseModels.swift      # 响应模型
└── README.md                 # 使用文档
```

