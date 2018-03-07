//
//  GGPExpandedTableView.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPExpandedTableView.h"

@implementation GGPExpandedTableView

- (CGSize)intrinsicContentSize {
    [self layoutIfNeeded];
    return CGSizeMake(UIViewNoIntrinsicMetric, self.contentSize.height);
}

@end
