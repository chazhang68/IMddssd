import UIKit

// 自定义导航栏模块
// 用于页面顶部导航，支持返回按钮、标题和日期信息
final class CustomNavigationBarModule: UIView {
    
    // 导航栏配置
    struct Configuration {
        let title: String              // 导航栏标题
        let date: String?              // 可选的日期信息
        let backgroundColor: UIColor   // 背景颜色
        let tintColor: UIColor         // 按钮颜色
        let titleFont: UIFont          // 标题字体
        let dateFont: UIFont           // 日期字体
    }
    
    // UI元素
    private let headerView = UIView()
    private let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    
    // 返回按钮回调
    var onBackButtonTapped: (() -> Void)?
    
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
        // 设置容器背景
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        // 设置导航栏
        headerView.backgroundColor = UIColor(hex: 0xFFD23A)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerView)
        
        // 返回按钮
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        headerView.addSubview(backButton)
        
        // 标题标签
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        // 日期标签
        dateLabel.textColor = UIColor(hex: 0x2A2B2D)
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        
        // 配置约束
        NSLayoutConstraint.activate([
            // 导航栏约束
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),
            
            // 返回按钮约束
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // 标题约束
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // 日期标签约束
            dateLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 16),
            
            // 容器高度
            bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    
    // 配置导航栏
    func configure(with config: Configuration) {
        titleLabel.text = config.title
        titleLabel.font = config.titleFont
        
        if let date = config.date {
            dateLabel.text = date
            dateLabel.isHidden = false
        } else {
            dateLabel.isHidden = true
        }
        
        dateLabel.font = config.dateFont
        dateLabel.textColor = config.backgroundColor.withAlphaComponent(0.5)
        headerView.backgroundColor = config.backgroundColor
        backButton.tintColor = config.tintColor
        titleLabel.textColor = config.tintColor
    }
    
    // 获取导航栏高度
    func getHeaderHeight() -> CGFloat {
        return 56 + (dateLabel.isHidden ? 0 : 24)
    }
    
    // MARK: - Private Methods
    
    @objc private func backButtonTapped() {
        onBackButtonTapped?()
    }
}
