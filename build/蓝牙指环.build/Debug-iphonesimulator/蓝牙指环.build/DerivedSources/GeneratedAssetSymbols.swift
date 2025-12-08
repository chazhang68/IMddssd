import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "Apple" asset catalog image resource.
    static let apple = ImageResource(name: "Apple", bundle: resourceBundle)

    /// The "Background" asset catalog image resource.
    static let background = ImageResource(name: "Background", bundle: resourceBundle)

    /// The "Google" asset catalog image resource.
    static let google = ImageResource(name: "Google", bundle: resourceBundle)

    /// The "Know-you-pro-n" asset catalog image resource.
    static let knowYouProN = ImageResource(name: "Know-you-pro-n", bundle: resourceBundle)

    /// The "Know-you-pro-s" asset catalog image resource.
    static let knowYouProS = ImageResource(name: "Know-you-pro-s", bundle: resourceBundle)

    /// The "MT-AI-Glasses-n" asset catalog image resource.
    static let mtAIGlassesN = ImageResource(name: "MT-AI-Glasses-n", bundle: resourceBundle)

    /// The "MT-AI-Glasses-s" asset catalog image resource.
    static let mtAIGlassesS = ImageResource(name: "MT-AI-Glasses-s", bundle: resourceBundle)

    /// The "SpO₂" asset catalog image resource.
    static let spO₂ = ImageResource(name: "SpO₂", bundle: resourceBundle)

    /// The "SplashIcon" asset catalog image resource.
    static let splashIcon = ImageResource(name: "SplashIcon", bundle: resourceBundle)

    /// The "WeChat" asset catalog image resource.
    static let weChat = ImageResource(name: "WeChat", bundle: resourceBundle)

    /// The "Welcome" asset catalog image resource.
    static let welcome = ImageResource(name: "Welcome", bundle: resourceBundle)

    /// The "add" asset catalog image resource.
    static let add = ImageResource(name: "add", bundle: resourceBundle)

    /// The "anxiety" asset catalog image resource.
    static let anxiety = ImageResource(name: "anxiety", bundle: resourceBundle)

    /// The "blood" asset catalog image resource.
    static let blood = ImageResource(name: "blood", bundle: resourceBundle)

    /// The "blood 1" asset catalog image resource.
    static let blood1 = ImageResource(name: "blood 1", bundle: resourceBundle)

    /// The "blood-pressure" asset catalog image resource.
    static let bloodPressure = ImageResource(name: "blood-pressure", bundle: resourceBundle)

    /// The "calendar" asset catalog image resource.
    static let calendar = ImageResource(name: "calendar", bundle: resourceBundle)

    /// The "calm" asset catalog image resource.
    static let calm = ImageResource(name: "calm", bundle: resourceBundle)

    /// The "cardiovascular" asset catalog image resource.
    static let cardiovascular = ImageResource(name: "cardiovascular", bundle: resourceBundle)

    /// The "check" asset catalog image resource.
    static let check = ImageResource(name: "check", bundle: resourceBundle)

    /// The "codale" asset catalog image resource.
    static let codale = ImageResource(name: "codale", bundle: resourceBundle)

    /// The "earphones" asset catalog image resource.
    static let earphones = ImageResource(name: "earphones", bundle: resourceBundle)

    /// The "earphones2" asset catalog image resource.
    static let earphones2 = ImageResource(name: "earphones2", bundle: resourceBundle)

    /// The "eye" asset catalog image resource.
    static let eye = ImageResource(name: "eye", bundle: resourceBundle)

    /// The "game" asset catalog image resource.
    static let game = ImageResource(name: "game", bundle: resourceBundle)

    /// The "glasses" asset catalog image resource.
    static let glasses = ImageResource(name: "glasses", bundle: resourceBundle)

    /// The "heermeng" asset catalog image resource.
    static let heermeng = ImageResource(name: "heermeng", bundle: resourceBundle)

    /// The "k-up" asset catalog image resource.
    static let kUp = ImageResource(name: "k-up", bundle: resourceBundle)

    /// The "light" asset catalog image resource.
    static let light = ImageResource(name: "light", bundle: resourceBundle)

    /// The "love" asset catalog image resource.
    static let love = ImageResource(name: "love", bundle: resourceBundle)

    /// The "love(1)" asset catalog image resource.
    static let love1 = ImageResource(name: "love(1)", bundle: resourceBundle)

    /// The "power" asset catalog image resource.
    static let power = ImageResource(name: "power", bundle: resourceBundle)

    /// The "ring" asset catalog image resource.
    static let ring = ImageResource(name: "ring", bundle: resourceBundle)

    /// The "sleep" asset catalog image resource.
    static let sleep = ImageResource(name: "sleep", bundle: resourceBundle)

    /// The "sleep(1)" asset catalog image resource.
    static let sleep1 = ImageResource(name: "sleep(1)", bundle: resourceBundle)

    /// The "smile" asset catalog image resource.
    static let smile = ImageResource(name: "smile", bundle: resourceBundle)

    /// The "step" asset catalog image resource.
    static let step = ImageResource(name: "step", bundle: resourceBundle)

    /// The "stress" asset catalog image resource.
    static let stress = ImageResource(name: "stress", bundle: resourceBundle)

    /// The "sun-line" asset catalog image resource.
    static let sunLine = ImageResource(name: "sun-line", bundle: resourceBundle)

    /// The "switch" asset catalog image resource.
    static let `switch` = ImageResource(name: "switch", bundle: resourceBundle)

    /// The "switch-off" asset catalog image resource.
    static let switchOff = ImageResource(name: "switch-off", bundle: resourceBundle)

    /// The "temperature" asset catalog image resource.
    static let temperature = ImageResource(name: "temperature", bundle: resourceBundle)

    /// The "temperature 1" asset catalog image resource.
    static let temperature1 = ImageResource(name: "temperature 1", bundle: resourceBundle)

    /// The "text-img" asset catalog image resource.
    static let textImg = ImageResource(name: "text-img", bundle: resourceBundle)

    /// The "tired" asset catalog image resource.
    static let tired = ImageResource(name: "tired", bundle: resourceBundle)

    /// The "头像" asset catalog image resource.
    static let 头像 = ImageResource(name: "头像", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "Apple" asset catalog image.
    static var apple: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .apple)
