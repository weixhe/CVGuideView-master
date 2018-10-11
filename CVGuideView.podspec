Pod::Spec.new do |s|
s.name         = 'CVGuideView'
s.version      = '1.0.0'
s.summary      = 'app引导页'
s.homepage     = 'https://github.com/weixhe/CVGuideView-master'
s.license      = 'MIT'
s.authors      = {'weixhe' => '1124592402@qq.com'}
s.platform     = :ios, '6.0'
s.source       = {:git => 'https://github.com/weixhe/CVGuideView-master.git', :tag => s.version}
s.source_files = 'KPLBlocks/**/*'
s.requires_arc = true
end