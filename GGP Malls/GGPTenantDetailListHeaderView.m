//
//  GGPTenantDetailListHeaderView.m
//  GGP Malls
//
//  Created by Janet Lin on 1/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantDetailListHeaderView.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

NSString *const GGPTenantDetailListHeaderViewId = @"GGPTenantDetailListHeaderViewId";
CGFloat const GGPTenantDetailListHeaderViewHeight = 28;

@interface GGPTenantDetailListHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation GGPTenantDetailListHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont ggp_boldWithSize:16];
    self.titleLabel.textColor = [UIColor blackColor];
}

- (void)configureWithTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
