import Foundation

// MARK: - 统一返回结果

/// 统一返回结果模型
struct ApiResponse<T: Codable>: Codable {
    let code: Int
    let msg: String
    let data: T?
    
    /// 是否成功
    var isSuccess: Bool {
        return code == 200
    }
}

/// 空数据返回结果（用于 data 字段为 object 的情况）
typealias EmptyResponse = [String: String]

// MARK: - 表格数据信息

struct TableDataInfo: Codable {
    let code: Int
    let msg: String
    let rows: [[String: AnyCodable]]?
    let total: Int64?
}

/// 用于处理 Any 类型的 Codable 包装器
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            value = dictionary.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "无法解码 AnyCodable")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues { AnyCodable($0) })
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "无法编码 AnyCodable"))
        }
    }
}

