//
//  UIFont+GGPAdditions.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/21/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (GGPAdditions)

+ (UIFont *)ggp_regularWithSize:(CGFloat)size;
+ (UIFont *)ggp_mediumWithSize:(CGFloat)size;
+ (UIFont *)ggp_boldWithSize:(CGFloat)size;
+ (UIFont *)ggp_lightWithSize:(CGFloat)size;
+ (UIFont *)ggp_lightItalicWithSize:(CGFloat)size;
+ (UIFont *)ggp_blackWithSize:(CGFloat)size;

@end
