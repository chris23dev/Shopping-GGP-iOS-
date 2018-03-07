//
//  GGPMessageViewController.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 4/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPMessageViewController : UIViewController

@property (assign, nonatomic) CGFloat contentHeight;

- (instancetype)initWithImage:(UIImage *)image headline:(NSString *)headline andBody:(NSString *)body;

- (instancetype)initWithImage:(UIImage *)image headline:(NSString *)headline body:(NSString *)body actionTitle:(NSString *)actionTitle actionTapHandler:(void(^)())onActionTap;

@end
