//
//  GGPAuthenticationController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPAuthenticationDelegate.h"

extern NSString *const GGPAuthenticationCompletedNotification;

@interface GGPAuthenticationController : UINavigationController

@property (weak, nonatomic) id<GGPAuthenticationDelegate> authenticationDelegate;

+ (instancetype)authenticationControllerForLogin;
+ (instancetype)authenticationControllerForRegistration;

@end
