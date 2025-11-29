import UIKit

/// 指环详情页面 - 显示已连接指环的详细数据
class RingDetailViewController: UIViewController {
    
    // MARK: - UI组件
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 顶部导航栏
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    
    // 指环信息卡片
    private let ringInfoCard = UIView()
    private let ringImageView = UIImageView()
    private let deviceNameLabel = UILabel()
    
    // 左列（奇数卡片）
    private let leftColumnView = UIView()
    
    // 右列（偶数卡片）
    private let rightColumnView = UIView()
    
    // MARK: - 属性
    
    var device: Device?
    
    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithDevice()
    }
    
    // MARK: - UI设置
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: 0x0E0F12)
        
        // 设置滚动视图
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // 顶部导航栏
        setupNavigationBar()
        
        // 指环信息卡片
        setupRingInfoCard()
        
        // 左右两列布局
        setupTwoColumnLayout()
        
        // 约束
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        let navBar = UIView()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(navBar)
        
        // 返回按钮
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navBar.addSubview(backButton)
        
        // 标题
        titleLabel.text = "智能指环"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        navBar.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 56),
            
            backButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor)
        ])
    }
    
    private func setupRingInfoCard() {
        ringInfoCard.backgroundColor = UIColor(hex: 0xFFB200)
        ringInfoCard.layer.cornerRadius = 24
        ringInfoCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ringInfoCard)
        
        // 左侧内容
        let leftContainer = UIView()
        leftContainer.translatesAutoresizingMaskIntoConstraints = false
        ringInfoCard.addSubview(leftContainer)
        
        // 指环图标
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "eyeglasses")
        iconView.tintColor = .black
        iconView.translatesAutoresizingMaskIntoConstraints = false
        leftContainer.addSubview(iconView)
        
        // 电池标签
        let batteryTag = UIView()
        batteryTag.backgroundColor = UIColor(hex: 0xFFE082)
        batteryTag.layer.cornerRadius = 12
        batteryTag.translatesAutoresizingMaskIntoConstraints = false
        leftContainer.addSubview(batteryTag)
        
        let batteryIcon = UIImageView()
        batteryIcon.image = UIImage(systemName: "battery.75")
        batteryIcon.tintColor = .black
        batteryIcon.translatesAutoresizingMaskIntoConstraints = false
        batteryTag.addSubview(batteryIcon)
        
        let batteryLabel = UILabel()
        batteryLabel.text = "98%"
        batteryLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        batteryLabel.textColor = .black
        batteryLabel.translatesAutoresizingMaskIntoConstraints = false
        batteryTag.addSubview(batteryLabel)
        
        // 设备名称
        deviceNameLabel.text = "MT AI Glasses"
        deviceNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        deviceNameLabel.textColor = .black
        deviceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        leftContainer.addSubview(deviceNameLabel)
        
        // 右侧蓝牙图标
        let bluetoothIcon = UIImageView()
        bluetoothIcon.image = UIImage(systemName: "bluetooth")
        bluetoothIcon.tintColor = .black
        bluetoothIcon.translatesAutoresizingMaskIntoConstraints = false
        ringInfoCard.addSubview(bluetoothIcon)
        
        let bluetoothBg = UIView()
        bluetoothBg.backgroundColor = .white
        bluetoothBg.layer.cornerRadius = 22
        bluetoothBg.translatesAutoresizingMaskIntoConstraints = false
        ringInfoCard.addSubview(bluetoothBg)
        ringInfoCard.sendSubviewToBack(bluetoothBg)
        
        NSLayoutConstraint.activate([
            ringInfoCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 70),
            ringInfoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ringInfoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ringInfoCard.heightAnchor.constraint(equalToConstant: 160),
            
            leftContainer.leadingAnchor.constraint(equalTo: ringInfoCard.leadingAnchor, constant: 16),
            leftContainer.topAnchor.constraint(equalTo: ringInfoCard.topAnchor, constant: 16),
            leftContainer.bottomAnchor.constraint(equalTo: ringInfoCard.bottomAnchor, constant: -16),
            
            iconView.topAnchor.constraint(equalTo: leftContainer.topAnchor),
            iconView.leadingAnchor.constraint(equalTo: leftContainer.leadingAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            batteryTag.topAnchor.constraint(equalTo: leftContainer.topAnchor),
            batteryTag.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            batteryTag.heightAnchor.constraint(equalToConstant: 24),
            batteryTag.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            batteryIcon.leadingAnchor.constraint(equalTo: batteryTag.leadingAnchor, constant: 6),
            batteryIcon.centerYAnchor.constraint(equalTo: batteryTag.centerYAnchor),
            batteryIcon.widthAnchor.constraint(equalToConstant: 12),
            batteryIcon.heightAnchor.constraint(equalToConstant: 12),
            
            batteryLabel.leadingAnchor.constraint(equalTo: batteryIcon.trailingAnchor, constant: 4),
            batteryLabel.centerYAnchor.constraint(equalTo: batteryTag.centerYAnchor),
            batteryLabel.trailingAnchor.constraint(equalTo: batteryTag.trailingAnchor, constant: -6),
            
            deviceNameLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 12),
            deviceNameLabel.leadingAnchor.constraint(equalTo: leftContainer.leadingAnchor),
            
            bluetoothBg.trailingAnchor.constraint(equalTo: ringInfoCard.trailingAnchor, constant: -16),
            bluetoothBg.topAnchor.constraint(equalTo: ringInfoCard.topAnchor, constant: 16),
            bluetoothBg.widthAnchor.constraint(equalToConstant: 44),
            bluetoothBg.heightAnchor.constraint(equalToConstant: 44),
            
            bluetoothIcon.centerXAnchor.constraint(equalTo: bluetoothBg.centerXAnchor),
            bluetoothIcon.centerYAnchor.constraint(equalTo: bluetoothBg.centerYAnchor),
            bluetoothIcon.widthAnchor.constraint(equalToConstant: 20),
            bluetoothIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupTwoColumnLayout() {
        // 左列
        leftColumnView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftColumnView)
        
        // 右列
        rightColumnView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightColumnView)
        
        // 数据卡片配置
        let cardsData: [(title: String, value: String, unit: String, icon: String, color: UInt32, date: String)] = [
            ("心率", "72", "BPM", "heart.fill", 0xFF6B6B, "今日"),
            ("Know-you pro", "", "", "applewatch", 0x666666, ""),
            ("步数", "8,234", "steps", "figure.walk", 0x4CAF50, "今日"),
            ("Interesting", "", "", "camera", 0x666666, ""),
            ("睡眠", "7h 24m", "", "moon.zzz.fill", 0x2196F3, "昨晚"),
            ("Earphones", "", "", "headphones", 0x666666, "")
        ]
        
        var leftCards: [UIView] = []
        var rightCards: [UIView] = []
        
        for (index, data) in cardsData.enumerated() {
            let card = createDataCard(
                title: data.title,
                value: data.value,
                unit: data.unit,
                icon: data.icon,
                color: data.color,
                date: data.date
            )
            
            if index % 2 == 0 {
                // 左列（奇数位置）
                leftCards.append(card)
                leftColumnView.addSubview(card)
                card.translatesAutoresizingMaskIntoConstraints = false
            } else {
                // 右列（偶数位置）
                rightCards.append(card)
                rightColumnView.addSubview(card)
                card.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        
        // 左列约束
        var previousLeftCard: UIView? = nil
        for card in leftCards {
            card.leadingAnchor.constraint(equalTo: leftColumnView.leadingAnchor).isActive = true
            card.trailingAnchor.constraint(equalTo: leftColumnView.trailingAnchor).isActive = true
            card.heightAnchor.constraint(equalToConstant: 160).isActive = true
            
            if let prev = previousLeftCard {
                card.topAnchor.constraint(equalTo: prev.bottomAnchor, constant: 12).isActive = true
            } else {
                card.topAnchor.constraint(equalTo: leftColumnView.topAnchor).isActive = true
            }
            previousLeftCard = card
        }
        if let lastCard = leftCards.last {
            lastCard.bottomAnchor.constraint(equalTo: leftColumnView.bottomAnchor).isActive = true
        }
        
        // 右列约束
        var previousRightCard: UIView? = nil
        for card in rightCards {
            card.leadingAnchor.constraint(equalTo: rightColumnView.leadingAnchor).isActive = true
            card.trailingAnchor.constraint(equalTo: rightColumnView.trailingAnchor).isActive = true
            card.heightAnchor.constraint(equalToConstant: 160).isActive = true
            
            if let prev = previousRightCard {
                card.topAnchor.constraint(equalTo: prev.bottomAnchor, constant: 12).isActive = true
            } else {
                card.topAnchor.constraint(equalTo: rightColumnView.topAnchor).isActive = true
            }
            previousRightCard = card
        }
        if let lastCard = rightCards.last {
            lastCard.bottomAnchor.constraint(equalTo: rightColumnView.bottomAnchor).isActive = true
        }
        
        // 左右列的顶部对齐
        NSLayoutConstraint.activate([
            leftColumnView.topAnchor.constraint(equalTo: ringInfoCard.bottomAnchor, constant: 16),
            leftColumnView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            rightColumnView.topAnchor.constraint(equalTo: ringInfoCard.bottomAnchor, constant: 16),
            rightColumnView.leadingAnchor.constraint(equalTo: leftColumnView.trailingAnchor, constant: 12),
            rightColumnView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            leftColumnView.widthAnchor.constraint(equalTo: rightColumnView.widthAnchor),
            
            // 底部约束：以右列为准
            rightColumnView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func createDataCard(title: String, value: String, unit: String, icon: String, color: UInt32, date: String) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor(hex: 0x1C1C1E)
        card.layer.cornerRadius = 16
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        card.addGestureRecognizer(tapGesture)
        card.isUserInteractionEnabled = true
        
        // 图标
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = UIColor(hex: color)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(iconView)
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        // 日期
        let dateLabel = UILabel()
        dateLabel.text = date
        dateLabel.font = .systemFont(ofSize: 10, weight: .regular)
        dateLabel.textColor = UIColor(hex: 0x999999)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(dateLabel)
        
        // 数值
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 28, weight: .bold)
        valueLabel.textColor = UIColor(hex: color)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(valueLabel)
        
        // 单位
        let unitLabel = UILabel()
        unitLabel.text = unit
        unitLabel.font = .systemFont(ofSize: 11, weight: .regular)
        unitLabel.textColor = UIColor(hex: 0x999999)
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(unitLabel)
        
        // 箭头
        let arrowView = UIImageView()
        arrowView.image = UIImage(systemName: "chevron.right")
        arrowView.tintColor = UIColor(hex: 0x666666)
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(arrowView)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            iconView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 16),
            
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 6),
            
            dateLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            dateLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -36),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            
            unitLabel.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor),
            unitLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 2),
            
            arrowView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            arrowView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            arrowView.widthAnchor.constraint(equalToConstant: 16),
            arrowView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        return card
    }
    
    private func setupConstraints() {
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
    
    private func configureWithDevice() {
        guard let device = device else { return }
        deviceNameLabel.text = device.name
    }
    
    // MARK: - 事件处理
    
    @objc private func backTapped() {
        if let nav = navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        if let card = gesture.view {
            UIView.animate(withDuration: 0.2, animations: {
                card.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    card.transform = .identity
                }
            }
        }
    }
}
