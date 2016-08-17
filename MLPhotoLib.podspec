
Pod::Spec.new do |s|

s.name         = "MLPhotoLib"
s.version      = "0.1.0"
s.summary      = "A New PhotoLib, Compatible with iOS7+, Simple, lightweight."

s.description  = <<-DESC
The PhotoKit package, so that the use of more simple, provides more pictures, more video preview, fast and easy to use features
DESC

s.homepage     = "https://github.com/MakeZL/MLPhotoLib"

s.license      = { :type => "MIT", :file => "LICENSE" }

s.author             = { "Leo" => "120886865@qq.com" }
s.social_media_url   = "http://weibo.com/MakeZL"

s.platform     = :ios, "8.0"
s.ios.deployment_target = "8.0"

s.source       = { :git => "https://github.com/MakeZL/MLPhotoLib.git", :tag => s.version }

s.source_files  = "MLPhotoLib/MLPhotoPicker/*.{h,m}"
s.resource = "MLPhotoLib/MLImagePickerController.bundle"

s.requires_arc = true
s.framework = "Photos","AssetsLibrary"

end
