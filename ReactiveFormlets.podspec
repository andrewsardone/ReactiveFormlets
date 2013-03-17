Pod::Spec.new do |s|
  s.name         = "ReactiveFormlets"
  s.version      = "0.90"
  s.summary      = "A framework for building iOS forms compositionally and reactively."
  s.homepage     = "https://github.com/jonsterling/ReactiveFormlets"
  s.author       = { "Jon Sterling" => "jonsterling@me.com" }
  s.source       = { :git => "https://github.com/jonsterling/ReactiveFormlets.git", :tag => "v#{s.version}" }
  s.license      = 'Simplified BSD License'
  s.description  = "ReactiveFormlets is an API for building forms compositionally with an Applicative-style interface."

  s.requires_arc = true
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.compiler_flags = '-DOS_OBJECT_USE_OBJC=0'

  s.subspec 'Core' do |sp|
    sp.ios.source_files = FileList['ReactiveFormlets/*.{h,m}']
    sp.header_dir = 'ReactiveFormlets'

    sp.dependency 'ReactiveCocoa', '~> 1.3.1'
  end
end
