import UIKit

// 身体电量进度模块
// 单独展示身体电量进度条，与警告信息分离
final class BodyPowerModule: UIView {
    
    // 进度条配置
    struct Configuration {
        let percentage: CGFloat       // 百分比值 (0-100)
        let barColor: UIColor         // 进度条颜色
        let labelColor: UIColor       // 标签颜色
    }
    
    // UI元素
    private let powerLabel = UILabel()
    private let progressContainer = UIView()
    private let backgroundBar = UIView()
    private let progressBar = UIView()
    private let percentLabel = UILabel()
    
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
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        // 标题标签
        powerLabel.text = "□  身体电量"
        powerLabel.textColor = UIColor(hex: 0xFFD23A)
        powerLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        powerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(powerLabel)
        
        // 进度条容器
        progressContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressContainer)
        
        // 背景进度条
        backgroundBar.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        backgroundBar.layer.cornerRadius = 3
        backgroundBar.translatesAutoresizingMaskIntoConstraints = false
        progressContainer.addSubview(backgroundBar)
        
        // 数据进度条
        progressBar.backgroundColor = UIColor(hex: 0xFFD23A)
        progressBar.layer.cornerRadius = 3
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressContainer.addSubview(progressBar)
        
        // 百分比标签
        percentLabel.textColor = UIColor(hex: 0xFFD23A)
        percentLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        percentLabel.textAlignment = .right
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(percentLabel)
        
        // 约束配置
        NSLayoutConstraint.activate([
            // 标题约束
            powerLabel.topAnchor.constraint(equalTo: topAnchor),
            powerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            // 进度条容器约束
            progressContainer.topAnchor.constraint(equalTo: powerLabel.bottomAnchor, constant: 10),
            progressContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressContainer.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -10),
            progressContainer.heightAnchor.constraint(equalToConstant: 6),
            progressContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 背景进度条约束
            backgroundBar.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            backgroundBar.topAnchor.constraint(equalTo: progressContainer.topAnchor),
            backgroundBar.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor),
            backgroundBar.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor),
            
            // 数据进度条约束
            progressBar.leadingAnchor.constraint(equalTo: backgroundBar.leadingAnchor),
            progressBar.topAnchor.constraint(equalTo: backgroundBar.topAnchor),
            progressBar.bottomAnchor.constraint(equalTo: backgroundBar.bottomAnchor),
            
            // 百分比标签约束
            percentLabel.topAnchor.constraint(equalTo: powerLabel.topAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            percentLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Public Methods
    
    // 配置进度条数据
    func configure(with config: Configuration) {
        // 更新百分比标签
        percentLabel.text = String(format: "%.0f%%", config.percentage)
        percentLabel.textColor = config.labelColor
        
        // 更新标题颜色
        powerLabel.textColor = config.labelColor
        
        // 更新进度条
        updateProgressBar(percentage: config.percentage, color: config.barColor)
    }
    
    // MARK: - Private Methods
    
    private func updateProgressBar(percentage: CGFloat, color: UIColor) {
        // 确保百分比在有效范围内
        let clampedPercentage = max(0, min(100, percentage))
        let multiplier = clampedPercentage / 100
        
        // 移除之前的宽度约束
        progressBar.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                progressBar.removeConstraint(constraint)
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
        // 使用CABasicAnimation实现高性能的动画
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
