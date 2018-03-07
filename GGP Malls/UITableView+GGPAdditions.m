//
//  UITableView+GGPAdditions.m
//  GGP Malls
//
//  Created by Janet Lin on 1/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "UITableView+GGPAdditions.h"

@implementation UITableView (GGPAdditions)

- (CGFloat)ggp_contentHeight {
    NSInteger lastFooterIndex = [self numberOfSections] - 1;
    CGRect lastFooterRect = [self rectForFooterInSection:lastFooterIndex];
    return lastFooterRect.origin.y + lastFooterRect.size.height;
}

@end
