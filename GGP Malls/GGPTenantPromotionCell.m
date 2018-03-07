//
//  GGPTenantPromotionCell.m
//  GGP Malls
//
//  Created by Janet Lin on 1/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantPromotionCell.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

NSString* const GGPTenantPromotionCellReuseIdentifier = @"GGPTenantPromotionCellReuseIdentifier";
CGFloat const GGPTenantPromotionCellRowHeight = 120.0f;

@interface GGPTenantPromotionCell ()
@property (weak, nonatomic) IBOutlet UIView *cellSeparatorLineView;
@property (weak, nonatomic) IBOutlet UIImageView *promoImageView;
@property (weak, nonatomic) IBOutlet UILabel *promoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoDateLabel;
@end

@implementation GGPTenantPromotionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupTextStyling];
}

- (void)setupTextStyling {
    self.promoTitleLabel.font = [UIFont ggp_boldWithSize:16];
    self.promoTitleLabel.textColor = [UIColor ggp_blue];
    
    self.promoDateLabel.font = [UIFont ggp_lightWithSize:16];
    self.promoDateLabel.textColor = [UIColor blackColor];
}

- (void)configureCellWithPromotion:(GGPPromotion *)promo isFirstCell:(BOOL)isFirstCell {
    self.promoImageView.image = nil;
    self.promoTitleLabel.text = promo.title;
    self.promoDateLabel.text = promo.promotionDates;
    self.cellSeparatorLineView.hidden = isFirstCell;
    NSURL *imageURL = promo.imageUrl;
    if (imageURL) {
        [self.promoImageView setImageWithURL:promo.imageUrl];
    }
}

@end
