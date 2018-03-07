//
//  GGPModalViewController.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPNavigationController.h"
#import <UIKit/UIKit.h>

@interface GGPModalViewController : GGPNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController includeCloseButton:(BOOL)includeCloseButton andOnClose:(void(^)())onClose;
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController andOnClose:(void(^)())onClose;

@end
