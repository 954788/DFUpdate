Pod::Spec.new do |s|
s.name = 'DFUpdate'
s.version = '1.0.1'
s.license = 'MIT'
s.summary = 'A simple update'
s.homepage = 'https://github.com/954788/DFUpdate'
s.authors = { '954788' => '569676974@qq.com' }
s.source = { :git => "https://github.com/954788/DFUpdate.git", :tag => "1.0.1"}
s.requires_arc = true
s.ios.deployment_target = '7.0'
s.source_files = "DFUpdate", "*.{h,m}"
end