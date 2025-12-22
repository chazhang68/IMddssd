//
//  JVerificationHelper.h
//  蓝牙指环
//
//  Created for JVerification Swift bridge
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JVerificationHelper : NSObject

// 使用 NS_SWIFT_NAME 确保 Swift 方法名正确
+ (void)getAuthorizationWithController:(UIViewController *)controller
                                    hide:(BOOL)hide
                              completion:(void (^)(NSDictionary * _Nullable result))completion
    NS_SWIFT_NAME(getAuthorization(withController:hide:completion:));

@end

NS_ASSUME_NONNULL_END

