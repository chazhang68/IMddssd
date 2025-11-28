import UIKit

// Simple test to verify image assets are available
func testImageAssets() {
    let googleImage = UIImage(named: "Google")
    let appleImage = UIImage(named: "Apple") 
    let wechatImage = UIImage(named: "WeChat")
    let checkImage = UIImage(named: "check")
    
    print("Google image: \(googleImage != nil ? "Available" : "Not found")")
    print("Apple image: \(appleImage != nil ? "Available" : "Not found")")
    print("WeChat image: \(wechatImage != nil ? "Available" : "Not found")")
    print("Check image: \(checkImage != nil ? "Available" : "Not found")")
}

// Call this in your AppDelegate or SceneDelegate to test
testImageAssets()