import UIKit

/// 登录视图 - 完整的用户登录界面
/// 包含顶部品牌区域、用户协议区域和第三方登录按钮区域
class LoginView: UIView {
    // MARK: - UI组件定义
    
    /// 顶部容器 - 包含品牌标题和Logo
    let topContainer = UIView()
    
    /// 欢迎标题标签 - 显示"Welcome to"
    let titleLabel = UILabel()
    
    /// 品牌名称标签 - 显示"SKYEAGLE"
    let brandLabel = UILabel()
    
    /// Logo视图 - 圆形Logo容器，包含Y形徽章
    let logoView = UIView() // Circular logo
    
    /// 用户协议容器 - 包含复选框和协议文本
    let consentContainer = UIView()
    
    /// 同意复选框 - 用户勾选同意协议
    let checkBox = UIButton(type: .system)
    
    /// 协议说明标签 - 显示"I have read and agree to the"
    let consentLabel = UILabel()
    
    /// 隐私政策按钮 - 链接到隐私政策页面
    let privacyButton = UIButton(type: .system)
    
    /// 管理按钮 - 链接到管理页面
    let managementButton = UIButton(type: .system)
    
    /// 社交登录容器 - 包含Google、Apple、WeChat登录按钮
    let socialContainer = UIView()
    
    /// Google登录按钮 - 黄色背景，黑色图标和文字
    let googleButton = UIButton(type: .system)
    
    /// Apple登录按钮 - 黄色背景，黑色图标和文字
    let appleButton = UIButton(type: .system)
    
    /// WeChat登录按钮 - 黄色背景，黑色图标和文字
    let wechatButton = UIButton(type: .system)
    
    /// 底部容器 - 用于显示对角线条纹背景
    let bottomContainer = UIView()
    
    /// 用户同意状态 - 记录用户是否勾选同意协议
    var isConsentChecked = false

