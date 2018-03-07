//
//  GGPViewCell.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/24/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPViewCell.h"
#import "UIView+GGPAdditions.h"

NSString *const GGPViewCellId = @"GGPViewCellId";

@implementation GGPViewCell

- (void)configureWithView:(UIView *)view {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    [self.contentView addSubview:view];
    [view ggp_addConstraintsToFillSuperview];
}

@end
