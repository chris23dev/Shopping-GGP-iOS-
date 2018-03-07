//
//  GGPAppContainerViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPAppContainerViewController : UIViewController

- (void)appDidBecomeActive;
- (void)handleDeeplinkedMallId:(NSInteger)mallId;
- (BOOL)handleQuickActionType:(NSString *)type;

@end
