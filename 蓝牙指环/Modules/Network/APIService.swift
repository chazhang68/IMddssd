import Foundation

/// API 服务类
/// 封装所有 API 接口调用
final class APIService {
    
    // MARK: - 单例
    
    static let shared = APIService()
    
    // MARK: - 属性
    
    private let networkManager = NetworkManager.shared
    
    // MARK: - 初始化
    
    private init() {}
    
    // MARK: - 设备管理接口
    
    /// 新增设备
    func addDevice(_ device: Device, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        networkManager.post("/deviceuser/device", body: device, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    /// 获取设备列表
    func getDeviceList(completion: @escaping (Result<TableDataInfo, NetworkError>) -> Void) {
        networkManager.get("/deviceuser/device/list", responseType: TableDataInfo.self, completion: completion)
    }
    
    /// 移除设备
    func removeDevice(id: Int64, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        networkManager.get("/deviceuser/device/\(id)", responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    // MARK: - 心率记录管理接口
    
    /// 新增心率记录
    func addHeartrate(_ heartrate: Heartrate, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        networkManager.post("/deviceuser/heartrate", body: heartrate, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    /// 查询心率记录（日）
    func getDailyHeartrate(deviceId: Int64, date: String, completion: @escaping (Result<ApiResponse<[Heartrate]>, NetworkError>) -> Void) {
        let parameters = [
            "deviceId": deviceId,
            "date": date
        ]
        networkManager.get("/deviceuser/heartrate/daily", parameters: parameters, responseType: ApiResponse<[Heartrate]>.self, completion: completion)
    }
    
    // MARK: - 血氧记录管理接口
    
    /// 新增血氧记录
    func addOxygen(_ oxygen: Oxygen, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        networkManager.post("/deviceuser/oxygen", body: oxygen, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    /// 查询血氧记录（日）
    func getDailyOxygen(deviceId: Int64, date: String, completion: @escaping (Result<ApiResponse<[Oxygen]>, NetworkError>) -> Void) {
        let parameters = [
            "deviceId": deviceId,
            "date": date
        ]
        networkManager.get("/deviceuser/oxygen/daily", parameters: parameters, responseType: ApiResponse<[Oxygen]>.self, completion: completion)
    }
    
    // MARK: - 血压记录管理接口
    
    /// 新增血压记录
    func addPressure(_ pressure: Pressure, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        networkManager.post("/deviceuser/pressure", body: pressure, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    /// 查询血压记录（日）
    func getDailyPressure(deviceId: Int64, date: String, completion: @escaping (Result<ApiResponse<[Pressure]>, NetworkError>) -> Void) {
        let parameters = [
            "deviceId": deviceId,
            "date": date
        ]
        networkManager.get("/deviceuser/pressure/daily", parameters: parameters, responseType: ApiResponse<[Pressure]>.self, completion: completion)
    }
    
    // MARK: - 睡眠记录管理接口
    
    /// 新增睡眠记录
    func addSleep(_ sleep: Sleep, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        networkManager.post("/deviceuser/sleep", body: sleep, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    /// 查询睡眠记录（日）
    func getDailySleep(deviceId: Int64, date: String, completion: @escaping (Result<ApiResponse<[Sleep]>, NetworkError>) -> Void) {
        let parameters = [
            "deviceId": deviceId,
            "date": date
        ]
        networkManager.get("/deviceuser/sleep/daily", parameters: parameters, responseType: ApiResponse<[Sleep]>.self, completion: completion)
    }
    
    // MARK: - 步数记录管理接口
    
    /// 新增步数记录
    func addStep(_ step: Step, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        networkManager.post("/deviceuser/step", body: step, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    /// 查询步数记录（日）
    func getDailyStep(deviceId: Int64, date: String, completion: @escaping (Result<ApiResponse<[Step]>, NetworkError>) -> Void) {
        let parameters = [
            "deviceId": deviceId,
            "date": date
        ]
        networkManager.get("/deviceuser/step/daily", parameters: parameters, responseType: ApiResponse<[Step]>.self, completion: completion)
    }
    
    // MARK: - 体温记录管理接口
    
    /// 新增体温记录
    func addTemperature(_ temperature: Temperature, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        networkManager.post("/deviceuser/temperature", body: temperature, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    /// 查询体温记录（日）
    func getDailyTemperature(deviceId: Int64, date: String, completion: @escaping (Result<ApiResponse<[Temperature]>, NetworkError>) -> Void) {
        let parameters = [
            "deviceId": deviceId,
            "date": date
        ]
        networkManager.get("/deviceuser/temperature/daily", parameters: parameters, responseType: ApiResponse<[Temperature]>.self, completion: completion)
    }
    
    // MARK: - 微信接口调用
    
    /// 微信登录
    func wxLogin(_ body: WxLoginBody, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        networkManager.post("/wxLogin", body: body, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    /// 手机号一键登录
    func phoneLogin(_ body: PhoneLoginBody, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        networkManager.post("/phoneLogin", body: body, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    /// 号码认证
    func phoneVerify(_ body: PhoneVerifyBody, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        networkManager.post("/phoneVerify", body: body, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    // MARK: - 推文管理接口
    
    /// 用户发布推文
    func addUserTweet(_ tweet: Tweet, completion: @escaping (Result<ApiResponse<Tweet>, NetworkError>) -> Void) {
        networkManager.post("/communityuser/tweet/user/add", body: tweet, responseType: ApiResponse<Tweet>.self, completion: completion)
    }
    
    /// 系统新增推文（自动发布）
    func addSystemTweet(_ tweet: Tweet, completion: @escaping (Result<ApiResponse<Tweet>, NetworkError>) -> Void) {
        networkManager.post("/communityuser/tweet/system/add", body: tweet, responseType: ApiResponse<Tweet>.self, completion: completion)
    }
    
    /// 查看推文详情
    func getTweetDetail(id: Int64, completion: @escaping (Result<ApiResponse<Tweet>, NetworkError>) -> Void) {
        networkManager.get("/communityuser/tweet/detail/\(id)", responseType: ApiResponse<Tweet>.self, completion: completion)
    }
    
    /// 查看推文详情(含互动统计)
    func getTweetDetailFull(id: Int64, userId: Int64? = nil, completion: @escaping (Result<ApiResponse<[String: AnyCodable]>, NetworkError>) -> Void) {
        var parameters: [String: Any] = [:]
        if let userId = userId {
            parameters["userId"] = userId
        }
        networkManager.get("/communityuser/tweet/detail/full/\(id)", parameters: parameters.isEmpty ? nil : parameters, responseType: ApiResponse<[String: AnyCodable]>.self, completion: completion)
    }
    
    /// 查看最新推文及未读统计
    func getLatestTweets(userId: Int64, size: Int? = nil, completion: @escaping (Result<ApiResponse<[String: AnyCodable]>, NetworkError>) -> Void) {
        var parameters: [String: Any] = ["userId": userId]
        if let size = size {
            parameters["size"] = size
        }
        networkManager.get("/communityuser/tweet/latest", parameters: parameters, responseType: ApiResponse<[String: AnyCodable]>.self, completion: completion)
    }
    
    // MARK: - 推文点赞接口
    
    /// 推文点赞添加
    func likeTweet(tweetId: Int64, userId: Int64, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        let parameters = [
            "tweetId": tweetId,
            "userId": userId
        ]
        networkManager.post("/communityuser/tweetlike/action", parameters: parameters, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    // MARK: - 推文查看接口
    
    /// 推文查看记录
    func recordTweetView(tweetId: Int64, userId: Int64, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        let parameters = [
            "tweetId": tweetId,
            "userId": userId
        ]
        networkManager.post("/communityuser/tweetview/record", parameters: parameters, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    // MARK: - 评论接口
    
    /// 用户发表评论
    func publishComment(_ comment: Comment, completion: @escaping (Result<ApiResponse<Comment>, NetworkError>) -> Void) {
        networkManager.post("/communityuser/comment/publish", body: comment, responseType: ApiResponse<Comment>.self, completion: completion)
    }
    
    /// 根据父级ID查看评论列表
    func getCommentListByPid(tweetId: Int64, pid: Int64? = nil, completion: @escaping (Result<ApiResponse<[Comment]>, NetworkError>) -> Void) {
        var parameters: [String: Any] = ["tweetId": tweetId]
        if let pid = pid {
            parameters["pid"] = pid
        }
        networkManager.get("/communityuser/comment/listByPid", parameters: parameters, responseType: ApiResponse<[Comment]>.self, completion: completion)
    }
    
    // MARK: - 评论查看接口
    
    /// 记录评论查看
    func recordCommentView(commentId: Int64, userId: Int64, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        let parameters = [
            "commentId": commentId,
            "userId": userId
        ]
        networkManager.post("/communityuser/commentview/record", parameters: parameters, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    // MARK: - 关注关系接口
    
    /// 添加关注
    func addFollow(userId: Int64, followUserId: Int64, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        let parameters = [
            "userId": userId,
            "followUserId": followUserId
        ]
        networkManager.post("/communityuser/follow/relation", parameters: parameters, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    /// 取消关注
    func cancelFollow(userId: Int64, followUserId: Int64, completion: @escaping (Result<ApiResponse<[String: String]>, NetworkError>) -> Void) {
        let parameters = [
            "userId": userId,
            "followUserId": followUserId
        ]
        networkManager.delete("/communityuser/follow/relation", parameters: parameters, responseType: ApiResponse<[String: String]>.self, completion: completion)
    }
    
    /// 查看我的关注列表
    func getMyFollows(userId: Int64, completion: @escaping (Result<ApiResponse<[Follow]>, NetworkError>) -> Void) {
        let parameters = ["userId": userId]
        networkManager.get("/communityuser/follow/mine", parameters: parameters, responseType: ApiResponse<[Follow]>.self, completion: completion)
    }
    
    // MARK: - 测试接口
    
    /// 获取用户列表
    func getUserList(completion: @escaping (Result<ApiResponse<[UserEntity]>, NetworkError>) -> Void) {
        networkManager.get("/test/user/list", responseType: ApiResponse<[UserEntity]>.self, completion: completion)
    }
    
    /// 新增用户
    func saveUser(username: String? = nil, password: String? = nil, mobile: String? = nil, userId: Int32? = nil, completion: @escaping (Result<ApiResponse<String>, NetworkError>) -> Void) {
        var parameters: [String: Any] = [:]
        if let username = username { parameters["username"] = username }
        if let password = password { parameters["password"] = password }
        if let mobile = mobile { parameters["mobile"] = mobile }
        if let userId = userId { parameters["userId"] = userId }
        networkManager.post("/test/user/save", parameters: parameters, responseType: ApiResponse<String>.self, completion: completion)
    }
    
    /// 更新用户
    func updateUser(_ user: UserEntity, completion: @escaping (Result<ApiResponse<String>, NetworkError>) -> Void) {
        networkManager.put("/test/user/update", body: user, responseType: ApiResponse<String>.self, completion: completion)
    }
    
    /// 获取用户详细
    func getUser(userId: Int32, completion: @escaping (Result<ApiResponse<UserEntity>, NetworkError>) -> Void) {
        networkManager.get("/test/user/\(userId)", responseType: ApiResponse<UserEntity>.self, completion: completion)
    }
    
    /// 删除用户信息
    func deleteUser(userId: Int32, completion: @escaping (Result<ApiResponse<String>, NetworkError>) -> Void) {
        networkManager.delete("/test/user/\(userId)", responseType: ApiResponse<String>.self, completion: completion)
    }
}

// MARK: - 扩展：POST 请求支持查询参数

extension NetworkManager {
    /// 发送 POST 请求（带查询参数）
    func post<T: Decodable>(
        _ path: String,
        parameters: [String: Any]? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        request(path: path, method: "POST", parameters: parameters, responseType: responseType, completion: completion)
    }
}

