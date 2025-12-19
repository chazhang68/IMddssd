import UIKit

/// 蓝牙设备搜索结果视图控制器
/// 显示搜索到的蓝牙设备列表，支持设备选择和连接
class SearchResultsViewController: UIViewController {
    
    // MARK: - 属性定义
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let cancelButton = UIButton()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let connectButton = UIButton()
    private let searchingLabel = UILabel()  // 搜索状态提示
    private let activityIndicator = UIActivityIndicatorView(style: .medium)  // 加载指示器
    private var selectedDevice: BCLDevice?
    
    /// 搜索结果设备列表
    var discoveredDevices: [BCLDevice] = [] {
        didSet {
            // 如果设备列表更新，检查选中的设备是否还在列表中
            if let selected = selectedDevice {
                // 如果选中的设备不在新列表中，清空选中状态
                if !discoveredDevices.contains(where: { $0.peripheralID == selected.peripheralID }) {
                    print("⚠️ 选中的设备不在新列表中，清空选中状态")
                    selectedDevice = nil
                } else {
                    // 更新选中设备的引用，确保使用最新的设备对象
                    if let updatedDevice = discoveredDevices.first(where: { $0.peripheralID == selected.peripheralID }) {
                        selectedDevice = updatedDevice
                        print("✅ 更新选中设备引用: \(updatedDevice.name)")
                    }
                }
            }
            
            tableView.reloadData()
            // 更新搜索状态显示
            updateSearchingState()
        }
    }
    
    /// 设备选择回调
    var onDeviceSelected: ((BCLDevice) -> Void)?
    
    /// 取消按钮回调
    var onCancel: (() -> Void)?
    
    /// 搜索状态标记
    var isSearching: Bool = true {
        didSet {
            updateSearchingState()
        }
    }
    
    /// 是否正在连接设备
    var isConnecting: Bool = false {
        didSet {
            updateConnectingState()
        }
    }
    
    /// 更新搜索状态显示
    private func updateSearchingState() {
        let hasDevices = !discoveredDevices.isEmpty
        
        if isSearching {
            if hasDevices {
                // 找到设备了，隐藏搜索提示，显示设备列表
                searchingLabel.isHidden = true
                activityIndicator.stopAnimating()
                tableView.isHidden = false
                connectButton.isHidden = false
            } else {
                // 还在搜索中，显示搜索提示
                searchingLabel.isHidden = false
                searchingLabel.text = "正在搜索设备..."
                activityIndicator.startAnimating()
                tableView.isHidden = true
                connectButton.isHidden = true  // 没有设备时隐藏连接按钮
            }
        } else {
            // 搜索已停止
            searchingLabel.isHidden = true
            activityIndicator.stopAnimating()
            tableView.isHidden = !hasDevices
            connectButton.isHidden = !hasDevices || selectedDevice == nil
        }
    }
    
    /// 更新连接状态显示
    private func updateConnectingState() {
        if isConnecting {
            // 显示连接中状态
            searchingLabel.isHidden = false
            searchingLabel.text = "正在连接设备..."
            activityIndicator.startAnimating()
            connectButton.isEnabled = false
            connectButton.setTitle("连接中...", for: .normal)
            tableView.isUserInteractionEnabled = false  // 连接中禁用选择
        } else {
            // 恢复正常状态
            searchingLabel.isHidden = true
            activityIndicator.stopAnimating()
            connectButton.isEnabled = true
            connectButton.setTitle("Connect", for: .normal)
            tableView.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        updateSearchingState()  // 初始化搜索状态显示
    }
    
    // MARK: - UI设置
    
    /// 设置界面
    private func setupUI() {
        // 透明背景，显示后面的主界面
        view.backgroundColor = .clear
        
        // 添加点击手势，点击背景区域可取消
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        tapGesture.cancelsTouchesInView = false  // 不取消子视图的触摸事件
        view.addGestureRecognizer(tapGesture)
        
        // 半透明黑色蒙版容器（从屏幕下半部分开始）
        containerView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.85)
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 确保容器视图可以接收触摸事件
        containerView.isUserInteractionEnabled = true
        
        // 标题
        titleLabel.text = "Select the device"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 取消按钮
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor(hex: 0x8E8E93), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        cancelButton.backgroundColor = .clear
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        containerView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 搜索状态提示
        searchingLabel.text = "正在搜索设备..."
        searchingLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        searchingLabel.textColor = UIColor(hex: 0x8E8E93)
        searchingLabel.textAlignment = .center
        searchingLabel.isHidden = false
        containerView.addSubview(searchingLabel)
        searchingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 加载指示器
        activityIndicator.color = UIColor(hex: 0xFFB200)
        activityIndicator.hidesWhenStopped = true
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // 表格
        containerView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Connect 按钮
        connectButton.setTitle("Connect", for: .normal)
        connectButton.setTitleColor(UIColor(hex: 0xFFB200), for: .normal)
        connectButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        connectButton.backgroundColor = .clear
        connectButton.addTarget(self, action: #selector(connectTapped), for: .touchUpInside)
        containerView.addSubview(connectButton)
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 蒙版从屏幕约2/3处开始
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65),
            
            // 取消按钮在右上角
            cancelButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            cancelButton.widthAnchor.constraint(equalToConstant: 60),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            
            // 标题居中（考虑取消按钮的位置，使用 centerX 确保真正居中）
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: cancelButton.leadingAnchor, constant: -10),
            
