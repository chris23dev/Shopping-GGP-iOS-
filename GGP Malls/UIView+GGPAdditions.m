//
//  UIView+GGPAdditions.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/17/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "UIColor+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <objc/runtime.h>

@implementation UIView (GGPAdditions)

- (void)setOriginalWidth:(NSNumber *)originalWidth {
    objc_setAssociatedObject(self, @selector(originalWidth), originalWidth, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)originalWidth {
    return objc_getAssociatedObject(self, @selector(originalWidth));
}

- (void)setOriginalHeight:(NSNumber *)originalHeight {
    objc_setAssociatedObject(self, @selector(originalHeight), originalHeight, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)originalHeight {
    return objc_getAssociatedObject(self, @selector(originalHeight));
}

- (void)setOriginalTopMargin:(NSNumber *)originalTopMargin {
    objc_setAssociatedObject(self, @selector(originalTopMargin), originalTopMargin, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)originalTopMargin {
    return objc_getAssociatedObject(self, @selector(originalTopMargin));
}

- (void)setOriginalLeadingMargin:(NSNumber *)originalLeadingMargin {
    objc_setAssociatedObject(self, @selector(originalLeadingMargin), originalLeadingMargin, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)originalLeadingMargin {
    return objc_getAssociatedObject(self, @selector(originalLeadingMargin));
}

- (void)ggp_addConstraintsToFillSuperview {
    if (!self.superview) {
        return;
    }
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    top.active = YES;
    bottom.active = YES;
    leading.active = YES;
    trailing.active = YES;
}

- (void)ggp_addShadowWithRadius:(float)radius andOpacity:(float)opacity {
    self.clipsToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)ggp_addInnerShadowWithRadius:(float)radius andOpacity:(float)opacity {
    CAShapeLayer *shadowLayer = CAShapeLayer.layer;
    shadowLayer.frame = self.bounds;
    shadowLayer.shadowColor = [UIColor ggp_colorFromHexString:@"000000"].CGColor;
    shadowLayer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    shadowLayer.shadowOpacity = opacity;
    shadowLayer.shadowRadius = radius;
    shadowLayer.fillRule = kCAFillRuleEvenOdd;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectInset(self.bounds, -4, -4));
    CGPathAddPath(path, NULL, [[UIBezierPath bezierPathWithRect:shadowLayer.bounds] CGPath]);
    CGPathCloseSubpath(path);
    shadowLayer.path = path;
    
    [self.layer addSublayer:shadowLayer];
}

- (void)ggp_addBorderRadius:(float)radius {
    self.layer.cornerRadius = radius;
}

- (void)ggp_addBorderWithWidth:(float)width andColor:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (CAGradientLayer *)ggp_addBottomGradientWithHeight:(CGFloat)height andColor:(UIColor *)color {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height - height, self.frame.size.width, height);
    gradientLayer.colors = @[(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor, (id)color.CGColor];
    [self.layer insertSublayer:gradientLayer atIndex:0];
    
    return gradientLayer;
}

- (void)ggp_addGradientLayerWithStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    [self.layer addSublayer:gradient];
}

- (void)ggp_collapseVertically {
    if (![self ggp_isCollapsed]) {
        NSLayoutConstraint *topMargin = [self ggp_topMarginConstraint];
        NSLayoutConstraint *heightConstraint = [self ggp_heightConstraint];
        
        self.originalTopMargin = @(topMargin.constant);
        self.originalHeight = heightConstraint.constant != 0 ? @(heightConstraint.constant) : @(self.frame.size.height);
        
        topMargin.constant = 0;
        heightConstraint.constant = 0;
        self.hidden = YES;
    }
}

- (void)ggp_collapseHorizontally {
    if (![self ggp_isCollapsed]) {
        NSLayoutConstraint *leadingMargin = [self ggp_leadingMarginConstraint];
        NSLayoutConstraint *widthConstraint = [self ggp_widthConstraint];
        
        self.originalLeadingMargin = @(leadingMargin.constant);
        self.originalWidth = @(self.frame.size.width);
        
        leadingMargin.constant = 0;
        widthConstraint.constant = 0;
        self.hidden = YES;
    }
}

- (void)ggp_expandVertically {
    if ([self ggp_isCollapsed]) {
        [self ggp_topMarginConstraint].constant = [self.originalTopMargin floatValue];
        [self ggp_heightConstraint].constant = [self.originalHeight floatValue];
        self.hidden = NO;
    }
}

- (void)ggp_expandVerticallyWithHeight:(CGFloat)height {
    if ([self ggp_isCollapsed]) {
        [self ggp_topMarginConstraint].constant = [self.originalTopMargin floatValue];
        [self ggp_heightConstraint].constant = height;
        self.hidden = NO;
    }
}

- (void)ggp_expandHorizontally {
    if ([self ggp_isCollapsed]) {
        [self ggp_leadingMarginConstraint].constant = [self.originalLeadingMargin floatValue];
        [self ggp_widthConstraint].constant = [self.originalWidth floatValue];
        self.hidden = NO;
    }
}

- (NSLayoutConstraint *)ggp_topMarginConstraint {
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeTop) {
            return constraint;
        }
    }
    return nil;
}

- (NSLayoutConstraint *)ggp_leadingMarginConstraint {
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeLeading) {
            return constraint;
        }
    }
    return nil;
}

- (NSLayoutConstraint *)ggp_heightConstraint {
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight && [constraint isMemberOfClass:[NSLayoutConstraint class]]) {
            return constraint;
        }
    }
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self addConstraint:heightConstraint];
    return heightConstraint;
}

- (NSLayoutConstraint *)ggp_widthConstraint {
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth && [constraint isMemberOfClass:[NSLayoutConstraint class]]) {
            return constraint;
        }
    }
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self addConstraint:widthConstraint];
    return widthConstraint;
}

- (BOOL)ggp_isCollapsed {
    return self.frame.size.height == 0 || self.frame.size.width == 0 || self.hidden;
}

@end
