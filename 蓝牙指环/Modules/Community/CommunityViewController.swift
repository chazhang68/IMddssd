import UIKit
import WebKit

/// 社区页面控制器 - 展示社交动态和内容发现功能
final class CommunityViewController: UIViewController {
    
    // MARK: - UI组件定义
    
    /// 搜索栏 - 用户搜索内容
    private let searchBar = UISearchBar()
    
    /// 筛选按钮容器 - 包含Discover、Following等筛选按钮
    private let filterStack = UIStackView()
    
    /// 发现按钮 - 默认选中状态，展示推荐内容
    private let discoverBtn = UIButton(type: .system)
    
    /// 关注按钮 - 展示用户关注的内容
    private let followingBtn = UIButton(type: .system)
    
    /// 标签按钮 - 按标签筛选内容
    private let tagBtn = UIButton(type: .system)
    
    /// 通知铃铛按钮 - 显示新消息通知
    private let bellBtn = UIButton(type: .system)
    
    /// 内容表格视图 - 展示帖子列表
    private let tableView = UITableView()
    
    /// 通知徽章 - 显示未读消息数量
    private let badge = UILabel()
    
    // MARK: - 数据模型
    
    /// 帖子数据数组 - 存储社区帖子内容
    private var posts: [Post] = []
    
