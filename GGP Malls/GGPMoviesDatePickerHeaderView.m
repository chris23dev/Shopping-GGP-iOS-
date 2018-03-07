//
//  GGPMoviesDatePickerHeaderView.m
//  GGP Malls
//
//  Created by Janet Lin on 12/15/15.
//  Copyright (c) 2015 GGP. All rights reserved.
//

#import "GGPMoviesDatePickerHeaderView.h"

NSString *const GGPMoviesDatePickerHeaderViewReuseIdentifier = @"GGPMoviesDatePickerHeaderViewReuseIdentifier";
CGFloat const GGPMoviesDatePickerHeaderViewHeight = 73;

@interface GGPMoviesDatePickerHeaderView()
@end

@implementation GGPMoviesDatePickerHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor clearColor];
}

@end
