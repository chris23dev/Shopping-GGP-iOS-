//
//  UIColor+GGPAdditions.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/21/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "UIColor+GGPAdditions.h"

@implementation UIColor (GGPAdditions)

+ (UIColor *)ggp_blue {
    return [UIColor ggp_colorFromHexString:@"0098CC"];
}

+ (UIColor *)ggp_red {
    return [UIColor ggp_colorFromHexString:@"f31d23"];
}

+ (UIColor *)ggp_darkRed {
    return [UIColor ggp_colorFromHexString:@"d0021b"];
}

+ (UIColor *)ggp_green {
    return [UIColor ggp_colorFromHexString:@"60ba46"];
}

#pragma mark - Grays

/**
 Gainsboro gray
 @return UIColor with #dddddd
 */
+ (UIColor *)ggp_gainsboroGray {
    return [UIColor ggp_colorFromHexString:@"DDDDDD"];
}

/**
 Pastel gray
 @return UIColor with #CCCCCC
 */
+ (UIColor *)ggp_pastelGray {
    return [UIColor ggp_colorFromHexString:@"CCCCCC"];
}

/**
 Timberwolf gray
 @return UIColor with #D7D7D7
 */
+ (UIColor *)ggp_timberWolfGray {
    return [UIColor ggp_colorFromHexString:@"D7D7D7"];
}

/**
 Gray
 @return UIColor with #666666
 */
+ (UIColor *)ggp_gray {
    return [UIColor ggp_colorFromHexString:@"666666"];
}

/**
 Dark Gray
 @return UIColor with #333333
 */
+ (UIColor *)ggp_darkGray {
    return [UIColor ggp_colorFromHexString:@"333333"];
}

/**
 Light Gray
 @return UIColor with #e3e3e3
 */
+ (UIColor *)ggp_lightGray {
    return [UIColor ggp_colorFromHexString:@"e3e3e3"];
}

/**
 Extra Light Gray
 @return UIColor with #f2f2f2
 */
+ (UIColor *)ggp_extraLightGray {
    return [UIColor ggp_colorFromHexString:@"f2f2f2"];
}

/**
 Medium Gray
 @return UIColor with #888888
 */
+ (UIColor *)ggp_mediumGray {
    return [UIColor ggp_colorFromHexString:@"888888"];
}

/**
 Manatee Gray
 @return UIColor with #999999
 */
+ (UIColor *)ggp_manateeGray {
    return [UIColor ggp_colorFromHexString:@"999999"];
}

#pragma mark - Component Colors

/**
 Divider color
 @return UIColor with #c8c8c8
 */
+ (UIColor *)ggp_divider {
    return [UIColor ggp_colorFromHexString:@"c8c8c8"];
}

+ (UIColor *)ggp_navigationBar {
    return [UIColor ggp_darkGray];
}

/**
 Modal Header Color
 @return UIColor with #6B6B6B
 */
+ (UIColor *)ggp_modalHeaderColor {
    return [UIColor ggp_colorFromHexString:@"6B6B6B"];
}

+ (UIColor *)ggp_disclaimerBackground {
    return [self ggp_pastelGray];
}

+ (UIColor *)ggp_separatorColor {
    return [UIColor ggp_gainsboroGray];
}

+ (UIColor *)ggp_facebookBackground {
    return [UIColor ggp_colorFromHexString:@"01669f"];
}

+ (UIColor *)ggp_googleBackground {
    return [UIColor whiteColor];
}

+ (UIColor *)ggp_googleFontColor {
    return [UIColor darkGrayColor];
}

+ (UIColor *)ggp_alertBackground {
    return [UIColor ggp_colorFromHexString:@"fcf8ec"];
}

+ (UIColor *)ggp_directoryTab {
    return [UIColor ggp_colorFromHexString:@"0098cc"];
}

+ (UIColor *)ggp_homeTab {
    return [UIColor ggp_colorFromHexString:@"656176"];
}

+ (UIColor *)ggp_moreTab {
    return [UIColor ggp_colorFromHexString:@"e69f2c"];
}

+ (UIColor *)ggp_shoppingTab {
    return [UIColor ggp_colorFromHexString:@"68823a"];
}

+ (UIColor *)ggp_parkingTab {
    return [UIColor ggp_colorFromHexString:@"a14444"];
}

#pragma mark - Color from hex string

+ (UIColor *)ggp_colorFromHexString:(NSString *)hexString {
    return [UIColor ggp_colorFromHexString:hexString andAlpha:1.0];
}

+ (UIColor *)ggp_colorFromHexString:(NSString *)hexString andAlpha:(CGFloat)alpha {
    NSCharacterSet *noneHexidecimalVals = [[NSCharacterSet characterSetWithCharactersInString:@"#0123456789ABCDEFacbdef"] invertedSet];
    
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if (hexString && [hexString rangeOfCharacterFromSet:noneHexidecimalVals].length == 0 && hexString.length <= 6) {
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner scanHexInt:&rgbValue];
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
    }
    return nil;
}

@end
