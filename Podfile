platform :ios, '11.0'
use_frameworks!

target 'WeatherApp' do
    pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift', :branch => 'master'
    pod 'RxCoreLocation'
    pod 'RxDataSources'
    pod 'RxSwift'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
      config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = "YES"
      config.build_settings['LD_NO_PIE'] = 'NO'
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
    end
  end

  installer.pods_project.build_configurations.each do |config|
    config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
    config.build_settings['CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED'] = 'YES'
    config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = "YES"
  end
  installer.pods_project.root_object.known_regions = ["Base", "en"]
  installer.pods_project.root_object.development_region = "en"
end
