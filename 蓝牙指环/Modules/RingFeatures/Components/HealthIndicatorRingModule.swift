import UIKit

// 健康指标环形模块
// 用于展示多个分化指标的环形进度图表
// 支持3个分层指标：和谐睡眠比例、疲劳、压力
final class HealthIndicatorRingModule: UIView {
    
    // 指标数据模型
    struct IndicatorData {
        let color: UIColor
        let radius: CGFloat
        let endAngle: CGFloat
        let title: String
        let value: String
    }
    
    // 环形容器
    private let ringContainerView = UIView()
    
    // 图例堆栈
    private let legendStack = UIStackView()
    
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
        
        // 设置环形容器
        ringContainerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ringContainerView)
        
        // 设置图例堆栈
        legendStack.axis = .vertical
        legendStack.spacing = 12
        legendStack.alignment = .leading
        legendStack.distribution = .equalSpacing
        legendStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(legendStack)
        
        // 配置约束
        NSLayoutConstraint.activate([
            ringContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            ringContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            ringContainerView.widthAnchor.constraint(equalToConstant: 100),
            ringContainerView.heightAnchor.constraint(equalToConstant: 100),
            
            legendStack.leadingAnchor.constraint(equalTo: ringContainerView.trailingAnchor, constant: 20),
            legendStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            legendStack.topAnchor.constraint(equalTo: ringContainerView.topAnchor, constant: 8),
            legendStack.bottomAnchor.constraint(lessThanOrEqualTo: ringContainerView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Public Methods
    
    // 配置模块数据
    // 参数：indicators - 指标数组，最多3个
    // 例如：
    // [
    //     IndicatorData(color: UIColor(hex: 0xFF6B6B), radius: 45, endAngle: CGFloat.pi * 1.5, title: "和谐睡眠比例", value: "28.0%"),
    //     IndicatorData(color: UIColor(hex: 0xFF9F43), radius: 33, endAngle: CGFloat.pi * 1.2, title: "疲劳", value: "61"),
    //     IndicatorData(color: UIColor(hex: 0x4C5FFF), radius: 21, endAngle: CGFloat.pi * 0.8, title: "压力", value: "39")
    // ]
    func configureWithIndicators(_ indicators: [IndicatorData]) {
        // 清除之前的内容
        ringContainerView.layer.sublayers?.removeAll()
        legendStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 绘制环形图表
        drawRings(with: indicators)
        
        // 添加图例
        addLegendItems(from: indicators)
    }
    
    // MARK: - Private Methods
    
    private func drawRings(with indicators: [IndicatorData]) {
        // 环形中心点
        let centerPoint = CGPoint(x: 50, y: 50)
        
        for indicator in indicators {
            // 绘制背景环
            let bgRing = CAShapeLayer()
            let bgPath = UIBezierPath(arcCenter: centerPoint,
                                     radius: indicator.radius,
                                     startAngle: -CGFloat.pi / 2,
                                     endAngle: CGFloat.pi * 1.5,
                                     clockwise: true)
            bgRing.path = bgPath.cgPath
            bgRing.fillColor = UIColor.clear.cgColor
            bgRing.strokeColor = UIColor.white.withAlphaComponent(0.08).cgColor
            bgRing.lineWidth = 8
            bgRing.lineCap = .round
            ringContainerView.layer.addSublayer(bgRing)
            
            // 绘制数据环
            let dataRing = CAShapeLayer()
            let dataPath = UIBezierPath(arcCenter: centerPoint,
                                       radius: indicator.radius,
                                       startAngle: -CGFloat.pi / 2,
                                       endAngle: indicator.endAngle,
                                       clockwise: true)
            dataRing.path = dataPath.cgPath
            dataRing.fillColor = UIColor.clear.cgColor
            dataRing.strokeColor = indicator.color.cgColor
            dataRing.lineWidth = 8
            dataRing.lineCap = .round
            
            // 添加阴影效果
            dataRing.shadowColor = indicator.color.cgColor
            dataRing.shadowOpacity = 0.35
            dataRing.shadowRadius = 6
            dataRing.shadowOffset = CGSize(width: 0, height: 3)
            
            ringContainerView.layer.addSublayer(dataRing)
        }
    }
    
    private func addLegendItems(from indicators: [IndicatorData]) {
        // 为每个指标添加图例项
        for indicator in indicators {
            let itemView = createLegendItem(
                color: indicator.color,
                title: indicator.title,
                value: indicator.value
            )
            legendStack.addArrangedSubview(itemView)
        }
    }
    
    private func createLegendItem(color: UIColor, title: String, value: String) -> UIView {
        // 创建单个图例项视图
        let itemView = UIView()
        itemView.translatesAutoresizingMaskIntoConstraints = false
        
        // 彩色圆点
        let dot = UIView()
        dot.backgroundColor = color
        dot.layer.cornerRadius = 5
        dot.layer.shadowColor = color.cgColor
        dot.layer.shadowOpacity = 0.4
        dot.layer.shadowRadius = 3
        dot.layer.shadowOffset = CGSize(width: 0, height: 2)
        dot.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(dot)
        
        // 标题标签
        let label = UILabel()
        label.text = title
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(label)
        
        // 数值标签
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = color
        valueLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            itemView.heightAnchor.constraint(equalToConstant: 22),
            
            dot.leadingAnchor.constraint(equalTo: itemView.leadingAnchor),
            dot.widthAnchor.constraint(equalToConstant: 10),
            dot.heightAnchor.constraint(equalToConstant: 10),
            dot.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: dot.trailingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            
            valueLabel.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: itemView.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        return itemView
    }
}