    // MARK: - 生命周期方法
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismissal() // 配置点击外部隐藏键盘
        loadMockData()
    }
    
    // MARK: - 私有方法
    
    /// 设置UI界面和样式
    private func setupUI() {
        view.backgroundColor = UIColor(hex: 0x0B0C0D) // 深色背景
        setupSearchBar()      // 配置搜索栏
        setupFilterButtons()  // 配置筛选按钮
        setupTableView()      // 配置表格视图
        setupConstraints()    // 设置布局约束
    }
    
    /// 加载模拟数据 - 用于开发和测试
    private func loadMockData() {
        mockData()
    }
    
    // MARK: - 搜索栏配置
    
    /// 配置搜索栏外观和样式
    /// - 设置占位符文本为"Search..."
    /// - 使用最小化样式，移除默认背景
    /// - 自定义搜索框内部样式：深色背景、白色文字、圆角边框
    /// - 设置搜索图标为黄色主题色
    private func setupSearchBar() {
        searchBar.placeholder = "Search..."  // 搜索占位符文本
        searchBar.searchBarStyle = .minimal  // 最小化样式，移除默认边框
        searchBar.backgroundImage = UIImage()  // 清除背景图片
        
        // 自定义搜索框内部样式
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(hex: 0x2A2B2D)  // 深色背景
            textField.textColor = .white  // 白色文字
            textField.layer.cornerRadius = 16  // 圆角边框
            textField.leftView?.tintColor = UIColor(hex: 0xFFD23A)  // 黄色搜索图标
        }
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self  // 设置搜索栏代理
    }
    
    /// 配置点击外部隐藏键盘功能
    /// 添加手势识别器，当点击搜索栏外部区域时隐藏键盘
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false  // 允许其他控件接收点击事件
        view.addGestureRecognizer(tapGesture)
    }
    
    /// 隐藏键盘
    /// 当用户点击搜索栏外部区域时调用，隐藏当前激活的键盘
    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()  // 隐藏搜索栏键盘
        view.endEditing(true)  // 确保隐藏所有输入框的键盘
    }
    
    // MARK: - 筛选按钮配置
    
    /// 配置筛选按钮区域
    /// - 设置水平布局的按钮组
    /// - Discover按钮：黄色背景，黑色文字，默认选中
    /// - Following按钮：深色背景，白色文字，带闪电图标
    /// - Tag按钮：标签图标，黄色主题
    /// - Bell按钮：铃铛图标，带未读消息徽章
    private func setupFilterButtons() {
        // 配置筛选按钮容器
        filterStack.axis = .horizontal  // 水平布局
        filterStack.spacing = 8  // 按钮间距8pt
        filterStack.alignment = .center  // 居中对齐
        
        // Discover按钮配置 - 默认选中状态
        discoverBtn.setTitle("Discover", for: .normal)  // 按钮文字
        discoverBtn.setTitleColor(.black, for: .normal)  // 黑色文字
        discoverBtn.backgroundColor = UIColor(hex: 0xFFD23A)  // 黄色背景（主题色）
        discoverBtn.layer.cornerRadius = 16  // 圆角16pt
        discoverBtn.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)  // 半粗体字体
        
        // Following按钮配置
        followingBtn.setTitle("⚡ Following", for: .normal)  // 带闪电图标的文字
        followingBtn.setTitleColor(.white, for: .normal)  // 白色文字
        followingBtn.backgroundColor = UIColor(hex: 0x2A2B2D)  // 深色背景
        followingBtn.layer.cornerRadius = 16  // 圆角16pt
        followingBtn.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)  // 半粗体字体
        
        // Tag按钮配置 - 图标按钮
        tagBtn.setImage(UIImage(systemName: "tag"), for: .normal)  // 标签系统图标
        tagBtn.tintColor = UIColor(hex: 0xFFD23A)  // 黄色主题色
        
        // Bell按钮配置 - 通知铃铛
        bellBtn.setImage(UIImage(systemName: "bell"), for: .normal)  // 铃铛系统图标
        bellBtn.tintColor = UIColor(hex: 0xFFD23A)  // 黄色主题色
        
        // 通知徽章配置
        badge.text = "2"  // 未读消息数量
        badge.textColor = .white  // 白色文字
        badge.backgroundColor = .red  // 红色背景
        badge.layer.cornerRadius = 8  // 圆角8pt（圆形）
        badge.clipsToBounds = true  // 裁剪超出部分
        badge.font = .systemFont(ofSize: 10, weight: .bold)  // 粗体小字体
        badge.textAlignment = .center  // 文字居中
        bellBtn.addSubview(badge)  // 添加到铃铛按钮
        
        // 组装筛选按钮区域
        filterStack.addArrangedSubview(discoverBtn)  // Discover按钮
        filterStack.addArrangedSubview(followingBtn)  // Following按钮
        filterStack.addArrangedSubview(UIView())  // 弹性空间，推动右侧按钮
        filterStack.addArrangedSubview(tagBtn)  // Tag按钮
        filterStack.addArrangedSubview(bellBtn)  // Bell按钮
        
        view.addSubview(filterStack)  // 添加到主视图
        filterStack.translatesAutoresizingMaskIntoConstraints = false
        badge.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 配置表格视图
    /// - 设置透明背景，移除分隔线
    /// - 注册自定义PostCell用于展示帖子
    /// - 设置数据源和代理为当前控制器
    private func setupTableView() {
        tableView.backgroundColor = .clear  // 透明背景，显示主视图背景色
        tableView.separatorStyle = .none  // 移除默认分隔线
        tableView.dataSource = self  // 设置数据源
        tableView.delegate = self  // 设置代理
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")  // 注册自定义单元格
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 加载模拟数据 - 用于开发和测试
    /// 包含两个示例帖子：
    /// - SKYEAGLE Team: 智能眼镜产品介绍
    /// - Stacey: GIF动画分享内容
    private func mockData() {
        posts = [
            Post(author: "SKYEAGLE Team", time: "15:34 • October 17, 2025", body: "Lightweight, sleek, and packed with tech: stream your favorite content, take hands-free calls, and get real-time navigation—all right in your line of sight. Perfect for work, workouts, or on-the-go advent…", likes: 3, comments: 5, views: 27),
            Post(author: "Stacey", time: "12:30 • October 17, 2025", body: "Just shared two hilarious and entertaining GIF animations that will definitely brighten your day! Swipe through and enjoy the fun moments. Which one is your favorite?", likes: 3, comments: 5, views: 27)
        ]
    }
    
    /// 设置所有UI组件的布局约束
    /// 定义各组件的位置、尺寸和间距关系
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            filterStack.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            filterStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterStack.heightAnchor.constraint(equalToConstant: 44),
            
            discoverBtn.widthAnchor.constraint(equalToConstant: 88),
            followingBtn.widthAnchor.constraint(equalToConstant: 108),
            tagBtn.widthAnchor.constraint(equalToConstant: 32),
            bellBtn.widthAnchor.constraint(equalToConstant: 32),
            
            badge.topAnchor.constraint(equalTo: bellBtn.topAnchor, constant: 2),
            badge.trailingAnchor.constraint(equalTo: bellBtn.trailingAnchor, constant: -2),
            badge.widthAnchor.constraint(equalToConstant: 16),
            badge.heightAnchor.constraint(equalToConstant: 16),
            
            tableView.topAnchor.constraint(equalTo: filterStack.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UISearchBar代理

extension CommunityViewController: UISearchBarDelegate {
    /// 搜索按钮点击事件 - 隐藏键盘
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()  // 隐藏键盘
    }
    
    /// 搜索文本变化事件 - 可以在这里实现搜索功能
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: 实现搜索逻辑
        print("搜索文本变化: \(searchText)")
    }
}

