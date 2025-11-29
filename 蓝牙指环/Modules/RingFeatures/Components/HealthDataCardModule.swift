import UIKit

// 健康数据卡片模块
// 用于展示单个健康指标的卡片
final class HealthDataCardModule: UIView {
    
    // 卡片配置
    struct Configuration {
        let icon: String                // 图标名称
        let title: String               // 标题
        let time: String                // 时间
        let value: String               // 数值
        let unit: String?               // 单位
        let chartType: ChartType         // 图表类型
    }
    
    // 图表类型
    enum ChartType {
        case bar(value: CGFloat)        // 柱状图（值0-1）
        case scatter                    // 散点图
        case line                       // 折线图
    }
    
    // UI元素
    private let titleStack = UIStackView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let valueLabel = UILabel()
    private let unitLabel = UILabel()
    private let chartView = UIView()
    
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
        // 设置卡片背景
        backgroundColor = UIColor(hex: 0x1A1B1D)
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true  // 启用用户交互，允许手势识别
        
        // 标题堆栈（图标 + 标题 + 时间）
        titleStack.axis = .horizontal
        titleStack.spacing = 8
        titleStack.alignment = .center
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleStack)
        
        // 图标
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = UIColor(hex: 0xFFD23A)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleStack.addArrangedSubview(iconView)
        
        // 标题
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleStack.addArrangedSubview(titleLabel)
        
        // 时间
        timeLabel.textColor = UIColor(hex: 0xFFD23A)
        timeLabel.font = .systemFont(ofSize: 10, weight: .regular)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        titleStack.addArrangedSubview(timeLabel)
        
        // 数值标签
        valueLabel.textColor = UIColor(hex: 0xFFD23A)
        valueLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueLabel)
        
        // 单位标签
        unitLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        unitLabel.font = .systemFont(ofSize: 10, weight: .regular)
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(unitLabel)
        
        // 图表区域
        chartView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chartView)
        
        // 配置约束
        NSLayoutConstraint.activate([
            // 标题堆栈
            titleStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            // 图标约束
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 16),
            
            // 数值标签
            valueLabel.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            // 单位标签
            unitLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            unitLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            // 图表区域
            chartView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 12),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            chartView.heightAnchor.constraint(equalToConstant: 35),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Public Methods
    
    // 配置卡片
    func configure(with config: Configuration) {
        iconView.image = UIImage(systemName: config.icon)
        titleLabel.text = config.title
        timeLabel.text = config.time
        valueLabel.text = config.value
        unitLabel.text = config.unit ?? ""
        
        // 绘制图表
        drawChart(type: config.chartType)
    }
    
    // MARK: - Private Methods
    
    private func drawChart(type: ChartType) {
        // 清除之前的图表
        chartView.subviews.forEach { $0.removeFromSuperview() }
        
        switch type {
        case .bar(let value):
            // 绘制柱状图
            let clampedValue = max(0, min(1, value))
            let barHeight = clampedValue * 35
            
            let bar = UIView()
            bar.backgroundColor = UIColor(hex: 0x8B5FFF)
            bar.layer.cornerRadius = 2
            bar.translatesAutoresizingMaskIntoConstraints = false
            chartView.addSubview(bar)
            
            // 添加标签
            let minLabel = UILabel()
            minLabel.text = "差"
            minLabel.textColor = UIColor.white.withAlphaComponent(0.3)
            minLabel.font = .systemFont(ofSize: 8, weight: .regular)
            minLabel.translatesAutoresizingMaskIntoConstraints = false
            chartView.addSubview(minLabel)
            
            let maxLabel = UILabel()
            maxLabel.text = "很好"
            maxLabel.textColor = UIColor.white.withAlphaComponent(0.3)
            maxLabel.font = .systemFont(ofSize: 8, weight: .regular)
            maxLabel.translatesAutoresizingMaskIntoConstraints = false
            chartView.addSubview(maxLabel)
            
            NSLayoutConstraint.activate([
                bar.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: 10),
                bar.bottomAnchor.constraint(equalTo: chartView.bottomAnchor),
                bar.widthAnchor.constraint(equalToConstant: 20),
                bar.heightAnchor.constraint(equalToConstant: barHeight),
                
                minLabel.leadingAnchor.constraint(equalTo: chartView.leadingAnchor),
                minLabel.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -2),
                
                maxLabel.trailingAnchor.constraint(equalTo: chartView.trailingAnchor),
                maxLabel.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -2)
            ])
            
        case .scatter:
            // 绘制散点图
            let points = [
                CGPoint(x: 15, y: 15),
                CGPoint(x: 25, y: 20),
                CGPoint(x: 35, y: 18),
                CGPoint(x: 45, y: 25),
                CGPoint(x: 55, y: 15),
                CGPoint(x: 65, y: 20),
                CGPoint(x: 75, y: 22)
            ]
            
            for point in points {
                let dot = UIView()
                dot.backgroundColor = UIColor(hex: 0xFF6B6B)
                dot.layer.cornerRadius = 2.5
                dot.translatesAutoresizingMaskIntoConstraints = false
                chartView.addSubview(dot)
                
                NSLayoutConstraint.activate([
                    dot.centerXAnchor.constraint(equalTo: chartView.leadingAnchor, constant: point.x),
                    dot.centerYAnchor.constraint(equalTo: chartView.topAnchor, constant: point.y),
                    dot.widthAnchor.constraint(equalToConstant: 5),
                    dot.heightAnchor.constraint(equalToConstant: 5)
                ])
            }
            
            // 添加时间轴标签
            let minTimeLabel = UILabel()
            minTimeLabel.text = "00:00"
            minTimeLabel.textColor = UIColor.white.withAlphaComponent(0.3)
            minTimeLabel.font = .systemFont(ofSize: 8, weight: .regular)
            minTimeLabel.translatesAutoresizingMaskIntoConstraints = false
            chartView.addSubview(minTimeLabel)
            
            let maxTimeLabel = UILabel()
            maxTimeLabel.text = "24:00"
            maxTimeLabel.textColor = UIColor.white.withAlphaComponent(0.3)
            maxTimeLabel.font = .systemFont(ofSize: 8, weight: .regular)
            maxTimeLabel.translatesAutoresizingMaskIntoConstraints = false
            chartView.addSubview(maxTimeLabel)
            
            NSLayoutConstraint.activate([
                minTimeLabel.leadingAnchor.constraint(equalTo: chartView.leadingAnchor),
                minTimeLabel.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -2),
                
                maxTimeLabel.trailingAnchor.constraint(equalTo: chartView.trailingAnchor),
                maxTimeLabel.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -2)
            ])
            
        case .line:
            // 绘制折线图
            break
        }
    }
}
