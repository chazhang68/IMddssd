import UIKit

final class RingDashboardViewController: UIViewController {
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
    private let featureButtonStack = UIStackView()
    private var featureButtons: [UIButton] = []
    private let healthModuleContainer = UIView()
    private let healthIndicesStack = UIStackView()
    private let bodyPowerView = UIView()
    private let bodyStatusView = UIView()
    private let sleepModuleContainer = UIView()
    private let bloodPressureModuleContainer = UIView()
    private let heartRateModuleContainer = UIView()
    private let bloodOxygenModuleContainer = UIView()
    private let stepsModuleContainer = UIView()
    private let temperatureModuleContainer = UIView()
    private var selectedDateIndex = 2 // 默认选中周三

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x0E0F12)
        setupLayout()
        setupHeader()
        setupDateSelector()
        setupFeatureButtons()
        setupHealthIndices()
        setupBodyPower()
        setupBodyStatus()
        setupSleepModule()
        setupBloodPressureModule()
        setupHeartRateModule()
        setupBloodOxygenModule()
        setupStepsModule()
        setupTemperatureModule()
        setupScrollViewBottom()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradient = header.layer.sublayers?.first as? CAGradientLayer {
            gradient.frame = header.bounds
        }
    }

    private func setupLayout() {
        // 配置 ScrollView 和 ContentView 的布局约束
        // ScrollView：主滚动视图，填满整个屏幕
        // ContentView：内容容器，宽度等于 ScrollView 宽度，高度由内容决定
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
        // 包含：返回按钮、标题标签、日历菜单按钮
        // 背景色：黄色渐变（从 #FFD23A 到 #FFC100）
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

        titleLabel.text = "智能戒指"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(titleLabel)

        menuButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        menuButton.tintColor = .black
        menuButton.translatesAutoresizingMaskIntoConstraints = false
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
        // 设置日期选择器
        // 显示一周七天的日期（26-31, 1）
        // 支持点击切换选中日期，选中日期显示蓝色高亮和下划线
        // 样式：黄色背景，下角弧形，可水平滑动
        dateScrollView.translatesAutoresizingMaskIntoConstraints = false
        dateScrollView.showsHorizontalScrollIndicator = false
        dateScrollView.backgroundColor = UIColor(hex: 0xFFD23A)
        dateScrollView.layer.cornerRadius = 16
        dateScrollView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        contentView.addSubview(dateScrollView)
        
        dateStackView.axis = .horizontal
        dateStackView.spacing = 16
        dateStackView.alignment = .center
        dateStackView.distribution = .fillEqually
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        dateScrollView.addSubview(dateStackView)
        
        let weekdays = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        let dates = [26, 27, 28, 29, 30, 31, 1]
        
        for (index, (day, date)) in zip(weekdays, dates).enumerated() {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.addTarget(self, action: #selector(dateSelected(_:)), for: .touchUpInside)
            dateButtons.append(button)
            container.addSubview(button)
            
            let dayLabel = UILabel()
            dayLabel.text = day
            dayLabel.textColor = UIColor(hex: 0x2A2B2D)
            dayLabel.font = .systemFont(ofSize: 12, weight: .regular)
            dayLabel.textAlignment = .center
            dayLabel.translatesAutoresizingMaskIntoConstraints = false
            dayLabel.tag = 1001 // 用于更新颜色
            container.addSubview(dayLabel)
            
            let dateLabel = UILabel()
            dateLabel.text = "\(date)"
            dateLabel.textColor = UIColor(hex: 0x2A2B2D)
            dateLabel.font = .systemFont(ofSize: 14, weight: .regular)
            dateLabel.textAlignment = .center
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.tag = 1002 // 用于更新颜色和下划线
            container.addSubview(dateLabel)
            
            dateStackView.addArrangedSubview(container)
            
            NSLayoutConstraint.activate([
                container.widthAnchor.constraint(equalToConstant: 40),
                button.topAnchor.constraint(equalTo: container.topAnchor),
                button.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                button.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                dayLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
                dayLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                dateLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 4),
                dateLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                dateLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4)
            ])
        }
        
        NSLayoutConstraint.activate([
            dateScrollView.topAnchor.constraint(equalTo: header.bottomAnchor),
            dateScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dateScrollView.heightAnchor.constraint(equalToConstant: 50),
            dateStackView.topAnchor.constraint(equalTo: dateScrollView.topAnchor, constant: 8),
            dateStackView.leadingAnchor.constraint(equalTo: dateScrollView.leadingAnchor, constant: 16),
            dateStackView.trailingAnchor.constraint(equalTo: dateScrollView.trailingAnchor, constant: -16),
            dateStackView.bottomAnchor.constraint(equalTo: dateScrollView.bottomAnchor, constant: -8)
        ])
        
        selectedDateIndex = 2 // 默认选中周二
        updateDateSelection()
    }
    
    @objc private func dateSelected(_ sender: UIButton) {
        selectedDateIndex = sender.tag
        updateDateSelection()
    }
    
    private func updateDateSelection() {
        // 更新日期选择器的视觉效果
        // 选中日期：蓝色文字 + 加粗字体 + 下划线
        // 未选中日期：深灰色文字 + 常规字体 + 无下划线
        for (index, button) in dateButtons.enumerated() {
            guard let container = button.superview else { continue }
            let dayLabel = container.subviews.first(where: { $0.tag == 1001 }) as? UILabel
            let dateLabel = container.subviews.first(where: { $0.tag == 1002 }) as? UILabel
            
            if index == selectedDateIndex {
                dayLabel?.textColor = UIColor(hex: 0x007AFF)
                dayLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
                dateLabel?.textColor = UIColor(hex: 0x007AFF)
                dateLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
                // 添加蓝色下划线在日期下方
                let underline = UIView()
                underline.backgroundColor = UIColor(hex: 0x007AFF)
                underline.translatesAutoresizingMaskIntoConstraints = false
                underline.tag = 999
                container.addSubview(underline)
                NSLayoutConstraint.activate([
                    underline.centerXAnchor.constraint(equalTo: dateLabel!.centerXAnchor),
                    underline.topAnchor.constraint(equalTo: dateLabel!.bottomAnchor, constant: 2),
                    underline.widthAnchor.constraint(equalToConstant: 20),
                    underline.heightAnchor.constraint(equalToConstant: 2)
                ])
            } else {
                dayLabel?.textColor = UIColor(hex: 0x2A2B2D)
                dayLabel?.font = .systemFont(ofSize: 12, weight: .regular)
                dateLabel?.textColor = UIColor(hex: 0x2A2B2D)
                dateLabel?.font = .systemFont(ofSize: 14, weight: .regular)
                container.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
            }
        }
    }

    private func setupFeatureButtons() {
        // 设置顶部功能按钮（亲友圈、亲密空间、微体检）
        // 使用水平堆栈视图均匀分布三个按钮
        // 样式：黄色背景，黑色文字，圆角18
        featureButtonStack.axis = .horizontal
        featureButtonStack.spacing = 8
        featureButtonStack.distribution = .fillEqually
        featureButtonStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(featureButtonStack)
        
        let titles = ["亲友圈", "亲密空间", "微体检"]
        for (index, title) in titles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
            button.backgroundColor = UIColor(hex: 0xFFD23A)
            button.layer.cornerRadius = 18
            button.tag = index
            featureButtons.append(button)
            featureButtonStack.addArrangedSubview(button)
        }
        
        NSLayoutConstraint.activate([
            featureButtonStack.topAnchor.constraint(equalTo: dateScrollView.bottomAnchor, constant: 16),
            featureButtonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            featureButtonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            featureButtonStack.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func setupHealthIndices() {
        // 设置健康指数模块
        // 显示五个关键指标：动情指数、愉悦、平静、荷尔蒙、血液粘稠度
        // 每个指标以圆形卡片展示，包含数值和标签
        healthModuleContainer.backgroundColor = UIColor(hex: 0x2A2B2D)
        healthModuleContainer.layer.cornerRadius = 16
        healthModuleContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(healthModuleContainer)
        
        healthIndicesStack.axis = .horizontal
        healthIndicesStack.spacing = 8
        healthIndicesStack.distribution = .fillEqually
        healthIndicesStack.alignment = .top
        healthIndicesStack.translatesAutoresizingMaskIntoConstraints = false
        healthModuleContainer.addSubview(healthIndicesStack)
        
        let indices = [
            ("动情指数", "face.smiling"),
            ("愉悦", "face.smiling"),
            ("平静", "face.smiling"),
            ("荷尔蒙", "atom"),
            ("血液粘稠度", "drop.fill")
        ]
        
        for (label, iconName) in indices {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            
            let circle = UIView()
            circle.backgroundColor = UIColor(hex: 0x2A2B2D)
            circle.layer.cornerRadius = 30
            circle.layer.borderWidth = 1
            circle.layer.borderColor = UIColor(hex: 0xFFD23A).cgColor
            circle.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(circle)
            
            let valueLabel = UILabel()
            valueLabel.text = "0"
            valueLabel.textColor = UIColor(hex: 0xFFD23A)
            valueLabel.font = .systemFont(ofSize: 24, weight: .bold)
            valueLabel.textAlignment = .center
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            circle.addSubview(valueLabel)
            
            let iconView = UIImageView()
            iconView.image = UIImage(systemName: iconName)
            iconView.tintColor = UIColor(hex: 0xFFD23A)
            iconView.contentMode = .scaleAspectFit
            iconView.translatesAutoresizingMaskIntoConstraints = false
            circle.addSubview(iconView)
            
            let labelView = UILabel()
            labelView.text = label
            labelView.textColor = .white
            labelView.font = .systemFont(ofSize: 12, weight: .regular)
            labelView.textAlignment = .center
            labelView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(labelView)
            
            healthIndicesStack.addArrangedSubview(container)
            
            NSLayoutConstraint.activate([
                container.heightAnchor.constraint(equalToConstant: 120),
                circle.widthAnchor.constraint(equalToConstant: 60),
                circle.heightAnchor.constraint(equalToConstant: 60),
                circle.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                circle.topAnchor.constraint(equalTo: container.topAnchor),
                valueLabel.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
                valueLabel.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: -10),
                iconView.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
                iconView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
                iconView.widthAnchor.constraint(equalToConstant: 20),
                iconView.heightAnchor.constraint(equalToConstant: 20),
                labelView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                labelView.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 8),
                labelView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                labelView.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor),
                labelView.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            healthModuleContainer.topAnchor.constraint(equalTo: featureButtonStack.bottomAnchor, constant: 24),
            healthModuleContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            healthModuleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            healthIndicesStack.topAnchor.constraint(equalTo: healthModuleContainer.topAnchor, constant: 16),
            healthIndicesStack.leadingAnchor.constraint(equalTo: healthModuleContainer.leadingAnchor, constant: 16),
            healthIndicesStack.trailingAnchor.constraint(equalTo: healthModuleContainer.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupBodyPower() {
        // 设置身体电量显示卡片
        // 展示设备电量百分比
        // 包含：电池图标、标题、电量数值
        bodyPowerView.backgroundColor = UIColor(hex: 0x1A1B1D)
        bodyPowerView.layer.cornerRadius = 8
        bodyPowerView.translatesAutoresizingMaskIntoConstraints = false
        healthModuleContainer.addSubview(bodyPowerView)
        
        let batteryIcon = UIImageView()
        batteryIcon.image = UIImage(systemName: "battery.100")
        batteryIcon.tintColor = UIColor(hex: 0xFFD23A)
        batteryIcon.contentMode = .scaleAspectFit
        batteryIcon.translatesAutoresizingMaskIntoConstraints = false
        bodyPowerView.addSubview(batteryIcon)
        
        let titleLabel = UILabel()
        titleLabel.text = "身体电量"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyPowerView.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.text = "0%"
        valueLabel.textColor = .white
        valueLabel.font = .systemFont(ofSize: 16, weight: .regular)
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyPowerView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            bodyPowerView.topAnchor.constraint(equalTo: healthIndicesStack.bottomAnchor, constant: 24),
            bodyPowerView.leadingAnchor.constraint(equalTo: healthModuleContainer.leadingAnchor, constant: 16),
            bodyPowerView.trailingAnchor.constraint(equalTo: healthModuleContainer.trailingAnchor, constant: -16),
            bodyPowerView.heightAnchor.constraint(equalToConstant: 44),
            batteryIcon.leadingAnchor.constraint(equalTo: bodyPowerView.leadingAnchor, constant: 12),
            batteryIcon.centerYAnchor.constraint(equalTo: bodyPowerView.centerYAnchor),
            batteryIcon.widthAnchor.constraint(equalToConstant: 24),
            batteryIcon.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: batteryIcon.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: bodyPowerView.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: bodyPowerView.trailingAnchor, constant: -12),
            valueLabel.centerYAnchor.constraint(equalTo: bodyPowerView.centerYAnchor)
        ])
    }
    
    private func setupBodyStatus() {
        // 设置身体健康状态提示卡片
        // 显示当前身体状态（次健康/健康/亚健康等）
        // 包含：状态标题、详细描述和建议
        bodyStatusView.backgroundColor = UIColor(hex: 0x1A1B1D)
        bodyStatusView.layer.cornerRadius = 8
        bodyStatusView.translatesAutoresizingMaskIntoConstraints = false
        healthModuleContainer.addSubview(bodyStatusView)
        
        let titleLabel = UILabel()
        titleLabel.text = "次健康"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyStatusView.addSubview(titleLabel)
        
        let contentLabel = UILabel()
        contentLabel.text = "您现在处于次健康状态 请自观是否有长期头晕现象、身体僵硬等问题,请自查 是否长期熬夜失眠,难以控制情绪,焦躁不安、抑郁等 问题,建议适当进行一定的心理咨询改善心境"
        contentLabel.textColor = .white
        contentLabel.font = .systemFont(ofSize: 14, weight: .regular)
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyStatusView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            bodyStatusView.topAnchor.constraint(equalTo: bodyPowerView.bottomAnchor, constant: 24),
            bodyStatusView.leadingAnchor.constraint(equalTo: healthModuleContainer.leadingAnchor, constant: 16),
            bodyStatusView.trailingAnchor.constraint(equalTo: healthModuleContainer.trailingAnchor, constant: -16),
            bodyStatusView.bottomAnchor.constraint(equalTo: healthModuleContainer.bottomAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: bodyStatusView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: bodyStatusView.leadingAnchor, constant: 12),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: bodyStatusView.leadingAnchor, constant: 12),
            contentLabel.trailingAnchor.constraint(equalTo: bodyStatusView.trailingAnchor, constant: -12),
            contentLabel.bottomAnchor.constraint(equalTo: bodyStatusView.bottomAnchor, constant: -12)
        ])
    }

    private func setupBloodPressureModule() {
        // 设置血压数据模块
        // 包含五个部分：
        // 1. 血压趋势图表（显示24小时血压变化曲线）
        // 2. 最高/最低血压数据卡片
        // 3. 圆形进度指示器（显示血压状态百分比）
        // 4. 血压状态分类列表（正常、高血压、低血压等）
        // 5. 收缩压和舒张压的健康建议
        bloodPressureModuleContainer.backgroundColor = UIColor(hex: 0x2A2B2D)
        bloodPressureModuleContainer.layer.cornerRadius = 16
        bloodPressureModuleContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bloodPressureModuleContainer)
        
        // 血压标题
        let bpHeaderView = UIView()
        bpHeaderView.translatesAutoresizingMaskIntoConstraints = false
        bloodPressureModuleContainer.addSubview(bpHeaderView)
        
        let bpIcon = UIImageView()
        bpIcon.image = UIImage(named: "blood-pressure")
        bpIcon.contentMode = .scaleAspectFit
        bpIcon.translatesAutoresizingMaskIntoConstraints = false
        bpHeaderView.addSubview(bpIcon)
        
        let bpTitleLabel = UILabel()
        bpTitleLabel.text = "血压"
        bpTitleLabel.textColor = .white
        bpTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        bpTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bpHeaderView.addSubview(bpTitleLabel)
        
        // 血压趋势图表
        let chartView = UIView()
        chartView.backgroundColor = UIColor(hex: 0x1A1B1D)
        chartView.layer.cornerRadius = 8
        chartView.translatesAutoresizingMaskIntoConstraints = false
        bloodPressureModuleContainer.addSubview(chartView)
        
        // 图表Y轴标签
        let yAxisStack = UIStackView()
        yAxisStack.axis = .vertical
        yAxisStack.distribution = .fillEqually
        yAxisStack.translatesAutoresizingMaskIntoConstraints = false
        chartView.addSubview(yAxisStack)
        
        for value in ["200", "160", "120", "80", "20", "0"] {
            let label = UILabel()
            label.text = value
            label.textColor = UIColor.white.withAlphaComponent(0.5)
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textAlignment = .right
            yAxisStack.addArrangedSubview(label)
        }
        
        // 图表X轴标签
        let xAxisStack = UIStackView()
        xAxisStack.axis = .horizontal
        xAxisStack.distribution = .fillEqually
        xAxisStack.translatesAutoresizingMaskIntoConstraints = false
        chartView.addSubview(xAxisStack)
        
        for time in ["00:00", "06:00", "12:00", "18:00", "24:00"] {
            let label = UILabel()
            label.text = time
            label.textColor = UIColor.white.withAlphaComponent(0.5)
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textAlignment = .center
            xAxisStack.addArrangedSubview(label)
        }
        
        // 血压数据卡片
        let dataCardStack = UIStackView()
        dataCardStack.axis = .horizontal
        dataCardStack.spacing = 12
        dataCardStack.distribution = .fillEqually
        dataCardStack.translatesAutoresizingMaskIntoConstraints = false
        bloodPressureModuleContainer.addSubview(dataCardStack)
        
        // 最高血压卡片
        let systolicCard = createBPCard(title: "最高血压", value: "110", unit: "mmHg")
        dataCardStack.addArrangedSubview(systolicCard)
        
        // 最低血压卡片
        let diastolicCard = createBPCard(title: "最低血压", value: "71", unit: "mmHg")
        dataCardStack.addArrangedSubview(diastolicCard)
        
        // 圆形进度指示器和状态
        let statusView = UIView()
        statusView.translatesAutoresizingMaskIntoConstraints = false
        bloodPressureModuleContainer.addSubview(statusView)
        
        let circleView = UIView()
        circleView.translatesAutoresizingMaskIntoConstraints = false
        statusView.addSubview(circleView)
        
        let circle = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 50, y: 50),
                                        radius: 40,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 3 * CGFloat.pi / 2,
                                        clockwise: true)
        circle.path = circularPath.cgPath
        circle.strokeColor = UIColor(hex: 0x4C5FFF).cgColor
        circle.lineWidth = 8
        circle.fillColor = UIColor.clear.cgColor
        circle.lineCap = .round
        circleView.layer.addSublayer(circle)
        
        // 状态列表
        let statusListStack = UIStackView()
        statusListStack.axis = .vertical
        statusListStack.spacing = 8
        statusListStack.translatesAutoresizingMaskIntoConstraints = false
        statusView.addSubview(statusListStack)
        
        let statusItems = [
            ("正常", "100%", UIColor(hex: 0x4C5FFF)),
            ("高血压", "0%", UIColor.gray),
            ("低血压", "0%", UIColor.gray),
            ("高血压", "0%", UIColor.red)
        ]
        
        for (status, percent, color) in statusItems {
            let itemView = UIView()
            itemView.translatesAutoresizingMaskIntoConstraints = false
            statusListStack.addArrangedSubview(itemView)
            
            let dot = UIView()
            dot.backgroundColor = color
            dot.layer.cornerRadius = 4
            dot.translatesAutoresizingMaskIntoConstraints = false
            itemView.addSubview(dot)
            
            let statusLabel = UILabel()
            statusLabel.text = status
            statusLabel.textColor = .white
            statusLabel.font = .systemFont(ofSize: 12, weight: .regular)
            statusLabel.translatesAutoresizingMaskIntoConstraints = false
            itemView.addSubview(statusLabel)
            
            let percentLabel = UILabel()
            percentLabel.text = percent
            percentLabel.textColor = .white
            percentLabel.font = .systemFont(ofSize: 12, weight: .regular)
            percentLabel.textAlignment = .right
            percentLabel.translatesAutoresizingMaskIntoConstraints = false
            itemView.addSubview(percentLabel)
            
            NSLayoutConstraint.activate([
                itemView.heightAnchor.constraint(equalToConstant: 20),
                dot.leadingAnchor.constraint(equalTo: itemView.leadingAnchor),
                dot.widthAnchor.constraint(equalToConstant: 8),
                dot.heightAnchor.constraint(equalToConstant: 8),
                dot.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
                statusLabel.leadingAnchor.constraint(equalTo: dot.trailingAnchor, constant: 8),
                statusLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
                percentLabel.trailingAnchor.constraint(equalTo: itemView.trailingAnchor),
                percentLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor)
            ])
        }
        
        // 健康建议
        let adviceStack = UIStackView()
        adviceStack.axis = .vertical
        adviceStack.spacing = 12
        adviceStack.translatesAutoresizingMaskIntoConstraints = false
        bloodPressureModuleContainer.addSubview(adviceStack)
        
        let adviceItems = [
            ("收缩压", "结果：收缩压正常\n指标：收缩压正常\n建议："),
            ("舒张压", "结果：舒张压正常\n指标：舒张压正常\n建议：")
        ]
        
        for (title, content) in adviceItems {
            let adviceView = UIView()
            adviceView.translatesAutoresizingMaskIntoConstraints = false
            adviceStack.addArrangedSubview(adviceView)
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = .white
            titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            adviceView.addSubview(titleLabel)
            
            let contentLabel = UILabel()
            contentLabel.text = content
            contentLabel.textColor = UIColor.white.withAlphaComponent(0.7)
            contentLabel.font = .systemFont(ofSize: 12, weight: .regular)
            contentLabel.numberOfLines = 0
            contentLabel.translatesAutoresizingMaskIntoConstraints = false
            adviceView.addSubview(contentLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: adviceView.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: adviceView.leadingAnchor),
                contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                contentLabel.leadingAnchor.constraint(equalTo: adviceView.leadingAnchor),
                contentLabel.trailingAnchor.constraint(equalTo: adviceView.trailingAnchor),
                contentLabel.bottomAnchor.constraint(equalTo: adviceView.bottomAnchor)
            ])
        }
        
        // 约束
        NSLayoutConstraint.activate([
            bloodPressureModuleContainer.topAnchor.constraint(equalTo: sleepModuleContainer.bottomAnchor, constant: 24),
            bloodPressureModuleContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bloodPressureModuleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            bpHeaderView.topAnchor.constraint(equalTo: bloodPressureModuleContainer.topAnchor, constant: 16),
            bpHeaderView.leadingAnchor.constraint(equalTo: bloodPressureModuleContainer.leadingAnchor, constant: 16),
            bpHeaderView.trailingAnchor.constraint(equalTo: bloodPressureModuleContainer.trailingAnchor, constant: -16),
            bpHeaderView.heightAnchor.constraint(equalToConstant: 24),
            
            bpIcon.leadingAnchor.constraint(equalTo: bpHeaderView.leadingAnchor),
            bpIcon.centerYAnchor.constraint(equalTo: bpHeaderView.centerYAnchor),
            bpIcon.widthAnchor.constraint(equalToConstant: 20),
            bpIcon.heightAnchor.constraint(equalToConstant: 20),
            
            bpTitleLabel.leadingAnchor.constraint(equalTo: bpIcon.trailingAnchor, constant: 8),
            bpTitleLabel.centerYAnchor.constraint(equalTo: bpHeaderView.centerYAnchor),
            
            chartView.topAnchor.constraint(equalTo: bpHeaderView.bottomAnchor, constant: 16),
            chartView.leadingAnchor.constraint(equalTo: bloodPressureModuleContainer.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: bloodPressureModuleContainer.trailingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 120),
            
            yAxisStack.topAnchor.constraint(equalTo: chartView.topAnchor, constant: 8),
            yAxisStack.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: 8),
            yAxisStack.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -8),
            yAxisStack.widthAnchor.constraint(equalToConstant: 30),
            
            xAxisStack.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -8),
            xAxisStack.leadingAnchor.constraint(equalTo: yAxisStack.trailingAnchor, constant: 8),
            xAxisStack.trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: -8),
            xAxisStack.heightAnchor.constraint(equalToConstant: 20),
            
            dataCardStack.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 16),
            dataCardStack.leadingAnchor.constraint(equalTo: bloodPressureModuleContainer.leadingAnchor, constant: 16),
            dataCardStack.trailingAnchor.constraint(equalTo: bloodPressureModuleContainer.trailingAnchor, constant: -16),
            dataCardStack.heightAnchor.constraint(equalToConstant: 80),
            
            statusView.topAnchor.constraint(equalTo: dataCardStack.bottomAnchor, constant: 16),
            statusView.leadingAnchor.constraint(equalTo: bloodPressureModuleContainer.leadingAnchor, constant: 16),
            statusView.trailingAnchor.constraint(equalTo: bloodPressureModuleContainer.trailingAnchor, constant: -16),
            
            circleView.leadingAnchor.constraint(equalTo: statusView.leadingAnchor),
            circleView.topAnchor.constraint(equalTo: statusView.topAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 100),
            circleView.heightAnchor.constraint(equalToConstant: 100),
            
            statusListStack.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 16),
            statusListStack.trailingAnchor.constraint(equalTo: statusView.trailingAnchor),
            statusListStack.topAnchor.constraint(equalTo: statusView.topAnchor),
            statusListStack.bottomAnchor.constraint(equalTo: statusView.bottomAnchor),
            
            adviceStack.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 16),
            adviceStack.leadingAnchor.constraint(equalTo: bloodPressureModuleContainer.leadingAnchor, constant: 16),
            adviceStack.trailingAnchor.constraint(equalTo: bloodPressureModuleContainer.trailingAnchor, constant: -16),
            adviceStack.bottomAnchor.constraint(equalTo: bloodPressureModuleContainer.bottomAnchor, constant: -16)
        ])
    }
    
    private func createBPCard(title: String, value: String, unit: String) -> UIView {
        // 创建血压数据卡片
        // 参数：title - 卡片标题（最高血压/最低血压）
        //       value - 数值
        //       unit - 单位（mmHg）
        // 样式：暗色背景，黄色数值文字，圆角8
        let card = UIView()
        card.backgroundColor = UIColor(hex: 0x1A1B1D)
        card.layer.cornerRadius = 8
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = UIColor(hex: 0xFFD23A)
        valueLabel.font = .systemFont(ofSize: 28, weight: .semibold)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(valueLabel)
        
        let unitLabel = UILabel()
        unitLabel.text = unit
        unitLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        unitLabel.font = .systemFont(ofSize: 12, weight: .regular)
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(unitLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valueLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            unitLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            unitLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            unitLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
        ])
        
        return card
    }
    
    private func setupSleepModule() {
        // 设置睡眠数据模块
        // 包含四个主要部分：
        // 1. 睡眠时间线（显示入睡和起床时间）
        // 2. 睡眠阶段卡片（深睡、浅睡、快速眼动、清醒）- 2x2 网格
        // 3. 睡眠分析（睡眠时长、深睡比例、浅睡比例、快速眼动比例、清醒次数）
        // 4. 零星睡眠和睡眠质量提示
        sleepModuleContainer.backgroundColor = UIColor(hex: 0x2A2B2D)
        sleepModuleContainer.layer.cornerRadius = 16
        sleepModuleContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sleepModuleContainer)
        
        // 睡眠标题
        let sleepHeaderView = UIView()
        sleepHeaderView.translatesAutoresizingMaskIntoConstraints = false
        sleepModuleContainer.addSubview(sleepHeaderView)
        
        let sleepIcon = UIImageView()
        sleepIcon.image = UIImage(named: "sleep")
        sleepIcon.contentMode = .scaleAspectFit
        sleepIcon.translatesAutoresizingMaskIntoConstraints = false
        sleepHeaderView.addSubview(sleepIcon)
        
        let sleepTitleLabel = UILabel()
        sleepTitleLabel.text = "睡眠"
        sleepTitleLabel.textColor = .white
        sleepTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        sleepTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sleepHeaderView.addSubview(sleepTitleLabel)
        
        // 睡眠时间线图表
        let sleepTimelineView = UIView()
        sleepTimelineView.backgroundColor = UIColor(hex: 0x1A1B1D)
        sleepTimelineView.layer.cornerRadius = 8
        sleepTimelineView.translatesAutoresizingMaskIntoConstraints = false
        sleepModuleContainer.addSubview(sleepTimelineView)
        
        // 时间标签
        let timeStartLabel = UILabel()
        timeStartLabel.text = "23:14"
        timeStartLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        timeStartLabel.font = .systemFont(ofSize: 12, weight: .regular)
        timeStartLabel.translatesAutoresizingMaskIntoConstraints = false
        sleepTimelineView.addSubview(timeStartLabel)
        
        let timeEndLabel = UILabel()
        timeEndLabel.text = "05:18"
        timeEndLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        timeEndLabel.font = .systemFont(ofSize: 12, weight: .regular)
        timeEndLabel.translatesAutoresizingMaskIntoConstraints = false
        sleepTimelineView.addSubview(timeEndLabel)
        
        // 睡眠阶段卡片（2x2网格）
        let sleepStagesStack = UIStackView()
        sleepStagesStack.axis = .vertical
        sleepStagesStack.spacing = 12
        sleepStagesStack.distribution = .fillEqually
        sleepStagesStack.translatesAutoresizingMaskIntoConstraints = false
        sleepModuleContainer.addSubview(sleepStagesStack)
        
        let sleepStages = [
            ("深睡", "1时45分", UIColor(hex: 0x6B46C1), "moon.fill"),
            ("浅睡", "2时5分", UIColor(hex: 0xA78BFA), "lightbulb.fill"),
            ("快速眼动", "1时10分", UIColor(hex: 0x2DD4BF), "eye.fill"),
            ("清醒", "1时0分", UIColor(hex: 0xFFD23A), "sun.max.fill")
        ]
        
        // 创建2行
        for row in 0..<2 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 12
            rowStack.distribution = .fillEqually
            rowStack.translatesAutoresizingMaskIntoConstraints = false
            sleepStagesStack.addArrangedSubview(rowStack)
            
            for col in 0..<2 {
                let index = row * 2 + col
                if index < sleepStages.count {
                    let stage = sleepStages[index]
                    let card = createSleepStageCard(title: stage.0, duration: stage.1, color: stage.2, iconName: stage.3)
                    rowStack.addArrangedSubview(card)
                }
            }
        }
        
        // 睡眠分析部分
        let sleepAnalysisView = UIView()
        sleepAnalysisView.translatesAutoresizingMaskIntoConstraints = false
        sleepModuleContainer.addSubview(sleepAnalysisView)
        
        let analysisTitleLabel = UILabel()
        analysisTitleLabel.text = "睡眠分析"
        analysisTitleLabel.textColor = .white
        analysisTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        analysisTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sleepAnalysisView.addSubview(analysisTitleLabel)
        
        let analysisStack = UIStackView()
        analysisStack.axis = .vertical
        analysisStack.spacing = 12
        analysisStack.translatesAutoresizingMaskIntoConstraints = false
        sleepAnalysisView.addSubview(analysisStack)
        
        let analysisItems = [
            ("睡眠时长", "5时35分", "6-10时", "偏低", UIColor(hex: 0xFF3B30)),
            ("深睡比例", "42%", "20%-60%", "正常", UIColor(hex: 0x007AFF)),
            ("浅睡比例", "43%", "<55%", "正常", UIColor(hex: 0x007AFF)),
            ("快速眼动比例", "15%", "10%-30%", "正常", UIColor(hex: 0x007AFF)),
            ("清醒次数", "5", "0-2次", "偏高", UIColor(hex: 0xFF3B30))
        ]
        
        for (title, value, reference, status, statusColor) in analysisItems {
            let itemView = createAnalysisItem(title: title, value: value, reference: reference, status: status, statusColor: statusColor)
            analysisStack.addArrangedSubview(itemView)
        }
        
        // 零星睡眠部分
        let fragmentedSleepView = UIView()
        fragmentedSleepView.translatesAutoresizingMaskIntoConstraints = false
        sleepModuleContainer.addSubview(fragmentedSleepView)
        
        let fragmentedTitleLabel = UILabel()
        fragmentedTitleLabel.text = "零星睡眠"
        fragmentedTitleLabel.textColor = .white
        fragmentedTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        fragmentedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        fragmentedSleepView.addSubview(fragmentedTitleLabel)
        
        let fragmentedStack = UIStackView()
        fragmentedStack.axis = .vertical
        fragmentedStack.spacing = 8
        fragmentedStack.translatesAutoresizingMaskIntoConstraints = false
        fragmentedSleepView.addSubview(fragmentedStack)
        
        let fragmentedItems = [
            ("12:32-12:42", "0时10分"),
            ("12:42-13:12", "0时30分")
        ]
        
        for (timeRange, duration) in fragmentedItems {
            let itemView = createFragmentedItem(timeRange: timeRange, duration: duration)
            fragmentedStack.addArrangedSubview(itemView)
        }
        
        // 睡眠质量较差部分
        let sleepQualityView = UIView()
        sleepQualityView.backgroundColor = UIColor(hex: 0x1A1B1D)
        sleepQualityView.layer.cornerRadius = 8
        sleepQualityView.translatesAutoresizingMaskIntoConstraints = false
        sleepModuleContainer.addSubview(sleepQualityView)
        
        let qualityTitleLabel = UILabel()
        qualityTitleLabel.text = "睡眠质量较差"
        qualityTitleLabel.textColor = .white
        qualityTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        qualityTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sleepQualityView.addSubview(qualityTitleLabel)
        
        let qualityContentLabel = UILabel()
        qualityContentLabel.text = "深睡时长不足:入睡时间过晚尝试规律作息,为睡眠创造安静、黑暗的环境。坚持一些睡前放松练习,能有效帮助加深睡眠。"
        qualityContentLabel.textColor = .white
        qualityContentLabel.font = .systemFont(ofSize: 14, weight: .regular)
        qualityContentLabel.numberOfLines = 0
        qualityContentLabel.translatesAutoresizingMaskIntoConstraints = false
        sleepQualityView.addSubview(qualityContentLabel)
        
        // 约束
        NSLayoutConstraint.activate([
            sleepModuleContainer.topAnchor.constraint(equalTo: healthModuleContainer.bottomAnchor, constant: 24),
            sleepModuleContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sleepModuleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            sleepHeaderView.topAnchor.constraint(equalTo: sleepModuleContainer.topAnchor, constant: 16),
            sleepHeaderView.leadingAnchor.constraint(equalTo: sleepModuleContainer.leadingAnchor, constant: 16),
            sleepHeaderView.trailingAnchor.constraint(equalTo: sleepModuleContainer.trailingAnchor, constant: -16),
            sleepHeaderView.heightAnchor.constraint(equalToConstant: 24),
            
            sleepIcon.leadingAnchor.constraint(equalTo: sleepHeaderView.leadingAnchor),
            sleepIcon.centerYAnchor.constraint(equalTo: sleepHeaderView.centerYAnchor),
            sleepIcon.widthAnchor.constraint(equalToConstant: 20),
            sleepIcon.heightAnchor.constraint(equalToConstant: 20),
            
            sleepTitleLabel.leadingAnchor.constraint(equalTo: sleepIcon.trailingAnchor, constant: 8),
            sleepTitleLabel.centerYAnchor.constraint(equalTo: sleepHeaderView.centerYAnchor),
            
            sleepTimelineView.topAnchor.constraint(equalTo: sleepHeaderView.bottomAnchor, constant: 16),
            sleepTimelineView.leadingAnchor.constraint(equalTo: sleepModuleContainer.leadingAnchor, constant: 16),
            sleepTimelineView.trailingAnchor.constraint(equalTo: sleepModuleContainer.trailingAnchor, constant: -16),
            sleepTimelineView.heightAnchor.constraint(equalToConstant: 80),
            
            timeStartLabel.leadingAnchor.constraint(equalTo: sleepTimelineView.leadingAnchor, constant: 12),
            timeStartLabel.bottomAnchor.constraint(equalTo: sleepTimelineView.bottomAnchor, constant: -8),
            
            timeEndLabel.trailingAnchor.constraint(equalTo: sleepTimelineView.trailingAnchor, constant: -12),
            timeEndLabel.bottomAnchor.constraint(equalTo: sleepTimelineView.bottomAnchor, constant: -8),
            
            sleepStagesStack.topAnchor.constraint(equalTo: sleepTimelineView.bottomAnchor, constant: 16),
            sleepStagesStack.leadingAnchor.constraint(equalTo: sleepModuleContainer.leadingAnchor, constant: 16),
            sleepStagesStack.trailingAnchor.constraint(equalTo: sleepModuleContainer.trailingAnchor, constant: -16),
            sleepStagesStack.heightAnchor.constraint(equalToConstant: 160),
            
            sleepAnalysisView.topAnchor.constraint(equalTo: sleepStagesStack.bottomAnchor, constant: 24),
            sleepAnalysisView.leadingAnchor.constraint(equalTo: sleepModuleContainer.leadingAnchor, constant: 16),
            sleepAnalysisView.trailingAnchor.constraint(equalTo: sleepModuleContainer.trailingAnchor, constant: -16),
            
            analysisTitleLabel.topAnchor.constraint(equalTo: sleepAnalysisView.topAnchor),
            analysisTitleLabel.leadingAnchor.constraint(equalTo: sleepAnalysisView.leadingAnchor),
            
            analysisStack.topAnchor.constraint(equalTo: analysisTitleLabel.bottomAnchor, constant: 12),
            analysisStack.leadingAnchor.constraint(equalTo: sleepAnalysisView.leadingAnchor),
            analysisStack.trailingAnchor.constraint(equalTo: sleepAnalysisView.trailingAnchor),
            analysisStack.bottomAnchor.constraint(equalTo: sleepAnalysisView.bottomAnchor),
            
            fragmentedSleepView.topAnchor.constraint(equalTo: sleepAnalysisView.bottomAnchor, constant: 24),
            fragmentedSleepView.leadingAnchor.constraint(equalTo: sleepModuleContainer.leadingAnchor, constant: 16),
            fragmentedSleepView.trailingAnchor.constraint(equalTo: sleepModuleContainer.trailingAnchor, constant: -16),
            
            fragmentedTitleLabel.topAnchor.constraint(equalTo: fragmentedSleepView.topAnchor),
            fragmentedTitleLabel.leadingAnchor.constraint(equalTo: fragmentedSleepView.leadingAnchor),
            
            fragmentedStack.topAnchor.constraint(equalTo: fragmentedTitleLabel.bottomAnchor, constant: 12),
            fragmentedStack.leadingAnchor.constraint(equalTo: fragmentedSleepView.leadingAnchor),
            fragmentedStack.trailingAnchor.constraint(equalTo: fragmentedSleepView.trailingAnchor),
            fragmentedStack.bottomAnchor.constraint(equalTo: fragmentedSleepView.bottomAnchor),
            
            sleepQualityView.topAnchor.constraint(equalTo: fragmentedSleepView.bottomAnchor, constant: 24),
            sleepQualityView.leadingAnchor.constraint(equalTo: sleepModuleContainer.leadingAnchor, constant: 16),
            sleepQualityView.trailingAnchor.constraint(equalTo: sleepModuleContainer.trailingAnchor, constant: -16),
            sleepQualityView.bottomAnchor.constraint(equalTo: sleepModuleContainer.bottomAnchor, constant: -16),
            
            qualityTitleLabel.topAnchor.constraint(equalTo: sleepQualityView.topAnchor, constant: 12),
            qualityTitleLabel.leadingAnchor.constraint(equalTo: sleepQualityView.leadingAnchor, constant: 12),
            
            qualityContentLabel.topAnchor.constraint(equalTo: qualityTitleLabel.bottomAnchor, constant: 8),
            qualityContentLabel.leadingAnchor.constraint(equalTo: sleepQualityView.leadingAnchor, constant: 12),
            qualityContentLabel.trailingAnchor.constraint(equalTo: sleepQualityView.trailingAnchor, constant: -12),
            qualityContentLabel.bottomAnchor.constraint(equalTo: sleepQualityView.bottomAnchor, constant: -12)
        ])
        
    }
    
    private func setupHeartRateModule() {
        // 设置心率数据模块
        // 包含四个部分：
        // 1. 心率趋势曲线图（显示24小时心率变化，红色线条）
        // 2. 心率数据卡片（当前心率、低值、高值）
        // 3. 心率状态指示（正常/异常）
        // 图表显示范围：0-150 bpm，时间轴：00:00-24:00
        heartRateModuleContainer.backgroundColor = UIColor(hex: 0x2A2B2D)
        heartRateModuleContainer.layer.cornerRadius = 16
        heartRateModuleContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(heartRateModuleContainer)
        
        // 心率标题
        let hrHeaderView = UIView()
        hrHeaderView.translatesAutoresizingMaskIntoConstraints = false
        heartRateModuleContainer.addSubview(hrHeaderView)
        
        let hrIcon = UIImageView()
        hrIcon.image = UIImage(systemName: "heart.fill")
        hrIcon.tintColor = UIColor(hex: 0xFF3B30)
        hrIcon.contentMode = .scaleAspectFit
        hrIcon.translatesAutoresizingMaskIntoConstraints = false
        hrHeaderView.addSubview(hrIcon)
        
        let hrTitleLabel = UILabel()
        hrTitleLabel.text = "心率"
        hrTitleLabel.textColor = .white
        hrTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        hrTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        hrHeaderView.addSubview(hrTitleLabel)
        
        // 心率趋势图
        let chartView = UIView()
        chartView.backgroundColor = UIColor(hex: 0x1A1B1D)
        chartView.layer.cornerRadius = 8
        chartView.translatesAutoresizingMaskIntoConstraints = false
        heartRateModuleContainer.addSubview(chartView)
        
        // 绘制厨线图
        let chartPath = UIBezierPath()
        let chartPoints = [CGPoint(x: 20, y: 80),
                          CGPoint(x: 50, y: 50),
                          CGPoint(x: 80, y: 70),
                          CGPoint(x: 110, y: 60),
                          CGPoint(x: 140, y: 75),
                          CGPoint(x: 170, y: 55),
                          CGPoint(x: 200, y: 65)]
        
        if let firstPoint = chartPoints.first {
            chartPath.move(to: firstPoint)
        }
        for point in chartPoints.dropFirst() {
            chartPath.addLine(to: point)
        }
        
        let chartLayer = CAShapeLayer()
        chartLayer.path = chartPath.cgPath
        chartLayer.strokeColor = UIColor(hex: 0xFF3B30).cgColor
        chartLayer.lineWidth = 2
        chartLayer.fillColor = UIColor.clear.cgColor
        chartLayer.lineCap = .round
        chartLayer.lineJoin = .round
        chartView.layer.addSublayer(chartLayer)
        
        // Y轴标签
        let yAxisStack = UIStackView()
        yAxisStack.axis = .vertical
        yAxisStack.distribution = .fillEqually
        yAxisStack.translatesAutoresizingMaskIntoConstraints = false
        chartView.addSubview(yAxisStack)
        
        for value in ["150", "120", "90", "60", "30", "0"] {
            let label = UILabel()
            label.text = value
            label.textColor = UIColor.white.withAlphaComponent(0.5)
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textAlignment = .right
            yAxisStack.addArrangedSubview(label)
        }
        
        // X轴标签
        let xAxisStack = UIStackView()
        xAxisStack.axis = .horizontal
        xAxisStack.distribution = .fillEqually
        xAxisStack.translatesAutoresizingMaskIntoConstraints = false
        chartView.addSubview(xAxisStack)
        
        for time in ["00:00", "06:00", "12:00", "18:00", "24:00"] {
            let label = UILabel()
            label.text = time
            label.textColor = UIColor.white.withAlphaComponent(0.5)
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textAlignment = .center
            xAxisStack.addArrangedSubview(label)
        }
        
        // 心率数据卡片
        let dataCardStack = UIStackView()
        dataCardStack.axis = .horizontal
        dataCardStack.spacing = 8
        dataCardStack.distribution = .fillEqually
        dataCardStack.translatesAutoresizingMaskIntoConstraints = false
        heartRateModuleContainer.addSubview(dataCardStack)
        
        let hrCards = [
            ("当前", "78", "bpm"),
            ("低值", "90", "bpm"),
            ("高值", "72", "bpm")
        ]
        
        for (label, value, unit) in hrCards {
            let card = createHRCard(title: label, value: value, unit: unit)
            dataCardStack.addArrangedSubview(card)
        }
        
        // 心率状态
        let statusView = UIView()
        statusView.translatesAutoresizingMaskIntoConstraints = false
        heartRateModuleContainer.addSubview(statusView)
        
        let statusLabel = UILabel()
        statusLabel.text = "心率正常"
        statusLabel.textColor = UIColor(hex: 0x4C5FFF)
        statusLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusView.addSubview(statusLabel)
        
        // 约束
        NSLayoutConstraint.activate([
            heartRateModuleContainer.topAnchor.constraint(equalTo: bloodPressureModuleContainer.bottomAnchor, constant: 24),
            heartRateModuleContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            heartRateModuleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            hrHeaderView.topAnchor.constraint(equalTo: heartRateModuleContainer.topAnchor, constant: 16),
            hrHeaderView.leadingAnchor.constraint(equalTo: heartRateModuleContainer.leadingAnchor, constant: 16),
            hrHeaderView.trailingAnchor.constraint(equalTo: heartRateModuleContainer.trailingAnchor, constant: -16),
            hrHeaderView.heightAnchor.constraint(equalToConstant: 24),
            
            hrIcon.leadingAnchor.constraint(equalTo: hrHeaderView.leadingAnchor),
            hrIcon.centerYAnchor.constraint(equalTo: hrHeaderView.centerYAnchor),
            hrIcon.widthAnchor.constraint(equalToConstant: 20),
            hrIcon.heightAnchor.constraint(equalToConstant: 20),
            
            hrTitleLabel.leadingAnchor.constraint(equalTo: hrIcon.trailingAnchor, constant: 8),
            hrTitleLabel.centerYAnchor.constraint(equalTo: hrHeaderView.centerYAnchor),
            
            chartView.topAnchor.constraint(equalTo: hrHeaderView.bottomAnchor, constant: 16),
            chartView.leadingAnchor.constraint(equalTo: heartRateModuleContainer.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: heartRateModuleContainer.trailingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 120),
            
            yAxisStack.topAnchor.constraint(equalTo: chartView.topAnchor, constant: 8),
            yAxisStack.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: 8),
            yAxisStack.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -8),
            yAxisStack.widthAnchor.constraint(equalToConstant: 30),
            
            xAxisStack.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -8),
            xAxisStack.leadingAnchor.constraint(equalTo: yAxisStack.trailingAnchor, constant: 8),
            xAxisStack.trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: -8),
            xAxisStack.heightAnchor.constraint(equalToConstant: 20),
            
            dataCardStack.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 16),
            dataCardStack.leadingAnchor.constraint(equalTo: heartRateModuleContainer.leadingAnchor, constant: 16),
            dataCardStack.trailingAnchor.constraint(equalTo: heartRateModuleContainer.trailingAnchor, constant: -16),
            dataCardStack.heightAnchor.constraint(equalToConstant: 80),
            
            statusView.topAnchor.constraint(equalTo: dataCardStack.bottomAnchor, constant: 16),
            statusView.leadingAnchor.constraint(equalTo: heartRateModuleContainer.leadingAnchor, constant: 16),
            statusView.trailingAnchor.constraint(equalTo: heartRateModuleContainer.trailingAnchor, constant: -16),
            statusView.bottomAnchor.constraint(equalTo: heartRateModuleContainer.bottomAnchor, constant: -16),
            
            statusLabel.topAnchor.constraint(equalTo: statusView.topAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusView.leadingAnchor)
        ])
    }
    
    private func createHRCard(title: String, value: String, unit: String) -> UIView {
        // 创建心率数据卡片
        // 参数：title - 卡片标题（当前/低值/高值）
        //       value - 数值
        //       unit - 单位（bpm）
        // 样式：透明背景，白色边框，黄色数值文字，圆角12
        let card = UIView()
        card.backgroundColor = UIColor.clear
        card.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        card.layer.borderWidth = 1
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = UIColor(hex: 0xFFD23A)
        valueLabel.font = .systemFont(ofSize: 28, weight: .semibold)
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(valueLabel)
        
        let unitLabel = UILabel()
        unitLabel.text = unit
        unitLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        unitLabel.font = .systemFont(ofSize: 12, weight: .regular)
        unitLabel.textAlignment = .center
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(unitLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            unitLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            unitLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            unitLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -8)
        ])
        
        return card
    }
    
    private func setupBloodOxygenModule() {
        // 设置血氧数据模块
        // 包含三个部分：
        // 1. 血氧趋势柱状图（显示24小时血氧变化，青色柱子）
        // 2. 血氧数据卡片（平均值、最大值、最小值）
        // 3. 血氧状态指示（正常/冲警/箱警）
        bloodOxygenModuleContainer.backgroundColor = UIColor(hex: 0x2A2B2D)
        bloodOxygenModuleContainer.layer.cornerRadius = 16
        bloodOxygenModuleContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bloodOxygenModuleContainer)
        
        // 血氧标题
        let boHeaderView = UIView()
        boHeaderView.translatesAutoresizingMaskIntoConstraints = false
        bloodOxygenModuleContainer.addSubview(boHeaderView)
        
        let boIcon = UIImageView()
        boIcon.image = UIImage(systemName: "drop.fill")
        boIcon.tintColor = UIColor(hex: 0x00B0FF)
        boIcon.contentMode = .scaleAspectFit
        boIcon.translatesAutoresizingMaskIntoConstraints = false
        boHeaderView.addSubview(boIcon)
        
        let boTitleLabel = UILabel()
        boTitleLabel.text = "血氧"
        boTitleLabel.textColor = .white
        boTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        boTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        boHeaderView.addSubview(boTitleLabel)
        
        // 血氧柱状图
        let chartView = UIView()
        chartView.backgroundColor = UIColor(hex: 0x1A1B1D)
        chartView.layer.cornerRadius = 8
        chartView.translatesAutoresizingMaskIntoConstraints = false
        bloodOxygenModuleContainer.addSubview(chartView)
        
        // 绘制柱状图
        let barWidth: CGFloat = 15
        let barSpacing: CGFloat = 8
        let chartHeight: CGFloat = 100
        
        let barValues: [CGFloat] = [0.6, 0.75, 0.8, 0.9, 0.85, 0.95, 0.8]
        
        for (index, value) in barValues.enumerated() {
            let barView = UIView()
            barView.backgroundColor = UIColor(hex: 0x00B0FF)
            barView.layer.cornerRadius = 2
            barView.translatesAutoresizingMaskIntoConstraints = false
            chartView.addSubview(barView)
            
            let barHeight = value * chartHeight
            
            NSLayoutConstraint.activate([
                barView.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: CGFloat(index) * (barWidth + barSpacing) + 20),
                barView.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -20),
                barView.widthAnchor.constraint(equalToConstant: barWidth),
                barView.heightAnchor.constraint(equalToConstant: barHeight)
            ])
        }
        
        // Y轴标签
        let yAxisStack = UIStackView()
        yAxisStack.axis = .vertical
        yAxisStack.distribution = .fillEqually
        yAxisStack.translatesAutoresizingMaskIntoConstraints = false
        chartView.addSubview(yAxisStack)
        
        for value in ["100", "80", "60", "40", "20", "0"] {
            let label = UILabel()
            label.text = value
            label.textColor = UIColor.white.withAlphaComponent(0.5)
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textAlignment = .right
            yAxisStack.addArrangedSubview(label)
        }
        
        // X轴标签
        let xAxisStack = UIStackView()
        xAxisStack.axis = .horizontal
        xAxisStack.distribution = .fillEqually
        xAxisStack.translatesAutoresizingMaskIntoConstraints = false
        chartView.addSubview(xAxisStack)
        
        for time in ["00:00", "06:00", "12:00", "18:00", "24:00"] {
            let label = UILabel()
            label.text = time
            label.textColor = UIColor.white.withAlphaComponent(0.5)
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textAlignment = .center
            xAxisStack.addArrangedSubview(label)
        }
        
        // 血氧数据卡片
        let dataCardStack = UIStackView()
        dataCardStack.axis = .horizontal
        dataCardStack.spacing = 8
        dataCardStack.distribution = .fillEqually
        dataCardStack.translatesAutoresizingMaskIntoConstraints = false
        bloodOxygenModuleContainer.addSubview(dataCardStack)
        
        let boCards = [
            ("平均值", "92.75%"),
            ("最大值", "97.0%"),
            ("最小值", "86.0%")
        ]
        
        for (label, value) in boCards {
            let card = createBOCard(title: label, value: value)
            dataCardStack.addArrangedSubview(card)
        }
        
        // 血氧状态
        let statusView = UIView()
        statusView.translatesAutoresizingMaskIntoConstraints = false
        bloodOxygenModuleContainer.addSubview(statusView)
        
        let statusLabel = UILabel()
        statusLabel.text = "血氧轻微变常"
        statusLabel.textColor = UIColor.white
        statusLabel.font = .systemFont(ofSize: 14, weight: .regular)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusView.addSubview(statusLabel)
        
        let descLabel = UILabel()
        descLabel.text = "可能液体摮支呩剪，氧气会降低"
        descLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        descLabel.font = .systemFont(ofSize: 12, weight: .regular)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        statusView.addSubview(descLabel)
        
        // 约束
        NSLayoutConstraint.activate([
            bloodOxygenModuleContainer.topAnchor.constraint(equalTo: heartRateModuleContainer.bottomAnchor, constant: 24),
            bloodOxygenModuleContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bloodOxygenModuleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            boHeaderView.topAnchor.constraint(equalTo: bloodOxygenModuleContainer.topAnchor, constant: 16),
            boHeaderView.leadingAnchor.constraint(equalTo: bloodOxygenModuleContainer.leadingAnchor, constant: 16),
            boHeaderView.trailingAnchor.constraint(equalTo: bloodOxygenModuleContainer.trailingAnchor, constant: -16),
            boHeaderView.heightAnchor.constraint(equalToConstant: 24),
            
            boIcon.leadingAnchor.constraint(equalTo: boHeaderView.leadingAnchor),
            boIcon.centerYAnchor.constraint(equalTo: boHeaderView.centerYAnchor),
            boIcon.widthAnchor.constraint(equalToConstant: 20),
            boIcon.heightAnchor.constraint(equalToConstant: 20),
            
            boTitleLabel.leadingAnchor.constraint(equalTo: boIcon.trailingAnchor, constant: 8),
            boTitleLabel.centerYAnchor.constraint(equalTo: boHeaderView.centerYAnchor),
            
            chartView.topAnchor.constraint(equalTo: boHeaderView.bottomAnchor, constant: 16),
            chartView.leadingAnchor.constraint(equalTo: bloodOxygenModuleContainer.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: bloodOxygenModuleContainer.trailingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 120),
            
            yAxisStack.topAnchor.constraint(equalTo: chartView.topAnchor, constant: 8),
            yAxisStack.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: 8),
            yAxisStack.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -8),
            yAxisStack.widthAnchor.constraint(equalToConstant: 25),
            
            xAxisStack.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -8),
            xAxisStack.leadingAnchor.constraint(equalTo: yAxisStack.trailingAnchor, constant: 8),
            xAxisStack.trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: -8),
            xAxisStack.heightAnchor.constraint(equalToConstant: 20),
            
            dataCardStack.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 16),
            dataCardStack.leadingAnchor.constraint(equalTo: bloodOxygenModuleContainer.leadingAnchor, constant: 16),
            dataCardStack.trailingAnchor.constraint(equalTo: bloodOxygenModuleContainer.trailingAnchor, constant: -16),
            dataCardStack.heightAnchor.constraint(equalToConstant: 80),
            
            statusView.topAnchor.constraint(equalTo: dataCardStack.bottomAnchor, constant: 16),
            statusView.leadingAnchor.constraint(equalTo: bloodOxygenModuleContainer.leadingAnchor, constant: 16),
            statusView.trailingAnchor.constraint(equalTo: bloodOxygenModuleContainer.trailingAnchor, constant: -16),
            statusView.bottomAnchor.constraint(equalTo: bloodOxygenModuleContainer.bottomAnchor, constant: -16),
            
            statusLabel.topAnchor.constraint(equalTo: statusView.topAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusView.leadingAnchor),
            
            descLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 4),
            descLabel.leadingAnchor.constraint(equalTo: statusView.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: statusView.trailingAnchor)
        ])
    }
    
    private func createBOCard(title: String, value: String) -> UIView {
        // 创建血氧数据卡片
        // 参数：title - 卡片标题（平均值/最大值/最小值）
        //       value - 血氧数值（百分比）
        // 样式：透明背景，白色边框，黄色数值文字，圆角12
        let card = UIView()
        card.backgroundColor = UIColor.clear
        card.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        card.layer.borderWidth = 1
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = UIColor(hex: 0xFFD23A)
        valueLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -8)
        ])
        
        return card
    }
    
    private func setupStepsModule() {
        // 设置步数数据模块
        // 包含三个部分：
        // 1. 步数趋势柱状图（显示24小时步数变化，黄色柱子）
        // 2. 步数数据卡片（稀闰步数、不轻流速度、热量）
        // 3. 步数提示案例
        stepsModuleContainer.backgroundColor = UIColor(hex: 0x2A2B2D)
        stepsModuleContainer.layer.cornerRadius = 16
        stepsModuleContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stepsModuleContainer)
        
        // 步数标题
        let stepsHeaderView = UIView()
        stepsHeaderView.translatesAutoresizingMaskIntoConstraints = false
        stepsModuleContainer.addSubview(stepsHeaderView)
        
        let stepsIcon = UIImageView()
        stepsIcon.image = UIImage(systemName: "figure.walk")
        stepsIcon.tintColor = UIColor(hex: 0xFFD23A)
        stepsIcon.contentMode = .scaleAspectFit
        stepsIcon.translatesAutoresizingMaskIntoConstraints = false
        stepsHeaderView.addSubview(stepsIcon)
        
        let stepsTitleLabel = UILabel()
        stepsTitleLabel.text = "步数"
        stepsTitleLabel.textColor = .white
        stepsTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        stepsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        stepsHeaderView.addSubview(stepsTitleLabel)
        
        // 步数柱状图
        let chartView = UIView()
        chartView.backgroundColor = UIColor(hex: 0x1A1B1D)
        chartView.layer.cornerRadius = 8
        chartView.translatesAutoresizingMaskIntoConstraints = false
        stepsModuleContainer.addSubview(chartView)
        
        // 绘制柱状图
        let barWidth: CGFloat = 12
        let barSpacing: CGFloat = 6
        let chartHeight: CGFloat = 100
        
        // 步数数据（每个小时）
        let stepValues: [CGFloat] = [0.1, 0.05, 0.15, 0.3, 0.2, 0.4, 0.35, 0.6, 0.55, 0.45, 0.5, 0.7, 0.75, 0.8, 0.85, 0.65, 0.4, 0.3, 0.25, 0.15, 0.1, 0.05, 0.0, 0.0]
        
        for (index, value) in stepValues.enumerated() {
            let barView = UIView()
            barView.backgroundColor = UIColor(hex: 0xFFD23A)
            barView.layer.cornerRadius = 1.5
            barView.translatesAutoresizingMaskIntoConstraints = false
            chartView.addSubview(barView)
            
            let barHeight = value * chartHeight
            
            NSLayoutConstraint.activate([
                barView.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: CGFloat(index) * (barWidth + barSpacing) + 15),
                barView.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -20),
                barView.widthAnchor.constraint(equalToConstant: barWidth),
                barView.heightAnchor.constraint(equalToConstant: max(barHeight, 1))
            ])
        }
        
        // Y轴标签
        let yAxisStack = UIStackView()
        yAxisStack.axis = .vertical
        yAxisStack.distribution = .fillEqually
        yAxisStack.translatesAutoresizingMaskIntoConstraints = false
        chartView.addSubview(yAxisStack)
        
        for value in ["500", "400", "300", "200", "100", "0"] {
            let label = UILabel()
            label.text = value
            label.textColor = UIColor.white.withAlphaComponent(0.5)
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textAlignment = .right
            yAxisStack.addArrangedSubview(label)
        }
        
        // X轴标签
        let xAxisStack = UIStackView()
        xAxisStack.axis = .horizontal
        xAxisStack.distribution = .fillEqually
        xAxisStack.translatesAutoresizingMaskIntoConstraints = false
        chartView.addSubview(xAxisStack)
        
        for time in ["00:00", "06:00", "12:00", "18:00", "24:00"] {
            let label = UILabel()
            label.text = time
            label.textColor = UIColor.white.withAlphaComponent(0.5)
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textAlignment = .center
            xAxisStack.addArrangedSubview(label)
        }
        
        // 步数数据卡片
        let dataCardStack = UIStackView()
        dataCardStack.axis = .horizontal
        dataCardStack.spacing = 8
        dataCardStack.distribution = .fillEqually
        dataCardStack.translatesAutoresizingMaskIntoConstraints = false
        stepsModuleContainer.addSubview(dataCardStack)
        
        let stepsCards = [
            ("稀闰步数", "2953"),
            ("不轻流速度", "2.07"),
            ("热量", "118")
        ]
        
        for (label, value) in stepsCards {
            let card = createStepsCard(title: label, value: value)
            dataCardStack.addArrangedSubview(card)
        }
        
        // 步数提示
        let tipsView = UIView()
        tipsView.translatesAutoresizingMaskIntoConstraints = false
        stepsModuleContainer.addSubview(tipsView)
        
        let tipsLabel = UILabel()
        tipsLabel.text = "运动渐少"
        tipsLabel.textColor = UIColor.white
        tipsLabel.font = .systemFont(ofSize: 14, weight: .regular)
        tipsLabel.translatesAutoresizingMaskIntoConstraints = false
        tipsView.addSubview(tipsLabel)
        
        // 约束
        NSLayoutConstraint.activate([
            stepsModuleContainer.topAnchor.constraint(equalTo: bloodOxygenModuleContainer.bottomAnchor, constant: 24),
            stepsModuleContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stepsModuleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stepsHeaderView.topAnchor.constraint(equalTo: stepsModuleContainer.topAnchor, constant: 16),
            stepsHeaderView.leadingAnchor.constraint(equalTo: stepsModuleContainer.leadingAnchor, constant: 16),
            stepsHeaderView.trailingAnchor.constraint(equalTo: stepsModuleContainer.trailingAnchor, constant: -16),
            stepsHeaderView.heightAnchor.constraint(equalToConstant: 24),
            
            stepsIcon.leadingAnchor.constraint(equalTo: stepsHeaderView.leadingAnchor),
            stepsIcon.centerYAnchor.constraint(equalTo: stepsHeaderView.centerYAnchor),
            stepsIcon.widthAnchor.constraint(equalToConstant: 20),
            stepsIcon.heightAnchor.constraint(equalToConstant: 20),
            
            stepsTitleLabel.leadingAnchor.constraint(equalTo: stepsIcon.trailingAnchor, constant: 8),
            stepsTitleLabel.centerYAnchor.constraint(equalTo: stepsHeaderView.centerYAnchor),
            
            chartView.topAnchor.constraint(equalTo: stepsHeaderView.bottomAnchor, constant: 16),
            chartView.leadingAnchor.constraint(equalTo: stepsModuleContainer.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: stepsModuleContainer.trailingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 120),
            
            yAxisStack.topAnchor.constraint(equalTo: chartView.topAnchor, constant: 8),
            yAxisStack.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: 8),
            yAxisStack.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -8),
            yAxisStack.widthAnchor.constraint(equalToConstant: 30),
            
            xAxisStack.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -8),
            xAxisStack.leadingAnchor.constraint(equalTo: yAxisStack.trailingAnchor, constant: 8),
            xAxisStack.trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: -8),
            xAxisStack.heightAnchor.constraint(equalToConstant: 20),
            
            dataCardStack.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 16),
            dataCardStack.leadingAnchor.constraint(equalTo: stepsModuleContainer.leadingAnchor, constant: 16),
            dataCardStack.trailingAnchor.constraint(equalTo: stepsModuleContainer.trailingAnchor, constant: -16),
            dataCardStack.heightAnchor.constraint(equalToConstant: 80),
            
            tipsView.topAnchor.constraint(equalTo: dataCardStack.bottomAnchor, constant: 16),
            tipsView.leadingAnchor.constraint(equalTo: stepsModuleContainer.leadingAnchor, constant: 16),
            tipsView.trailingAnchor.constraint(equalTo: stepsModuleContainer.trailingAnchor, constant: -16),
            tipsView.bottomAnchor.constraint(equalTo: stepsModuleContainer.bottomAnchor, constant: -16),
            
            tipsLabel.topAnchor.constraint(equalTo: tipsView.topAnchor),
            tipsLabel.leadingAnchor.constraint(equalTo: tipsView.leadingAnchor)
        ])
    }
    
    private func createStepsCard(title: String, value: String) -> UIView {
        // 创建步数数据卡片
        // 参数：title - 卡片标题（稀闰步数/速度/热量）
        //       value - 步数数值
        // 样式：透明背景，白色边框，黄色数值文字，圆角12
        let card = UIView()
        card.backgroundColor = UIColor.clear
        card.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        card.layer.borderWidth = 1
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = UIColor(hex: 0xFFD23A)
        valueLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -8)
        ])
        
        return card
    }
    
    private func setupTemperatureModule() {
        // 设置体温数据模块
        // 包含三个部分：
        // 1. 体温趋势柱状图（显示24小时体温变化，黄色柱子）
        // 2. 体温数据卡片（平均体温、最高体温）
        // 3. 体温状态提示
        temperatureModuleContainer.backgroundColor = UIColor(hex: 0x2A2B2D)
        temperatureModuleContainer.layer.cornerRadius = 16
        temperatureModuleContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(temperatureModuleContainer)
        
        // 体温标题
        let tempHeaderView = UIView()
        tempHeaderView.translatesAutoresizingMaskIntoConstraints = false
        temperatureModuleContainer.addSubview(tempHeaderView)
        
        let tempIcon = UIImageView()
        tempIcon.image = UIImage(systemName: "thermometer")
        tempIcon.tintColor = UIColor(hex: 0xFFD23A)
        tempIcon.contentMode = .scaleAspectFit
        tempIcon.translatesAutoresizingMaskIntoConstraints = false
        tempHeaderView.addSubview(tempIcon)
        
        let tempTitleLabel = UILabel()
        tempTitleLabel.text = "体温分布"
        tempTitleLabel.textColor = .white
        tempTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        tempTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tempHeaderView.addSubview(tempTitleLabel)
        
        // 体温柱状图
        let chartView = UIView()
        chartView.backgroundColor = UIColor(hex: 0x1A1B1D)
        chartView.layer.cornerRadius = 8
        chartView.translatesAutoresizingMaskIntoConstraints = false
        temperatureModuleContainer.addSubview(chartView)
        
        // 绘制柱状图
        let barWidth: CGFloat = 10
        let barSpacing: CGFloat = 5
        let chartHeight: CGFloat = 80
        
        // 体温数据（每个小时）
        let tempValues: [CGFloat] = [0.3, 0.35, 0.4, 0.45, 0.5, 0.52, 0.55, 0.6, 0.62, 0.58, 0.54, 0.56, 0.58, 0.6, 0.58, 0.55, 0.52, 0.5, 0.48, 0.45, 0.42, 0.38, 0.35, 0.32]
        
        for (index, value) in tempValues.enumerated() {
            let barView = UIView()
            barView.backgroundColor = UIColor(hex: 0xFFD23A)
            barView.layer.cornerRadius = 1.5
            barView.translatesAutoresizingMaskIntoConstraints = false
            chartView.addSubview(barView)
            
            let barHeight = value * chartHeight
            
            NSLayoutConstraint.activate([
                barView.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: CGFloat(index) * (barWidth + barSpacing) + 15),
                barView.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -20),
                barView.widthAnchor.constraint(equalToConstant: barWidth),
                barView.heightAnchor.constraint(equalToConstant: max(barHeight, 1))
            ])
        }
        
        // Y轴标签
        let yAxisStack = UIStackView()
        yAxisStack.axis = .vertical
        yAxisStack.distribution = .fillEqually
        yAxisStack.translatesAutoresizingMaskIntoConstraints = false
        chartView.addSubview(yAxisStack)
        
        for value in ["42.0", "41.0", "40.0", "39.0", "38.0", "37.0", "36.0", "35.0", "34.0"] {
            let label = UILabel()
            label.text = value
            label.textColor = UIColor.white.withAlphaComponent(0.5)
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textAlignment = .right
            yAxisStack.addArrangedSubview(label)
        }
        
        // X轴标签
        let xAxisStack = UIStackView()
        xAxisStack.axis = .horizontal
        xAxisStack.distribution = .fillEqually
        xAxisStack.translatesAutoresizingMaskIntoConstraints = false
        chartView.addSubview(xAxisStack)
        
        for time in ["00:00", "06:00", "12:00", "18:00", "24:00"] {
            let label = UILabel()
            label.text = time
            label.textColor = UIColor.white.withAlphaComponent(0.5)
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textAlignment = .center
            xAxisStack.addArrangedSubview(label)
        }
        
        // 体温数据卡片
        let dataCardStack = UIStackView()
        dataCardStack.axis = .horizontal
        dataCardStack.spacing = 12
        dataCardStack.distribution = .fillEqually
        dataCardStack.translatesAutoresizingMaskIntoConstraints = false
        temperatureModuleContainer.addSubview(dataCardStack)
        
        let tempCards = [
            ("平均体温", "37.03"),
            ("最高体温", "35.82")
        ]
        
        for (label, value) in tempCards {
            let card = createTempCard(title: label, value: value)
            dataCardStack.addArrangedSubview(card)
        }
        
        // 体温提示
        let tipsView = UIView()
        tipsView.translatesAutoresizingMaskIntoConstraints = false
        temperatureModuleContainer.addSubview(tipsView)
        
        let tipsLabel = UILabel()
        tipsLabel.text = "体温正常"
        tipsLabel.textColor = UIColor.white
        tipsLabel.font = .systemFont(ofSize: 14, weight: .regular)
        tipsLabel.translatesAutoresizingMaskIntoConstraints = false
        tipsView.addSubview(tipsLabel)
        
        // 约束
        NSLayoutConstraint.activate([
            temperatureModuleContainer.topAnchor.constraint(equalTo: stepsModuleContainer.bottomAnchor, constant: 24),
            temperatureModuleContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            temperatureModuleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            tempHeaderView.topAnchor.constraint(equalTo: temperatureModuleContainer.topAnchor, constant: 16),
            tempHeaderView.leadingAnchor.constraint(equalTo: temperatureModuleContainer.leadingAnchor, constant: 16),
            tempHeaderView.trailingAnchor.constraint(equalTo: temperatureModuleContainer.trailingAnchor, constant: -16),
            tempHeaderView.heightAnchor.constraint(equalToConstant: 24),
            
            tempIcon.leadingAnchor.constraint(equalTo: tempHeaderView.leadingAnchor),
            tempIcon.centerYAnchor.constraint(equalTo: tempHeaderView.centerYAnchor),
            tempIcon.widthAnchor.constraint(equalToConstant: 20),
            tempIcon.heightAnchor.constraint(equalToConstant: 20),
            
            tempTitleLabel.leadingAnchor.constraint(equalTo: tempIcon.trailingAnchor, constant: 8),
            tempTitleLabel.centerYAnchor.constraint(equalTo: tempHeaderView.centerYAnchor),
            
            chartView.topAnchor.constraint(equalTo: tempHeaderView.bottomAnchor, constant: 16),
            chartView.leadingAnchor.constraint(equalTo: temperatureModuleContainer.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: temperatureModuleContainer.trailingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 100),
            
            yAxisStack.topAnchor.constraint(equalTo: chartView.topAnchor, constant: 8),
            yAxisStack.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: 8),
            yAxisStack.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -8),
            yAxisStack.widthAnchor.constraint(equalToConstant: 30),
            
            xAxisStack.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -8),
            xAxisStack.leadingAnchor.constraint(equalTo: yAxisStack.trailingAnchor, constant: 8),
            xAxisStack.trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: -8),
            xAxisStack.heightAnchor.constraint(equalToConstant: 20),
            
            dataCardStack.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 16),
            dataCardStack.leadingAnchor.constraint(equalTo: temperatureModuleContainer.leadingAnchor, constant: 16),
            dataCardStack.trailingAnchor.constraint(equalTo: temperatureModuleContainer.trailingAnchor, constant: -16),
            dataCardStack.heightAnchor.constraint(equalToConstant: 80),
            
            tipsView.topAnchor.constraint(equalTo: dataCardStack.bottomAnchor, constant: 16),
            tipsView.leadingAnchor.constraint(equalTo: temperatureModuleContainer.leadingAnchor, constant: 16),
            tipsView.trailingAnchor.constraint(equalTo: temperatureModuleContainer.trailingAnchor, constant: -16),
            tipsView.bottomAnchor.constraint(equalTo: temperatureModuleContainer.bottomAnchor, constant: -16),
            
            tipsLabel.topAnchor.constraint(equalTo: tipsView.topAnchor),
            tipsLabel.leadingAnchor.constraint(equalTo: tipsView.leadingAnchor)
        ])
    }
    
    private func createTempCard(title: String, value: String) -> UIView {
        // 创建体温数据卡片
        // 参数：title - 卡片标题（平均体温/最高体温）
        //       value - 体温数值
        // 样式：透明背景，白色边框，黄色数值文字，圆角12
        let card = UIView()
        card.backgroundColor = UIColor.clear
        card.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        card.layer.borderWidth = 1
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = UIColor(hex: 0xFFD23A)
        valueLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(valueLabel)
        
        let unitLabel = UILabel()
        unitLabel.text = "°C"
        unitLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        unitLabel.font = .systemFont(ofSize: 12, weight: .regular)
        unitLabel.textAlignment = .center
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(unitLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            unitLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            unitLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            unitLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -8)
        ])
        
        return card
    }
    
    private func setupScrollViewBottom() {
        // 配置 ScrollView 底部约束
        // 确保 contentView 底部延伸到最后一个模块下方
        // 这样 ScrollView 才能正确计算内容高度，支持滚动
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: temperatureModuleContainer.bottomAnchor, constant: 24).isActive = true
    }
    
    private func createSleepStageCard(title: String, duration: String, color: UIColor, iconName: String) -> UIView {
        // 创建睡眠阶段卡片（深睡/浅睡/快速眼动/清醒）
        // 参数：title - 睡眠类型标题
        //       duration - 睡眠持续时间
        //       color - 代表该睡眠阶段的颜色
        //       iconName - SF Symbols 图标名称
        // 样式：暗色背景，彩色圆形图标，圆角12
        let card = UIView()
        card.backgroundColor = UIColor(hex: 0x1A1B1D)
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = color
        iconContainer.layer.cornerRadius = 20
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(iconContainer)
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: iconName)
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(iconView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        let durationLabel = UILabel()
        durationLabel.text = duration
        durationLabel.textColor = .white
        durationLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 74),
            iconContainer.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            iconContainer.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),
            
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            
            durationLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            durationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
        ])
        
        return card
    }
    
    private func createAnalysisItem(title: String, value: String, reference: String, status: String, statusColor: UIColor) -> UIView {
        // 创建睡眠分析项目
        // 参数：title - 分析项目名称（睡眠时长/深睡比例等）
        //       value - 当前数值
        //       reference - 参考范围
        //       status - 状态标签（正常/偏高/偏低）
        //       statusColor - 状态颜色
        // 样式：暗色背景，水平布局，圆角8
        let itemView = UIView()
        itemView.backgroundColor = UIColor(hex: 0x1A1B1D)
        itemView.layer.cornerRadius = 8
        itemView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = .white
        valueLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(valueLabel)
        
        let referenceLabel = UILabel()
        referenceLabel.text = reference
        referenceLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        referenceLabel.font = .systemFont(ofSize: 12, weight: .regular)
        referenceLabel.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(referenceLabel)
        
        let statusLabel = UILabel()
        statusLabel.text = status
        statusLabel.textColor = statusColor
        statusLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            itemView.heightAnchor.constraint(equalToConstant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            valueLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            
            referenceLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 8),
            referenceLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            
            statusLabel.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -12),
            statusLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor)
        ])
        
        return itemView
    }
    
    private func createFragmentedItem(timeRange: String, duration: String) -> UIView {
        // 创建零星睡眠项目
        // 参数：timeRange - 睡眠时间段（如 12:32-12:42）
        //       duration - 睡眠持续时间
        // 样式：暗色背景，水平布局，时间和持续时间分别显示
        let itemView = UIView()
        itemView.backgroundColor = UIColor(hex: 0x1A1B1D)
        itemView.layer.cornerRadius = 8
        itemView.translatesAutoresizingMaskIntoConstraints = false
        
        let timeLabel = UILabel()
        timeLabel.text = timeRange
        timeLabel.textColor = .white
        timeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(timeLabel)
        
        let durationLabel = UILabel()
        durationLabel.text = duration
        durationLabel.textColor = .white
        durationLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            itemView.heightAnchor.constraint(equalToConstant: 44),
            timeLabel.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 12),
            timeLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            
            durationLabel.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -12),
            durationLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor)
        ])
        
        return itemView
    }

    @objc private func backTapped() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
