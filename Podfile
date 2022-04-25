# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

inhibit_all_warnings!

def rx_swift
    pod 'RxSwift', '~> 6.5.0'
end

def rx_cocoa
    pod 'RxCocoa', '~> 6.5.0'
end

target 'CleanArchitecture' do
  use_frameworks!

  rx_swift
  rx_cocoa
  pod 'QueryKit'

end

target 'Domain' do
  use_frameworks!

  rx_swift

end

target 'CoreDataPlatform' do
  use_frameworks!

  rx_swift
  pod 'QueryKit'

end
