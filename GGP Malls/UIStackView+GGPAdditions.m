//
//  UIStackView+GGPAdditions.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "UIStackView+GGPAdditions.h"

@implementation UIStackView (GGPAdditions)

- (void)ggp_clearArrangedSubviews {
    for (int i = (int)self.arrangedSubviews.count - 1; i >= 0; i--) {
        UIView *arrangedSubview = self.arrangedSubviews[i];
        [self removeArrangedSubview:arrangedSubview];
        [arrangedSubview removeFromSuperview];
    }
}

@end
