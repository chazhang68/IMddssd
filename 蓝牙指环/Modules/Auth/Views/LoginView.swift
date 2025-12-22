import UIKit

class LoginView: UIView, UITextViewDelegate {
    // MARK: - UI组件定义
    
    /// 顶部容器 - 包含品牌标题和Logo
    let topContainer = UIView()
    
    let backgroundImageView = UIImageView()
    let welcomeImageView = UIImageView()
    let avatarImageView = UIImageView()
    
    /// Logo视图 - 圆形Logo容器，包含Y形徽章
    let logoView = UIView() // Circular logo
    
    /// 用户协议容器 - 包含复选框和协议文本
    let consentContainer = UIView()
    let consentTextView = UITextView()
    
    /// 同意复选框 - 用户勾选同意协议
    let checkBox = UIButton(type: .custom)
    
    /// 协议说明标签 - 显示"I have read and agree to the"
    let consentLabel = UILabel()
    
    /// 隐私政策按钮 - 链接到隐私政策页面
    let privacyButton = UIButton(type: .system)
    
    /// 管理按钮 - 链接到管理页面
    let managementButton = UIButton(type: .system)
    
    /// 社交登录容器 - 包含手机登录、Apple、WeChat登录按钮
    let socialContainer = UIView()
    
    /// 极光一键登录按钮 - 黄色背景，黑色图标和文字
    let jiguangLoginButton = UIButton(type: .system)
    
    /// Apple登录按钮 - 黄色背景，黑色图标和文字
    let appleButton = UIButton(type: .system)
    
    /// WeChat登录按钮 - 黄色背景，黑色图标和文字
    let wechatButton = UIButton(type: .system)
    
    /// 底部容器 - 用于显示对角线条纹背景
    let bottomContainer = UIView()
    
    /// 用户同意状态 - 记录用户是否勾选同意协议
    var isConsentChecked = false
    
    let cornerButtonRadius: CGFloat = 20

    // MARK: - 初始化方法
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupBackground()
        setupTopContainer()      // 配置顶部容器
        setupHeaderTexts()       // 配置标题和品牌文字
        setupLogo()              // 配置Logo和徽章
        setupConsentSection()    // 配置用户协议区域
        setupSocialButtons()     // 配置社交登录按钮
        setupBottomContainer()   // 配置底部容器
        //updateSocialButtonsEnabled()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI配置方法