            // 搜索状态提示和加载指示器
            searchingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            searchingLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            searchingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            searchingLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: searchingLabel.bottomAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: connectButton.topAnchor, constant: -20),
            
            connectButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            connectButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            connectButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            connectButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    /// 设置表格视图
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "SearchResultCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(hex: 0x3A3A3C)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.allowsSelection = true  // 确保允许选择
        tableView.allowsMultipleSelection = false  // 不允许多选
        tableView.isUserInteractionEnabled = true  // 确保可以交互
        tableView.delaysContentTouches = false  // 不延迟触摸事件
    }
    
    // MARK: - 事件处理
    
    @objc private func connectTapped() {
        // 防止重复点击
        guard !isConnecting else {
            print("⚠️ 正在连接中，忽略重复点击")
            return
        }
        
        // 调试信息
        print("🔍 Connect 按钮被点击")
        print("   当前 selectedDevice: \(selectedDevice?.name ?? "nil")")
        print("   当前 selectedDevice ID: \(selectedDevice?.peripheralID ?? "nil")")
        print("   当前设备列表数量: \(discoveredDevices.count)")
        
        guard let device = selectedDevice else { 
            print("❌ selectedDevice 为 nil，提示用户选择设备")
            // 如果没有选择设备，提示用户
            let alert = UIAlertController(
                title: "提示",
                message: "请先选择一个设备",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "确定", style: .default))
            present(alert, animated: true)
            return
        }
        
        print("✅ 开始连接设备: \(device.name), ID: \(device.peripheralID)")
        
        // 先调用回调，让父控制器处理设备连接和关闭视图
        onDeviceSelected?(device)
        // 注意：不在这里 dismiss，让父控制器统一处理关闭逻辑
    }
    
    /// 取消按钮点击事件
    @objc private func cancelTapped() {
        handleCancel()
    }
    
    /// 背景点击事件（点击蒙版外部区域）
    @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        // 如果点击位置不在容器视图内，则取消
        // 同时检查是否点击在 tableView 上，如果是则不处理
        let tableViewLocation = gesture.location(in: tableView)
        if tableView.bounds.contains(tableViewLocation) {
            // 点击在 tableView 上，不处理背景点击
            return
        }
        
        if !containerView.frame.contains(location) {
            handleCancel()
        }
    }
    
    /// 处理取消操作
    private func handleCancel() {
        // 调用取消回调
        onCancel?()
        // 关闭视图控制器
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SearchResultCell",
            for: indexPath
        ) as! SearchResultCell
        
        let device = discoveredDevices[indexPath.row]
        
        // 检查是否选中：比较 peripheralID
        let isSelected = selectedDevice?.peripheralID == device.peripheralID
        
        // 调试信息
        if isSelected {
            print("🔵 配置单元格为选中状态: \(device.name)")
            print("   selectedDevice ID: \(selectedDevice?.peripheralID ?? "nil")")
            print("   device ID: \(device.peripheralID)")
        }
        
        cell.configure(with: device, isSelected: isSelected)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 只选择设备，不直接连接
        let device = discoveredDevices[indexPath.row]
        
        print("🔵 点击了设备: \(device.name), ID: \(device.peripheralID)")
        print("   之前的 selectedDevice: \(selectedDevice?.name ?? "nil")")
        
        // 记录之前选中的行（如果有）
        var previousIndexPath: IndexPath?
        if let previousDevice = selectedDevice,
           let previousIndex = discoveredDevices.firstIndex(where: { $0.peripheralID == previousDevice.peripheralID }) {
            previousIndexPath = IndexPath(row: previousIndex, section: 0)
            print("   之前选中的行: \(previousIndex)")
        }
        
        // 更新选中的设备
        selectedDevice = device
        print("✅ 已设置 selectedDevice: \(device.name), ID: \(device.peripheralID)")
        
        // 立即刷新整个表格以确保选中状态正确显示
        tableView.reloadData()
        print("✅ 已刷新表格")
        
        // 取消系统默认的选中高亮（我们使用自定义的选中状态）
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
}

// MARK: - 搜索结果单元格

/// 搜索结果列表单元格
class SearchResultCell: UITableViewCell {
    
    // MARK: - 属性定义
    
    /// 设备名称标签
    private let nameLabel = UILabel()
    
    /// 设备ID标签
    private let idLabel = UILabel()
    
    /// 信号强度标签
    private let signalLabel = UILabel()
    
    /// 信号强度进度条
    private let signalProgressView = UIProgressView()
    
    // MARK: - 初始化
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI设置
    
    /// 设置界面
    private func setupUI() {
        contentView.backgroundColor = UIColor(hex: 0x000000)
        
        // 设备名称标签
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        nameLabel.textColor = UIColor(hex: 0x8E8E93)
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 隐藏其他标签和进度条
        idLabel.isHidden = true
        signalLabel.isHidden = true
        signalProgressView.isHidden = true
        
        // 布局约束
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - 配置方法
    
    /// 配置单元格
    /// - Parameters:
    ///   - device: 蓝牙设备
    ///   - isSelected: 是否选中
    func configure(with device: BCLDevice, isSelected: Bool) {
        nameLabel.text = device.name
        
        // 选中状态：黄色文字，深灰色背景
        // 未选中状态：灰色文字，黑色背景
        if isSelected {
            nameLabel.textColor = UIColor(hex: 0xFFB200)  // 黄色
            contentView.backgroundColor = UIColor(hex: 0x2C2C2E)  // 深灰色
            print("🔵 单元格已配置为选中: \(device.name)")
        } else {
            nameLabel.textColor = UIColor(hex: 0x8E8E93)  // 灰色
            contentView.backgroundColor = UIColor(hex: 0x1C1C1E)  // 黑色
        }
        
        // 确保背景色可见
        contentView.layer.cornerRadius = 0
        backgroundColor = contentView.backgroundColor
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = contentView.backgroundColor
    }
}
