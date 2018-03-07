//
//  GGPHomeChooseFavoritesTableViewCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPChooseFavoritesCell.h"
#import "GGPTenant.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

NSString *const GGChooseFavoritesCellReuseIdentifier = @"GGChooseFavoritesCellReuseIdentifier";

@interface GGPChooseFavoritesCell ()

@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartIcon;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation GGPChooseFavoritesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureControls {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headingLabel.numberOfLines = 0;
    self.headingLabel.textAlignment = NSTextAlignmentCenter;
    self.headingLabel.font = [UIFont ggp_regularWithSize:16];
    
    self.heartIcon.image = [UIImage imageNamed:@"ggp_tenant_heart_red"];
    
    [self.button ggp_styleAsDarkActionButton];
}

- (void)configureWithTenants:(NSArray *)tenants {
    NSArray *favoriteTenants = [tenants ggp_arrayWithFilter:^BOOL(GGPTenant *tenant) {
        return tenant.isFavorite;
    }];
    
    if (favoriteTenants.count == 0) {
        self.headingLabel.text = [@"CHOOSE_FAVORITES_TITLE_NO_FAVORITES" ggp_toLocalized];
        [self.button setTitle:[@"CHOOSE_FAVORITES_BUTTON_NO_FAVORITES" ggp_toLocalized] forState:UIControlStateNormal];
    } else {
        self.headingLabel.text = [@"CHOOSE_FAVORITES_TITLE_NO_SALES" ggp_toLocalized];
        [self.button setTitle:[@"CHOOSE_FAVORITES_BUTTON_NO_SALES" ggp_toLocalized] forState:UIControlStateNormal];
    }
}

- (IBAction)onChooseFavoritesTap:(id)sender {
    if (self.onChooseFavoritesTapped) {
        self.onChooseFavoritesTapped();
    }
}

@end
