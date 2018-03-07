//
//  GGPRegisterPreferencesViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPScrollViewController.h"

@class GGPUser;

@interface GGPRegisterPreferencesViewController : GGPScrollViewController

- (instancetype)initWithUser:(GGPUser *)user andPassword:(NSString *)password;
- (instancetype)initWithUser:(GGPUser *)user provider:(NSString *)provider andRegistrationToken:(NSString *)registrationToken;

@end
