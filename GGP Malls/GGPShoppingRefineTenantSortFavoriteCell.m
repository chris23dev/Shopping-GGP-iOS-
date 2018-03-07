//
//  GGPShoppingRefineTenantSortFavoriteCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPShoppingRefineTenantSortFavoriteCell.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

NSString *const GGPShoppingRefineTenantSortFavoriteCellReuseIdentifier = @"GGPShoppingRefineTenantSortFavoriteCellReuseIdentifier";

@interface GGPShoppingRefineTenantSortFavoriteCell ()

@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;

@end

@implementation GGPShoppingRefineTenantSortFavoriteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.favoriteLabel.font = [UIFont ggp_regularWithSize:14];
    self.favoriteLabel.text = [@"SHOPPING_REFINE_STORE_FILTER_MY_FAVORITES" ggp_toLocalized];
    self.favoriteLabel.textColor = [UIColor ggp_darkGray];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

@end
