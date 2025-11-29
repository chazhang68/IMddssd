import UIKit

// 心率历史数据页面
final class HeartRateHistoryViewController: UIViewController {
    
    var device: Device?
    var bclDevice: BCLDevice?  // 真实蓝牙设备对象
    
    // MARK: - UI Elements
    
    private let navigationBar = UIView()
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    
    private let dateContainer = UIView()
    private let dateLabel = UILabel()
    private let previousDateButton = UIButton()
    private let nextDateButton = UIButton()
    
    private let heartRateChartView = UIView()
    private let chartView = UIView()
    
    private let statsContainer = UIView()
    private let averageLabel = UILabel()
    private let maxLabel = UILabel()
    private let minLabel = UILabel()
    
    private let statusLabel = UILabel()
    private let disclaimerLabel = UILabel()
    private let startButton = UIButton()
    
    // MARK: - Data
    
    private var currentDate = Date()
    private var heartRateData: [Int] = [65, 68, 72, 70, 68, 75, 78, 80, 78, 75]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x0E0F12)
        navigationController?.navigationBar.isHidden = true
        
        setupUI()
        updateDateDisplay()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        // 导航栏
        setupNavigationBar()
        
        // 日期选择器
        setupDateSelector()
        
        // 心率图表
        setupHeartRateChart()
        
        // 统计数据
        setupStats()
        
        // 状态标签
        setupStatusLabel()
        
        // 开始按钮
        setupStartButton()
    }
    
    private func setupNavigationBar() {
        navigationBar.backgroundColor = UIColor(hex: 0xFFD23A)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        // 返回按钮
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navigationBar.addSubview(backButton)
        
        // 标题
        titleLabel.text = "心率"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 56),
            
            backButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
        ])
    }
    
    private func setupDateSelector() {
        dateContainer.backgroundColor = UIColor(hex: 0xFFD23A)
        dateContainer.layer.cornerRadius = 24
        dateContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateContainer)
        
        // 上一天按钮
        previousDateButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        previousDateButton.tintColor = .black
        previousDateButton.translatesAutoresizingMaskIntoConstraints = false
        previousDateButton.addTarget(self, action: #selector(previousDateTapped), for: .touchUpInside)
        dateContainer.addSubview(previousDateButton)
        
        // 日期标签
        dateLabel.textColor = .black
        dateLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateContainer.addSubview(dateLabel)
        
        // 下一天按钮
        nextDateButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextDateButton.tintColor = .black
        nextDateButton.translatesAutoresizingMaskIntoConstraints = false
        nextDateButton.addTarget(self, action: #selector(nextDateTapped), for: .touchUpInside)
        dateContainer.addSubview(nextDateButton)
        
        NSLayoutConstraint.activate([
            dateContainer.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 16),
            dateContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateContainer.heightAnchor.constraint(equalToConstant: 48),
            
            previousDateButton.leadingAnchor.constraint(equalTo: dateContainer.leadingAnchor, constant: 12),
            previousDateButton.centerYAnchor.constraint(equalTo: dateContainer.centerYAnchor),
            previousDateButton.widthAnchor.constraint(equalToConstant: 24),
            previousDateButton.heightAnchor.constraint(equalToConstant: 24),
            
            dateLabel.centerXAnchor.constraint(equalTo: dateContainer.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: dateContainer.centerYAnchor),
            
            nextDateButton.trailingAnchor.constraint(equalTo: dateContainer.trailingAnchor, constant: -12),
            nextDateButton.centerYAnchor.constraint(equalTo: dateContainer.centerYAnchor),
            nextDateButton.widthAnchor.constraint(equalToConstant: 24),
            nextDateButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupHeartRateChart() {
        heartRateChartView.backgroundColor = UIColor(hex: 0x1A1B1D)
        heartRateChartView.layer.cornerRadius = 16
        heartRateChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(heartRateChartView)
        
        // 图表标题
        let titleStack = UIStackView()
        titleStack.axis = .horizontal
        titleStack.spacing = 8
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        heartRateChartView.addSubview(titleStack)
        
        let heartIcon = UIImageView()
        heartIcon.image = UIImage(systemName: "heart.fill")
        heartIcon.tintColor = UIColor(hex: 0xFFD23A)
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        titleStack.addArrangedSubview(heartIcon)
        
        let chartTitle = UILabel()
        chartTitle.text = "心率"
        chartTitle.textColor = UIColor(hex: 0xFFD23A)
        chartTitle.font = .systemFont(ofSize: 14, weight: .semibold)
        titleStack.addArrangedSubview(chartTitle)
        
        NSLayoutConstraint.activate([
            heartRateChartView.topAnchor.constraint(equalTo: dateContainer.bottomAnchor, constant: 16),
            heartRateChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            heartRateChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            heartRateChartView.heightAnchor.constraint(equalToConstant: 240),
            
            titleStack.topAnchor.constraint(equalTo: heartRateChartView.topAnchor, constant: 12),
            titleStack.leadingAnchor.constraint(equalTo: heartRateChartView.leadingAnchor, constant: 12)
        ])
        
        // 绘制柱状图
        drawBarChart()
    }
    
    private func drawBarChart() {
        let chartHeight: CGFloat = 200
        let chartWidth = view.bounds.width - 64
        let barWidth: CGFloat = 12
        let spacing: CGFloat = 4
        
        let maxValue: CGFloat = 150
        let minValue: CGFloat = 0
        
        for (index, value) in heartRateData.enumerated() {
            let barView = UIView()
            barView.backgroundColor = UIColor(hex: 0xFF6B6B)
            barView.layer.cornerRadius = 2
            barView.translatesAutoresizingMaskIntoConstraints = false
            heartRateChartView.addSubview(barView)
            
            let barHeight = (CGFloat(value) - minValue) / (maxValue - minValue) * chartHeight
            let xPosition = CGFloat(index) * (barWidth + spacing) + 12
            
            NSLayoutConstraint.activate([
                barView.leadingAnchor.constraint(equalTo: heartRateChartView.leadingAnchor, constant: xPosition),
                barView.bottomAnchor.constraint(equalTo: heartRateChartView.bottomAnchor, constant: -12),
                barView.widthAnchor.constraint(equalToConstant: barWidth),
                barView.heightAnchor.constraint(equalToConstant: barHeight)
            ])
        }
    }
    
    private func setupStats() {
        statsContainer.backgroundColor = UIColor(hex: 0x1A1B1D)
        statsContainer.layer.cornerRadius = 16
        statsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statsContainer)
        
        // 平均值
        averageLabel.text = "78\n平均值"
        averageLabel.textAlignment = .center
        averageLabel.textColor = UIColor(hex: 0xFFD23A)
        averageLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        averageLabel.numberOfLines = 2
        averageLabel.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.addSubview(averageLabel)
        
        // 最大值
        maxLabel.text = "90\n最大值"
        maxLabel.textAlignment = .center
        maxLabel.textColor = UIColor(hex: 0xFFD23A)
        maxLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        maxLabel.numberOfLines = 2
        maxLabel.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.addSubview(maxLabel)
        
        // 最小值
        minLabel.text = "72\n最小值"
        minLabel.textAlignment = .center
        minLabel.textColor = UIColor(hex: 0xFFD23A)
        minLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        minLabel.numberOfLines = 2
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.addSubview(minLabel)
        
        NSLayoutConstraint.activate([
            statsContainer.topAnchor.constraint(equalTo: heartRateChartView.bottomAnchor, constant: 16),
            statsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statsContainer.heightAnchor.constraint(equalToConstant: 100),
            
            averageLabel.centerYAnchor.constraint(equalTo: statsContainer.centerYAnchor),
            averageLabel.leadingAnchor.constraint(equalTo: statsContainer.leadingAnchor, constant: 20),
            
            maxLabel.centerYAnchor.constraint(equalTo: statsContainer.centerYAnchor),
            maxLabel.centerXAnchor.constraint(equalTo: statsContainer.centerXAnchor),
            
            minLabel.centerYAnchor.constraint(equalTo: statsContainer.centerYAnchor),
            minLabel.trailingAnchor.constraint(equalTo: statsContainer.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupStatusLabel() {
        statusLabel.text = "心率正常"
        statusLabel.textColor = .white
        statusLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        statusLabel.textAlignment = .center
        statusLabel.backgroundColor = UIColor(hex: 0x2A2B2D)
        statusLabel.layer.cornerRadius = 12
        statusLabel.clipsToBounds = true
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: statsContainer.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statusLabel.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupStartButton() {
        startButton.setTitle("开始测量", for: .normal)
        startButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        startButton.backgroundColor = UIColor(hex: 0xFFD23A)
        startButton.setTitleColor(.black, for: .normal)
        startButton.tintColor = .black
        startButton.layer.cornerRadius = 24
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startMeasurement), for: .touchUpInside)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            startButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func backTapped() {
        // HeartRateHistoryViewController 是由 present 方式来自 RingHealthViewController
        // 所以返回应该使用 dismiss()
        if navigationController?.viewControllers.count ?? 0 > 1 {
            // 如果是执行了 push 操作，需要 pop
            navigationController?.popViewController(animated: true)
        } else {
            // 执行了 present 操作，需要 dismiss
            dismiss(animated: true)
        }
    }
    
    @objc private func previousDateTapped() {
        currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        updateDateDisplay()
    }
    
    @objc private func nextDateTapped() {
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        updateDateDisplay()
    }
    
    @objc private func startMeasurement() {
        let measureVC = HeartRateMeasurementViewController()
        measureVC.device = device
        measureVC.bclDevice = bclDevice
        navigationController?.pushViewController(measureVC, animated: true)
    }
    
    private func updateDateDisplay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日"
        formatter.locale = Locale(identifier: "zh_CN")
        dateLabel.text = formatter.string(from: currentDate)
    }
}
