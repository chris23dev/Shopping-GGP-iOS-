//
//  GGPFavoriteTenantsCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/7/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFavoriteTenantsCell.h"
#import "GGPTenant.h"
#import "UIFont+GGPAdditions.h"

NSString *const GGPFavoriteTenantsCellReuseIdentifier = @"GGPFavoriteTenantsCellReuseIdentifier";

@interface GGPFavoriteTenantsCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartIcon;

@end

@implementation GGPFavoriteTenantsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.font = [UIFont ggp_regularWithSize:15];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
}

- (void)configureWithTenant:(GGPTenant *)tenant {
    UIImage *heartIcon = tenant.isFavorite ?
        [UIImage imageNamed:@"ggp_choose_favorites_heart_active"] :
        [UIImage imageNamed:@"ggp_choose_favorites_heart_inactive"];
    
    self.heartIcon.image = heartIcon;
    self.nameLabel.text = tenant.displayName;
}

@end
