//
//  GGPCarLocationHeaderCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCarLocationHeaderCell.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

NSString *const GGPCarLocationHeaderCellId = @"GGPCarLocationHeaderCellId";

@interface GGPCarLocationHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@end

@implementation GGPCarLocationHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headerLabel.textColor = [UIColor ggp_manateeGray];
    self.headerLabel.font = [UIFont ggp_regularWithSize:15];
}

- (void)configureWithSearchText:(NSString *)searchText andResultCount:(NSInteger)resultCount {
    self.headerLabel.text = [NSString stringWithFormat:[@"FIND_MY_CAR_RESULTS_MATCHING" ggp_toLocalized], (long)resultCount, searchText];
}

@end
