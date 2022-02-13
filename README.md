# **LottieUI**
It is a library developed to make Lottie easy to implement. It supports iOS and macOS.

[![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS-blue?style=flat-square)](https://developer.apple.com/macOS)
[![iOS](https://img.shields.io/badge/iOS-14.0-blue.svg)](https://developer.apple.com/iOS)
[![macOS](https://img.shields.io/badge/macOS-11.0-blue.svg)](https://developer.apple.com/macOS)
[![instagram](https://img.shields.io/badge/instagram-@dev.fabula-orange.svg?style=flat-square)](https://www.instagram.com/dev.fabula)
[![SPM](https://img.shields.io/badge/SPM-compatible-red?style=flat-square)](https://developer.apple.com/documentation/swift_packages/package/)
[![MIT](https://img.shields.io/badge/licenses-MIT-red.svg)](https://opensource.org/licenses/MIT)  

## Screenshot
https://user-images.githubusercontent.com/1617304/153740565-52e8fb67-c548-4124-a803-fa75c287cd6d.mp4

## Example
[https://fabulaapp.page.link/225](https://fabulaapp.page.link/225)

## Usages
1. LUStateData examples.
    ```swift
    /// Loads an animation model from a bundle by its name.
    let state1 = LUStateData(type: .name("bubble1"), loopMode: .loop)
    /// Loads a Lottie animation asynchronously from the URL.
    let state2 = LUStateData(type: .loadedFrom(URL(string: "https://assets9.lottiefiles.com/packages/lf20_mniampqn.json")!), speed: 1.0, loopMode: .loop)
    /// Loads an animation from a specific filepath.
    let state3 = LUStateData(type: .filepath("/Users/jasu/Downloads/bubble2.json"), speed: 1.0, loopMode: .loop)
    ```
    
3. How to use LottieView.
    ```swift
    /// 1
    LottieView(state: state1)
    ...
    /// 2
    LottieView(state: state1, onCompleted: { success in
        print("Completed")
    }, onDownloaded: { success in
        print("Downloaded")
    })
    ...
    /// 3
    VStack {
        LottieView(state: state1, value: value, onCompleted: { success in
            print("Completed")
        }, onDownloaded: { success in
            print("Downloaded")
        })
        Slider(value: $value, in: 0...1)
    }
    ```
## Swift Package Manager
The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler. Once you have your Swift package set up, adding LottieUI as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```swift
dependencies: [
    .package(url: "https://github.com/jasudev/LottieUI.git", .branch("main"))
]
```

## Contact
instagram : [@dev.fabula](https://www.instagram.com/dev.fabula)  
email : [dev.fabula@gmail.com](mailto:dev.fabula@gmail.com)

## License
LottieUI is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
