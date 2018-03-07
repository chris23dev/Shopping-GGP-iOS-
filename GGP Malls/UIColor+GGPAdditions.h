//
//  UIColor+GGPAdditions.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/21/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (GGPAdditions)

+ (UIColor *)ggp_separatorColor;
+ (UIColor *)ggp_navigationBar;
+ (UIColor *)ggp_blue;
+ (UIColor *)ggp_red;
+ (UIColor *)ggp_darkRed;
+ (UIColor *)ggp_green;
+ (UIColor *)ggp_pastelGray;
+ (UIColor *)ggp_gray;
+ (UIColor *)ggp_timberWolfGray;
+ (UIColor *)ggp_darkGray;
+ (UIColor *)ggp_lightGray;
+ (UIColor *)ggp_extraLightGray;
+ (UIColor *)ggp_mediumGray;
+ (UIColor *)ggp_manateeGray;
+ (UIColor *)ggp_gainsboroGray;
+ (UIColor *)ggp_divider;
+ (UIColor *)ggp_facebookBackground;
+ (UIColor *)ggp_googleBackground;
+ (UIColor *)ggp_googleFontColor;
+ (UIColor *)ggp_modalHeaderColor;
+ (UIColor *)ggp_disclaimerBackground;
+ (UIColor *)ggp_alertBackground;
+ (UIColor *)ggp_directoryTab;
+ (UIColor *)ggp_homeTab;
+ (UIColor *)ggp_moreTab;
+ (UIColor *)ggp_shoppingTab;
+ (UIColor *)ggp_parkingTab;

+ (UIColor *)ggp_colorFromHexString:(NSString *)hexString;
+ (UIColor *)ggp_colorFromHexString:(NSString *)hexString andAlpha:(CGFloat)alpha;

@end
