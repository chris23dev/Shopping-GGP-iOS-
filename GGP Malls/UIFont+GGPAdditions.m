//
//  UIFont+GGPAdditions.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/21/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "UIFont+GGPAdditions.h"

@implementation UIFont (GGPAdditions)

+ (UIFont *)ggp_regularWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-Regular" size:size];
}

+ (UIFont *)ggp_mediumWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-Medium" size:size];
}

+ (UIFont *)ggp_boldWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-Bold" size:size];
}

+ (UIFont *)ggp_lightWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-Light" size:size];
}

+ (UIFont *)ggp_lightItalicWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-LightItalic" size:size];
}

+ (UIFont *)ggp_blackWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-Black" size:size];
}

@end
