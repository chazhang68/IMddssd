//
//  JVerificationHelper.m
//  蓝牙指环
//
//  Created for JVerification Swift bridge
//

#import "JVerificationHelper.h"
#import <JVerification/JVERIFICATIONService.h>

@implementation JVerificationHelper

+ (void)getAuthorizationWithController:(UIViewController *)controller
                                    hide:(BOOL)hide
                              completion:(void (^)(NSDictionary * _Nullable result))completion {
    [JVERIFICATIONService getAuthorizationWithController:controller
                                                     hide:hide
                                               completion:completion];
}

@end


