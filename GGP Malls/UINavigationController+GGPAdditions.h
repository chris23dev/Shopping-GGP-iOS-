//
//  UINavigationController+GGPAdditions.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (GGPAdditions)

- (void)ggp_configureWithDarkText;
- (void)ggp_configureWithLightText;
- (void)ggp_configureAsTransparent:(BOOL)transparent;

@end
