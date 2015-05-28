PACKAGE = "com.wenpkpk.ios.phone.SYSNAME"

Pod::Spec.new do |s|

  s.name         = "PoseidonMonitor"
  s.version      = "1.0.0"
  s.summary      = "PoseidonMonitor - PoseidonMonitor类库"

  s.description  = <<-DESC
                   * Detail about this framework.
                   DESC

  s.homepage     = "http://www.wenpkpk.com/PoseidonMonitor"
  s.license      = 'MIT (example)'
  s.author       = { "未定义" => "undefined@wenpkpk.com" }
  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'
  s.source       = { :http => "http://mvn.dev.wenpkpk.net:8081/artifactory/service/local/repositories/mobile/content/com/wenpkpk/ios/PoseidonMonitor/1.0.0/PoseidonMonitor-1.0.0-framework.zip" }
  s.preserve_paths = "PoseidonMonitor.framework/*"
  s.resources  = "PoseidonMonitor.framework/*.bundle"

  s.vendored_frameworks = 'PoseidonMonitor.framework'
  s.requires_arc = true
  s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/PoseidonMonitor' }

end
