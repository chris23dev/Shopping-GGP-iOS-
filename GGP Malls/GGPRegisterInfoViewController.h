//
//  GGPSiteRegisterViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPScrollViewController.h"
#import <UIKit/UIKit.h>

@class GGPSocialInfo;

@interface GGPRegisterInfoViewController : GGPScrollViewController

- (instancetype)initWithSocialInfo:(GGPSocialInfo *)socialInfo provider:(NSString *)provider andRegistrationToken:(NSString *)registrationToken;

@end
