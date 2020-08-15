

Pod::Spec.new do |s|
s.name         = "JHGarage"
s.version      = "0.0.2"
s.summary      = "Personal Usage."
s.homepage     = "https://github.com/JC-Hu/JHGarage"
s.license      = "MIT"
s.author             = { "JC-Hu" => "jchu_dlcn@icloud.com" }\

s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/JC-Hu/JHGarage.git", :tag => s.version }
s.frameworks   =  'Foundation','UIKit'
s.requires_arc = true



# Pod Dependencies

s.dependency   'JRSwizzle'
s.dependency   'BlocksKit'
s.dependency   'YYModel'
s.dependency   'YYCache'
s.dependency   'YYImage'
s.dependency   'YYWebImage'
s.dependency   'YYText'
s.dependency   'YYDispatchQueuePool'
s.dependency   'YYAsyncLayer'

# 网络数据--
s.dependency   'AFNetworking','~> 3.2.1'

# UI--
# Basic
s.dependency   'SDWebImage'
s.dependency   'MBProgressHUD'
s.dependency   'Masonry'
s.dependency   'MJRefresh'
s.dependency   'Toast', '~> 4.0.0'
# Table
s.dependency   'JHCellConfig', '~> 2.1.0'
# other
s.dependency   'IQKeyboardManager'
s.dependency   'NJKWebViewProgress'
s.dependency   'SIAlertView'
s.dependency   'WZLBadge'
# s.dependency   'ActionSheetPicker-3.0'

# 工具--
s.dependency   'INTULocationManager', '~> 4.3.2'

s.source_files = 'src/**/*.{h,m,c,mm}'



end
