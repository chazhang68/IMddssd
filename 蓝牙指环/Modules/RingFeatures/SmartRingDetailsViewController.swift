import UIKit

// 智能成指详情页面 - 第二个TabBar的第二个页面
final class SmartRingDetailsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 顶部区域
    private let headerView = UIView()
    private let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    
    // 环形进度指示器和身体电量
    private let topCardView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x0E0F12)
        setupLayout()
        setupHeader()
        setupTopCard()
        setupHealthCards()
    }
    
    // MARK: - Setup Methods
    
    private func setupLayout() {
        // 配置ScrollView和ContentView的布局
        // ScrollView：主滚动视图，填满整个屏幕
        // ContentView：内容容器，宽度等于ScrollView，高度由内容决定
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func setupHeader() {
        // 设置页面顶部导航栏
        // 包含：返回按钮、标题标签
        // 背景色：黄色
        headerView.backgroundColor = UIColor(hex: 0xFFD23A)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerView)
        
        // 返回按钮
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        headerView.addSubview(backButton)
        
        // 标题标签
        titleLabel.text = "智能成指"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),
            
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }
    
    private func setupTopCard() {
        // 设置顶部卡片（环形进度指示器和身体电量）
        topCardView.backgroundColor = UIColor(hex: 0x2A2B2D)
        topCardView.layer.cornerRadius = 16
        topCardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topCardView)
        
        // 环形进度指示器（智能成指得分）
        let ringView = UIView()
        ringView.translatesAutoresizingMaskIntoConstraints = false
        topCardView.addSubview(ringView)
        
        // 绘制环形进度
        let ringLayer = CAShapeLayer()
        let ringPath = UIBezierPath(arcCenter: CGPoint(x: 60, y: 60),
                                    radius: 50,
                                    startAngle: -CGFloat.pi / 2,
                                    endAngle: 3 * CGFloat.pi / 2,
                                    clockwise: true)
        ringLayer.path = ringPath.cgPath
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = UIColor(hex: 0x4C5FFF).cgColor
        ringLayer.lineWidth = 12
        ringLayer.lineCap = .round
        ringView.layer.addSublayer(ringLayer)
        
        // 环形标签区域（右侧信息）
        let legendStack = UIStackView()
        legendStack.axis = .vertical
        legendStack.spacing = 8
        legendStack.alignment = .leading
        legendStack.translatesAutoresizingMaskIntoConstraints = false
        topCardView.addSubview(legendStack)
        
        let legendItems = [
            ("和谐睡眠比例", UIColor(hex: 0xFF6B6B)),
            ("疲劳", UIColor(hex: 0xFF9F43)),
            ("压力", UIColor(hex: 0x4C5FFF))
        ]
        
        for (title, color) in legendItems {
            let itemView = UIView()
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            let dot = UIView()
            dot.backgroundColor = color
            dot.layer.cornerRadius = 4
            dot.translatesAutoresizingMaskIntoConstraints = false
            itemView.addSubview(dot)
            
            let label = UILabel()
            label.text = title
            label.textColor = .white
            label.font = .systemFont(ofSize: 12, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            itemView.addSubview(label)
            
            NSLayoutConstraint.activate([
                itemView.heightAnchor.constraint(equalToConstant: 20),
                dot.leadingAnchor.constraint(equalTo: itemView.leadingAnchor),
                dot.widthAnchor.constraint(equalToConstant: 8),
                dot.heightAnchor.constraint(equalToConstant: 8),
                dot.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
                label.leadingAnchor.constraint(equalTo: dot.trailingAnchor, constant: 8),
                label.centerYAnchor.constraint(equalTo: itemView.centerYAnchor)
            ])
            
            legendStack.addArrangedSubview(itemView)
        }
        
        // 身体电量进度条
        let bodyPowerView = UIView()
        bodyPowerView.translatesAutoresizingMaskIntoConstraints = false
        topCardView.addSubview(bodyPowerView)
        
        let powerLabel = UILabel()
        powerLabel.text = "身体电量"
        powerLabel.textColor = UIColor(hex: 0xFFD23A)
        powerLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        powerLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyPowerView.addSubview(powerLabel)
        
        let progressBar = UIView()
        progressBar.backgroundColor = UIColor(hex: 0xFFD23A)
        progressBar.layer.cornerRadius = 4
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        bodyPowerView.addSubview(progressBar)
        
        let percentLabel = UILabel()
        percentLabel.text = "34%"
        percentLabel.textColor = .white
        percentLabel.font = .systemFont(ofSize: 12, weight: .regular)
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyPowerView.addSubview(percentLabel)
        
        // 警告信息
        let warningView = UIView()
        warningView.backgroundColor = UIColor(hex: 0x1A1B1D)
        warningView.layer.cornerRadius = 8
        warningView.translatesAutoresizingMaskIntoConstraints = false
        topCardView.addSubview(warningView)
        
        let warningLabel = UILabel()
        warningLabel.text = "次健康\n您处于亚健康状态\n请自查是否有长期头晕现象、身体僵硬等问题，建议适当进行一定的心理咨询改善心境。请自查是否长期熬夜失眠。"
        warningLabel.textColor = .white
        warningLabel.font = .systemFont(ofSize: 12, weight: .regular)
        warningLabel.numberOfLines = 0
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningView.addSubview(warningLabel)
        
        // 约束
        NSLayoutConstraint.activate([
            topCardView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            topCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ringView.leadingAnchor.constraint(equalTo: topCardView.leadingAnchor, constant: 16),
            ringView.topAnchor.constraint(equalTo: topCardView.topAnchor, constant: 16),
            ringView.widthAnchor.constraint(equalToConstant: 120),
            ringView.heightAnchor.constraint(equalToConstant: 120),
            
            legendStack.leadingAnchor.constraint(equalTo: ringView.trailingAnchor, constant: 16),
            legendStack.trailingAnchor.constraint(equalTo: topCardView.trailingAnchor, constant: -16),
            legendStack.topAnchor.constraint(equalTo: ringView.topAnchor, constant: 20),
            
            powerLabel.topAnchor.constraint(equalTo: ringView.bottomAnchor, constant: 16),
            powerLabel.leadingAnchor.constraint(equalTo: topCardView.leadingAnchor, constant: 16),
            
            progressBar.topAnchor.constraint(equalTo: powerLabel.bottomAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: topCardView.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -8),
            progressBar.heightAnchor.constraint(equalToConstant: 8),
            
            percentLabel.topAnchor.constraint(equalTo: powerLabel.bottomAnchor, constant: 8),
            percentLabel.trailingAnchor.constraint(equalTo: topCardView.trailingAnchor, constant: -16),
            percentLabel.widthAnchor.constraint(equalToConstant: 40),
            
            warningView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 12),
            warningView.leadingAnchor.constraint(equalTo: topCardView.leadingAnchor, constant: 16),
            warningView.trailingAnchor.constraint(equalTo: topCardView.trailingAnchor, constant: -16),
            warningView.bottomAnchor.constraint(equalTo: topCardView.bottomAnchor, constant: -16),
            
            warningLabel.topAnchor.constraint(equalTo: warningView.topAnchor, constant: 12),
            warningLabel.leadingAnchor.constraint(equalTo: warningView.leadingAnchor, constant: 12),
            warningLabel.trailingAnchor.constraint(equalTo: warningView.trailingAnchor, constant: -12),
            warningLabel.bottomAnchor.constraint(equalTo: warningView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupHealthCards() {
        // 设置健康数据卡片（2x2网格）
        // 包含12个卡片：身心数、心电、血压、睡眠、压力、血氧、步数、血温、体感、压力热力、血压、血氧
        let cardsData = [
            (icon: "heart.fill", label: "身心数", time: "10:28", value: "42", unit: ""),
            (icon: "heart.pulse", label: "心电", time: "10:28", value: "", unit: ""),
            (icon: "drop.fill", label: "血压", time: "10:28", value: "110/71", unit: ""),
            (icon: "moon.fill", label: "情绪", time: "10:28", value: "", unit: ""),
            (icon: "cloud.fill", label: "睡眠", time: "10:28", value: "5h24m", unit: ""),
            (icon: "drop.fill", label: "血氧", time: "10:28", value: "39", unit: "%"),
            (icon: "figure.walk", label: "步数", time: "10:28", value: "69", unit: ""),
            (icon: "thermometer", label: "血温", time: "10:28", value: "36.22℃", unit: ""),
            (icon: "eye.fill", label: "看眼", time: "10:28", value: "22", unit: ""),
            (icon: "sun.max.fill", label: "压力", time: "10:28", value: "39", unit: ""),
            (icon: "figure.walk", label: "运动", time: "10:28", value: "2342步", unit: ""),
            (icon: "drop.fill", label: "血氧", time: "10:28", value: "93.1%", unit: "")
        ]
        
        let cardsGrid = UIView()
        cardsGrid.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardsGrid)
        
        var previousRow: UIView? = nil
        
        for (index, data) in cardsData.enumerated() {
            let isLeftCard = index % 2 == 0
            let row = index / 2
            
            let cardView = createHealthCard(icon: data.icon, label: data.label, time: data.time, value: data.value, unit: data.unit)
            cardsGrid.addSubview(cardView)
            
            if isLeftCard {
                // 左卡片
                NSLayoutConstraint.activate([
                    cardView.leadingAnchor.constraint(equalTo: cardsGrid.leadingAnchor, constant: 16),
                    cardView.widthAnchor.constraint(equalTo: cardsGrid.widthAnchor, multiplier: 0.5, constant: -24),
                    cardView.heightAnchor.constraint(equalToConstant: 140)
                ])
                
                if row == 0 {
                    NSLayoutConstraint.activate([
                        cardView.topAnchor.constraint(equalTo: cardsGrid.topAnchor, constant: 16)
                    ])
                } else if let prev = previousRow {
                    NSLayoutConstraint.activate([
                        cardView.topAnchor.constraint(equalTo: prev.bottomAnchor, constant: 12)
                    ])
                }
            } else {
                // 右卡片
                let leftCard = cardsGrid.subviews.filter { $0 != cardView }[(index - 1)]
                NSLayoutConstraint.activate([
                    cardView.leadingAnchor.constraint(equalTo: leftCard.trailingAnchor, constant: 12),
                    cardView.topAnchor.constraint(equalTo: leftCard.topAnchor),
                    cardView.widthAnchor.constraint(equalTo: leftCard.widthAnchor),
                    cardView.heightAnchor.constraint(equalTo: leftCard.heightAnchor)
                ])
                previousRow = cardView
            }
        }
        
        let lastCard = cardsGrid.subviews.last
        
        NSLayoutConstraint.activate([
            cardsGrid.topAnchor.constraint(equalTo: topCardView.bottomAnchor, constant: 16),
            cardsGrid.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardsGrid.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardsGrid.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            (lastCard?.bottomAnchor ?? cardsGrid.bottomAnchor).constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func createHealthCard(icon: String, label: String, time: String, value: String, unit: String) -> UIView {
        // 创建健康数据卡片
        // 包含：图标、标题、时间、数值、柱状图或散点图
        let card = UIView()
        card.backgroundColor = UIColor(hex: 0x1A1B1D)
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false
        
        // 标题区域
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.spacing = 8
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(headerStack)
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = UIColor(hex: 0xFFD23A)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        headerStack.addArrangedSubview(iconView)
        
        let labelView = UILabel()
        labelView.text = label
        labelView.textColor = .white
        labelView.font = .systemFont(ofSize: 14, weight: .semibold)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        headerStack.addArrangedSubview(labelView)
        
        let timeView = UILabel()
        timeView.text = time
        timeView.textColor = UIColor.white.withAlphaComponent(0.5)
        timeView.font = .systemFont(ofSize: 10, weight: .regular)
        timeView.translatesAutoresizingMaskIntoConstraints = false
        headerStack.addArrangedSubview(UIView()) // 空白占位符
        headerStack.addArrangedSubview(timeView)
        
        // 数值区域
        let valueStack = UIStackView()
        valueStack.axis = .vertical
        valueStack.spacing = 4
        valueStack.alignment = .center
        valueStack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(valueStack)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = UIColor(hex: 0xFFD23A)
        valueLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueStack.addArrangedSubview(valueLabel)
        
        let unitLabel = UILabel()
        unitLabel.text = unit
        unitLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        unitLabel.font = .systemFont(ofSize: 10, weight: .regular)
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        valueStack.addArrangedSubview(unitLabel)
        
        // 图表区域（柱状图或散点图）
        let chartView = UIView()
        chartView.backgroundColor = UIColor.clear
        chartView.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(chartView)
        
        // 简单的柱状图示意
        for i in 0..<8 {
            let bar = UIView()
            bar.backgroundColor = UIColor(hex: 0xFF6B6B).withAlphaComponent(CGFloat(0.3 + Double(i) * 0.1))
            bar.layer.cornerRadius = 2
            bar.translatesAutoresizingMaskIntoConstraints = false
            chartView.addSubview(bar)
            
            NSLayoutConstraint.activate([
                bar.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: CGFloat(i * 12)),
                bar.bottomAnchor.constraint(equalTo: chartView.bottomAnchor),
                bar.widthAnchor.constraint(equalToConstant: 10),
                bar.heightAnchor.constraint(equalToConstant: CGFloat(20 + i * 5))
            ])
        }
        
        // 时间轴
        let timeAxisLabel = UILabel()
        timeAxisLabel.text = "00:00                                  24:00"
        timeAxisLabel.textColor = UIColor.white.withAlphaComponent(0.3)
        timeAxisLabel.font = .systemFont(ofSize: 8, weight: .regular)
        timeAxisLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(timeAxisLabel)
        
        // 约束
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            headerStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            headerStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            valueStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 12),
            valueStack.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            
            chartView.topAnchor.constraint(equalTo: valueStack.bottomAnchor, constant: 12),
            chartView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            chartView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            chartView.heightAnchor.constraint(equalToConstant: 30),
            
            timeAxisLabel.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 4),
            timeAxisLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            timeAxisLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            timeAxisLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -8)
        ])
        
        return card
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
