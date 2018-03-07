//
//  UIButton+UIButton_GGPAdditions.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (GGPAdditions)

- (void)ggp_centerImageAboveTextWithSpacing:(CGFloat)spacing;
+ (UIButton *)ggp_buttonForNavigationToolbarWithTitle:(NSString *)title defaultImage:(UIImage *)defaultImage andSelectedImage:(UIImage *)selectedImage;

- (UIButton *)ggp_styleAsLinkButton;
- (UIButton *)ggp_styleAsLightActionButton;
- (UIButton *)ggp_styleAsDarkActionButton;

@end
