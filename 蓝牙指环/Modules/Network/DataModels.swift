import Foundation

// MARK: - 设备模型

struct Device: Codable {
    let id: Int64?
    let deviceNo: String
    let deviceName: String?
    let deviceType: String?
    let deviceLinkJson: String?
    let hardwareVersion: String?
    let softwareVersion: String?
    let status: String?
    let userId: Int64?
    let createTime: String?
    let updateTime: String?
}

// MARK: - 健康数据模型

/// 心率记录
struct Heartrate: Codable {
    let id: Int64?
    let deviceId: Int64
    let heartRateValue: Int64
    let measureTime: String
    let userId: Int64
    let createTime: String?
    let updateTime: String?
}

/// 血氧记录
struct Oxygen: Codable {
    let id: Int64?
    let deviceId: Int64
    let oxygenValue: String
    let measureTime: String
    let userId: Int64
    let createTime: String?
    let updateTime: String?
}

/// 血压记录
struct Pressure: Codable {
    let id: Int64?
    let deviceId: Int64
    let systolicPressure: Int64  // 收缩压（高压）
    let diastolicPressure: Int64  // 舒张压（低压）
    let pulse: Int64  // 脉搏
    let measureTime: String
    let userId: Int64
    let createTime: String?
    let updateTime: String?
}

/// 睡眠记录
struct Sleep: Codable {
    let id: Int64?
    let deviceId: Int64
    let sleepType: String
    let measureTime: String
    let userId: Int64
    let createTime: String?
    let updateTime: String?
}

/// 步数记录
struct Step: Codable {
    let id: Int64?
    let deviceId: Int64
    let stepCount: Int64
    let distance: String?
    let calories: String?
    let measureTime: String
    let userId: Int64
    let createTime: String?
    let updateTime: String?
}

/// 体温记录
struct Temperature: Codable {
    let id: Int64?
    let deviceId: Int64
    let temperatureValue: String
    let measureTime: String
    let userId: Int64
    let createTime: String?
    let updateTime: String?
}

// MARK: - 社区模型

/// 推文
struct Tweet: Codable {
    let id: Int64?
    let title: String?
    let content: String?
    let userId: Int64?
    let tweetType: String?
    let publishStatus: String?
    let publishTime: String?
    let createTime: String?
    let updateTime: String?
}

/// 评论
struct Comment: Codable {
    let id: Int64?
    let commentContent: String?
    let tweetId: Int64?
    let userId: Int64?
    let pid: Int64?  // 父级评论ID，顶级为0
    let createTime: String?
    let updateTime: String?
}

/// 关注关系
struct Follow: Codable {
    let userId: Int64
    let followUserId: Int64
    let createTime: String?
    let updateTime: String?
}

// MARK: - 认证模型

/// 微信登录请求体
struct WxLoginBody: Codable {
    let code: String
    let encryptedData: String?
    let encryptedIv: String?
}

/// 手机登录请求体
struct PhoneLoginBody: Codable {
    let exID: String
    let loginToken: String
}

/// 号码认证请求体
struct PhoneVerifyBody: Codable {
    let exID: String
    let phone: String
    let token: String
}

// MARK: - 用户模型

struct UserEntity: Codable {
    let userId: Int32?
    let username: String?
    let password: String?
    let mobile: String?
}

