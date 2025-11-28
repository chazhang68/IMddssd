platform :ios, '15'
use_frameworks!

target '蓝牙指环' do
  # BCLRingSDK 主依赖
  pod 'SwiftyBeaver', '~> 1.9'
  pod 'ZIPFoundation', '0.9.19'
  
  # BCLRingSDK 附加依赖
  pod 'Foil'
  pod 'NordicDFU'
  pod 'RxSwift'
  pod 'RxRelay'
  pod 'SwiftDate'
  
  # 暂时禁用第三方库，专注于核心功能
  # pod 'WechatOpenSDK'
  # pod 'GoogleSignIn'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # 确保所有 Pods 的部署目标至少是 13.4
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 13.4
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.4'
      end
    end
  end
end
