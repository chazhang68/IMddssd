import UIKit

/// 设备网格单元格 - 展示单个蓝牙设备卡片
/// 包含设备名称、图标、电池百分比、蓝牙连接状态等
class DeviceGridCell: UICollectionViewCell {
    
    // MARK: - UI组件定义
    
    /// 背景容器
    private let containerView = UIView()
    
    /// 背景图片视图 - 展示设备产品图
    private let backgroundImageView = UIImageView()
    
    /// 设备类型图标 - 显示设备类型（眼镜、手表等）
    let deviceTypeIcon = UIImageView()
    
    /// 设备名称标签
    let deviceNameLabel = UILabel()
    
    /// 电池百分比标签
    let batteryLabel = UILabel()
    
    /// 蓝牙连接状态 - 圆形指示点
    let bluetoothIndicator = UIView()
    
    /// 顶部内容栈视图 - 包含图标和电池信息
    private let topStackView = UIStackView()
    
    // MARK: - 初始化方法
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI设置
    
    private func setupUI() {
        // 背景容器设置
        containerView.backgroundColor = UIColor(hex: 0xE5E5E5)
        containerView.layer.cornerRadius = 24
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // 背景图片设置（居中显示设备大图）
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(backgroundImageView)
        
        // 左上角设备类型图标
        deviceTypeIcon.contentMode = .scaleAspectFit
        deviceTypeIcon.tintColor = UIColor(hex: 0x333333)
        deviceTypeIcon.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(deviceTypeIcon)
        
        // 电池标签（左上角，图标右侧，黄色背景）
        batteryLabel.font = .systemFont(ofSize: 11, weight: .medium)
        batteryLabel.textColor = .black
        batteryLabel.backgroundColor = UIColor(hex: 0xFFB200)
        batteryLabel.layer.cornerRadius = 8
        batteryLabel.layer.masksToBounds = true
        batteryLabel.textAlignment = .center
        batteryLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(batteryLabel)
        
        // 右上角蓝牙按钮容器
        bluetoothIndicator.backgroundColor = .white
        bluetoothIndicator.layer.cornerRadius = 22
        bluetoothIndicator.layer.masksToBounds = true
        bluetoothIndicator.layer.borderWidth = 2
        bluetoothIndicator.layer.borderColor = UIColor(hex: 0x333333).cgColor
        bluetoothIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bluetoothIndicator)
        
        // 蓝牙图标
        let bluetoothIcon = UIImageView()
        bluetoothIcon.image = UIImage(systemName: "bluetooth")
        bluetoothIcon.tintColor = UIColor(hex: 0x333333)
        bluetoothIcon.contentMode = .scaleAspectFit
        bluetoothIcon.tag = 999 // 标记以便后续修改颜色
        bluetoothIcon.translatesAutoresizingMaskIntoConstraints = false
        bluetoothIndicator.addSubview(bluetoothIcon)
        
        // 设备名称标签 - 左侧中上位置
        deviceNameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        deviceNameLabel.textColor = UIColor(hex: 0x333333)
        deviceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(deviceNameLabel)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 容器约束
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // 背景图片约束（居中，占满底部空间）
            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            backgroundImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5),
            
            // 左上角设备类型图标
            deviceTypeIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            deviceTypeIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            deviceTypeIcon.widthAnchor.constraint(equalToConstant: 24),
            deviceTypeIcon.heightAnchor.constraint(equalToConstant: 24),
            
            // 电池标签（图标右侧）
            batteryLabel.centerYAnchor.constraint(equalTo: deviceTypeIcon.centerYAnchor),
            batteryLabel.leadingAnchor.constraint(equalTo: deviceTypeIcon.trailingAnchor, constant: 6),
            batteryLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
            batteryLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // 右上角蓝牙按钮
            bluetoothIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            bluetoothIndicator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            bluetoothIndicator.widthAnchor.constraint(equalToConstant: 44),
            bluetoothIndicator.heightAnchor.constraint(equalToConstant: 44),
            
            // 蓝牙图标
            bluetoothIcon.centerXAnchor.constraint(equalTo: bluetoothIndicator.centerXAnchor),
            bluetoothIcon.centerYAnchor.constraint(equalTo: bluetoothIndicator.centerYAnchor),
            bluetoothIcon.widthAnchor.constraint(equalToConstant: 20),
            bluetoothIcon.heightAnchor.constraint(equalToConstant: 20),
            
            // 设备名称约束（左侧中上）
            deviceNameLabel.topAnchor.constraint(equalTo: deviceTypeIcon.bottomAnchor, constant: 12),
            deviceNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            deviceNameLabel.trailingAnchor.constraint(equalTo: bluetoothIndicator.leadingAnchor, constant: -8)
        ])
    }
    
    // MARK: - 配置方法
    
    func configure(name: String, batteryPercentage: Int?, deviceType: String?, backgroundImage: UIImage?, isConnected: Bool) {
        deviceNameLabel.text = name
        
        // 设置背景颜色：已连接为黄色，未连接为浅灰色
        containerView.backgroundColor = isConnected ? UIColor(hex: 0xFFB200) : UIColor(hex: 0xE5E5E5)
        
        // 设置电池百分比（仅已连接设备显示）
        if isConnected, let battery = batteryPercentage {
            batteryLabel.text = "\(battery)%"
            batteryLabel.isHidden = false
        } else {
            batteryLabel.text = ""
            batteryLabel.isHidden = true
        }
        
        // 设置设备类型图标
        if let type = deviceType {
            deviceTypeIcon.image = UIImage(systemName: type)
        } else {
            deviceTypeIcon.image = nil
        }
        
        // 设置背景图片
        backgroundImageView.image = backgroundImage
        
        // 设置蓝牙按钮样式
        if isConnected {
            // 已连接：蓝色背景，白色图标，无边框
            bluetoothIndicator.backgroundColor = UIColor(hex: 0x2196F3)
            bluetoothIndicator.layer.borderWidth = 0
            if let bluetoothIcon = bluetoothIndicator.viewWithTag(999) as? UIImageView {
                bluetoothIcon.tintColor = .white
            }
        } else {
            // 未连接：白色背景，黑色图标，黑色边框
            bluetoothIndicator.backgroundColor = .white
            bluetoothIndicator.layer.borderWidth = 2
            bluetoothIndicator.layer.borderColor = UIColor(hex: 0x333333).cgColor
            if let bluetoothIcon = bluetoothIndicator.viewWithTag(999) as? UIImageView {
                bluetoothIcon.tintColor = UIColor(hex: 0x333333)
            }
        }
    }
}
