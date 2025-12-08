import UIKit

/// 设备选择弹窗（覆盖层）
final class DeviceSelectViewController: UIViewController {
    
//    var devices: [String] = []
    /// 设备列表 - 存储搜索到的设备
     var devices: [Device] = []
    var onCancel: (() -> Void)?
    var onConnect: ((String?) -> Void)?
    
    private var selected: String?
    
    private let dimView = UIView()
    private let cardView = UIView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let connectButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        dimView.alpha = 0
        dimView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimView)
        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelTapped)))
        
        cardView.backgroundColor = UIColor(hex: 0x1C1C1E)
        cardView.layer.cornerRadius = 22
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.masksToBounds = true
        view.addSubview(cardView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Select the device"
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.15)
        tableView.rowHeight = 56
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        cardView.addSubview(tableView)
        
        connectButton.setTitle("Connect", for: .normal)
        connectButton.setTitleColor(UIColor(hex: 0xFFD23A), for: .normal)
        connectButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        connectButton.addTarget(self, action: #selector(connectTapped), for: .touchUpInside)
        view.addSubview(connectButton)
        
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 280),
            
            connectButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 12),
            connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.dimView.alpha = 1
        }
    }
    
    // MARK: - Actions
    @objc private func cancelTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onCancel?()
        }
    }
    
    @objc private func connectTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onConnect?(self?.selected)
        }
    }
}

extension DeviceSelectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = devices[indexPath.row].name
        cell.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        cell.textLabel?.textColor = devices[indexPath.row].name == selected ? UIColor(hex: 0xFFD23A) : .white
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = devices[indexPath.row].name
        tableView.reloadData()
    }
}

