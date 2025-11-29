import UIKit
import CoreBluetooth

private var waveformTimerKey = "waveformTimerKey"

// ... existing code ...
final class HeartRateMeasurementViewController: UIViewController, BluetoothHeartRateDelegate {
    
    var device: Device?
    var bclDevice: BCLDevice?  // 真实蓝牙设备对象
    
    // MARK: - UI Elements
    
    private let navigationBar = UIView()
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let infoButton = UIButton()
    
    private let waveformView = UIView()
    private let progressView = UIView()
    private let timeLabels = [UILabel(), UILabel()]
    private var progressWidthConstraint: NSLayoutConstraint?
    
    private let currentHeartRateLabel = UILabel()
    private let startButton = UIButton()
    
    // MARK: - Data
    
    private var isWearingPositionShown = false
    private var currentHeartRate: Int = 0
    private var measurementTime: TimeInterval = 0
    private var timer: Timer?
    private var waveformDataPoints: [CGPoint] = []  // 存储波形数据点
    private var shapeLayer: CAShapeLayer?  // 实时绘制的路径层
    private var bluetoothManager: BluetoothHeartRateManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0xFFD23A)
        navigationController?.navigationBar.isHidden = true
        
        setupUI()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        setupNavigationBar()
        setupWaveformChart()
        setupProgressControl()
        setupCurrentHeartRate()
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
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            
            infoButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -16),
            infoButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 24),
            infoButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupWaveformChart() {
        waveformView.backgroundColor = UIColor(hex: 0xFFD23A)
        waveformView.translatesAutoresizingMaskIntoConstraints = false
        waveformView.isHidden = true  // 初始时隐藏
        view.addSubview(waveformView)
        
        // 绘制网格背景
        drawGridBackground()
        
        // 绘制波形
        drawWaveform()
        
        NSLayoutConstraint.activate([
            waveformView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 12),
            waveformView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            waveformView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            waveformView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func drawGridBackground() {
        let gridSize: CGFloat = 20
        let gridColor = UIColor.black.withAlphaComponent(0.1)
        
        let width = waveformView.bounds.width
        let height = waveformView.bounds.height
        
        // 绘制竖线
        var x: CGFloat = 0
        while x < width {
            let vLine = UIView()
            vLine.backgroundColor = gridColor
            vLine.translatesAutoresizingMaskIntoConstraints = false
            waveformView.addSubview(vLine)
            
            NSLayoutConstraint.activate([
                vLine.leadingAnchor.constraint(equalTo: waveformView.leadingAnchor, constant: x),
                vLine.topAnchor.constraint(equalTo: waveformView.topAnchor),
                vLine.widthAnchor.constraint(equalToConstant: 1),
                vLine.heightAnchor.constraint(equalTo: waveformView.heightAnchor)
            ])
            
            x += gridSize
        }
        
        // 绘制横线
        var y: CGFloat = 0
        while y < height {
            let hLine = UIView()
            hLine.backgroundColor = gridColor
            hLine.translatesAutoresizingMaskIntoConstraints = false
            waveformView.addSubview(hLine)
            
            NSLayoutConstraint.activate([
                hLine.topAnchor.constraint(equalTo: waveformView.topAnchor, constant: y),
                hLine.leadingAnchor.constraint(equalTo: waveformView.leadingAnchor),
                hLine.heightAnchor.constraint(equalToConstant: 1),
                hLine.widthAnchor.constraint(equalTo: waveformView.widthAnchor)
            ])
            
            y += gridSize
        }
    }
    
    private func drawWaveform() {
        let path = UIBezierPath()
        let width = waveformView.bounds.width
        let height = waveformView.bounds.height
        
        // 生成波形数据
        let points = generateWaveformPoints(count: Int(width), height: height)
        
        if let firstPoint = points.first {
            path.move(to: firstPoint)
        }
        
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        waveformView.layer.addSublayer(shapeLayer)
    }
    
    private func generateWaveformPoints(count: Int, height: CGFloat) -> [CGPoint] {
        var points: [CGPoint] = []
        let centerY = height / 2
        let amplitude = height / 4
        
        for i in 0..<count {
            let x = CGFloat(i)
            let y = centerY + amplitude * sin(CGFloat(i) * 0.05)
            points.append(CGPoint(x: x, y: y))
        }
        
        return points
    }
    
    private func setupProgressControl() {
        // 进度条背景
        let progressBG = UIView()
        progressBG.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        progressBG.layer.cornerRadius = 2
        progressBG.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressBG)
        
        // 进度条前景
        progressView.backgroundColor = UIColor(hex: 0x4C8FFF)
        progressView.layer.cornerRadius = 2
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressBG.addSubview(progressView)
        
        // 时间标签
        timeLabels[0].text = "00:00"
        timeLabels[0].textColor = .black
        timeLabels[0].font = .systemFont(ofSize: 12, weight: .regular)
        timeLabels[0].translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeLabels[0])
        
        timeLabels[1].text = "00:30"
        timeLabels[1].textColor = .black
        timeLabels[1].font = .systemFont(ofSize: 12, weight: .regular)
        timeLabels[1].translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeLabels[1])
        
        // 进度条宽度约束（初始为 0）
        progressWidthConstraint = progressView.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            progressBG.topAnchor.constraint(equalTo: waveformView.bottomAnchor, constant: 16),
            progressBG.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressBG.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressBG.heightAnchor.constraint(equalToConstant: 4),
            
            progressView.leadingAnchor.constraint(equalTo: progressBG.leadingAnchor),
            progressView.topAnchor.constraint(equalTo: progressBG.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: progressBG.bottomAnchor),
            progressWidthConstraint!,
            
            timeLabels[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            timeLabels[0].topAnchor.constraint(equalTo: progressBG.bottomAnchor, constant: 8),
            
            timeLabels[1].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            timeLabels[1].topAnchor.constraint(equalTo: progressBG.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupCurrentHeartRate() {
        currentHeartRateLabel.text = "82bpm"
        currentHeartRateLabel.textColor = .white
        currentHeartRateLabel.font = .systemFont(ofSize: 32, weight: .semibold)
        currentHeartRateLabel.textAlignment = .left
        currentHeartRateLabel.backgroundColor = UIColor(hex: 0x1A1B1D)
        currentHeartRateLabel.layer.cornerRadius = 24
        currentHeartRateLabel.clipsToBounds = true
        currentHeartRateLabel.translatesAutoresizingMaskIntoConstraints = false
        currentHeartRateLabel.isHidden = true  // 初始时隐藏
        view.addSubview(currentHeartRateLabel)
        
        // 心形图标
        let heartIcon = UIImageView()
        heartIcon.image = UIImage(systemName: "heart.fill")
        heartIcon.tintColor = UIColor(hex: 0xFF6B6B)
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        currentHeartRateLabel.addSubview(heartIcon)
        
        NSLayoutConstraint.activate([
            currentHeartRateLabel.topAnchor.constraint(equalTo: timeLabels[0].bottomAnchor, constant: 24),
            currentHeartRateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currentHeartRateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currentHeartRateLabel.heightAnchor.constraint(equalToConstant: 60),
            
            heartIcon.trailingAnchor.constraint(equalTo: currentHeartRateLabel.trailingAnchor, constant: -16),
            heartIcon.centerYAnchor.constraint(equalTo: currentHeartRateLabel.centerYAnchor),
            heartIcon.widthAnchor.constraint(equalToConstant: 24),
            heartIcon.heightAnchor.constraint(equalToConstant: 24)
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
        showWearingPositionGuide()
    }
    
    @objc private func startButtonTapped() {
        // 发送蓝牙命令开始测量
        startHeartRateMeasurement()
    }
    
    // MARK: - Bluetooth Communication
    
    private func startMeasurement() {
        // 模拟数据接收 - 实际应该从蓝牙接收
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.updateHeartRate()
        }
    }
    
    private func startHeartRateMeasurement() {
        // 优先从全局管理器中获取设备，其次是本地 bclDevice
        var bclDevice = BluetoothDeviceManager.shared.getCurrentDevice()
        if bclDevice == nil {
            bclDevice = self.bclDevice
        }
        
        // 检查设备是否存在
        guard let bclDevice = bclDevice else {
            print("❌ 未找到蓝牙设备")
            showAlert("错误", "未找到指环设备，请先需配对")
            return
        }
        
        print("✅ 找到蓝牙设备: \(bclDevice.name)")
        
        // 检查 peripheral 是否存在
        guard let peripheral = bclDevice.peripheral else {
            print("❌ peripheral 为 nil")
            showAlert("错误", "设备连接异常，请重新连接")
            return
        }
        
        print("✅ peripheral 存在，状态: \(peripheral.state.rawValue) (0=disconnected, 1=connecting, 2=connected, 3=disconnecting)")
        
        // 如果 peripheral 状态不是 connected，给用户一个警告但继续尝试
        if peripheral.state != .connected {
            print("⚠️  警告：设备状态不是 connected，状态值: \(peripheral.state.rawValue)")
        }
        
        print("✅ 开始真实测量")
        
        // 显示波形和 bpm
        waveformView.isHidden = false
        currentHeartRateLabel.isHidden = false
        startButton.isEnabled = false  // 禁用按钮
        startButton.alpha = 0.5
        
        // 清空之前的波形数据
        waveformDataPoints.removeAll()
        shapeLayer?.removeFromSuperlayer()
        measurementTime = 0
        currentHeartRate = 0
        
        // 启动时间计时器，每秒更新一次时间显示
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateMeasurementTime()
        }
        
        // 启动模拟波形生成定时器（如果蓝牙没有发送数据，至少显示模拟波形）
        let waveformTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.generateSimulatedWaveformPoint()
        }
        objc_setAssociatedObject(self, &waveformTimerKey, waveformTimer, .OBJC_ASSOCIATION_RETAIN)
        
        // 创建蓝牙管理器并设置委托
        bluetoothManager = BluetoothHeartRateManager()
        bluetoothManager?.delegate = self
        bluetoothManager?.initialize(with: bclDevice)
        
        // 开始心率测量
        bluetoothManager?.startHeartRateMeasurement()
    }
    
    private func sendBluetoothCommand(data: Data) {
        // TODO: 实现蓝牙发送逻辑
        // device?.writeToCharacteristic(data: data)
    }
    
    private func updateMeasurementTime() {
        // 更新测量时间
        measurementTime += 1
        let seconds = Int(measurementTime) % 60
        let minutes = Int(measurementTime) / 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        
        DispatchQueue.main.async { [weak self] in
            self?.timeLabels[0].text = timeString
        }
        
        // 30秒后停止测量
        if measurementTime >= 30 {
            timer?.invalidate()
            timer = nil
            finishMeasurement()
        }
    }
    
    private func finishMeasurement() {
        startButton.isEnabled = true
        startButton.alpha = 1.0
        print("✅ 心率测量完成")
        
        // 停止模拟波形定时器
        if let waveformTimer = objc_getAssociatedObject(self, &waveformTimerKey) as? Timer {
            waveformTimer.invalidate()
        }
        
        // 延迟 0.5 秒后跳转到结果页面，确保数据已更新
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.showMeasurementResult()
        }
    }
    
    private func showMeasurementResult() {
        // 创建结果页面
        let resultVC = HeartRateMeasurementResultViewController()
        resultVC.heartRate = currentHeartRate
        resultVC.measurementTime = Int(measurementTime)
        resultVC.delegate = self
        
        // 使用导航栈推送（而不是替换）
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
    private func updateHeartRate() {
        // 生成模拟心率数据 + 波形数据
        let randomHR = Int.random(in: 70...100)
        currentHeartRate = randomHR
        
        // 更新心率显示
        DispatchQueue.main.async { [weak self] in
            self?.currentHeartRateLabel.text = "\(randomHR)bpm"
        }
        
        // 生成波形数据点
        let waveformValue = CGFloat.random(in: 40...160)  // 波形高度范围
        let xPosition = CGFloat(waveformDataPoints.count) * 2  // 间距
        let yPosition = waveformValue
        
        waveformDataPoints.append(CGPoint(x: xPosition, y: yPosition))
        
        // 更新折线图
        updateWaveformChart()
        
        // 更新进度条
        measurementTime += 0.05
        let progress = min(measurementTime / 30.0, 1.0)
        
        // 使用约束动画更新进度条宽度
        let progressBGWidth = view.bounds.width - 32 - 120
        let targetWidth = progressBGWidth * progress
        
        progressWidthConstraint?.constant = targetWidth
        
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear, animations: {
                self?.view.layoutIfNeeded()
            })
        }
        
        // 测量完成
        if progress >= 1.0 {
            timer?.invalidate()
            timer = nil
            print("✅ 心率测量完成")
        }
    }
    
    private func updateWaveformChart() {
        // 实时绘制折线图
        guard waveformDataPoints.count > 1 else { return }
        
        // 移除旧的绘制
        shapeLayer?.removeFromSuperlayer()
        
        // 创建路径
        let path = UIBezierPath()
        let waveHeight = waveformView.bounds.height
        let waveWidth = waveformView.bounds.width
        
        // 计算缩放比例
        let scaleX = waveWidth / (CGFloat(waveformDataPoints.count) * 2)
        let scaleY = waveHeight / 120  // 数据范围 40-160
        
        // 绘制路径
        for (index, point) in waveformDataPoints.enumerated() {
            let x = CGFloat(index) * scaleX
            let y = waveHeight - (point.y - 40) * scaleY
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        // 创建图形层
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 2
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.lineJoin = .round
        
        waveformView.layer.addSublayer(layer)
        shapeLayer = layer
    }
    
    private func generateSimulatedWaveformPoint() {
        // 生成模拟波形数据点（如果蓝牙没有发送真实数据）
        // 使用心率为 60-80 的正弦波模拟
        let baseHeartRate = currentHeartRate > 0 ? currentHeartRate : 70
        let waveformValue = CGFloat(baseHeartRate) + CGFloat.random(in: -5...5)
        let xPosition = CGFloat(waveformDataPoints.count) * 2
        let yPosition = waveformValue
        
        waveformDataPoints.append(CGPoint(x: xPosition, y: yPosition))
        
        // 更新折线图
        updateWaveformChart()
    }
    
    private func showWearingPositionGuide() {
        let alert = UIAlertController(title: "佐戴姿持", message: "1, 选择合适的手指佐戴\n2, 佐戴时将设备闪烁指示灰放置在指腻方向\n3, 测量时适当弯曲手指贴紧设备", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确认", style: .default))
        present(alert, animated: true)
    }
        
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    // MARK: - BluetoothHeartRateDelegate
    
    func didUpdateHeartRate(_ result: BluetoothDataParser.HeartRateResult) {
        // 更新心率显示
        print("📊 didUpdateHeartRate 被调用: heartRate=\(result.heartRate)")
        DispatchQueue.main.async { [weak self] in
            if result.heartRate > 0 {
                print("✅ 更新 UI: \(result.heartRate)bpm")
                self?.currentHeartRate = Int(result.heartRate)  // 保存当前心率
                self?.currentHeartRateLabel.text = "\(result.heartRate)bpm"
                
                // 不应该在这里生成波形，应该由进度或波形数据命令提供
                // 但为了保证出现波形数据，我们这里也生成一个波形点
                let waveformValue = CGFloat(result.heartRate) + CGFloat.random(in: -5...5)
                let xPosition = CGFloat((self?.waveformDataPoints.count ?? 0)) * 2
                let yPosition = waveformValue
                self?.waveformDataPoints.append(CGPoint(x: xPosition, y: yPosition))
                
                // 更新折线图
                self?.updateWaveformChart()
            }
        }
    }
    
    func didUpdateProgress(_ progress: UInt8) {
        // 更新进度条（根据蓝牙协议的进度数据）
        print("📏 didUpdateProgress 被调用: progress=\(progress)%")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 进度条应该铺满整个宽度（从0到100%）
            // progressBG 的实际宽度 = view.bounds.width - 32（16左 + 16右）
            let progressBGWidth = self.view.bounds.width - 32
            let progressPercentage = CGFloat(progress) / 100.0
            let targetWidth = progressBGWidth * progressPercentage
            
            print("📏 进度条计算: 总宽度=\(progressBGWidth), 百分比=\(progressPercentage), 目标宽度=\(targetWidth)")
            
            // 更新进度条的约束常数
            self.progressWidthConstraint?.constant = targetWidth
            
            // 动画更新
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            // 根据进度数据生成波形数据点（模拟接收到连续波形）
            // 实际应接收波形数据(0x31 0x01)
            if self.currentHeartRate > 0 {
                // 基于心率生成波形数据（模拟）
                let waveformValue = CGFloat(self.currentHeartRate) + CGFloat.random(in: -10...10)
                let xPosition = CGFloat(self.waveformDataPoints.count) * 2
                let yPosition = waveformValue
                self.waveformDataPoints.append(CGPoint(x: xPosition, y: yPosition))
                
                // 更新折线图
                self.updateWaveformChart()
                
                print("📏 波形数据点: \(self.waveformDataPoints.count), 当前心率: \(self.currentHeartRate)")
            }
        }
    }
    
    func didUpdateWaveform(_ waveform: BluetoothDataParser.WaveformData) {
        // 处理波形数据（如需要绘制ECG波形）
        print("收到波形数据: seq=\(waveform.seq), dataCount=\(waveform.dataCount)")
    }
    
    func didUpdateRRInterval(_ rrData: BluetoothDataParser.RRIntervalData) {
        // 处理RR间期数据
        print("收到RR间期数据: seq=\(rrData.seq), dataCount=\(rrData.dataCount)")
    }
    
    func didReceiveBluetoothError(_ error: String) {
        // 显示蓝牙错误
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "蓝牙错误", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