#else
        .init()
#endif
    }

    /// The "Background" asset catalog image.
    static var background: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .background)
#else
        .init()
#endif
    }

    /// The "Google" asset catalog image.
    static var google: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .google)
#else
        .init()
#endif
    }

    /// The "Know-you-pro-n" asset catalog image.
    static var knowYouProN: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .knowYouProN)
#else
        .init()
#endif
    }

    /// The "Know-you-pro-s" asset catalog image.
    static var knowYouProS: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .knowYouProS)
#else
        .init()
#endif
    }

    /// The "MT-AI-Glasses-n" asset catalog image.
    static var mtAIGlassesN: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mtAIGlassesN)
#else
        .init()
#endif
    }

    /// The "MT-AI-Glasses-s" asset catalog image.
    static var mtAIGlassesS: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mtAIGlassesS)
#else
        .init()
#endif
    }

    /// The "SpO₂" asset catalog image.
    static var spO₂: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .spO₂)
#else
        .init()
#endif
    }

    /// The "SplashIcon" asset catalog image.
    static var splashIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .splashIcon)
#else
        .init()
#endif
    }

    /// The "WeChat" asset catalog image.
    static var weChat: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .weChat)
#else
        .init()
#endif
    }

    /// The "Welcome" asset catalog image.
    static var welcome: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .welcome)
#else
        .init()
#endif
    }

    /// The "add" asset catalog image.
    static var add: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .add)
#else
        .init()
#endif
    }

    /// The "anxiety" asset catalog image.
    static var anxiety: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .anxiety)
#else
        .init()
#endif
    }

    /// The "blood" asset catalog image.
    static var blood: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blood)
#else
        .init()
#endif
    }

    /// The "blood 1" asset catalog image.
    static var blood1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blood1)
#else
        .init()
#endif
    }

    /// The "blood-pressure" asset catalog image.
    static var bloodPressure: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bloodPressure)
#else
        .init()
#endif
    }

    /// The "calendar" asset catalog image.
    static var calendar: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .calendar)
#else
        .init()
#endif
    }

    /// The "calm" asset catalog image.
    static var calm: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .calm)
#else
        .init()
#endif
    }

    /// The "cardiovascular" asset catalog image.
    static var cardiovascular: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cardiovascular)