    // MARK: - 初始化方法
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0xFFD700) // 明亮黄色背景
        setupTopContainer()      // 配置顶部容器
        setupHeaderTexts()       // 配置标题和品牌文字
        setupLogo()              // 配置Logo和徽章
        setupConsentSection()    // 配置用户协议区域
        setupSocialButtons()     // 配置社交登录按钮
        setupBottomContainer()   // 配置底部容器
        applyDiagonalStripes(to: bottomContainer)  // 应用对角线条纹背景
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
            topContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            topContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65) // 调整高度适配社交登录
        ])
        topContainer.backgroundColor = UIColor(hex: 0xFFD700) // 明亮黄色背景
        topContainer.layer.cornerRadius = 32 // 大圆角底部边框
        topContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]  // 仅底部左右圆角
    }

    /// 配置标题和品牌文字
    /// - 设置"Welcome to"标题（28pt粗体黑色）
    /// - 设置"SKYEAGLE"品牌名（40pt特粗，深橄榄色）
    /// - 添加多层阴影效果增强3D视觉
    private func setupHeaderTexts() {
        topContainer.addSubview(titleLabel)
        topContainer.addSubview(brandLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 欢迎标题配置
        titleLabel.text = "Welcome to"
        titleLabel.textColor = UIColor.black  // 黑色文字
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)  // 28pt粗体
        titleLabel.textAlignment = .center  // 居中对齐
        
        // 品牌名称配置
        brandLabel.text = "SKYEAGLE"
        brandLabel.textColor = UIColor(hex: 0x6B5B00) // 深橄榄/棕色
        brandLabel.font = UIFont.systemFont(ofSize: 40, weight: .heavy)  // 40pt特粗
        brandLabel.textAlignment = .center  // 居中对齐
        
        // 添加分层3D阴影效果
        brandLabel.layer.shadowColor = UIColor(hex: 0x6B5B00).cgColor
        brandLabel.layer.shadowOffset = CGSize(width: 2, height: 2)  // 阴影偏移
        brandLabel.layer.shadowOpacity = 0.4  // 40%透明度
        brandLabel.layer.shadowRadius = 2  // 阴影半径2pt
        
        // 添加多层标签副本创建深度效果
        let shadowLabel1 = UILabel()
        shadowLabel1.text = "SKYEAGLE"
        shadowLabel1.textColor = UIColor(hex: 0x6B5B00).withAlphaComponent(0.3)  // 30%透明度
        shadowLabel1.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        shadowLabel1.textAlignment = .center
        shadowLabel1.alpha = 0.3
        shadowLabel1.transform = CGAffineTransform(translationX: 2, y: 2)  // 偏移2pt
        topContainer.addSubview(shadowLabel1)
        shadowLabel1.translatesAutoresizingMaskIntoConstraints = false
        
        let shadowLabel2 = UILabel()
        shadowLabel2.text = "SKYEAGLE"
        shadowLabel2.textColor = UIColor(hex: 0x6B5B00).withAlphaComponent(0.2)  // 20%透明度
        shadowLabel2.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        shadowLabel2.textAlignment = .center
        shadowLabel2.alpha = 0.2
        shadowLabel2.transform = CGAffineTransform(translationX: 4, y: 4)  // 偏移4pt
        topContainer.addSubview(shadowLabel2)
        shadowLabel2.translatesAutoresizingMaskIntoConstraints = false
        
        // 设置约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 80), // 更多间距
            titleLabel.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
            brandLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            brandLabel.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
            shadowLabel1.topAnchor.constraint(equalTo: brandLabel.topAnchor),
            shadowLabel1.centerXAnchor.constraint(equalTo: brandLabel.centerXAnchor, constant: 2),
            shadowLabel2.topAnchor.constraint(equalTo: brandLabel.topAnchor),
            shadowLabel2.centerXAnchor.constraint(equalTo: brandLabel.centerXAnchor, constant: 4)
        ])
    }

    /// 配置Logo视图
    /// - 创建50x50pt的圆形黑色背景
    /// - 添加Y形金色徽章（翅膀形状）
    /// - 定位在品牌文字右下方
    private func setupLogo() {
        topContainer.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.backgroundColor = UIColor.black  // 黑色背景
        logoView.layer.cornerRadius = 25 // 圆形Logo（50pt直径）
        
        // 添加Y形徽章（翅膀/鹰形状）
        let emblemLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 20, y: 15))    // 起点：左上
        path.addLine(to: CGPoint(x: 25, y: 25))  // 中线向下
        path.addLine(to: CGPoint(x: 30, y: 15))  // 右上
        path.addLine(to: CGPoint(x: 25, y: 35))  // 底部中心
        path.close()  // 闭合路径形成Y形
        emblemLayer.path = path.cgPath
        emblemLayer.fillColor = UIColor(hex: 0xFFD700).cgColor // 金色填充
        emblemLayer.strokeColor = UIColor(hex: 0xFFD700).cgColor // 金色描边
        emblemLayer.lineWidth = 1  // 描边宽度1pt
        logoView.layer.addSublayer(emblemLayer)
        
        // 设置Logo位置和尺寸
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 30),  // 品牌文字下方30pt
            logoView.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -30),  // 右侧30pt
            logoView.widthAnchor.constraint(equalToConstant: 50),  // 宽度50pt
            logoView.heightAnchor.constraint(equalToConstant: 50)  // 高度50pt
        ])
    }

    private func setupConsentSection() {
        addSubview(consentContainer)
        consentContainer.translatesAutoresizingMaskIntoConstraints = false
        consentContainer.backgroundColor = .clear
        
        // Checkbox
        consentContainer.addSubview(checkBox)
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.layer.borderWidth = 2
        checkBox.layer.borderColor = UIColor.white.cgColor
        checkBox.layer.cornerRadius = 12
        checkBox.backgroundColor = .clear
        checkBox.addTarget(self, action: #selector(toggleConsent), for: .touchUpInside)
        checkBox.contentMode = .center
        
        // Consent text
        consentLabel.translatesAutoresizingMaskIntoConstraints = false
        consentLabel.text = "I have read and agree to the"
        consentLabel.textColor = UIColor(white: 0.7, alpha: 1.0) // Grey text
        consentLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        consentLabel.numberOfLines = 0
        consentContainer.addSubview(consentLabel)
        
        // Privacy Policy button
        privacyButton.translatesAutoresizingMaskIntoConstraints = false
        privacyButton.setTitle("Privacy Policy", for: .normal)
        privacyButton.setTitleColor(UIColor(hex: 0xFFD700), for: .normal) // Yellow text
        privacyButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        privacyButton.contentHorizontalAlignment = .left
        consentContainer.addSubview(privacyButton)
        
        // Management button
        managementButton.translatesAutoresizingMaskIntoConstraints = false
        managementButton.setTitle("Management", for: .normal)
        managementButton.setTitleColor(UIColor(hex: 0xFFD700), for: .normal) // Yellow text
        managementButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        managementButton.contentHorizontalAlignment = .left
        consentContainer.addSubview(managementButton)
        
        NSLayoutConstraint.activate([
            consentContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 30),
            consentContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            consentContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            checkBox.leadingAnchor.constraint(equalTo: consentContainer.leadingAnchor),
            checkBox.topAnchor.constraint(equalTo: consentContainer.topAnchor),
            checkBox.widthAnchor.constraint(equalToConstant: 24),
            checkBox.heightAnchor.constraint(equalToConstant: 24),
            
            consentLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 12),
            consentLabel.topAnchor.constraint(equalTo: consentContainer.topAnchor),
            consentLabel.trailingAnchor.constraint(equalTo: consentContainer.trailingAnchor),
            
            privacyButton.leadingAnchor.constraint(equalTo: consentLabel.leadingAnchor),
            privacyButton.topAnchor.constraint(equalTo: consentLabel.bottomAnchor, constant: 2),
            
            managementButton.leadingAnchor.constraint(equalTo: privacyButton.leadingAnchor),
            managementButton.topAnchor.constraint(equalTo: privacyButton.bottomAnchor, constant: 2),
            
            consentContainer.bottomAnchor.constraint(equalTo: managementButton.bottomAnchor)
        ])
    }

    private func setupSocialButtons() {
        addSubview(socialContainer)
        socialContainer.translatesAutoresizingMaskIntoConstraints = false
        socialContainer.backgroundColor = .clear
        
        // Google Button
        setupGoogleButton()
        
        // Apple Button
        setupAppleButton()
        
        // WeChat Button
        setupWeChatButton()
        
        NSLayoutConstraint.activate([
            socialContainer.topAnchor.constraint(equalTo: consentContainer.bottomAnchor, constant: 30),
            socialContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            socialContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            googleButton.leadingAnchor.constraint(equalTo: socialContainer.leadingAnchor),
            googleButton.topAnchor.constraint(equalTo: socialContainer.topAnchor),
            googleButton.trailingAnchor.constraint(equalTo: appleButton.leadingAnchor, constant: -15),
            
            appleButton.topAnchor.constraint(equalTo: socialContainer.topAnchor),
            appleButton.centerXAnchor.constraint(equalTo: socialContainer.centerXAnchor),
            appleButton.widthAnchor.constraint(equalTo: googleButton.widthAnchor),
            
            wechatButton.topAnchor.constraint(equalTo: socialContainer.topAnchor),
            wechatButton.leadingAnchor.constraint(equalTo: appleButton.trailingAnchor, constant: 15),
            wechatButton.trailingAnchor.constraint(equalTo: socialContainer.trailingAnchor),
            wechatButton.widthAnchor.constraint(equalTo: googleButton.widthAnchor),
            
            socialContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupGoogleButton() {
        socialContainer.addSubview(googleButton)
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.backgroundColor = UIColor(hex: 0xFFD700) // Yellow background
        googleButton.layer.cornerRadius = 16
        
        // Google icon image
        let googleIcon = UIImageView(image: UIImage(named: "Google"))
        googleIcon.contentMode = .scaleAspectFit
        googleIcon.tintColor = UIColor.black
        googleButton.addSubview(googleIcon)
        googleIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // Google text
        let googleText = UILabel()
        googleText.text = "Google"
        googleText.textColor = UIColor.black
        googleText.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        googleText.textAlignment = .center
        googleButton.addSubview(googleText)
        googleText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            googleIcon.topAnchor.constraint(equalTo: googleButton.topAnchor, constant: 8),
            googleIcon.centerXAnchor.constraint(equalTo: googleButton.centerXAnchor),
            googleIcon.widthAnchor.constraint(equalToConstant: 28),
            googleIcon.heightAnchor.constraint(equalToConstant: 28),
            googleText.topAnchor.constraint(equalTo: googleIcon.bottomAnchor, constant: 4),
            googleText.centerXAnchor.constraint(equalTo: googleButton.centerXAnchor),
            googleText.bottomAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: -8)
        ])
        
        googleButton.addTarget(self, action: #selector(googleLoginTapped), for: .touchUpInside)
    }

    private func setupAppleButton() {
        socialContainer.addSubview(appleButton)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.backgroundColor = UIColor(hex: 0xFFD700) // Yellow background
        appleButton.layer.cornerRadius = 16
        
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
        appleText.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
        wechatButton.layer.cornerRadius = 16
        
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
        wechatText.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
        isConsentChecked.toggle()  // 切换状态
        if isConsentChecked {
            // 已勾选状态
            checkBox.setImage(UIImage(named: "check"), for: .normal)  // 显示勾选图标
            checkBox.tintColor = UIColor.black  // 黑色图标
            checkBox.backgroundColor = UIColor(hex: 0xFFD700)  // 黄色背景
        } else {
            // 未勾选状态
            checkBox.setImage(nil, for: .normal)  // 清空图标
            checkBox.backgroundColor = .clear  // 透明背景
        }
        // 更新边框颜色
        checkBox.layer.borderColor = isConsentChecked ? UIColor(hex: 0xFFD700).cgColor : UIColor.white.cgColor
    }
    
    /// Google登录按钮点击事件
    /// 目前仅打印调试信息，需要后续实现具体登录逻辑
    @objc private func googleLoginTapped() {
        print("Google login tapped")  // 调试输出
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
}