// MARK: - UITableView数据源和代理方法

extension CommunityViewController: UITableViewDataSource, UITableViewDelegate {
    /// 返回表格行数 - 等于帖子数组数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { posts.count }
    
    /// 配置并返回指定行的单元格
    /// - 重用PostCell并配置帖子数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
    /// 返回行高 - 使用自动计算高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }
}

// MARK: - 数据模型

/// 帖子数据模型 - 表示社区中的单个帖子
/// 包含作者信息、时间戳、内容和互动数据
struct Post {
    let author: String    // 帖子作者名称
    let time: String      // 发布时间字符串
    let body: String      // 帖子正文内容
    let likes: Int        // 点赞数量
    let comments: Int     // 评论数量
    let views: Int        // 浏览数量
}

// MARK: - 帖子单元格

/// 帖子单元格 - 展示单个帖子的完整信息
/// 包含作者头像、名称、时间、内容、图片和操作按钮
final class PostCell: UITableViewCell {
    
    // MARK: - UI组件定义
    
    /// 卡片容器 - 包裹所有帖子内容，提供圆角和背景色
    private let card = UIView()
    
    /// 作者头像 - 显示用户头像或默认眼镜图标
    private let logo = UIImageView(image: UIImage(named: "glasses"))
    
    /// 作者名称标签 - 显示帖子作者
    private let author = UILabel()
    
    /// 取消关注标签 - 显示"unfollow"文字
    private let unfollow = UILabel()
    
    /// 时间标签 - 显示帖子发布时间
    private let time = UILabel()
    
    /// 正文标签 - 显示帖子内容文本
    private let body = UILabel()
    
    /// 图片卡片 - 展示帖子图片内容的背景区域
    private let imgCard = UIView()
    
    /// 操作按钮容器 - 包含点赞、评论、浏览、分享等操作
    private let actionStack = UIStackView()
    
    // MARK: - 初始化方法
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    /// 设置单元格UI组件和样式
    /// 配置卡片容器、作者信息、内容文本和操作按钮
    private func setup() {
        // 基础设置
        backgroundColor = .clear  // 透明背景
        selectionStyle = .none  // 移除选中效果
        
        // 卡片容器配置
        card.backgroundColor = UIColor(hex: 0x2A2B2D)  // 深色背景
        card.layer.cornerRadius = 16  // 圆角16pt
        contentView.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        
        // 作者头像配置
        logo.contentMode = .scaleAspectFit  // 按比例缩放
        logo.layer.cornerRadius = 12  // 圆角头像
        logo.clipsToBounds = true  // 裁剪超出部分
        card.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        // 作者名称配置
        author.textColor = .white  // 白色文字
        author.font = .systemFont(ofSize: 16, weight: .semibold)  // 16pt半粗体
        card.addSubview(author)
        author.translatesAutoresizingMaskIntoConstraints = false
        
        // 取消关注标签配置
        unfollow.text = "unfollow"  // 固定文字
        unfollow.textColor = .white  // 白色文字
        unfollow.font = .systemFont(ofSize: 14, weight: .regular)  // 14pt常规字体
        card.addSubview(unfollow)
        unfollow.translatesAutoresizingMaskIntoConstraints = false
        
        // 时间标签配置
        time.textColor = UIColor.white.withAlphaComponent(0.6)  // 60%透明度的白色
        time.font = .systemFont(ofSize: 12, weight: .regular)  // 12pt小字体
        card.addSubview(time)
        time.translatesAutoresizingMaskIntoConstraints = false
        
        // 正文标签配置
        body.textColor = .white  // 白色文字
        body.font = .systemFont(ofSize: 15, weight: .regular)  // 15pt常规字体
        body.numberOfLines = 0  // 多行显示
        card.addSubview(body)
        body.translatesAutoresizingMaskIntoConstraints = false
        
        // 图片卡片配置
        imgCard.backgroundColor = UIColor(hex: 0xFFD23A)  // 黄色主题背景
        imgCard.layer.cornerRadius = 12  // 圆角12pt
        card.addSubview(imgCard)
        imgCard.translatesAutoresizingMaskIntoConstraints = false
        
        // 操作按钮容器配置
        actionStack.axis = .horizontal  // 水平布局
        actionStack.spacing = 24  // 按钮间距24pt
        card.addSubview(actionStack)
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            logo.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            logo.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            logo.widthAnchor.constraint(equalToConstant: 24),
            logo.heightAnchor.constraint(equalToConstant: 24),
            
            author.topAnchor.constraint(equalTo: logo.topAnchor),
            author.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 8),
            
