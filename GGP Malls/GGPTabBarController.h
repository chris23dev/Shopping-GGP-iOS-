//
//  GGPTabBarController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPTabBarController : UITabBarController

- (void)dismissModalView;
- (void)handleMallChanged;
- (void)reloadControllers;
- (BOOL)handleQuickActionType:(NSString *)type;

@end
