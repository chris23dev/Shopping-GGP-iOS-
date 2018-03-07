//
//  GGPDynamicHeightImageView.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/24/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPDynamicHeightImageView.h"

@interface GGPDynamicHeightImageView ()
@property (strong, nonatomic) NSLayoutConstraint *aspectConstraint;
@end

@implementation GGPDynamicHeightImageView

- (void)setImage:(UIImage *)image {
    [self removeConstraint:self.aspectConstraint];
    
    if (image.size.height > 0) {
        CGFloat aspectRatio = image.size.width / image.size.height;
        self.aspectConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:aspectRatio constant:0.0];
        self.aspectConstraint.priority = 999;
        self.aspectConstraint.active = true;
    }

    super.image = image;
}

@end
