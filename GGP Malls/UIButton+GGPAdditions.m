//
//  UIButton+UIButton_GGPAdditions.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"

static NSInteger const kStandardButtonFontSize = 18;
static NSInteger const kLinkButtonFontSize = 14;
static NSInteger const kButtonBorderRadius = 5;

@implementation UIButton (GGPAdditions)

+ (UIButton *)ggp_buttonForNavigationToolbarWithTitle:(NSString *)title defaultImage:(UIImage *)defaultImage andSelectedImage:(UIImage *)selectedImage {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.font = [UIFont ggp_lightWithSize:9];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button sizeToFit];
    [button setImage:defaultImage forState:UIControlStateNormal];
    
    if (selectedImage) {
        [button setImage:selectedImage forState:UIControlStateSelected];
        [button setTitleColor:[UIColor ggp_blue] forState:UIControlStateSelected];
    }
    
    [button ggp_centerImageAboveTextWithSpacing:1];
    
    return button;
}

- (void)ggp_centerImageAboveTextWithSpacing:(CGFloat)spacing {
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(imageSize.height + spacing), 0);
    
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0, 0, -titleSize.width);
}

- (UIButton *)ggp_actionButtonWithBackgroundColor:(UIColor *)backgroundColor andTextColor:(UIColor *)textColor {
    self.backgroundColor = backgroundColor;
    [self ggp_addBorderRadius:kButtonBorderRadius];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont ggp_boldWithSize:kStandardButtonFontSize];
    [self setTitleColor:textColor forState:UIControlStateNormal];
    return self;
}

- (UIButton *)ggp_styleAsDarkActionButton {
    return [self ggp_actionButtonWithBackgroundColor:[UIColor ggp_blue]
                                        andTextColor:[UIColor ggp_extraLightGray]];
}

- (UIButton *)ggp_styleAsLightActionButton {
    return [self ggp_actionButtonWithBackgroundColor:[UIColor whiteColor]
                                        andTextColor:[UIColor ggp_blue]];
}

- (UIButton *)ggp_styleAsLinkButton {
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont ggp_regularWithSize:kLinkButtonFontSize];
    [self.titleLabel sizeToFit];
    [self setTitleColor:[UIColor ggp_blue] forState:UIControlStateNormal];
    return self;
}

@end
