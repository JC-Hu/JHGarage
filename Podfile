platform :ios, '12.0'



targets = ['JHGarage']

targets.each do |t|
  target t do
    
    inhibit_all_warnings!
    use_frameworks!
    
    
    #本地pod
    pod 'JHGarage', :path => './'
    
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
