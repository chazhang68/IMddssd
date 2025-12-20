import Foundation

/// 网络请求管理器
/// 封装基础的 HTTP 请求功能，包括认证、错误处理等
final class NetworkManager {
    
    // MARK: - 单例
    
    static let shared = NetworkManager()
    
    // MARK: - 属性
    
    /// 基础 URL
    private let baseURL = "http://47.106.189.19/prod-api"
    
    /// 认证 Token（从 UserDefaults 或其他地方获取）
    private var authToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "auth_token")
        }
        set {
            if let token = newValue {
                UserDefaults.standard.set(token, forKey: "auth_token")
            } else {
                UserDefaults.standard.removeObject(forKey: "auth_token")
            }
        }
    }
    
    /// URLSession 配置
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        return URLSession(configuration: configuration)
    }()
    
    // MARK: - 初始化
    
    private init() {}
    
    // MARK: - 公开方法
    
    /// 设置认证 Token
    /// - Parameter token: 认证令牌
    func setAuthToken(_ token: String?) {
        authToken = token
    }
    
    /// 获取当前认证 Token
    /// - Returns: 认证令牌，如果未设置则返回 nil
    func getAuthToken() -> String? {
        return authToken
    }
    
    /// 清除认证 Token
    func clearAuthToken() {
        authToken = nil
    }
    
    // MARK: - 通用请求方法
    
    /// 发送 GET 请求
    /// - Parameters:
    ///   - path: 接口路径（如：/deviceuser/device/list）
    ///   - parameters: 查询参数
    ///   - completion: 完成回调
    func get<T: Decodable>(
        _ path: String,
        parameters: [String: Any]? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        request(path: path, method: "GET", parameters: parameters, responseType: responseType, completion: completion)
    }
    
    /// 发送 POST 请求
    /// - Parameters:
    ///   - path: 接口路径
    ///   - body: 请求体（会被编码为 JSON）
    ///   - completion: 完成回调
    func post<T: Decodable>(
        _ path: String,
        body: Encodable? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        request(path: path, method: "POST", body: body, responseType: responseType, completion: completion)
    }
    
    /// 发送 PUT 请求
    /// - Parameters:
    ///   - path: 接口路径
    ///   - body: 请求体
    ///   - completion: 完成回调
    func put<T: Decodable>(
        _ path: String,
        body: Encodable? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        request(path: path, method: "PUT", body: body, responseType: responseType, completion: completion)
    }
    
    /// 发送 DELETE 请求
    /// - Parameters:
    ///   - path: 接口路径
    ///   - parameters: 查询参数
    ///   - completion: 完成回调
    func delete<T: Decodable>(
        _ path: String,
        parameters: [String: Any]? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        request(path: path, method: "DELETE", parameters: parameters, responseType: responseType, completion: completion)
    }
    
    // MARK: - 私有方法
    
    /// 通用请求方法
    private func request<T: Decodable>(
        path: String,
        method: String,
        parameters: [String: Any]? = nil,
        body: Encodable? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        // 构建 URL
        guard var urlComponents = URLComponents(string: baseURL + path) else {
            completion(.failure(.invalidURL))
            return
        }
        
        // 添加查询参数（GET/DELETE/POST with parameters）
        if let parameters = parameters, !parameters.isEmpty {
            urlComponents.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        // 创建请求
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 添加认证 Token
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // 添加请求体（POST/PUT with body）
        // 注意：如果同时有 parameters 和 body，body 优先
        if let body = body {
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                request.httpBody = try encoder.encode(body)
            } catch {
                completion(.failure(.encodingError(error)))
                return
            }
        }
        
        // 发送请求
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            // 处理网络错误
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            // 检查 HTTP 响应
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            // 处理 HTTP 状态码
            guard (200...299).contains(httpResponse.statusCode) else {
                let error = self?.handleHTTPError(statusCode: httpResponse.statusCode, data: data)
                DispatchQueue.main.async {
                    completion(.failure(error ?? .httpError(httpResponse.statusCode)))
                }
                return
            }
            
            // 解析响应数据
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let result = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                print("❌ JSON 解析失败: \(error)")
                print("   响应数据: \(String(data: data, encoding: .utf8) ?? "无法解析")")
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
        task.resume()
    }
    
    /// 处理 HTTP 错误
    private func handleHTTPError(statusCode: Int, data: Data?) -> NetworkError {
        // 尝试解析错误信息
        if let data = data,
           let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            return .apiError(statusCode: statusCode, message: errorResponse.msg)
        }
        
        // 根据状态码返回对应的错误
        switch statusCode {
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 500:
            return .serverError
        case 601:
            return .warning
        default:
            return .httpError(statusCode)
        }
    }
}

// MARK: - 网络错误类型

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case encodingError(Error)
    case decodingError(Error)
    case networkError(Error)
    case httpError(Int)
    case unauthorized
    case forbidden
    case serverError
    case warning
    case apiError(statusCode: Int, message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的 URL"
        case .invalidResponse:
            return "无效的响应"
        case .noData:
            return "没有返回数据"
        case .encodingError(let error):
            return "编码错误: \(error.localizedDescription)"
        case .decodingError(let error):
            return "解码错误: \(error.localizedDescription)"
        case .networkError(let error):
            return "网络错误: \(error.localizedDescription)"
        case .httpError(let code):
            return "HTTP 错误: \(code)"
        case .unauthorized:
            return "未授权，请先登录"
        case .forbidden:
            return "没有权限访问该资源"
        case .serverError:
            return "操作失败，请联系管理员"
        case .warning:
            return "警告消息"
        case .apiError(_, let message):
            return message
        }
    }
}

// MARK: - 错误响应模型

struct ErrorResponse: Codable {
    let code: Int
    let msg: String
}

