

Pod::Spec.new do |s|
s.name         = "JHGarage"
s.version      = "0.1.0"
s.summary      = "Personal Usage."
s.homepage     = "https://github.com/JC-Hu/JHGarage"
s.license      = "MIT"
s.author             = { "JC-Hu" => "jchu_dlcn@icloud.com" }\

s.platform     = :ios, "10.0"
s.source       = { :git => "https://github.com/JC-Hu/JHGarage.git", :tag => s.version }
s.frameworks   =  'Foundation','UIKit'
s.requires_arc = true

s.source_files = 'src/**/*.{h,m,c,mm}'
s.resources     = ['src/**/*.{bundle,plist,xib,storyboard}']
s.vendored_frameworks = 'src/**/*.framework'
s.vendored_libraries = 'src/**/*.a'
#s.prefix_header_file = 'src/JHGaragePrefix.pch'

s.subspec 'Data' do |ss|
ss.source_files = 'src/Data/**/*.{h,m,c,mm}'
end

s.subspec 'Other' do |ss|
ss.source_files = 'src/Other/**/*.{h,m,c,mm}'
end

s.subspec 'UI' do |ss|
ss.source_files = 'src/UI/**/*.{h,m,c,mm}'
end

s.subspec 'UtilityTools' do |ss|
ss.source_files = 'src/UtilityTools/**/*.{h,m,c,mm}'
end


# Pod Dependencies

s.dependency   'YYModel'
s.dependency   'YYCache'
s.dependency   'YYImage'
s.dependency   'YYWebImage'
s.dependency   'YYText'
s.dependency   'YYDispatchQueuePool'
s.dependency   'YYAsyncLayer'
s.dependency   'YYCategories'

# 网络数据--
s.dependency 'AFNetworking/Reachability', '~> 4.0.1'
s.dependency 'AFNetworking/Serialization', '~> 4.0.1'
s.dependency 'AFNetworking/Security', '~> 4.0.1'
s.dependency 'AFNetworking/NSURLSession', '~> 4.0.1'

# UI--
# Basic
s.dependency   'SDWebImage'
s.dependency   'MBProgressHUD'
s.dependency   'Masonry'
s.dependency   'MJRefresh'
s.dependency   'Toast', '~> 4.0.0'

# Table
s.dependency   'JHCellConfig'

# other
s.dependency   'IQKeyboardManager'




end
