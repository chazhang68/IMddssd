import UIKit

/// 首页视图 - 包含设备搜索和管理功能
/// 提供设备网格卡片展示、搜索、连接状态管理等核心功能
class HomeView: UIView {
    
    // MARK: - UI组件定义
    
    /// 顶部容器 - 包含标题和导航按钮
    let topContainer = UIView()
    
    /// 标题标签 - 显示"SKYEAGLE"
    let titleLabel = UILabel()
    
    /// 日期标签 - 显示当前日期
    let dateLabel = UILabel()
    
    /// 菜单按钮 - 右上角圆形按钮
    let menuButton = UIButton(type: .system)
    
    /// 返回按钮 - 返回上一页面
    let backButton = UIButton(type: .system)
    
    /// 设备集合视图 - 网格展示可连接的设备
    let deviceCollectionView: UICollectionView
    
    /// 空状态视图 - 当没有设备时显示
    let emptyStateView = UIView()
    
    /// 空状态图标 - 显示设备图标
    let emptyStateIcon = UIImageView()
    
    /// 空状态文字 - 提示用户开启蓝牙或搜索设备
    let emptyStateLabel = UILabel()
    
    /// 搜索按钮 - 开始搜索设备
    let searchButton = UIButton(type: .system)
    
    /// 刷新按钮 - 刷新设备列表
    let refreshButton = UIButton(type: .system)

    // MARK: - 初始化方法
    
    override init(frame: CGRect) {
        // 配置 Collection View Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        self.deviceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        backgroundColor = .black  // 黑色主背景
        setupTop()                // 配置顶部导航区域
        setupDeviceCollection()   // 配置设备集合视图
        setupEmptyState()         // 配置空状态视图
        setupControlButtons()     // 配置控制按钮
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// 配置顶部导航区域
    /// - 黑色背景
    /// - 显示标题、日期和菜单按钮
    private func setupTop() {
        addSubview(topContainer)
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            topContainer.heightAnchor.constraint(equalToConstant: 80)  // 调整高度为100pt
        ])

        // 配置标题
        titleLabel.text = "SKYEAGLE"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(titleLabel)

        // 配置日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateLabel.text = dateFormatter.string(from: Date())
        dateLabel.textColor = UIColor(hex: 0x999999)
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(dateLabel)

        // 配置菜单按钮
//        menuButton.backgroundColor = UIColor(hex: 0x333333)
        menuButton.layer.cornerRadius = 28
        menuButton.setImage(UIImage(named: "add"), for: .normal)
        menuButton.tintColor = UIColor(hex: 0xFFD700)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(menuButton)

        // 配置返回按钮
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.isHidden = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(backButton)

        NSLayoutConstraint.activate([
            // 标题约束
            titleLabel.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 12),
            
            // 日期约束
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            // 菜单按钮约束
            menuButton.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -16),
            menuButton.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 12),
            menuButton.widthAnchor.constraint(equalToConstant: 56),
            menuButton.heightAnchor.constraint(equalToConstant: 56),
            
            // 返回按钮约束
            backButton.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    /// 配置设备网格集合视图
    /// - 2列布局
    /// - 网格卡片显示
    private func setupDeviceCollection() {
        addSubview(deviceCollectionView)
        deviceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        deviceCollectionView.backgroundColor = .clear
        deviceCollectionView.register(DeviceGridCell.self, forCellWithReuseIdentifier: "DeviceGridCell")
        
        NSLayoutConstraint.activate([
            deviceCollectionView.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 8),
            deviceCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            deviceCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            deviceCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -70)  // 调整为-70以适应TabBar
        ])
    }
    

    
    /// 配置空状态视图
    /// - 当没有设备时显示提示信息
    /// - 包含图标和说明文字
    private func setupEmptyState() {
        addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.backgroundColor = .clear  // 透明背景
        
        // 配置空状态图标
        emptyStateIcon.image = UIImage(systemName: "antenna.radiowaves.left.and.right")  // 蓝牙图标
        emptyStateIcon.tintColor = UIColor(hex: 0x666666)  // 灰色图标
        emptyStateIcon.contentMode = .scaleAspectFit
        emptyStateView.addSubview(emptyStateIcon)
        emptyStateIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // 配置空状态文字
        emptyStateLabel.text = "暂无设备\n点击搜索按钮开始扫描蓝牙设备"  // 两行文字
        emptyStateLabel.textColor = UIColor(hex: 0x999999)  // 浅灰色文字
        emptyStateLabel.font = .systemFont(ofSize: 16)
        emptyStateLabel.numberOfLines = 0  // 多行显示
        emptyStateLabel.textAlignment = .center
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 40),
            emptyStateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -70),
            
            emptyStateIcon.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateIcon.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -40),
            emptyStateIcon.widthAnchor.constraint(equalToConstant: 64),
            emptyStateIcon.heightAnchor.constraint(equalToConstant: 64),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateIcon.bottomAnchor, constant: 16),
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -32)
        ])
        
        // 初始显示空状态
        emptyStateView.isHidden = false
        deviceCollectionView.isHidden = true
    }
    
    /// 配置底部控制按钮
    /// - 搜索按钮和刷新按钮
    /// - 水平排列在底部
    private func setupControlButtons() {
        let buttonContainer = UIView()
        addSubview(buttonContainer)
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.backgroundColor = UIColor(hex: 0x1A1A1A)  // 深色背景
        
        // 搜索按钮配置
        searchButton.setTitle("搜索设备", for: .normal)  // 按钮文字
        searchButton.backgroundColor = UIColor(hex: 0xFFD700)  // 黄色背景
        searchButton.setTitleColor(.black, for: .normal)  // 黑色文字
        searchButton.layer.cornerRadius = 12  // 圆角12pt
        searchButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)  // 16pt中等字体
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 刷新按钮配置
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)  // 刷新图标
        refreshButton.tintColor = UIColor(hex: 0xFFD700)  // 黄色图标
        refreshButton.backgroundColor = UIColor(hex: 0x2A2A2A)  // 深灰色背景
        refreshButton.layer.cornerRadius = 12  // 圆角12pt
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        buttonContainer.addSubview(searchButton)
        buttonContainer.addSubview(refreshButton)
        
        NSLayoutConstraint.activate([
            // 按钮容器约束
            buttonContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            buttonContainer.heightAnchor.constraint(equalToConstant: 70),  // 调整高度为70pt以适应TabBar
            
            // 搜索按钮约束
            searchButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 16),
            searchButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 10),
            searchButton.trailingAnchor.constraint(equalTo: refreshButton.leadingAnchor, constant: -12),
            searchButton.heightAnchor.constraint(equalToConstant: 48),
            
            // 刷新按钮约束
            refreshButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -16),
            refreshButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 10),
            refreshButton.widthAnchor.constraint(equalToConstant: 48),
            refreshButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
