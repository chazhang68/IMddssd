import UIKit

/// 蓝牙设备搜索结果视图控制器
/// 显示搜索到的蓝牙设备列表，支持设备选择和连接
class SearchResultsViewController: UIViewController {
    
    // MARK: - 属性定义
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let connectButton = UIButton()
    private var selectedDevice: BCLDevice?
    
    /// 搜索结果设备列表
    var discoveredDevices: [BCLDevice] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    /// 设备选择回调
    var onDeviceSelected: ((BCLDevice) -> Void)?
    
    /// 取消按钮回调
    var onCancel: (() -> Void)?
    
    /// 搜索状态标记
    var isSearching: Bool = true
    
    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    // MARK: - UI设置
    
    /// 设置界面
    private func setupUI() {
        // 透明背景，显示后面的主界面
        view.backgroundColor = .clear
        
        // 半透明黑色蒙版容器（从屏幕下半部分开始）
        containerView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.85)
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 标题
        titleLabel.text = "Select the device"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
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
    }
    
    // MARK: - 事件处理
    
    @objc private func connectTapped() {
        guard let device = selectedDevice else { return }
        onDeviceSelected?(device)
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
        let isSelected = selectedDevice?.peripheralID == device.peripheralID
        cell.configure(with: device, isSelected: isSelected)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDevice = discoveredDevices[indexPath.row]
        tableView.reloadData()
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
        nameLabel.textColor = isSelected ? UIColor(hex: 0xFFB200) : UIColor(hex: 0x8E8E93)
        contentView.backgroundColor = isSelected ? UIColor(hex: 0x2C2C2E) : UIColor(hex: 0x1C1C1E)
    }
}
