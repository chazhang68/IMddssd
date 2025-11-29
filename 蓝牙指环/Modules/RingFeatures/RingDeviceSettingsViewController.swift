import UIKit

final class RingDeviceSettingsViewController: UIViewController {
    var device: Device?

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let header = UIView()
    private let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let menuButton = UIButton(type: .system)
    private let dateScrollView = UIScrollView()
    private let dateStackView = UIStackView()
    private var dateButtons: [UIButton] = []
    private let summaryButtonStack = UIStackView()
    private var summaryButtons: [UIButton] = []
    private let activityTypeStack = UIStackView()
    private var activityTypeButtons: [UIButton] = []
    private let activityCardsStack = UIStackView()
    private let healthMetricsStack = UIStackView()
    
    private var selectedDateIndex = 2 // 默认选中周三
    private var selectedSummaryIndex = 0 // 默认选中"今天活动"
    private var selectedActivityTypeIndex = 0 // 默认选中"全部"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x0E0F12)
        setupLayout()
        setupHeader()
        setupDateSelector()
        setupSummaryButtons()
        setupActivityTypeFilter()
        setupActivityCards()
        setupHealthMetrics()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradient = header.layer.sublayers?.first as? CAGradientLayer {
            gradient.frame = header.bounds
        }
    }

    private func setupLayout() {
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
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(header)
        header.backgroundColor = UIColor(hex: 0xFFD23A)
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(hex: 0xFFD23A).cgColor, UIColor(hex: 0xFFC100).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        header.layer.insertSublayer(gradient, at: 0)

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        header.addSubview(backButton)

        titleLabel.text = "活动"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(titleLabel)

        menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        menuButton.tintColor = .black
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
        header.addSubview(menuButton)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: contentView.topAnchor),
            header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 88),
            backButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            menuButton.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
            menuButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
    }

    private func setupDateSelector() {
        dateScrollView.translatesAutoresizingMaskIntoConstraints = false
        dateScrollView.showsHorizontalScrollIndicator = false
        dateScrollView.backgroundColor = UIColor(hex: 0x0E0F12)
        contentView.addSubview(dateScrollView)
        
        dateStackView.axis = .horizontal
        dateStackView.spacing = 16
        dateStackView.alignment = .center
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        dateScrollView.addSubview(dateStackView)
        
        let weekdays = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
        let dates = [21, 22, 23, 24, 25, 26, 27]
        
        for (index, (day, date)) in zip(weekdays, dates).enumerated() {
            let button = UIButton(type: .system)
            button.setTitle("\(day) \(date)", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.addTarget(self, action: #selector(dateSelected(_:)), for: .touchUpInside)
            dateButtons.append(button)
            dateStackView.addArrangedSubview(button)
        }
        
        NSLayoutConstraint.activate([
            dateScrollView.topAnchor.constraint(equalTo: header.bottomAnchor),
            dateScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dateScrollView.heightAnchor.constraint(equalToConstant: 50),
            dateStackView.topAnchor.constraint(equalTo: dateScrollView.topAnchor),
            dateStackView.leadingAnchor.constraint(equalTo: dateScrollView.leadingAnchor, constant: 16),
            dateStackView.trailingAnchor.constraint(equalTo: dateScrollView.trailingAnchor, constant: -16),
            dateStackView.bottomAnchor.constraint(equalTo: dateScrollView.bottomAnchor),
            dateStackView.heightAnchor.constraint(equalTo: dateScrollView.heightAnchor)
        ])
        
        updateDateSelection()
    }
    
    @objc private func dateSelected(_ sender: UIButton) {
        selectedDateIndex = sender.tag
        updateDateSelection()
    }
    
    private func updateDateSelection() {
        for (index, button) in dateButtons.enumerated() {
            if index == selectedDateIndex {
                button.setTitleColor(UIColor(hex: 0xFFD23A), for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
                // 添加下划线
                let underline = UIView()
                underline.backgroundColor = UIColor(hex: 0xFFD23A)
                underline.translatesAutoresizingMaskIntoConstraints = false
                underline.tag = 999
                button.addSubview(underline)
                NSLayoutConstraint.activate([
                    underline.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                    underline.trailingAnchor.constraint(equalTo: button.trailingAnchor),
                    underline.bottomAnchor.constraint(equalTo: button.bottomAnchor),
                    underline.heightAnchor.constraint(equalToConstant: 2)
                ])
            } else {
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
                button.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
            }
        }
    }

    private func setupSummaryButtons() {
        summaryButtonStack.axis = .horizontal
        summaryButtonStack.spacing = 8
        summaryButtonStack.distribution = .fillEqually
        summaryButtonStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(summaryButtonStack)
        
        let titles = ["今天活动", "周报", "月报"]
        for (index, title) in titles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
            button.backgroundColor = UIColor(hex: 0x2A2B2D)
            button.layer.cornerRadius = 8
            button.tag = index
            button.addTarget(self, action: #selector(summaryButtonTapped(_:)), for: .touchUpInside)
            summaryButtons.append(button)
            summaryButtonStack.addArrangedSubview(button)
        }
        
        NSLayoutConstraint.activate([
            summaryButtonStack.topAnchor.constraint(equalTo: dateScrollView.bottomAnchor, constant: 16),
            summaryButtonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            summaryButtonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            summaryButtonStack.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        updateSummarySelection()
    }
    
    @objc private func summaryButtonTapped(_ sender: UIButton) {
        selectedSummaryIndex = sender.tag
        updateSummarySelection()
    }
    
    private func updateSummarySelection() {
        for (index, button) in summaryButtons.enumerated() {
            if index == selectedSummaryIndex {
                button.backgroundColor = UIColor(hex: 0xFFD23A)
                button.setTitleColor(.black, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
            } else {
                button.backgroundColor = UIColor(hex: 0x2A2B2D)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
            }
        }
    }

    private func setupActivityTypeFilter() {
        activityTypeStack.axis = .horizontal
        activityTypeStack.spacing = 16
        activityTypeStack.alignment = .center
        activityTypeStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityTypeStack)
        
        let types = ["全部", "步行", "跑步", "自行车", "游泳"]
        for (index, type) in types.enumerated() {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(hex: 0x2A2B2D)
            button.layer.cornerRadius = 25
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            button.tag = index
            button.addTarget(self, action: #selector(activityTypeTapped(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            activityTypeButtons.append(button)
            
            // 添加图标
            let iconNames = ["person.fill", "figure.walk", "figure.run", "bicycle", "figure.pool.swim"]
            let iconView = UIImageView()
            iconView.image = UIImage(systemName: iconNames[min(index, iconNames.count - 1)])
            iconView.tintColor = .white
            iconView.contentMode = .scaleAspectFit
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.tag = 1000 // 用于后续更新颜色
            button.addSubview(iconView)
            
            let label = UILabel()
            label.text = type
            label.textColor = .white
            label.font = .systemFont(ofSize: 12, weight: .regular)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)
            
            container.addSubview(button)
            activityTypeStack.addArrangedSubview(container)
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 50),
                button.heightAnchor.constraint(equalToConstant: 50),
                iconView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                iconView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                iconView.widthAnchor.constraint(equalToConstant: 24),
                iconView.heightAnchor.constraint(equalToConstant: 24),
                label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 4),
                label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                label.widthAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        NSLayoutConstraint.activate([
            activityTypeStack.topAnchor.constraint(equalTo: summaryButtonStack.bottomAnchor, constant: 16),
            activityTypeStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            activityTypeStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            activityTypeStack.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        updateActivityTypeSelection()
    }
    
    @objc private func activityTypeTapped(_ sender: UIButton) {
        selectedActivityTypeIndex = sender.tag
        updateActivityTypeSelection()
    }
    
    private func updateActivityTypeSelection() {
        for (index, button) in activityTypeButtons.enumerated() {
            if let iconView = button.subviews.first(where: { $0.tag == 1000 }) as? UIImageView {
                if index == selectedActivityTypeIndex {
                    button.backgroundColor = UIColor(hex: 0xFFD23A)
                    iconView.tintColor = .black
                    button.layer.borderColor = UIColor.clear.cgColor
                } else {
                    button.backgroundColor = UIColor(hex: 0x2A2B2D)
                    iconView.tintColor = .white
                    button.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
                }
            }
        }
    }

    private func setupActivityCards() {
        activityCardsStack.axis = .vertical
        activityCardsStack.spacing = 12
        activityCardsStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityCardsStack)
        
        let cards = [
            ("步数", "0步", "figure.walk"),
            ("消耗卡路里", "0kcal", "flame.fill"),
            ("活动时间", "0分钟", "figure.run"),
            ("活动距离", "0km", "heart.fill"),
            ("楼层", "0层", "mountain.2.fill"),
            ("睡眠时间", "0小时 0分钟", "bed.double.fill")
        ]
        
        // 创建3列2行的网格布局
        for row in 0..<2 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 12
            rowStack.distribution = .fillEqually
            rowStack.translatesAutoresizingMaskIntoConstraints = false
            activityCardsStack.addArrangedSubview(rowStack)
            
            for col in 0..<3 {
                let index = row * 3 + col
                if index < cards.count {
                    let card = createActivityCard(title: cards[index].0, value: cards[index].1, iconName: cards[index].2)
                    rowStack.addArrangedSubview(card)
                }
            }
        }
        
        NSLayoutConstraint.activate([
            activityCardsStack.topAnchor.constraint(equalTo: activityTypeStack.bottomAnchor, constant: 16),
            activityCardsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            activityCardsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func createActivityCard(title: String, value: String, iconName: String) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor(hex: 0x2A2B2D)
        card.layer.cornerRadius = 16
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: iconName)
        iconView.tintColor = UIColor(hex: 0xFFD23A)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(iconView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor(hex: 0xFFD23A)
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = .white
        valueLabel.font = .systemFont(ofSize: 18, weight: .bold)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 60),
            iconView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor, constant: -8),
            valueLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
        ])
        
        return card
    }

    private func setupHealthMetrics() {
        healthMetricsStack.axis = .vertical
        healthMetricsStack.spacing = 16
        healthMetricsStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(healthMetricsStack)
        
        let metrics = [
            ("睡眠", "moon.stars.fill", false), // 睡眠
            ("血压", "waveform.path.ecg", false), // 血压
            ("心率", "heart.fill", true), // 心率 - 特殊处理（显示区域图）
            ("血氧", "drop.fill", false), // 血氧
            ("步数", "figure.walk", false), // 步数
            ("体温", "thermometer", false) // 体温
        ]
        
        for (title, iconName, isHeartRate) in metrics {
            let metricView = createHealthMetricView(title: title, iconName: iconName, isHeartRate: isHeartRate)
            healthMetricsStack.addArrangedSubview(metricView)
        }
        
        NSLayoutConstraint.activate([
            healthMetricsStack.topAnchor.constraint(equalTo: activityCardsStack.bottomAnchor, constant: 16),
            healthMetricsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            healthMetricsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            healthMetricsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func createHealthMetricView(title: String, iconName: String, isHeartRate: Bool) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(hex: 0x2A2B2D)
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // 标题栏
        let titleContainer = UIView()
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleContainer)
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: iconName)
        iconView.tintColor = UIColor(hex: 0xFFD23A)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(iconView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor(hex: 0xFFD23A)
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(titleLabel)
        
        // 图表区域
        let chartView = UIView()
        chartView.backgroundColor = UIColor(hex: 0x1A1B1D)
        chartView.layer.cornerRadius = 8
        chartView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(chartView)
        
        if isHeartRate {
            // 心率特殊处理 - 显示区域图
            setupHeartRateZones(in: chartView)
        } else {
            // 其他指标显示空图表
            setupEmptyChart(in: chartView)
        }
        
        // 摘要按钮
        let summaryStack = UIStackView()
        summaryStack.axis = .horizontal
        summaryStack.spacing = 8
        summaryStack.distribution = .fillEqually
        summaryStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(summaryStack)
        
        let summaries = ["平均", "最低", "最高"]
        for summary in summaries {
            let button = UIButton(type: .system)
            button.setTitle("\(summary)\n0", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
            button.titleLabel?.numberOfLines = 2
            button.titleLabel?.textAlignment = .center
            button.backgroundColor = UIColor(hex: 0x1A1B1D)
            button.layer.cornerRadius = 8
            summaryStack.addArrangedSubview(button)
        }
        
        let chartHeight: CGFloat = isHeartRate ? 280 : 150
        let totalHeight: CGFloat = 16 + 24 + 12 + chartHeight + 12 + 50 + 16 // top + title + spacing + chart + spacing + summary + bottom
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: totalHeight),
            titleContainer.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            titleContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            titleContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            titleContainer.heightAnchor.constraint(equalToConstant: 24),
            iconView.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor),
            chartView.topAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: 12),
            chartView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: chartHeight),
            summaryStack.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 12),
            summaryStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            summaryStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            summaryStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            summaryStack.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return container
    }
    
    private func setupHeartRateZones(in view: UIView) {
        // 左侧圆形仪表盘
        let gaugeContainer = UIView()
        gaugeContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gaugeContainer)
        
        let gaugeCircle = UIView()
        gaugeCircle.backgroundColor = UIColor(hex: 0x2A2B2D)
        gaugeCircle.layer.cornerRadius = 50
        gaugeCircle.translatesAutoresizingMaskIntoConstraints = false
        gaugeContainer.addSubview(gaugeCircle)
        
        let gaugeValue = UILabel()
        gaugeValue.text = "0"
        gaugeValue.textColor = .white
        gaugeValue.font = .systemFont(ofSize: 24, weight: .bold)
        gaugeValue.textAlignment = .center
        gaugeValue.translatesAutoresizingMaskIntoConstraints = false
        gaugeCircle.addSubview(gaugeValue)
        
        // 右侧心率区域图例（垂直排列）
        let zones = [
            ("休息", 0x34C759, 0.0),
            ("热身", 0xFFD23A, 0.0),
            ("脂肪燃烧", 0x5AC8FA, 0.0),
            ("有氧", 0xAF52DE, 0.0),
            ("无氧", 0xFF3B30, 0.0),
            ("最大", 0xFF9500, 0.0),
            ("超过", 0x8B0000, 0.0),
            ("未测量", 0x007AFF, 1.0)
        ]
        
        let legendStack = UIStackView()
        legendStack.axis = .vertical
        legendStack.spacing = 4
        legendStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(legendStack)
        
        func legendItem(_ label: String, _ color: UInt32, _ percentage: Double) -> UIView {
            let container = UIStackView()
            container.axis = .horizontal
            container.spacing = 8
            container.alignment = .center
            
            let dot = UIView()
            dot.backgroundColor = UIColor(hex: UInt32(color))
            dot.layer.cornerRadius = 4
            dot.translatesAutoresizingMaskIntoConstraints = false
            
            let labelView = UILabel()
            labelView.text = label
            labelView.textColor = .white
            labelView.font = .systemFont(ofSize: 12, weight: .regular)
            
            let percentLabel = UILabel()
            percentLabel.text = "\(Int(percentage * 100))%"
            percentLabel.textColor = .white
            percentLabel.font = .systemFont(ofSize: 12, weight: .regular)
            percentLabel.textAlignment = .right
            
            container.addArrangedSubview(dot)
            container.addArrangedSubview(labelView)
            container.addArrangedSubview(percentLabel)
            
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 8),
                dot.heightAnchor.constraint(equalToConstant: 8),
                percentLabel.widthAnchor.constraint(equalToConstant: 40)
            ])
            
            return container
        }
        
        for (label, color, percentage) in zones {
            legendStack.addArrangedSubview(legendItem(label, UInt32(color), percentage))
        }
        
        // 平均心率标签
        let avgLabel = UILabel()
        avgLabel.text = "平均心率"
        avgLabel.textColor = UIColor(hex: 0xFFD23A)
        avgLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        avgLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avgLabel)
        
        let avgValue = UILabel()
        avgValue.text = "0"
        avgValue.textColor = .white
        avgValue.font = .systemFont(ofSize: 16, weight: .bold)
        avgValue.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avgValue)
        
        // 线图区域
        let lineChartView = UIView()
        lineChartView.backgroundColor = UIColor(hex: 0x1A1B1D)
        lineChartView.layer.cornerRadius = 8
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineChartView)
        
        // 设置心率线图的坐标轴
        setupHeartRateChart(in: lineChartView)
        
        NSLayoutConstraint.activate([
            gaugeContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gaugeContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            gaugeContainer.widthAnchor.constraint(equalToConstant: 100),
            gaugeContainer.heightAnchor.constraint(equalToConstant: 100),
            gaugeCircle.widthAnchor.constraint(equalToConstant: 100),
            gaugeCircle.heightAnchor.constraint(equalToConstant: 100),
            gaugeValue.centerXAnchor.constraint(equalTo: gaugeCircle.centerXAnchor),
            gaugeValue.centerYAnchor.constraint(equalTo: gaugeCircle.centerYAnchor),
            legendStack.leadingAnchor.constraint(equalTo: gaugeContainer.trailingAnchor, constant: 16),
            legendStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            legendStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            avgLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avgLabel.topAnchor.constraint(equalTo: gaugeContainer.bottomAnchor, constant: 12),
            avgValue.leadingAnchor.constraint(equalTo: avgLabel.trailingAnchor, constant: 8),
            avgValue.centerYAnchor.constraint(equalTo: avgLabel.centerYAnchor),
            lineChartView.topAnchor.constraint(equalTo: avgLabel.bottomAnchor, constant: 12),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lineChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            lineChartView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupHeartRateChart(in view: UIView) {
        // 心率图表 - 带坐标轴
        let yAxisLabels = ["200", "150", "100", "50", "0"]
        let xAxisLabels = ["00:00", "04:00", "08:00", "12:00", "16:00", "20:00"]
        
        // Y轴标签
        let yStack = UIStackView()
        yStack.axis = .vertical
        yStack.distribution = .equalSpacing
        yStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(yStack)
        
        for labelText in yAxisLabels.reversed() {
            let label = UILabel()
            label.text = labelText
            label.textColor = UIColor.white.withAlphaComponent(0.4)
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textAlignment = .right
            yStack.addArrangedSubview(label)
        }
        
        // X轴标签
        let xStack = UIStackView()
        xStack.axis = .horizontal
        xStack.distribution = .equalSpacing
        xStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(xStack)
        
        for labelText in xAxisLabels {
            let label = UILabel()
            label.text = labelText
            label.textColor = UIColor.white.withAlphaComponent(0.4)
            label.font = .systemFont(ofSize: 10, weight: .regular)
            xStack.addArrangedSubview(label)
        }
        
        // 网格线
        DispatchQueue.main.async {
            let gridLayer = CAShapeLayer()
            let path = UIBezierPath()
            let width = view.bounds.width - 40
            let height = view.bounds.height - 50
            
            // 水平线
            for i in 0..<5 {
                let y = 20 + CGFloat(i) * (height / 4)
                path.move(to: CGPoint(x: 30, y: y))
                path.addLine(to: CGPoint(x: 30 + width, y: y))
            }
            
            // 垂直线
            for i in 0..<6 {
                let x = 30 + CGFloat(i) * (width / 5)
                path.move(to: CGPoint(x: x, y: 20))
                path.addLine(to: CGPoint(x: x, y: 20 + height))
            }
            
            gridLayer.path = path.cgPath
            gridLayer.strokeColor = UIColor.white.withAlphaComponent(0.1).cgColor
            gridLayer.lineWidth = 0.5
            view.layer.addSublayer(gridLayer)
        }
        
        NSLayoutConstraint.activate([
            yStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            yStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            yStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            yStack.widthAnchor.constraint(equalToConstant: 20),
            xStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            xStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            xStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            xStack.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupEmptyChart(in view: UIView) {
        // 创建空图表 - 带坐标轴
        let yAxisLabels = ["100", "75", "50", "25", "0"]
        let xAxisLabels = ["00:00", "03:00", "06:00", "09:00", "12:00", "15:00", "18:00"]
        
        // Y轴标签
        let yStack = UIStackView()
        yStack.axis = .vertical
        yStack.distribution = .equalSpacing
        yStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(yStack)
        
        for labelText in yAxisLabels.reversed() {
            let label = UILabel()
            label.text = labelText
            label.textColor = UIColor.white.withAlphaComponent(0.4)
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textAlignment = .right
            yStack.addArrangedSubview(label)
        }
        
        // X轴标签
        let xStack = UIStackView()
        xStack.axis = .horizontal
        xStack.distribution = .equalSpacing
        xStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(xStack)
        
        for labelText in xAxisLabels {
            let label = UILabel()
            label.text = labelText
            label.textColor = UIColor.white.withAlphaComponent(0.4)
            label.font = .systemFont(ofSize: 10, weight: .regular)
            xStack.addArrangedSubview(label)
        }
        
        // 网格线
        DispatchQueue.main.async {
            let gridLayer = CAShapeLayer()
            let path = UIBezierPath()
            let width = view.bounds.width - 40
            let height = view.bounds.height - 50
            
            // 水平线
            for i in 0..<5 {
                let y = 20 + CGFloat(i) * (height / 4)
                path.move(to: CGPoint(x: 30, y: y))
                path.addLine(to: CGPoint(x: 30 + width, y: y))
            }
            
            // 垂直线
            for i in 0..<7 {
                let x = 30 + CGFloat(i) * (width / 6)
                path.move(to: CGPoint(x: x, y: 20))
                path.addLine(to: CGPoint(x: x, y: 20 + height))
            }
            
            gridLayer.path = path.cgPath
            gridLayer.strokeColor = UIColor.white.withAlphaComponent(0.1).cgColor
            gridLayer.lineWidth = 0.5
            view.layer.addSublayer(gridLayer)
        }
        
        NSLayoutConstraint.activate([
            yStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            yStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            yStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            yStack.widthAnchor.constraint(equalToConstant: 20),
            xStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            xStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            xStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            xStack.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    @objc private func backTapped() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
