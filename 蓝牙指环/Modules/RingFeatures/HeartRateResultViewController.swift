import UIKit

// 心率测量结果页面（实时数据显示）
final class HeartRateResultViewController: UIViewController {
    
    var device: Device?
    
    // MARK: - UI Elements
    
    private let navigationBar = UIView()
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let infoButton = UIButton()
    
    private let waveformView = UIView()
    private let progressView = UIView()
    private let timeLabels = [UILabel(), UILabel()]
    
    private let statusCircleView = UIView()
    private let extremeValueCircleView = UIView()
    
    private let statusLabel = UILabel()
    private let currentHeartRateLabel = UILabel()
    private let disclaimerLabel = UILabel()
    private let startButton = UIButton()
    
    // MARK: - Data
    
    private var heartRateData: [Int] = []
    private var maxHeartRate: Int = 0
    private var minHeartRate: Int = 0
    private var currentHeartRate: Int = 82
    private var measurementTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0xFFD23A)
        navigationController?.navigationBar.isHidden = true
        
        setupUI()
    }
    
    deinit {
        measurementTimer?.invalidate()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        setupNavigationBar()
        setupWaveformChart()
        setupProgressControl()
        setupStatusAndExtremes()
        setupCurrentHeartRate()
        setupDisclaimer()
        setupStartButton()
    }
    
    private func setupNavigationBar() {
        navigationBar.backgroundColor = UIColor(hex: 0xFFD23A)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navigationBar.addSubview(backButton)
        
        titleLabel.text = "心率测量"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(titleLabel)
        
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.tintColor = .black
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.addTarget(self, action: #selector(infoBTapped), for: .touchUpInside)
        navigationBar.addSubview(infoButton)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 56),
            
            backButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            
            infoButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -16),
            infoButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
        ])
    }
    
    private func setupWaveformChart() {
        waveformView.backgroundColor = UIColor(hex: 0xFFD23A)
        waveformView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(waveformView)
        
        // 绘制网格
        drawGridPattern()
        
        // 绘制波形
        drawWaveformLine()
        
        NSLayoutConstraint.activate([
            waveformView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 12),
            waveformView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            waveformView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            waveformView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func drawGridPattern() {
        let gridSize: CGFloat = 15
        let gridColor = UIColor.black.withAlphaComponent(0.08)
        
        let width = waveformView.bounds.width
        let height = waveformView.bounds.height
        
        var x: CGFloat = 0
        while x < width {
            let line = UIView()
            line.backgroundColor = gridColor
            line.translatesAutoresizingMaskIntoConstraints = false
            waveformView.addSubview(line)
            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: waveformView.leadingAnchor, constant: x),
                line.topAnchor.constraint(equalTo: waveformView.topAnchor),
                line.widthAnchor.constraint(equalToConstant: 1),
                line.heightAnchor.constraint(equalTo: waveformView.heightAnchor)
            ])
            x += gridSize
        }
        
        var y: CGFloat = 0
        while y < height {
            let line = UIView()
            line.backgroundColor = gridColor
            line.translatesAutoresizingMaskIntoConstraints = false
            waveformView.addSubview(line)
            NSLayoutConstraint.activate([
                line.topAnchor.constraint(equalTo: waveformView.topAnchor, constant: y),
                line.leadingAnchor.constraint(equalTo: waveformView.leadingAnchor),
                line.heightAnchor.constraint(equalToConstant: 1),
                line.widthAnchor.constraint(equalTo: waveformView.widthAnchor)
            ])
            y += gridSize
        }
    }
    
    private func drawWaveformLine() {
        let path = UIBezierPath()
        let width = waveformView.bounds.width
        let height = waveformView.bounds.height
        
        // 生成波形曲线
        let points = generateSmoothWaveform(width: width, height: height)
        
        if let first = points.first {
            path.move(to: first)
        }
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2.5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        
        waveformView.layer.addSublayer(shapeLayer)
    }
    
    private func generateSmoothWaveform(width: CGFloat, height: CGFloat) -> [CGPoint] {
        var points: [CGPoint] = []
        let centerY = height / 2
        let amplitude = height / 3
        
        for i in stride(from: 0, through: Int(width), by: 2) {
            let x = CGFloat(i)
            let frequency: CGFloat = 0.04
            let y = centerY + amplitude * sin(CGFloat(i) * frequency)
            points.append(CGPoint(x: x, y: y))
        }
        
        return points
    }
    
    private func setupProgressControl() {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        bgView.layer.cornerRadius = 2
        bgView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bgView)
        
        progressView.backgroundColor = UIColor(hex: 0x4C8FFF)
        progressView.layer.cornerRadius = 2
        progressView.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(progressView)
        
        timeLabels[0].text = "00:30"
        timeLabels[0].textColor = .black
        timeLabels[0].font = .systemFont(ofSize: 12, weight: .regular)
        timeLabels[0].translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeLabels[0])
        
        timeLabels[1].text = "00:30"
        timeLabels[1].textColor = .black
        timeLabels[1].font = .systemFont(ofSize: 12, weight: .regular)
        timeLabels[1].textAlignment = .right
        timeLabels[1].translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeLabels[1])
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: waveformView.bottomAnchor, constant: 16),
            bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            bgView.heightAnchor.constraint(equalToConstant: 4),
            
            progressView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            progressView.topAnchor.constraint(equalTo: bgView.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor),
            progressView.widthAnchor.constraint(equalTo: bgView.widthAnchor, multiplier: 1.0),
            
            timeLabels[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            timeLabels[0].topAnchor.constraint(equalTo: bgView.bottomAnchor, constant: 8),
            
            timeLabels[1].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            timeLabels[1].topAnchor.constraint(equalTo: bgView.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupStatusAndExtremes() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(hex: 0x1A1B1D)
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // 左侧：状态圆环
        statusCircleView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(statusCircleView)
        
        // 绘制状态圆环（蓝色）
        drawCircleWithProgress(in: statusCircleView, progress: 1.0, color: UIColor(hex: 0x4C8FFF))
        
        let statusText = UILabel()
        statusText.text = "正常"
        statusText.textColor = .white
        statusText.font = .systemFont(ofSize: 12, weight: .semibold)
        statusText.textAlignment = .center
        statusText.translatesAutoresizingMaskIntoConstraints = false
        statusCircleView.addSubview(statusText)
        
        let statusIcon = UIImageView()
        statusIcon.image = UIImage(systemName: "square")
        statusIcon.tintColor = .white
        statusIcon.translatesAutoresizingMaskIntoConstraints = false
        statusText.addSubview(statusIcon)
        
        // 右侧：心率极值圆环
        extremeValueCircleView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(extremeValueCircleView)
        
        // 绘制极值圆环（黄色）
        drawCircleWithProgress(in: extremeValueCircleView, progress: 0.8, color: UIColor(hex: 0xB8860B))
        
        let extremeValueText = UILabel()
        extremeValueText.text = "90/72"
        extremeValueText.textColor = .white
        extremeValueText.font = .systemFont(ofSize: 14, weight: .semibold)
        extremeValueText.textAlignment = .center
        extremeValueText.translatesAutoresizingMaskIntoConstraints = false
        extremeValueCircleView.addSubview(extremeValueText)
        
        let extremeValueSub = UILabel()
        extremeValueSub.text = "心率极值"
        extremeValueSub.textColor = UIColor.white.withAlphaComponent(0.6)
        extremeValueSub.font = .systemFont(ofSize: 10, weight: .regular)
        extremeValueSub.textAlignment = .center
        extremeValueSub.translatesAutoresizingMaskIntoConstraints = false
        extremeValueCircleView.addSubview(extremeValueSub)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: timeLabels[0].bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 140),
            
            statusCircleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            statusCircleView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusCircleView.widthAnchor.constraint(equalToConstant: 80),
            statusCircleView.heightAnchor.constraint(equalToConstant: 80),
            
            statusText.centerXAnchor.constraint(equalTo: statusCircleView.centerXAnchor),
            statusText.centerYAnchor.constraint(equalTo: statusCircleView.centerYAnchor),
            
            extremeValueCircleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            extremeValueCircleView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            extremeValueCircleView.widthAnchor.constraint(equalToConstant: 80),
            extremeValueCircleView.heightAnchor.constraint(equalToConstant: 80),
            
            extremeValueText.centerXAnchor.constraint(equalTo: extremeValueCircleView.centerXAnchor),
            extremeValueText.centerYAnchor.constraint(equalTo: extremeValueCircleView.centerYAnchor, constant: -8),
            
            extremeValueSub.centerXAnchor.constraint(equalTo: extremeValueCircleView.centerXAnchor),
            extremeValueSub.bottomAnchor.constraint(equalTo: extremeValueCircleView.bottomAnchor, constant: -12)
        ])
    }
    
    private func drawCircleWithProgress(in view: UIView, progress: CGFloat, color: UIColor) {
        let circleLayer = CAShapeLayer()
        let radius = view.bounds.width / 2
        let center = CGPoint(x: radius, y: radius)
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius - 8, 
                                     startAngle: -CGFloat.pi / 2, 
                                     endAngle: -CGFloat.pi / 2 + CGFloat.pi * 2 * progress,
                                     clockwise: true)
        
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = color.cgColor
        circleLayer.lineWidth = 4
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        
        view.layer.addSublayer(circleLayer)
    }
    
    private func setupCurrentHeartRate() {
        currentHeartRateLabel.text = "82bpm"
        currentHeartRateLabel.textColor = .white
        currentHeartRateLabel.font = .systemFont(ofSize: 28, weight: .semibold)
        currentHeartRateLabel.backgroundColor = UIColor(hex: 0x1A1B1D)
        currentHeartRateLabel.layer.cornerRadius = 20
        currentHeartRateLabel.clipsToBounds = true
        currentHeartRateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentHeartRateLabel)
        
        let heartIcon = UIImageView()
        heartIcon.image = UIImage(systemName: "heart.fill")
        heartIcon.tintColor = UIColor(hex: 0xFF6B6B)
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        currentHeartRateLabel.addSubview(heartIcon)
        
        NSLayoutConstraint.activate([
            currentHeartRateLabel.topAnchor.constraint(equalTo: extremeValueCircleView.bottomAnchor, constant: 20),
            currentHeartRateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currentHeartRateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currentHeartRateLabel.heightAnchor.constraint(equalToConstant: 56),
            
            heartIcon.trailingAnchor.constraint(equalTo: currentHeartRateLabel.trailingAnchor, constant: -16),
            heartIcon.centerYAnchor.constraint(equalTo: currentHeartRateLabel.centerYAnchor),
            heartIcon.widthAnchor.constraint(equalToConstant: 20),
            heartIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupDisclaimer() {
        disclaimerLabel.text = "测量时请保持设备连接\n声明：所有数据结果仅供参考，不建议以此作为医疗或健康情况的正规依据，请使用专业测试器材进行复测。"
        disclaimerLabel.textColor = UIColor(hex: 0xFFD23A)
        disclaimerLabel.font = .systemFont(ofSize: 12, weight: .regular)
        disclaimerLabel.numberOfLines = 0
        disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(disclaimerLabel)
        
        NSLayoutConstraint.activate([
            disclaimerLabel.topAnchor.constraint(equalTo: currentHeartRateLabel.bottomAnchor, constant: 12),
            disclaimerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            disclaimerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupStartButton() {
        startButton.setTitle("开始测量", for: .normal)
        startButton.backgroundColor = UIColor(hex: 0xFFD23A)
        startButton.setTitleColor(.black, for: .normal)
        startButton.layer.cornerRadius = 24
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
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
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func infoBTapped() {
        // 显示帮助信息
    }
    
    @objc private func startButtonTapped() {
        // 开始新的测量
    }
}
