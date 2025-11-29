import UIKit

// 智能成指详情页面
final class RingHealthViewController: UIViewController {
    
    var device: Device?
    var bclDevice: BCLDevice?  // 真实蓝牙设备对象
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let navigationBarModule = CustomNavigationBarModule()
    private let updateTimeLabel = UILabel()
    private let healthIndicatorModule = HealthIndicatorRingModule()
    private let bodyPowerAndHealthModule = BodyPowerAndHealthModule()
    // 第一行卡片
    private let sleepCard = HealthDataCardModule()        // 睡眠
    private let bloodPressureCard = HealthDataCardModule() // 血压
    // 第二行卡片
    private let heartRateCard = HealthDataCardModule()    // 心率
    private let temperatureCard = HealthDataCardModule()   // 体温
    // 第三行卡片
    private let stepCard = HealthDataCardModule()         // 步数
    private let temperatureCard2 = HealthDataCardModule()  // 体温
    private var heartRateButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x0E0F12)
        
        // 隐藏系统导航栏
        navigationController?.navigationBar.isHidden = true
        
        setupLayout()
        setupNavigationBar()
        setupUpdateTimeLabel()
        setupHealthIndicatorModule()
        setupBodyPowerAndHealthModule()
        setupHealthDataCards()
    }
    
    // MARK: - Setup Methods
    
    private func setupLayout() {
        // 配置ScrollView和ContentView的布局
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 配置约束
        NSLayoutConstraint.activate([
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
    
    private func setupNavigationBar() {
        // 配置导航栏
        navigationBarModule.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBarModule)
        
        // 配置导航栏样式
        navigationBarModule.configure(with: CustomNavigationBarModule.Configuration(
            title: "智能成指",
            date: nil,  // 不显示日期
            backgroundColor: UIColor(hex: 0xFFD23A),
            tintColor: .black,
            titleFont: .systemFont(ofSize: 18, weight: .semibold),
            dateFont: .systemFont(ofSize: 12, weight: .regular)
        ))
        
        // 设置返回按钮回调
        navigationBarModule.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        // 配置约束
        NSLayoutConstraint.activate([
            navigationBarModule.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBarModule.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBarModule.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupUpdateTimeLabel() {
        // 设置最近更新时间显示条
        // 样式：黑色背景、圆角12、白色文字
        updateTimeLabel.text = "最近更新2025-10-2810:09:21"
        updateTimeLabel.textColor = .white
        updateTimeLabel.font = .systemFont(ofSize: 12, weight: .regular)
        updateTimeLabel.textAlignment = .center
        updateTimeLabel.backgroundColor = UIColor(hex: 0x1A1B1D)
        updateTimeLabel.layer.cornerRadius = 12
        updateTimeLabel.clipsToBounds = true
        updateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(updateTimeLabel)
        
        // 配置约束
        NSLayoutConstraint.activate([
            updateTimeLabel.topAnchor.constraint(equalTo: navigationBarModule.bottomAnchor, constant: 12),
            updateTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            updateTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            updateTimeLabel.heightAnchor.constraint(equalToConstant: 32),
            
            scrollView.topAnchor.constraint(equalTo: updateTimeLabel.bottomAnchor, constant: 12)
        ])
    }
    
    private func setupHealthIndicatorModule() {
        // 配置健康指标环形模块
        // 包含三个分化指标：和谐睡眠比例、疲劳、压力
        healthIndicatorModule.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(healthIndicatorModule)
        
        // 绘制环形图表数据
        let indicators: [HealthIndicatorRingModule.IndicatorData] = [
            HealthIndicatorRingModule.IndicatorData(
                color: UIColor(hex: 0xFF6B6B),
                radius: 45,
                endAngle: CGFloat.pi * 1.5,
                title: "和谐睡眠比例",
                value: "28.0%"
            ),
            HealthIndicatorRingModule.IndicatorData(
                color: UIColor(hex: 0xFF9F43),
                radius: 33,
                endAngle: CGFloat.pi * 1.2,
                title: "疲劳",
                value: "61"
            ),
            HealthIndicatorRingModule.IndicatorData(
                color: UIColor(hex: 0x4C5FFF),
                radius: 21,
                endAngle: CGFloat.pi * 0.8,
                title: "压力",
                value: "39"
            )
        ]
        
        healthIndicatorModule.configureWithIndicators(indicators)
        
        // 配置约束
        NSLayoutConstraint.activate([
            healthIndicatorModule.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            healthIndicatorModule.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            healthIndicatorModule.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            healthIndicatorModule.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    private func setupBodyPowerAndHealthModule() {
        // 配置身体电量与健康建议模块
        // 包含：身体电量进度条、健康模式、警告信息
        bodyPowerAndHealthModule.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bodyPowerAndHealthModule)
        
        // 配置模块数据
        bodyPowerAndHealthModule.configure(with: BodyPowerAndHealthModule.Configuration(
            powerPercentage: 34,
            powerColor: UIColor(hex: 0xFFD23A),
            statusTitle: "次健康",
            adviceText: "您处于亚健康状态\n请自查是否有长期头晕现象、身体僵硬等问题，建议适当进行一定的心理咨询改善心境。请自查是否长期熬夜失眠，难以控制情绪，焦躁不安、抑郁等问题，建议适当进行一定的心理咨询改善心境。"
        ))
        
        // 配置约束
        NSLayoutConstraint.activate([
            bodyPowerAndHealthModule.topAnchor.constraint(equalTo: healthIndicatorModule.bottomAnchor, constant: 16),
            bodyPowerAndHealthModule.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bodyPowerAndHealthModule.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupHealthDataCards() {
        // 按照设计稿顺序排列卡片
        // 第一行：睡眠 | 血压
        // 第二行：心率 | 体温
        
        // 配置睡眠卡片（左上）
        sleepCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sleepCard)
        sleepCard.configure(with: HealthDataCardModule.Configuration(
            icon: "moon.fill",
            title: "睡眠",
            time: "10:28",
            value: "5h24m",
            unit: nil,
            chartType: .bar(value: 0.7)
        ))
        
        // 配置血压卡片（右上）
        bloodPressureCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bloodPressureCard)
        bloodPressureCard.configure(with: HealthDataCardModule.Configuration(
            icon: "drop.fill",
            title: "血压",
            time: "10:28",
            value: "110/71",
            unit: nil,
            chartType: .scatter
        ))
        
        // 配置心率卡片（左下）
        heartRateCard.translatesAutoresizingMaskIntoConstraints = false
        heartRateCard.isUserInteractionEnabled = true
        contentView.addSubview(heartRateCard)
        heartRateCard.configure(with: HealthDataCardModule.Configuration(
            icon: "heart.fill",
            title: "心率",
            time: "10:28",
            value: "78bpm",
            unit: nil,
            chartType: .scatter
        ))
        
        // 添加点击事件 - 使用按钮包装
        heartRateButton = UIButton(type: .custom)
        heartRateButton?.translatesAutoresizingMaskIntoConstraints = false
        heartRateButton?.backgroundColor = .clear
        heartRateButton?.addTarget(self, action: #selector(heartRateCardTapped), for: .touchUpInside)
        view.addSubview(heartRateButton!)
        view.bringSubviewToFront(heartRateButton!)
        
        // 配置体温卡片（右下）
        temperatureCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(temperatureCard)
        temperatureCard.configure(with: HealthDataCardModule.Configuration(
            icon: "thermometer.sun.fill",
            title: "体温",
            time: "10:28",
            value: "",
            unit: nil,
            chartType: .bar(value: 0.6)
        ))
        
        // 配置步数卡片（第三行左）
        stepCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stepCard)
        stepCard.configure(with: HealthDataCardModule.Configuration(
            icon: "figure.walk",
            title: "步数",
            time: "10:28",
            value: "2342步",
            unit: nil,
            chartType: .bar(value: 0.8)
        ))
        
        // 配置体温卡片2（第三行右）
        temperatureCard2.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(temperatureCard2)
        temperatureCard2.configure(with: HealthDataCardModule.Configuration(
            icon: "thermometer.sun.fill",
            title: "体温",
            time: "10:28",
            value: "36.22°C",
            unit: nil,
            chartType: .scatter
        ))
        
        // 配置约束 - 2x3网格布局
        NSLayoutConstraint.activate([
            // 第一行（睡眠和血压）
            sleepCard.topAnchor.constraint(equalTo: bodyPowerAndHealthModule.bottomAnchor, constant: 16),
            sleepCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sleepCard.heightAnchor.constraint(equalTo: sleepCard.widthAnchor, multiplier: 1.0),
            
            bloodPressureCard.topAnchor.constraint(equalTo: bodyPowerAndHealthModule.bottomAnchor, constant: 16),
            bloodPressureCard.leadingAnchor.constraint(equalTo: sleepCard.trailingAnchor, constant: 12),
            bloodPressureCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bloodPressureCard.widthAnchor.constraint(equalTo: sleepCard.widthAnchor),
            bloodPressureCard.heightAnchor.constraint(equalTo: sleepCard.heightAnchor),
            
            // 第二行（心率和体温）
            heartRateCard.topAnchor.constraint(equalTo: sleepCard.bottomAnchor, constant: 12),
            heartRateCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            heartRateCard.widthAnchor.constraint(equalTo: sleepCard.widthAnchor),
            heartRateCard.heightAnchor.constraint(equalTo: sleepCard.heightAnchor),
            
            // 心率按钮 - 对齐心率卡片
            heartRateButton!.topAnchor.constraint(equalTo: heartRateCard.topAnchor),
            heartRateButton!.leadingAnchor.constraint(equalTo: heartRateCard.leadingAnchor),
            heartRateButton!.widthAnchor.constraint(equalTo: heartRateCard.widthAnchor),
            heartRateButton!.heightAnchor.constraint(equalTo: heartRateCard.heightAnchor),
            
            temperatureCard.topAnchor.constraint(equalTo: bloodPressureCard.bottomAnchor, constant: 12),
            temperatureCard.leadingAnchor.constraint(equalTo: heartRateCard.trailingAnchor, constant: 12),
            temperatureCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            temperatureCard.widthAnchor.constraint(equalTo: heartRateCard.widthAnchor),
            temperatureCard.heightAnchor.constraint(equalTo: heartRateCard.heightAnchor),
            
            // 第三行（步数和体温）
            stepCard.topAnchor.constraint(equalTo: heartRateCard.bottomAnchor, constant: 12),
            stepCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stepCard.widthAnchor.constraint(equalTo: heartRateCard.widthAnchor),
            stepCard.heightAnchor.constraint(equalTo: heartRateCard.heightAnchor),
            
            temperatureCard2.topAnchor.constraint(equalTo: temperatureCard.bottomAnchor, constant: 12),
            temperatureCard2.leadingAnchor.constraint(equalTo: stepCard.trailingAnchor, constant: 12),
            temperatureCard2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            temperatureCard2.widthAnchor.constraint(equalTo: stepCard.widthAnchor),
            temperatureCard2.heightAnchor.constraint(equalTo: stepCard.heightAnchor),
            
            // 底部约束
            contentView.bottomAnchor.constraint(equalTo: stepCard.bottomAnchor, constant: 24)
        ])
    }
    
    // MARK: - Navigation
    
    @objc private func heartRateCardTapped() {
        print("✅ 心率卡片被点击了")
        let historyVC = HeartRateHistoryViewController()
        historyVC.device = device
        historyVC.bclDevice = bclDevice
        
        // 使用 NavigationController 包装
        let navController = UINavigationController(rootViewController: historyVC)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.isHidden = false
        
        print("导航控制器：\(navigationController != nil)")
        print("当前视图控制器：\(self)")
        
        self.present(navController, animated: true)
    }
}