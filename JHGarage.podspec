

Pod::Spec.new do |s|
s.name         = "JHGarage"
s.version      = "0.0.1"
s.summary      = "Personal Usage."
s.homepage     = "https://github.com/JC-Hu/JHGarage"
s.license      = "MIT"
s.author             = { "JC-Hu" => "jchu_dlcn@icloud.com" }\

s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/JC-Hu/JHGarage.git", :tag => s.version }
s.frameworks   =  'Foundation','UIKit'
s.requires_arc = true

# Pod Dependencies
#s.dependency   'AFNetworking',
#s.dependency   'SDWebImage'
#s.dependency   'JHCellConfig'
#s.dependency   'Masonry'

s.source_files = 'src/**/*.{h,m,c,mm}'

end