#else
        .init()
#endif
    }

    /// The "check" asset catalog image.
    static var check: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .check)
#else
        .init()
#endif
    }

    /// The "codale" asset catalog image.
    static var codale: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .codale)
#else
        .init()
#endif
    }

    /// The "earphones" asset catalog image.
    static var earphones: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .earphones)
#else
        .init()
#endif
    }

    /// The "earphones2" asset catalog image.
    static var earphones2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .earphones2)
#else
        .init()
#endif
    }

    /// The "eye" asset catalog image.
    static var eye: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .eye)
#else
        .init()
#endif
    }

    /// The "game" asset catalog image.
    static var game: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .game)
#else
        .init()
#endif
    }

    /// The "glasses" asset catalog image.
    static var glasses: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .glasses)
#else
        .init()
#endif
    }

    /// The "heermeng" asset catalog image.
    static var heermeng: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .heermeng)
#else
        .init()
#endif
    }

    /// The "k-up" asset catalog image.
    static var kUp: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .kUp)
#else
        .init()
#endif
    }

    /// The "light" asset catalog image.
    static var light: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .light)
#else
        .init()
#endif
    }

    /// The "love" asset catalog image.
    static var love: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .love)
#else
        .init()
#endif
    }

    /// The "love(1)" asset catalog image.
    static var love1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .love1)
#else
        .init()
#endif
    }

    /// The "power" asset catalog image.
    static var power: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .power)
#else
        .init()
#endif
    }

    /// The "ring" asset catalog image.
    static var ring: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ring)
#else
        .init()
#endif
    }

    /// The "sleep" asset catalog image.
    static var sleep: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sleep)
#else
        .init()
#endif
    }

    /// The "sleep(1)" asset catalog image.
    static var sleep1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sleep1)
#else
        .init()
#endif
    }

    /// The "smile" asset catalog image.
    static var smile: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .smile)
#else
        .init()
#endif
    }

    /// The "step" asset catalog image.
    static var step: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .step)
#else
        .init()
#endif
    }

    /// The "stress" asset catalog image.
    static var stress: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .stress)
#else
        .init()
#endif
    }

    /// The "sun-line" asset catalog image.
    static var sunLine: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sunLine)
#else
        .init()
#endif
    }

    /// The "switch" asset catalog image.
    static var `switch`: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .`switch`)
#else
        .init()
#endif
    }

    /// The "switch-off" asset catalog image.
    static var switchOff: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .switchOff)
#else
        .init()
#endif
    }

    /// The "temperature" asset catalog image.
    static var temperature: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .temperature)
#else
        .init()
#endif
    }

    /// The "temperature 1" asset catalog image.
    static var temperature1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .temperature1)
#else
        .init()
#endif
    }

    /// The "text-img" asset catalog image.
    static var textImg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .textImg)
#else
        .init()
#endif
    }

    /// The "tired" asset catalog image.
    static var tired: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tired)
#else
        .init()
#endif
    }

    /// The "头像" asset catalog image.
    static var 头像: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .头像)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "Apple" asset catalog image.
    static var apple: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .apple)
#else
        .init()
#endif
    }

    /// The "Background" asset catalog image.
    static var background: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .background)
#else
        .init()
#endif
    }

    /// The "Google" asset catalog image.
    static var google: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .google)
#else
        .init()
#endif
    }

    /// The "Know-you-pro-n" asset catalog image.
    static var knowYouProN: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .knowYouProN)
#else
        .init()
#endif
    }

    /// The "Know-you-pro-s" asset catalog image.
    static var knowYouProS: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .knowYouProS)
#else
        .init()
#endif
    }

    /// The "MT-AI-Glasses-n" asset catalog image.
    static var mtAIGlassesN: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mtAIGlassesN)
#else
        .init()
#endif
    }

    /// The "MT-AI-Glasses-s" asset catalog image.
    static var mtAIGlassesS: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mtAIGlassesS)
#else
        .init()
#endif
    }

    /// The "SpO₂" asset catalog image.
    static var spO₂: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .spO₂)
#else
        .init()
#endif
    }

    /// The "SplashIcon" asset catalog image.
    static var splashIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .splashIcon)
#else
        .init()
#endif
    }

    /// The "WeChat" asset catalog image.
    static var weChat: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .weChat)
