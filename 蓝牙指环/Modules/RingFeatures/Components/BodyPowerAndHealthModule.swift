import UIKit

// 身体电量与健康建议模块
// 用于展示身体电量进度条和健康状态警告信息
final class BodyPowerAndHealthModule: UIView {
    
    // 模块配置数据
    struct Configuration {
        let powerPercentage: CGFloat  // 身体电量百分比 (0-100)
        let powerColor: UIColor       // 进度条颜色
        let statusTitle: String       // 状态标题（如"次健康"）
        let adviceText: String        // 健康建议文本
    }
    
    // 进度条视图
    private let progressBar = UIView()
    private let backgroundBar = UIView()
    private let percentLabel = UILabel()
    
    // 警告信息视图
    private let warningView = UIView()
    private let warningLabel = UILabel()
    
    // 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // 设置模块背景和圆角
        backgroundColor = UIColor(hex: 0x2A2B2D)
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false
        
        setupPowerSection()
        setupWarningSection()
    }
    
    private func setupPowerSection() {
        // 设置身体电量标题
        let powerLabel = UILabel()
        powerLabel.text = "□  身体电量"
        powerLabel.textColor = UIColor(hex: 0xFFD23A)
        powerLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        powerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(powerLabel)
        
        // 设置背景进度条
        backgroundBar.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        backgroundBar.layer.cornerRadius = 3
        backgroundBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundBar)
        
        // 设置数据进度条
        progressBar.backgroundColor = UIColor(hex: 0xFFD23A)
        progressBar.layer.cornerRadius = 3
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressBar)
        
        // 设置百分比标签
        percentLabel.textColor = UIColor(hex: 0xFFD23A)
        percentLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(percentLabel)
        
        // 配置约束
        NSLayoutConstraint.activate([
            powerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            powerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            backgroundBar.topAnchor.constraint(equalTo: powerLabel.bottomAnchor, constant: 10),
            backgroundBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            backgroundBar.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -10),
            backgroundBar.heightAnchor.constraint(equalToConstant: 6),
            
            progressBar.topAnchor.constraint(equalTo: backgroundBar.topAnchor),
            progressBar.leadingAnchor.constraint(equalTo: backgroundBar.leadingAnchor),
            progressBar.bottomAnchor.constraint(equalTo: backgroundBar.bottomAnchor),
            
            percentLabel.topAnchor.constraint(equalTo: powerLabel.bottomAnchor, constant: 10),
            percentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            percentLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupWarningSection() {
        // 设置警告信息容器
        warningView.backgroundColor = UIColor(hex: 0x1A1B1D)
        warningView.layer.cornerRadius = 10
        warningView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(warningView)
        
        // 设置警告文本
        warningLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        warningLabel.font = .systemFont(ofSize: 12, weight: .regular)
        warningLabel.numberOfLines = 0
        warningLabel.lineSpacing = 2
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningView.addSubview(warningLabel)
        
        // 配置约束
        NSLayoutConstraint.activate([
            warningView.topAnchor.constraint(equalTo: backgroundBar.bottomAnchor, constant: 16),
            warningView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            warningView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            warningView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            warningLabel.topAnchor.constraint(equalTo: warningView.topAnchor, constant: 12),
            warningLabel.leadingAnchor.constraint(equalTo: warningView.leadingAnchor, constant: 12),
            warningLabel.trailingAnchor.constraint(equalTo: warningView.trailingAnchor, constant: -12),
            warningLabel.bottomAnchor.constraint(equalTo: warningView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Public Methods
    
    // 配置模块数据
    // 参数：config - 配置对象，包含电量百分比、颜色、警告信息等
    // 例如：
    // let config = Configuration(
    //     powerPercentage: 34,
    //     powerColor: UIColor(hex: 0xFFD23A),
    //     statusTitle: "次健康",
    //     adviceText: "您处于亚健康状态..."
    // )
    // module.configure(with: config)
    func configure(with config: Configuration) {
        // 更新进度条宽度
        updateProgressBar(percentage: config.powerPercentage, color: config.powerColor)
        
        // 更新百分比标签
        percentLabel.text = String(format: "%.0f%%", config.powerPercentage)
        percentLabel.textColor = config.powerColor
        
        // 更新背景色和进度条色
        progressBar.backgroundColor = config.powerColor
        
        // 更新警告信息
        let warningText = "\(config.statusTitle)\n\(config.adviceText)"
        warningLabel.text = warningText
    }
    
    // 更新进度条
    // 参数：percentage - 百分比值 (0-100)
    //       color - 进度条颜色
    private func updateProgressBar(percentage: CGFloat, color: UIColor) {
        // 计算进度条宽度
        let clampedPercentage = max(0, min(100, percentage))
        let multiplier = clampedPercentage / 100
        
        // 移除之前的宽度约束
        progressBar.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                removeConstraint(constraint)
            }
        }
        
        // 添加新的宽度约束
        progressBar.widthAnchor.constraint(
            equalTo: backgroundBar.widthAnchor,
            multiplier: multiplier
        ).isActive = true
        
        // 更新颜色
        progressBar.backgroundColor = color
        
        // 动画更新 - 平滑过渡进度条宽度
        // 使用CABasicAnimation实现更高性能的动画
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            self?.layoutIfNeeded()
        }
        
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        progressBar.layer.add(animation, forKey: "progressAnimation")
        
        CATransaction.commit()
        
        // 主线程更新约束
        DispatchQueue.main.async { [weak self] in
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    self?.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
}

// MARK: - UILabel Extension

extension UILabel {
    // 用于设置行间距的辅助属性
    var lineSpacing: CGFloat {
        get {
            let paragraphStyle = (attributedText?.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle) ?? NSParagraphStyle.default
            return paragraphStyle.lineSpacing
        }
        set {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = newValue
            if let text = text {
                attributedText = NSAttributedString(string: text, attributes: [.paragraphStyle: paragraphStyle])
            }
        }
    }
}
