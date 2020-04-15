**How to use the customized TwitterKit pod**
```
pod 'TwitterKit5'
```

**How to build and use the customized TwitterKit pod**
1. Build TwitterKit.zip. In the root folder of the project, run
```
./build.sh
```
2. Upload the TwitterKit.zip file somewhere and get a [URL](https://swarm-dev.s3.amazonaws.com/pods/twitterkit/ios/5.0.0/TwitterKit.zip) points to it.
3. Change your [podspec file](https://raw.githubusercontent.com/touren/twitter-kit-ios/Swift5/TwitterKit/TwitterKit.podspec) as:  s.source = { :http => "<URL created in step 2>" }
4. Change your Podfile as: `pod "TwitterKit"` ==> `pod "TwitterKit", :podspec => "<URL point to the podspec created in step 3>"`


**How to build and push to CocoaPods TwitterKit5**
1. Build TwitterKit.zip. In the root folder of the project, run
```
./build.sh
```
2. Release a new version in [GitHub](https://github.com/touren/twitter-kit-ios/releases), say 5.0.2, upload the TwitterKit.zip just built.
3. Update TwitterKit5.podspec, make sure `s.version` and `s.source` is correct.
4. Deploy to [CocoaPods Trunk](https://guides.cocoapods.org/making/getting-setup-with-trunk.html)
```
pod trunk push TwitterKit5.podspec
```

----

**Twitter will be discontinuing support for Twitter Kit on October 31, 2018. [Read the blog post here](https://blog.twitter.com/developer/en_us/topics/tools/2018/discontinuing-support-for-twitter-kit-sdk.html).**

# Twitter Kit for iOS

## Background

Twitter Kit is a native SDK to include Twitter content in mobile apps. Twitter Kit is designed to make interacting with Twitter seamless and efficient.

Using Twitter Kit from source in production applications is not officially supported. Please utilize the official binaries released via [CocoaPods](https://cocoapods.org/pods/TwitterKit) or [Carthage](https://github.com/Carthage/Carthage).

## Twitter Kit Features

* Display Tweets and timelines
  * Native views to display Tweets in alignment with Twitter's display guidelines.
  * Timeline adapters for displaying collections, lists, and profile timelines from the Twitter API
  * Search result timelines using the Search API, with additional client-side filter capability
* Compose Tweets
  * Share Tweets with text, URLs, photos and video.
  * Automatically handles API access and login for quick sharing.
* Monetize with MoPub integration
  * Easy integration of MoPub's display ads tools with Twitter content.
* Log in with Twitter
  * Authorize users, using the Twitter accounts already on their phone.
  * Support for requesting email address
* Access the Twitter API
  * API client for all interactions with the Twitter API.

## Components of Twitter Kit iOS

* TwitterCore
  * Network calls are handled
* TwitterKit
  * Tweet display
* TwitterShareExtensionUI
  * Tweet composer 

## Installation

### Get started

* Generate your Twitter API keys through the [Twitter developer apps dashboard](https://apps.twitter.com/).
* Install Twitter Kit using instructions below.
* For extensive documentation, please see the official [documentation](https://github.com/twitter/twitter-kit-ios/wiki).
	
### Install using Cocoapods

To add Twitter Kit to your app, simply add `TwitterKit` to your Podfile.

```ruby
target 'MyApp' do
  use_frameworks!
  pod 'TwitterKit'
end
```

### Install using Carthage

To install Twitter Kit for iOS using Carthage, add the following lines to your Cartfile. For more information about how to set up Carthage and your Cartfile, see [here](https://github.com/Carthage/Carthage).

```swift
binary "https://ton.twimg.com/syndication/twitterkit/ios/TwitterKit.json"
binary "https://ton.twimg.com/syndication/twitterkit/ios/TwitterCore.json"
```

After running `carthage update`, add `TwitterKit.framework` and `TwitterShareExtensionUI.framework` to the `Linked Frameworks and Binaries` section under General of your App target. In addition to that, make sure that when you are adding the copy-frameworks run script for Carthage that you add the following input paths: 

```swift
$(SRCROOT)/Carthage/Build/iOS/TwitterCore.framework
$(SRCROOT)/Carthage/Build/iOS/TwitterKit.framework
$(SRCROOT)/Carthage/Build/iOS/TwitterShareExtensionUI.framework
```

Make sure that the run script phase is after your Link Binaries with Libraries phase to prevent issues with properly archiving your iOS application.

### Preview Twitter Kit Features in the Demo App

Twitter Kit includes a demonstration app allowing you to preview features, and verify functionality. Create Twitter API keys as above, and then:

* To check out a demo app with features already built in, rename `DemoApp/Config.xcconfig.sample` to `DemoApp/Config.xcconfig` and populate the consumer key and secret.
* Run `DemoApp.xcworkspace` on Xcode to verify build.

## Code of conduct

This, and all github.com/twitter projects, are under the [Twitter Open Source Code of Conduct](https://github.com/twitter/code-of-conduct/blob/master/code-of-conduct.md). Additionally, see the [Typelevel Code of Conduct](http://typelevel.org/conduct) for specific examples of harassing behavior that are not tolerated.

## Contribution

The master branch of this repository contains the latest stable release of Twitter Kit.

Twitter Kit can be used as a dependency for substantial other work, and we welcome fixes and enhancements to the core libraries as well. See [CONTRIBUTING.md](https://github.com/twitter/twitter-kit-ios/blob/master/CONTRIBUTING.md) for more details about how to contribute.

## Contact

For usage questions post on [Twitter Community](https://twittercommunity.com/tags/c/publisher/twitter/ios).
Please report any bugs as [issues](https://github.com/twitter/twitter-kit-ios/issues).
Follow [@TwitterDev](http://twitter.com/twitterdev) on Twitter for updates.

## License

Copyright 2017 Twitter, Inc.
Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