#else
        .init()
#endif
    }

    /// The "Welcome" asset catalog image.
    static var welcome: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .welcome)
#else
        .init()
#endif
    }

    #warning("The \"add\" image asset name resolves to a conflicting UIImage symbol \"add\". Try renaming the asset.")

    /// The "anxiety" asset catalog image.
    static var anxiety: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .anxiety)
#else
        .init()
#endif
    }

    /// The "blood" asset catalog image.
    static var blood: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blood)
#else
        .init()
#endif
    }

    /// The "blood 1" asset catalog image.
    static var blood1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blood1)
#else
        .init()
#endif
    }

    /// The "blood-pressure" asset catalog image.
    static var bloodPressure: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bloodPressure)
#else
        .init()
#endif
    }

    /// The "calendar" asset catalog image.
    static var calendar: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .calendar)
#else
        .init()
#endif
    }

    /// The "calm" asset catalog image.
    static var calm: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .calm)
#else
        .init()
#endif
    }

    /// The "cardiovascular" asset catalog image.
    static var cardiovascular: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cardiovascular)
#else
        .init()
#endif
    }

    /// The "check" asset catalog image.
    static var check: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .check)
#else
        .init()
#endif
    }

    /// The "codale" asset catalog image.
    static var codale: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .codale)
#else
        .init()
#endif
    }

    /// The "earphones" asset catalog image.
    static var earphones: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .earphones)
#else
        .init()
#endif
    }

    /// The "earphones2" asset catalog image.
    static var earphones2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .earphones2)
#else
        .init()
#endif
    }

    /// The "eye" asset catalog image.
    static var eye: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .eye)
#else
        .init()
#endif
    }

    /// The "game" asset catalog image.
    static var game: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .game)
#else
        .init()
#endif
    }

    /// The "glasses" asset catalog image.
    static var glasses: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .glasses)
#else
        .init()
#endif
    }

    /// The "heermeng" asset catalog image.
    static var heermeng: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .heermeng)
#else
        .init()
#endif
    }

    /// The "k-up" asset catalog image.
    static var kUp: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .kUp)
#else
        .init()
#endif
    }

    /// The "light" asset catalog image.
    static var light: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .light)
#else
        .init()
#endif
    }

    /// The "love" asset catalog image.
    static var love: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .love)
#else
        .init()
#endif
    }

    /// The "love(1)" asset catalog image.
    static var love1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .love1)
#else
        .init()
#endif
    }

    /// The "power" asset catalog image.
    static var power: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .power)
#else
        .init()
#endif
    }

    /// The "ring" asset catalog image.
    static var ring: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ring)
#else
        .init()
#endif
    }

    /// The "sleep" asset catalog image.
    static var sleep: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sleep)
#else
        .init()
#endif
    }

    /// The "sleep(1)" asset catalog image.
    static var sleep1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sleep1)
#else
        .init()
#endif
    }

    /// The "smile" asset catalog image.
    static var smile: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .smile)
#else
        .init()
#endif
    }

    /// The "step" asset catalog image.
    static var step: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .step)
#else
        .init()
#endif
    }

    /// The "stress" asset catalog image.
    static var stress: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .stress)
#else
        .init()
#endif
    }

    /// The "sun-line" asset catalog image.
    static var sunLine: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sunLine)
#else
        .init()
#endif
    }

    /// The "switch" asset catalog image.
    static var `switch`: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .`switch`)
#else
        .init()
#endif
    }

    /// The "switch-off" asset catalog image.
    static var switchOff: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .switchOff)
#else
        .init()
#endif
    }

    /// The "temperature" asset catalog image.
    static var temperature: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .temperature)
#else
        .init()
#endif
    }

    /// The "temperature 1" asset catalog image.
    static var temperature1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .temperature1)
#else
        .init()
#endif
    }

    /// The "text-img" asset catalog image.
    static var textImg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .textImg)
#else
        .init()
#endif
    }

    /// The "tired" asset catalog image.
    static var tired: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tired)
#else
        .init()
#endif
    }

    /// The "头像" asset catalog image.
    static var 头像: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .头像)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ColorResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ImageResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Hashable {

    /// An asset catalog color resource name.
    fileprivate let name: String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Hashable {

    /// An asset catalog image resource name.
    fileprivate let name: String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif