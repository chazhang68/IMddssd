import UIKit

/// 设置页面控制器 - 用户个人信息和产品展示
/// 包含用户头像、昵称、签名以及产品推荐列表
final class SettingsViewController: UIViewController {
    
    // MARK: - UI组件定义
    
    /// 顶部用户卡片 - 展示用户基本信息
    private let headerCard = UIView()
    
    /// 用户头像 - 显示用户头像图片
    private let avatar = UIImageView(image: UIImage(named: "头像"))
    
    /// 用户昵称 - 显示用户名称
    private let name = UILabel()
    
    /// 用户签名 - 显示用户个性签名
    private let bio = UILabel()
    
    /// 设置图标 - 系统设置入口图标
    private let settingsIcon = UIImageView(image: UIImage(systemName: "gear"))
    
    /// 产品列表 - 展示推荐产品
    private let tableView = UITableView()
    
    // MARK: - 数据模型
    
    /// 产品数据 - 包含标题、描述和图标名称
    private let items = [
        (title: "MT AI Glasses", subtitle: "Experience big screen movies !", img: "glasses"),
        (title: "Interesting", subtitle: "Interesting product, coming soon!", img: "game"),
        (title: "Interesting", subtitle: "Interesting product, coming soon!", img: "earphones"),
        (title: "Interesting", subtitle: "Interesting product, coming soon!", img: "codale"),
        (title: "Interesting", subtitle: "Interesting product, coming soon!", img: "earphones2")
    ]
    
    // MARK: - 生命周期方法
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x0B0C0D)  // 设置深色背景
        setupHeader()     // 配置顶部用户卡片
        setupTable()      // 配置产品列表
        setupConstraints() // 设置布局约束
    }
    
    // MARK: - 私有方法
    
    /// 配置顶部用户卡片
    /// - 设置黄色渐变背景
    /// - 添加用户头像、昵称和签名
    /// - 添加设置按钮图标
    private func setupHeader() {
        headerCard.backgroundColor = UIColor(hex: 0xFFD23A)  // 黄色背景
        headerCard.layer.cornerRadius = 24  // 圆角24pt
        view.addSubview(headerCard)
        headerCard.translatesAutoresizingMaskIntoConstraints = false
        
        // 配置用户头像
        avatar.contentMode = .scaleAspectFit
        avatar.layer.cornerRadius = 32  // 圆形头像（64pt直径）
        avatar.clipsToBounds = true
        headerCard.addSubview(avatar)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        
        // 配置用户昵称
        name.text = "Palmer"  // 默认用户名
        name.font = .systemFont(ofSize: 24, weight: .bold)  // 24pt粗体
        name.textColor = .black  // 黑色文字
        headerCard.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        // 配置用户签名
        bio.text = "Keep smiling every day !"  // 默认签名
        bio.font = .systemFont(ofSize: 16, weight: .semibold)  // 16pt半粗体
        bio.textColor = .black  // 黑色文字
        headerCard.addSubview(bio)
        bio.translatesAutoresizingMaskIntoConstraints = false
        
        // 配置设置图标
        settingsIcon.tintColor = .black  // 黑色图标
        settingsIcon.contentMode = .scaleAspectFit
        headerCard.addSubview(settingsIcon)
        settingsIcon.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTable() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerCard.heightAnchor.constraint(equalToConstant: 120),
            
            avatar.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 16),
            avatar.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 64),
            avatar.heightAnchor.constraint(equalToConstant: 64),
            
            name.topAnchor.constraint(equalTo: avatar.topAnchor, constant: 4),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            
            bio.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            bio.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            
            settingsIcon.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            settingsIcon.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -16),
            settingsIcon.widthAnchor.constraint(equalToConstant: 24),
            settingsIcon.heightAnchor.constraint(equalToConstant: 24),
            
            tableView.topAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let item = items[indexPath.row]
        cell.configure(title: item.title, subtitle: item.subtitle, imgName: item.img)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 88 }
}

final class ProductCell: UITableViewCell {
    private let card = UIView()
    private let icon = UIImageView()
    private let title = UILabel()
    private let subtitle = UILabel()
    private let product = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        
        card.backgroundColor = UIColor(hex: 0x2A2B2D)
        card.layer.cornerRadius = 16
        contentView.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        
        icon.contentMode = .scaleAspectFit
        icon.layer.cornerRadius = 12
        icon.clipsToBounds = true
        card.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        title.textColor = .white
        title.font = .systemFont(ofSize: 16, weight: .semibold)
        card.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        subtitle.textColor = UIColor.white.withAlphaComponent(0.6)
        subtitle.font = .systemFont(ofSize: 14, weight: .regular)
        card.addSubview(subtitle)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        
        product.contentMode = .scaleAspectFit
        product.layer.cornerRadius = 12
        product.clipsToBounds = true
        card.addSubview(product)
        product.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            icon.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            icon.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            
            title.topAnchor.constraint(equalTo: icon.topAnchor),
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            subtitle.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            
            product.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            product.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            product.widthAnchor.constraint(equalToConstant: 64),
            product.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    func configure(title: String, subtitle: String, imgName: String) {
        self.title.text = title
        self.subtitle.text = subtitle
        icon.image = UIImage(named: imgName)
        product.image = UIImage(named: imgName)
    }
}