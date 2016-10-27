# Uncomment this line to define a global platform for your project
# platform :ios, '7.0'

source 'https://github.com/CocoaPods/Specs.git'

xcodeproj 'edX.xcodeproj'

target 'edX' do
    pod 'Analytics', '~> 3.0.0'
    pod 'Segment-GoogleAnalytics', '~> 1.0.0'
    pod 'Crashlytics', '~> 3.2'
    pod 'DateTools', '~> 1.6.1'
    pod 'Fabric', '~> 1.5'
    pod 'GoogleSignIn', '~> 2.4'
    pod 'Masonry', '~> 0.6'
    pod 'NewRelicAgent', '~> 4.1'
    pod 'FBSDKCoreKit', '~> 4.6'
    pod 'FBSDKLoginKit', '~> 4.6'
    pod 'Parse', '~> 1.7'
    pod 'Smartling.i18n', '~> 1.0'
    if defined? ENV[OEX_REMOTE_CONFIG_POD_URL]
        pod 'OEXRemoteConfig', :git => ENV[OEX_REMOTE_CONFIG_POD_URL] 
    else
        pod 'OEXRemoteConfig', :git => "https://github.com/appsembler/edx-app-ios-config.git"
    end
end

target 'edXTests' do
    pod 'FBSnapshotTestCase/Core', '= 2.0.1'
    pod 'OCMock', '~> 3.1'
    pod 'OHHTTPStubs', '~> 4.0'
end 

