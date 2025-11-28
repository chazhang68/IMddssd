import UIKit

// MARK: - 设备单元格

/// 设备单元格 - 展示单个蓝牙设备信息
/// 包含设备名称、信号强度、连接状态等
class DeviceCell: UITableViewCell {
    
    // MARK: - UI组件定义
    
    /// 设备容器 - 包裹所有设备信息
    private let deviceContainer = UIView()
    
    /// 设备图标 - 显示设备类型图标
    let deviceIcon = UIImageView()
    
    /// 设备名称标签 - 显示设备名称
    let deviceNameLabel = UILabel()
    
    /// 设备状态标签 - 显示连接状态或信号强度
    let deviceStatusLabel = UILabel()
    
    /// 信号强度图标 - 显示WiFi信号图标
    let signalIcon = UIImageView()
    
    /// 连接状态指示点 - 显示设备是否已连接
    let connectionDot = UIView()
    
    /// 箭头图标 - 表示可点击
    let arrowIcon = UIImageView()
    
    // MARK: - 初始化方法
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI设置
    
    /// 设置UI界面
    /// - 创建设备信息展示布局
    /// - 配置各组件样式
    private func setupUI() {
        // 基础设置
        backgroundColor = .clear
        selectionStyle = .none
        
        // 设备容器设置
        deviceContainer.backgroundColor = UIColor(hex: 0xF5F5F5)
        deviceContainer.layer.cornerRadius = 12
        deviceContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deviceContainer)
        
        // 设备图标设置
        deviceIcon.contentMode = .scaleAspectFit
        deviceIcon.tintColor = UIColor(hex: 0x666666)
        deviceIcon.translatesAutoresizingMaskIntoConstraints = false
        deviceContainer.addSubview(deviceIcon)
        
        // 设备名称设置
        deviceNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        deviceNameLabel.textColor = UIColor(hex: 0x333333)
        deviceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        deviceContainer.addSubview(deviceNameLabel)
        
        // 设备状态设置
        deviceStatusLabel.font = UIFont.systemFont(ofSize: 14)
        deviceStatusLabel.textColor = UIColor(hex: 0x999999)
        deviceStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        deviceContainer.addSubview(deviceStatusLabel)
        
        // 信号图标设置
        signalIcon.contentMode = .scaleAspectFit
        signalIcon.tintColor = UIColor(hex: 0x66BB6A)
        signalIcon.translatesAutoresizingMaskIntoConstraints = false
        deviceContainer.addSubview(signalIcon)
        
        // 连接状态点设置
        connectionDot.backgroundColor = UIColor(hex: 0xFF5252)
        connectionDot.layer.cornerRadius = 4
        connectionDot.translatesAutoresizingMaskIntoConstraints = false
        deviceContainer.addSubview(connectionDot)
        
        // 箭头图标设置
        arrowIcon.image = UIImage(systemName: "chevron.right")
        arrowIcon.tintColor = UIColor(hex: 0x999999)
        arrowIcon.contentMode = .scaleAspectFit
        arrowIcon.translatesAutoresizingMaskIntoConstraints = false
        deviceContainer.addSubview(arrowIcon)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 设备容器约束
            deviceContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            deviceContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deviceContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            deviceContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            deviceContainer.heightAnchor.constraint(equalToConstant: 80),
            
            // 设备图标约束
            deviceIcon.leadingAnchor.constraint(equalTo: deviceContainer.leadingAnchor, constant: 16),
            deviceIcon.centerYAnchor.constraint(equalTo: deviceContainer.centerYAnchor),
            deviceIcon.widthAnchor.constraint(equalToConstant: 24),
            deviceIcon.heightAnchor.constraint(equalToConstant: 24),
            
            // 设备名称约束
            deviceNameLabel.leadingAnchor.constraint(equalTo: deviceIcon.trailingAnchor, constant: 12),
            deviceNameLabel.topAnchor.constraint(equalTo: deviceContainer.topAnchor, constant: 20),
            deviceNameLabel.trailingAnchor.constraint(equalTo: signalIcon.leadingAnchor, constant: -8),
            
            // 设备状态约束
            deviceStatusLabel.leadingAnchor.constraint(equalTo: deviceNameLabel.leadingAnchor),
            deviceStatusLabel.topAnchor.constraint(equalTo: deviceNameLabel.bottomAnchor, constant: 4),
            deviceStatusLabel.trailingAnchor.constraint(equalTo: deviceNameLabel.trailingAnchor),
            
            // 信号图标约束
            signalIcon.trailingAnchor.constraint(equalTo: connectionDot.leadingAnchor, constant: -8),
            signalIcon.centerYAnchor.constraint(equalTo: deviceContainer.centerYAnchor),
            signalIcon.widthAnchor.constraint(equalToConstant: 20),
            signalIcon.heightAnchor.constraint(equalToConstant: 20),
            
            // 连接状态点约束
            connectionDot.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -12),
            connectionDot.centerYAnchor.constraint(equalTo: deviceContainer.centerYAnchor),
            connectionDot.widthAnchor.constraint(equalToConstant: 8),
            connectionDot.heightAnchor.constraint(equalToConstant: 8),
            
            // 箭头图标约束
            arrowIcon.trailingAnchor.constraint(equalTo: deviceContainer.trailingAnchor, constant: -16),
            arrowIcon.centerYAnchor.constraint(equalTo: deviceContainer.centerYAnchor),
            arrowIcon.widthAnchor.constraint(equalToConstant: 16),
            arrowIcon.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    // MARK: - 配置方法
    
    /// 配置单元格显示的设备信息
    /// - Parameters:
    ///   - name: 设备名称
    ///   - status: 设备状态（信号强度或连接状态）
    ///   - isConnected: 是否已连接
    ///   - signalStrength: 信号强度（0-3）
    func configure(name: String, status: String, isConnected: Bool, signalStrength: Int = 0) {
        deviceNameLabel.text = name  // 设置设备名称
        deviceStatusLabel.text = status  // 设置状态文字
        
        // 设置连接状态
        if isConnected {
            connectionDot.backgroundColor = UIColor(hex: 0x66BB6A)  // 绿色已连接
        } else {
            connectionDot.backgroundColor = UIColor(hex: 0xFF5252)  // 红色未连接
        }
        
        // 设置信号强度图标
        let signalIconName: String
        switch signalStrength {
        case 0:
            signalIconName = "wifi"  // 无信号
        case 1:
            signalIconName = "wifi"  // 弱信号
        case 2:
            signalIconName = "wifi"  // 中信号
        case 3:
            signalIconName = "wifi"  // 强信号
        default:
            signalIconName = "wifi"
        }
        signalIcon.image = UIImage(systemName: signalIconName)
        
        // 根据信号强度调整颜色
        if signalStrength >= 2 {
            signalIcon.tintColor = UIColor(hex: 0x66BB6A)  // 绿色好信号
        } else if signalStrength >= 1 {
            signalIcon.tintColor = UIColor(hex: 0xFFB74D)  // 黄色一般信号
        } else {
            signalIcon.tintColor = UIColor(hex: 0xFF5252)  // 红色弱信号
        }
    }
}