    /// 配置顶部容器
    /// - 设置明亮黄色背景
    /// - 配置圆角底部边框（32pt圆角）
    /// - 占据屏幕65%高度
    private func setupTopContainer() {
        addSubview(topContainer)
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            topContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.60)
        ])
        topContainer.backgroundColor = UIColor(hex: 0xFFD700) // 明亮黄色背景
        topContainer.layer.cornerRadius = 36 // 大圆角底部边框
        topContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]  // 仅底部左右圆角
    }

    /// 配置标题和品牌文字
    /// - 设置"Welcome to"标题（28pt粗体黑色）
    /// - 设置"SKYEAGLE"品牌名（40pt特粗，深橄榄色）
    /// - 添加多层阴影效果增强3D视觉
    private func setupHeaderTexts() {
        topContainer.addSubview(welcomeImageView)
        welcomeImageView.translatesAutoresizingMaskIntoConstraints = false
        welcomeImageView.image = UIImage(named: "Welcome")
        welcomeImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            welcomeImageView.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 166),
            welcomeImageView.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 24),
            welcomeImageView.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -24),
            welcomeImageView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }

    /// 配置Logo视图
    /// - 创建50x50pt的圆形黑色背景
    /// - 添加Y形金色徽章（翅膀形状）
    /// - 定位在品牌文字右下方
    private func setupLogo() {
        topContainer.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.image = UIImage(named: "头像")
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 12
        avatarImageView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 110),
            avatarImageView.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -24),
            avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            avatarImageView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setupConsentSection() {
        addSubview(consentContainer)
        consentContainer.translatesAutoresizingMaskIntoConstraints = false
        consentContainer.backgroundColor = .clear
        
        // Checkbox
        consentContainer.addSubview(checkBox)
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.addTarget(self, action: #selector(toggleConsent), for: .touchUpInside)
        checkBox.contentMode = .center
        checkBox.adjustsImageWhenHighlighted = false
        checkBox.showsTouchWhenHighlighted = false
        checkBox.backgroundColor = .clear
        checkBox.setImage(UIImage(named: "unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        checkBox.setImage(UIImage(named: "selected")?.withRenderingMode(.alwaysOriginal), for: .selected)
        
        consentTextView.translatesAutoresizingMaskIntoConstraints = false
        consentTextView.backgroundColor = .clear
        consentTextView.isEditable = false
        consentTextView.isScrollEnabled = false
        consentTextView.textContainerInset = .zero
        consentTextView.textContainer.lineFragmentPadding = 0
        consentTextView.linkTextAttributes = [
            .foregroundColor: UIColor(hex: 0xFFD700)
        ]
        let baseColor = UIColor(white: 0.7, alpha: 1.0)
        let text = "I have read and agree to the Privacy Policy Management"
        let attr = NSMutableAttributedString(string: text, attributes: [
            .foregroundColor: baseColor,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ])
        if let range1 = (text as NSString).range(of: "Privacy Policy") as NSRange? {
            attr.addAttributes([.link: URL(string: "action://privacy")!], range: range1)
        }
        if let range2 = (text as NSString).range(of: "Management") as NSRange? {
            attr.addAttributes([.link: URL(string: "action://management")!], range: range2)
        }
        consentTextView.attributedText = attr
        consentTextView.delegate = self
        consentContainer.addSubview(consentTextView)
        
        NSLayoutConstraint.activate([
            consentContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 30),
            consentContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            consentContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            checkBox.leadingAnchor.constraint(equalTo: consentContainer.leadingAnchor),
            checkBox.topAnchor.constraint(equalTo: consentContainer.topAnchor),
            checkBox.widthAnchor.constraint(equalToConstant: 24),
            checkBox.heightAnchor.constraint(equalToConstant: 24),
            
            consentTextView.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 12),
            consentTextView.topAnchor.constraint(equalTo: consentContainer.topAnchor),
            consentTextView.trailingAnchor.constraint(equalTo: consentContainer.trailingAnchor),
            consentTextView.bottomAnchor.constraint(equalTo: consentContainer.bottomAnchor)
        ])
    }

    private func setupSocialButtons() {
        addSubview(socialContainer)
        socialContainer.translatesAutoresizingMaskIntoConstraints = false
        socialContainer.backgroundColor = .clear
        
        // 按从左到右的顺序设置按钮：手机登录、Apple、WeChat
        setupJiguangLoginButton() // 左侧：手机登录
        setupAppleButton()        // 中间：Apple
        setupWeChatButton()       // 右侧：WeChat
        
        let spacing: CGFloat = 15
        
        NSLayoutConstraint.activate([
            socialContainer.topAnchor.constraint(greaterThanOrEqualTo: consentContainer.bottomAnchor, constant: 30),
            socialContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            socialContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            socialContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            socialContainer.heightAnchor.constraint(equalToConstant: 60),
            
            // 手机登录按钮 - 左侧
            jiguangLoginButton.leadingAnchor.constraint(equalTo: socialContainer.leadingAnchor),
            jiguangLoginButton.topAnchor.constraint(equalTo: socialContainer.topAnchor),
            jiguangLoginButton.bottomAnchor.constraint(equalTo: socialContainer.bottomAnchor),
            jiguangLoginButton.widthAnchor.constraint(equalTo: socialContainer.widthAnchor, multiplier: 1.0/3.0, constant: -spacing * 2.0/3.0),
            
            // Apple按钮 - 中间
            appleButton.leadingAnchor.constraint(equalTo: jiguangLoginButton.trailingAnchor, constant: spacing),
            appleButton.topAnchor.constraint(equalTo: socialContainer.topAnchor),
            appleButton.bottomAnchor.constraint(equalTo: socialContainer.bottomAnchor),
            appleButton.widthAnchor.constraint(equalTo: jiguangLoginButton.widthAnchor),
            
            // WeChat按钮 - 右侧
            wechatButton.leadingAnchor.constraint(equalTo: appleButton.trailingAnchor, constant: spacing),
            wechatButton.topAnchor.constraint(equalTo: socialContainer.topAnchor),
            wechatButton.bottomAnchor.constraint(equalTo: socialContainer.bottomAnchor),
            wechatButton.trailingAnchor.constraint(equalTo: socialContainer.trailingAnchor),
            wechatButton.widthAnchor.constraint(equalTo: jiguangLoginButton.widthAnchor)
        ])
    }

    /// 配置极光一键登录按钮
    private func setupJiguangLoginButton() {
        // 确保按钮被添加到视图层级
        if jiguangLoginButton.superview == nil {
            socialContainer.addSubview(jiguangLoginButton)
        }
        jiguangLoginButton.translatesAutoresizingMaskIntoConstraints = false
        jiguangLoginButton.backgroundColor = UIColor(hex: 0xFFD700) // Yellow background
        jiguangLoginButton.layer.cornerRadius = cornerButtonRadius
        jiguangLoginButton.clipsToBounds = true  // 确保圆角生效
        jiguangLoginButton.isHidden = false  // 确保按钮可见
        jiguangLoginButton.alpha = 1.0  // 确保不透明
        
        // 创建手机图标 - 使用SF Symbols系统图标
        let phoneIcon = UIImageView()
        phoneIcon.contentMode = .scaleAspectFit
        if let iconImage = UIImage(systemName: "phone.fill") {
            phoneIcon.image = iconImage
            phoneIcon.tintColor = UIColor.black
        } else {
            // 如果系统图标不可用，创建一个简单的视图作为占位符
            phoneIcon.backgroundColor = UIColor.black
            phoneIcon.layer.cornerRadius = 2
        }
        jiguangLoginButton.addSubview(phoneIcon)
        phoneIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // 手机登录文字
        let loginText = UILabel()
        loginText.text = "手机登录"
        loginText.textColor = UIColor.black
        loginText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        loginText.textAlignment = .center
        loginText.numberOfLines = 1
        jiguangLoginButton.addSubview(loginText)
        loginText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            phoneIcon.topAnchor.constraint(equalTo: jiguangLoginButton.topAnchor, constant: 8),
            phoneIcon.centerXAnchor.constraint(equalTo: jiguangLoginButton.centerXAnchor),
            phoneIcon.widthAnchor.constraint(equalToConstant: 24),
            phoneIcon.heightAnchor.constraint(equalToConstant: 24),
            
            loginText.topAnchor.constraint(equalTo: phoneIcon.bottomAnchor, constant: 4),
            loginText.centerXAnchor.constraint(equalTo: jiguangLoginButton.centerXAnchor),
            loginText.leadingAnchor.constraint(greaterThanOrEqualTo: jiguangLoginButton.leadingAnchor, constant: 4),
            loginText.trailingAnchor.constraint(lessThanOrEqualTo: jiguangLoginButton.trailingAnchor, constant: -4),
            loginText.bottomAnchor.constraint(equalTo: jiguangLoginButton.bottomAnchor, constant: -8)
        ])
        
        // 添加点击事件
        jiguangLoginButton.addTarget(self, action: #selector(jiguangLoginTapped), for: .touchUpInside)
    }

    private func setupAppleButton() {
        socialContainer.addSubview(appleButton)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.backgroundColor = UIColor(hex: 0xFFD700) // Yellow background
        appleButton.layer.cornerRadius = cornerButtonRadius
        
        // Apple icon image
        let appleIcon = UIImageView(image: UIImage(named: "Apple"))
        appleIcon.contentMode = .scaleAspectFit
        appleIcon.tintColor = UIColor.black
        appleButton.addSubview(appleIcon)
        appleIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // Apple ID text
        let appleText = UILabel()
        appleText.text = "Apple ID"
        appleText.textColor = UIColor.black
        appleText.font = UIFont.systemFont(ofSize: 14)
        appleText.textAlignment = .center
        appleButton.addSubview(appleText)
        appleText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appleIcon.topAnchor.constraint(equalTo: appleButton.topAnchor, constant: 8),
            appleIcon.centerXAnchor.constraint(equalTo: appleButton.centerXAnchor),
            appleIcon.widthAnchor.constraint(equalToConstant: 28),
            appleIcon.heightAnchor.constraint(equalToConstant: 28),
            appleText.topAnchor.constraint(equalTo: appleIcon.bottomAnchor, constant: 4),
            appleText.centerXAnchor.constraint(equalTo: appleButton.centerXAnchor),
            appleText.bottomAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: -8)
        ])
        
        appleButton.addTarget(self, action: #selector(appleLoginTapped), for: .touchUpInside)
    }

    private func setupWeChatButton() {
        socialContainer.addSubview(wechatButton)
        wechatButton.translatesAutoresizingMaskIntoConstraints = false
        wechatButton.backgroundColor = UIColor(hex: 0xFFD700) // Yellow background
        wechatButton.layer.cornerRadius = cornerButtonRadius
        
        // WeChat icon image
        let wechatIcon = UIImageView(image: UIImage(named: "WeChat"))
        wechatIcon.contentMode = .scaleAspectFit
        wechatIcon.tintColor = UIColor.black
        wechatButton.addSubview(wechatIcon)
        wechatIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // WeChat text
        let wechatText = UILabel()
        wechatText.text = "WeChat"
        wechatText.textColor = UIColor.black
        wechatText.font = UIFont.systemFont(ofSize: 14)
        wechatText.textAlignment = .center
        wechatButton.addSubview(wechatText)
        wechatText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            wechatIcon.topAnchor.constraint(equalTo: wechatButton.topAnchor, constant: 8),
            wechatIcon.centerXAnchor.constraint(equalTo: wechatButton.centerXAnchor),
            wechatIcon.widthAnchor.constraint(equalToConstant: 28),
            wechatIcon.heightAnchor.constraint(equalToConstant: 28),
            wechatText.topAnchor.constraint(equalTo: wechatIcon.bottomAnchor, constant: 4),
            wechatText.centerXAnchor.constraint(equalTo: wechatButton.centerXAnchor),
            wechatText.bottomAnchor.constraint(equalTo: wechatButton.bottomAnchor, constant: -8)
        ])
        
        wechatButton.addTarget(self, action: #selector(wechatLoginTapped), for: .touchUpInside)
    }

    private func setupBottomContainer() {
        addSubview(bottomContainer)
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomContainer.topAnchor.constraint(equalTo: socialContainer.bottomAnchor, constant: 20),
            bottomContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupBackground() {
        addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: "Background")
        backgroundImageView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        sendSubviewToBack(backgroundImageView)
    }

    private func applyDiagonalStripes(to view: UIView) {
        let size = CGSize(width: 24, height: 24)
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            UIColor(hex: 0x1A1A1A).setFill() // Dark base
            ctx.fill(CGRect(origin: .zero, size: size))
            UIColor(hex: 0x2A2A2A).setFill() // Slightly lighter stripes
            ctx.cgContext.rotate(by: CGFloat.pi / 6) // Diagonal angle
            for i in stride(from: -60, through: 60, by: 8) {
                ctx.fill(CGRect(x: CGFloat(i), y: -20, width: 4, height: 60))
            }
        }
        view.backgroundColor = UIColor(patternImage: img)
    }

    // MARK: - 事件处理方法
    
    /// 切换用户同意状态
    /// - 更新复选框的视觉状态
    /// - 已勾选：显示勾选图标，黄色背景
    /// - 未勾选：清空图标，透明背景
    @objc private func toggleConsent() {
        isConsentChecked.toggle()
        checkBox.isSelected = isConsentChecked
    }
    
    /// 极光一键登录按钮点击事件
    /// 调用父视图控制器的极光登录方法
    @objc private func jiguangLoginTapped() {
        if let vc = owningViewController() {
            vc.loginWithJiguang { token, error in
                if let token = token {
                    print("极光登录成功，token: \(token)")
                    // 发送登录成功通知
                    NotificationCenter.default.post(name: Notification.Name("LoginSuccess"), object: nil)
                } else if let error = error {
                    print("极光登录失败: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Apple登录按钮点击事件
    /// 调用父视图控制器的Apple登录方法
    @objc private func appleLoginTapped() {
        if let vc = owningViewController() {
            vc.loginWithApple { token, error in
                print(token ?? "")  // 打印获取的token或空字符串
            }
        }
    }
    
    /// WeChat登录按钮点击事件
    /// 直接模拟微信登录成功并跳转到首页
    @objc private func wechatLoginTapped() {
        if let vc = owningViewController() {
            // 直接调用微信登录方法，模拟登录成功
            vc.loginWithWeChat { code, errCode, errStr in
                print("WeChat登录成功，授权码: \(code ?? "")")
            }
        }
    }

    /// 获取当前视图的父视图控制器
    /// 通过响应链向上查找UIViewController
    private func owningViewController() -> UIViewController? {
        var r: UIResponder? = self  // 从当前视图开始
        while let next = r?.next {
            if let vc = next as? UIViewController { return vc }  // 找到视图控制器
            r = next  // 继续向上查找
        }
        return nil  // 未找到
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "action://privacy" {
            print("Open Privacy Policy")
            return false
        } else if URL.absoluteString == "action://management" {
            print("Open Management")
            return false
        }
        return true
    }
}
