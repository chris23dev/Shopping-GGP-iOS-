//
//  GGPPresenterDelegate.h
//  GGP Malls
//
//  Created by Dustin Duclo on 8/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;

@protocol GGPPresenterDelegate <NSObject>

- (void)pushViewController:(UIViewController *)viewController;
- (void)presentViewController:(UIViewController *)viewController;

@end
