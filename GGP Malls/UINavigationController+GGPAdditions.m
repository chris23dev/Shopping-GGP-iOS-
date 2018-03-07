//
//  UINavigationController+GGPAdditions.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "UINavigationController+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

@implementation UINavigationController (GGPAdditions)

- (void)ggp_configureWithDarkText {
    self.navigationBar.tintColor = [UIColor ggp_blue]; //arrow color
    [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor blackColor],
                                                  NSFontAttributeName:[UIFont ggp_boldWithSize:16] }];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)ggp_configureWithLightText {
    self.navigationBar.tintColor = [UIColor ggp_extraLightGray];
    [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor ggp_extraLightGray],
                                                  NSFontAttributeName: [UIFont ggp_boldWithSize:16] }];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)ggp_configureAsTransparent:(BOOL)isTransparent {
    self.navigationBar.translucent = isTransparent;
    self.navigationBar.shadowImage = isTransparent ? [UIImage new] : [[UINavigationBar appearance] shadowImage];
    
    if (isTransparent) {
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    } else {
        [self.navigationBar setBackgroundImage:[[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    }
}

@end
