platform :ios, '12.0'



targets = ['JHGarage']

targets.each do |t|
  target t do
    
    # Pods for JHGarage
    inhibit_all_warnings!
#    use_frameworks!
    
    pod 'YYModel'
    pod 'YYCache'
    pod 'YYImage'
    pod 'YYWebImage'
    pod 'YYText'
    pod 'YYDispatchQueuePool'
    pod 'YYAsyncLayer'
    pod 'YYCategories'
    
    
    # 网络数据--
    pod 'AFNetworking', '~> 4.0.1', :subspecs => ['Reachability', 'Serialization', 'Security', 'NSURLSession']
    
    # 本地数据--
    
    # UI--
    # Basic
    
    pod 'SDWebImage'
    pod 'MBProgressHUD'
    pod 'Masonry'
    pod 'MJRefresh'
    pod 'Toast', '~> 4.0.0'
    pod 'MyLayout'
    
    # Table
    pod 'JHCellConfig', '2.2.0'
    
    # other
    pod 'IQKeyboardManager'
    
    # 工具--
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # some older pods don't support some architectures, anything over iOS 11 resolves that
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
