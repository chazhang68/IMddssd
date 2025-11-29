import UIKit

// 心率测量结果页面
final class HeartRateMeasurementResultViewController: UIViewController {
    
    var heartRate: Int = 0
    var measurementTime: Int = 0
    weak var delegate: HeartRateMeasurementResultDelegate?
    
    // MARK: - UI Elements
    
    private let navigationBar = UIView()
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let infoButton = UIButton()
    
    private let resultContainer = UIView()
    private let statusCircle = UIView()
    private let statusLabel = UILabel()
    private let heartRateCircle = UIView()
    private let heartRateValueLabel = UILabel()
    private let heartRateSubtitleLabel = UILabel()
    
    private let progressContainer = UIView()
    private let timeStartLabel = UILabel()
    private let timeEndLabel = UILabel()
    private let progressView = UIView()
    
    private let bpmContainer = UIView()
    private let bpmLabel = UILabel()
    private let heartIcon = UIImageView()
    
    private let disclaimerLabel = UILabel()
    private let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0xFFD23A)
        navigationController?.navigationBar.isHidden = true
        
        setupUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        setupNavigationBar()
        setupResultContainer()
        setupProgressControl()
        setupBPMContainer()
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
    
    private func setupResultContainer() {
        resultContainer.backgroundColor = UIColor(hex: 0x1A1B1D)
        resultContainer.layer.cornerRadius = 20
        resultContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultContainer)
        
        // 状态圆圈
        statusCircle.layer.borderColor = UIColor(hex: 0x4C8FFF).cgColor
        statusCircle.layer.borderWidth = 3
        statusCircle.layer.cornerRadius = 60
        statusCircle.translatesAutoresizingMaskIntoConstraints = false
        resultContainer.addSubview(statusCircle)
        
        statusLabel.text = "正常"
        statusLabel.textColor = .white
        statusLabel.font = .systemFont(ofSize: 14, weight: .regular)
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusCircle.addSubview(statusLabel)
        
        let heartIconSmall = UIImageView()
        heartIconSmall.image = UIImage(systemName: "heart.fill")
        heartIconSmall.tintColor = .white
        heartIconSmall.translatesAutoresizingMaskIntoConstraints = false
        statusCircle.addSubview(heartIconSmall)
        
        // 心率极值圆圈
        heartRateCircle.layer.borderColor = UIColor(hex: 0xD4A574).cgColor
        heartRateCircle.layer.borderWidth = 3
        heartRateCircle.layer.cornerRadius = 60
        heartRateCircle.translatesAutoresizingMaskIntoConstraints = false
        resultContainer.addSubview(heartRateCircle)
        
        heartRateValueLabel.text = "\(heartRate)"
        heartRateValueLabel.textColor = .white
        heartRateValueLabel.font = .systemFont(ofSize: 28, weight: .semibold)
        heartRateValueLabel.translatesAutoresizingMaskIntoConstraints = false
        heartRateCircle.addSubview(heartRateValueLabel)
        
        heartRateSubtitleLabel.text = "极值"
        heartRateSubtitleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        heartRateSubtitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        heartRateSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        heartRateCircle.addSubview(heartRateSubtitleLabel)
        
        NSLayoutConstraint.activate([
            resultContainer.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 16),
            resultContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resultContainer.heightAnchor.constraint(equalToConstant: 240),
            
            statusCircle.leadingAnchor.constraint(equalTo: resultContainer.leadingAnchor, constant: 30),
            statusCircle.centerYAnchor.constraint(equalTo: resultContainer.centerYAnchor),
            statusCircle.widthAnchor.constraint(equalToConstant: 120),
            statusCircle.heightAnchor.constraint(equalToConstant: 120),
            
            heartIconSmall.centerXAnchor.constraint(equalTo: statusCircle.centerXAnchor),
            heartIconSmall.topAnchor.constraint(equalTo: statusCircle.topAnchor, constant: 20),
            heartIconSmall.widthAnchor.constraint(equalToConstant: 24),
            heartIconSmall.heightAnchor.constraint(equalToConstant: 24),
            
            statusLabel.centerXAnchor.constraint(equalTo: statusCircle.centerXAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: statusCircle.bottomAnchor, constant: -16),
            
            heartRateCircle.trailingAnchor.constraint(equalTo: resultContainer.trailingAnchor, constant: -30),
            heartRateCircle.centerYAnchor.constraint(equalTo: resultContainer.centerYAnchor),
            heartRateCircle.widthAnchor.constraint(equalToConstant: 120),
            heartRateCircle.heightAnchor.constraint(equalToConstant: 120),
            
            heartRateValueLabel.centerXAnchor.constraint(equalTo: heartRateCircle.centerXAnchor),
            heartRateValueLabel.centerYAnchor.constraint(equalTo: heartRateCircle.centerYAnchor, constant: -8),
            
            heartRateSubtitleLabel.centerXAnchor.constraint(equalTo: heartRateCircle.centerXAnchor),
            heartRateSubtitleLabel.bottomAnchor.constraint(equalTo: heartRateCircle.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupProgressControl() {
        progressContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressContainer)
        
        // 进度条背景
        let progressBG = UIView()
        progressBG.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        progressBG.layer.cornerRadius = 2
        progressBG.translatesAutoresizingMaskIntoConstraints = false
        progressContainer.addSubview(progressBG)
        
        // 进度条前景
        progressView.backgroundColor = UIColor(hex: 0x4C8FFF)
        progressView.layer.cornerRadius = 2
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressBG.addSubview(progressView)
        
        // 时间标签
        timeStartLabel.text = "00:00"
        timeStartLabel.textColor = .black
        timeStartLabel.font = .systemFont(ofSize: 12, weight: .regular)
        timeStartLabel.translatesAutoresizingMaskIntoConstraints = false
        progressContainer.addSubview(timeStartLabel)
        
        timeEndLabel.text = "00:30"
        timeEndLabel.textColor = .black
        timeEndLabel.font = .systemFont(ofSize: 12, weight: .regular)
        timeEndLabel.translatesAutoresizingMaskIntoConstraints = false
        progressContainer.addSubview(timeEndLabel)
        
        let progressPercentage = min(CGFloat(measurementTime) / 30.0, 1.0)
        
        NSLayoutConstraint.activate([
            progressContainer.topAnchor.constraint(equalTo: resultContainer.bottomAnchor, constant: 32),
            progressContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            progressBG.topAnchor.constraint(equalTo: progressContainer.topAnchor),
            progressBG.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            progressBG.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor),
            progressBG.heightAnchor.constraint(equalToConstant: 4),
            
            progressView.leadingAnchor.constraint(equalTo: progressBG.leadingAnchor),
            progressView.topAnchor.constraint(equalTo: progressBG.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: progressBG.bottomAnchor),
            progressView.widthAnchor.constraint(equalTo: progressBG.widthAnchor, multiplier: progressPercentage),
            
            timeStartLabel.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            timeStartLabel.topAnchor.constraint(equalTo: progressBG.bottomAnchor, constant: 8),
            
            timeEndLabel.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor),
            timeEndLabel.topAnchor.constraint(equalTo: progressBG.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupBPMContainer() {
        bpmContainer.backgroundColor = UIColor(hex: 0x1A1B1D)
        bpmContainer.layer.cornerRadius = 20
        bpmContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bpmContainer)
        
        bpmLabel.text = "\(heartRate)bpm"
        bpmLabel.textColor = .white
        bpmLabel.font = .systemFont(ofSize: 32, weight: .semibold)
        bpmLabel.translatesAutoresizingMaskIntoConstraints = false
        bpmContainer.addSubview(bpmLabel)
        
        heartIcon.image = UIImage(systemName: "heart.fill")
        heartIcon.tintColor = UIColor(hex: 0xFF6B6B)
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        bpmContainer.addSubview(heartIcon)
        
        NSLayoutConstraint.activate([
            bpmContainer.topAnchor.constraint(equalTo: progressContainer.bottomAnchor, constant: 24),
            bpmContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bpmContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bpmContainer.heightAnchor.constraint(equalToConstant: 60),
            
            bpmLabel.leadingAnchor.constraint(equalTo: bpmContainer.leadingAnchor, constant: 16),
            bpmLabel.centerYAnchor.constraint(equalTo: bpmContainer.centerYAnchor),
            
            heartIcon.trailingAnchor.constraint(equalTo: bpmContainer.trailingAnchor, constant: -16),
            heartIcon.centerYAnchor.constraint(equalTo: bpmContainer.centerYAnchor),
            heartIcon.widthAnchor.constraint(equalToConstant: 24),
            heartIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupDisclaimer() {
        let titleLabel = UILabel()
        titleLabel.text = "测量时请保持设备连接"
        titleLabel.textColor = UIColor(hex: 0xFFD23A)
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        disclaimerLabel.text = "声明：所有数据结果仅供参考，不建议以此作为医疗或健康情况的正规依据，请使用专业测试器材进行复测。"
        disclaimerLabel.textColor = .white
        disclaimerLabel.font = .systemFont(ofSize: 12, weight: .regular)
        disclaimerLabel.numberOfLines = 0
        disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(disclaimerLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: bpmContainer.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            disclaimerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
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
        // 返回到健康页面并更新数据
        delegate?.measurementDidFinish(heartRate: heartRate)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func startButtonTapped() {
        // 返回到健康页面
        delegate?.measurementDidFinish(heartRate: heartRate)
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Delegate Protocol

protocol HeartRateMeasurementResultDelegate: AnyObject {
    func measurementDidFinish(heartRate: Int)
}

extension HeartRateMeasurementViewController: HeartRateMeasurementResultDelegate {
    func measurementDidFinish(heartRate: Int) {
        // 更新健康页面的心率数据
        // 这里可以通过 NotificationCenter 或其他方式通知健康页面更新
        print("✅ 更新心率数据: \(heartRate)bpm")
        NotificationCenter.default.post(name: NSNotification.Name("HeartRateMeasurementComplete"), object: ["heartRate": heartRate])
    }
}