            unfollow.centerYAnchor.constraint(equalTo: author.centerYAnchor),
            unfollow.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            
            time.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 2),
            time.leadingAnchor.constraint(equalTo: author.leadingAnchor),
            
            body.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 8),
            body.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            body.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            
            imgCard.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 8),
            imgCard.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            imgCard.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            imgCard.heightAnchor.constraint(equalToConstant: 160),
            
            actionStack.topAnchor.constraint(equalTo: imgCard.bottomAnchor, constant: 12),
            actionStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            actionStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
        ])
    }
    
    /// 配置单元格显示帖子数据
    /// - 设置作者、时间、正文内容
    /// - 创建操作按钮（点赞、评论、浏览、分享）
    func configure(with post: Post) {
        // 设置基本帖子信息
        author.text = post.author
        time.text = post.time
        body.text = post.body
        
        // 清空并重新创建操作按钮
        actionStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        actionStack.addArrangedSubview(makeAction(icon: "heart", count: post.likes))  // 点赞按钮
        actionStack.addArrangedSubview(makeAction(icon: "bubble.right", count: post.comments))  // 评论按钮
        actionStack.addArrangedSubview(makeAction(icon: "eye", count: post.views))  // 浏览按钮
        actionStack.addArrangedSubview(makeAction(icon: "square.and.arrow.up", count: nil))  // 分享按钮（无计数）
    }
    
    /// 创建操作按钮视图
    /// - 包含图标和可选的数量显示
    /// - 图标使用系统图标，数量为可选参数
    private func makeAction(icon: String, count: Int?) -> UIView {
        let v = UIView()  // 按钮容器视图
        let iv = UIImageView(image: UIImage(systemName: icon))  // 系统图标
        iv.tintColor = UIColor.white.withAlphaComponent(0.6)  // 60%透明度的白色
        v.addSubview(iv)
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        if let c = count {
            // 有数量显示的情况（点赞、评论、浏览）
            let l = UILabel()
            l.text = "\(c)"  // 数量文本
            l.textColor = UIColor.white.withAlphaComponent(0.6)  // 60%透明度的白色
            l.font = .systemFont(ofSize: 14, weight: .regular)  // 14pt常规字体
            v.addSubview(l)
            l.translatesAutoresizingMaskIntoConstraints = false
            
            // 设置约束：图标+文字水平布局
            NSLayoutConstraint.activate([
                iv.leadingAnchor.constraint(equalTo: v.leadingAnchor),  // 图标左对齐
                iv.centerYAnchor.constraint(equalTo: v.centerYAnchor),  // 图标垂直居中
                l.leadingAnchor.constraint(equalTo: iv.trailingAnchor, constant: 4),  // 文字在图标右侧4pt
                l.centerYAnchor.constraint(equalTo: v.centerYAnchor),  // 文字垂直居中
                l.trailingAnchor.constraint(equalTo: v.trailingAnchor)  // 文字右对齐
            ])
        } else {
            // 无数量显示的情况（分享按钮）
            NSLayoutConstraint.activate([
                iv.leadingAnchor.constraint(equalTo: v.leadingAnchor),  // 图标左对齐
                iv.centerYAnchor.constraint(equalTo: v.centerYAnchor),  // 图标垂直居中
                iv.trailingAnchor.constraint(equalTo: v.trailingAnchor)  // 图标右对齐
            ])
        }
        return v
    }
}