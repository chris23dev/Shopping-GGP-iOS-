//
//  UIView+GGPAdditions.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/17/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GGPAdditions)

@property (strong, nonatomic) NSNumber *originalHeight;
@property (strong, nonatomic) NSNumber *originalWidth;
@property (strong, nonatomic) NSNumber *originalTopMargin;
@property (strong, nonatomic) NSNumber *originalLeadingMargin;

- (void)ggp_addConstraintsToFillSuperview;
- (void)ggp_addShadowWithRadius:(float)radius andOpacity:(float)opacity;

- (void)ggp_collapseVertically;
- (void)ggp_collapseHorizontally;
- (void)ggp_expandVertically;
- (void)ggp_expandVerticallyWithHeight:(CGFloat)height;
- (void)ggp_expandHorizontally;

- (void)ggp_addBorderRadius:(float)radius;
- (void)ggp_addBorderWithWidth:(float)width andColor:(UIColor *)color;
- (void)ggp_addInnerShadowWithRadius:(float)radius andOpacity:(float)opacity;
- (CAGradientLayer *)ggp_addBottomGradientWithHeight:(CGFloat)height andColor:(UIColor *)color;
- (void)ggp_addGradientLayerWithStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor;

@end
