

Pod::Spec.new do |s|
s.name         = "JHGarage"
s.version      = "0.0.2"
s.summary      = "Personal Usage."
s.homepage     = "https://github.com/JC-Hu/JHGarage"
s.license      = "MIT"
s.author             = { "JC-Hu" => "jchu_dlcn@icloud.com" }\

s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/JC-Hu/JHGarage.git", :tag => s.version }
s.frameworks   =  'Foundation','UIKit'
s.requires_arc = true

# Pod Dependencies

s.dependency   'YYKit'
s.dependency   'BlocksKit'

# 网络数据--
s.dependency   'AFNetworking'

# UI--
# Basic
s.dependency   'SDWebImage'
s.dependency   'MBProgressHUD'
s.dependency   'Masonry'
s.dependency   'MJRefresh'
s.dependency   'Toast', '~> 4.0.0'
s.dependency   'SIAlertView'
s.dependency   'WZLBadge'
# Table
s.dependency   'JHCellConfig','~> 2.0.0'
# other
s.dependency   'IQKeyboardManager'
s.dependency   'NJKWebViewProgress'

# 工具--
s.dependency   'INTULocationManager'


s.source_files = 'src/**/*.{h,m,c,mm}'



end
