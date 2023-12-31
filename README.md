# Turbo Native Initializer

A turbo native project generator for iOS and Android.

## Differences when compared to the demos

- Added SwiftUI error screen. (iOS)
- Added SwiftUI numbers example screen. (iOS)
- Added Jetpack Compose numbers example screen. (Android)
- Added UIAlertController to handle `data-turbo-confirm`. (iOS)
- Added presentations `back`, `refresh`, `none`, `replace`, `clear-all`, and `replace-all`. (iOS)
- Added `visitable` property in order to avoid visits. (iOS)
- Added support for tab navigation. (iOS/Android)
- Added support for flash messages. (iOS/Android)
- Integrated with the gem [strada-rails](https://github.com/lazaronixon/strada-rails).

## Installation

```
$ gem install turbo-native-initializer
```

## Quick Start

iOS (Xcode is required)

```
$ turbo-native-initializer AwesomeProject --platform=ios
$ cd AwesomeProject
$ xed .
```

Android (Android Studio is required)

To be able to open projects from terminal, open Android Studio and click on `Tools -> Create Command-line Launcher...`.

```
$ turbo-native-initializer AwesomeProject --platform=android
$ cd AwesomeProject
$ studio .
```

## Usage

```
Usage:
  turbo-native-initializer NAME --platform=PLATFORM

Options:
  --platform=PLATFORM        
                             # Possible values: ios, android
  [--navigation=NAVIGATION]  
                             # Default: stack
                             # Possible values: stack, tabs
  [--package=PACKAGE]        
                             # Default: dev.hotwire.turbo
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment, you can run something like `TurboNativeInitializer::Generator.start(["TurboNativeProject", "--platform=ios", "--navigation=stack"])`.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lazaronixon/turbo-native-initializer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/lazaronixon/turbo-native-initializer/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TurboNativeInitializer project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/turbo-native-initializer/blob/master/CODE_OF_CONDUCT.md).
