platform :ios, '11.0'

target 'CompanyManagerUnitTests' do
  use_frameworks!

  pod 'Unicorns'
  pod 'IQKeyboardManagerSwift'
  pod 'AlamofireImage'
  pod 'Firebase/Core'

  target 'CompanyManagerUnitTestsTests' do
    inherit! :search_paths
  	pod 'Unicorns'
  end

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end