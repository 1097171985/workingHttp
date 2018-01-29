Pod::Spec.new do |spec|
spec.name         = 'XWNetworking'
spec.version      = '0.0.2'
spec.license      = { :type => "MIT", :file => "LICENSE" }
spec.homepage     = 'https://github.com/1097171985/workingHttp'
spec.authors      = { '1097171985' => '1097171985@qq.com' }
spec.summary      = 'ARC and GCD Compatible Reachability Class for iOS and OS X.'
spec.source       = { :git => 'https://github.com/1097171985/workingHttp.git', :tag =>'0.0.2'  }
spec.platform     = :ios, '9.0'
spec.source_files = 'XWNetworking/XWNetworking/**/*.{h,m}'
#spec.frameworks   = 'UIKit','AVFoundation','Foundation'
spec.requires_arc = true
spec.dependency 'AFNetworking', '~> 3.0.4'

end
