//
//  GGPHomePromotionTableViewCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/3/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPEvent.h"
#import "GGPHomePromotionTableViewCell.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPPromotion.h"
#import "GGPSale.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIImage+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

NSString *const GGPHomePromotionTableViewCellReuseIdentifier = @"GGPHomePromotionTableViewCellReuseIdentifier";
CGFloat const kTitleLabelTopMargin = 10;

@interface GGPHomePromotionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *promotionImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *postOptionsHitContainer;
@property (weak, nonatomic) IBOutlet UIImageView *postOptionsIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *dividerView;

@property (strong, nonatomic) GGPPromotion *promotion;

@end

@implementation GGPHomePromotionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureWithPromotion:(GGPPromotion *)promotion andImage:(UIImage *)image {
    if (self.promotion == promotion) {
        return;
    }
    
    self.promotion = promotion;
    self.promotionImageView.image = image;
    self.titleLabelTopConstraint.constant = image.size.height > 0 ? kTitleLabelTopMargin : 0;
    
    [self configureText];
}

- (void)configureText {
    self.locationLabel.text = self.promotion.tenant ? self.promotion.tenant.name.uppercaseString : self.promotion.location.uppercaseString;
    self.titleLabel.text = self.promotion.title;
    self.dateLabel.text = self.promotion.promotionDates;
}

- (void)configureControls {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.clipsToBounds = YES;
    
    self.locationLabel.textColor = [UIColor ggp_darkGray];
    self.locationLabel.font = [UIFont ggp_mediumWithSize:14];
    
    self.titleLabel.textColor = [UIColor ggp_darkGray];
    self.titleLabel.font = [UIFont ggp_regularWithSize:16];
    
    self.dateLabel.textColor = [UIColor ggp_gray];
    self.dateLabel.font = [UIFont ggp_regularWithSize:14];
    
    self.dividerView.backgroundColor = [UIColor ggp_gainsboroGray];
    
    [self configureShareIcon];
}

- (void)configureShareIcon {
    self.postOptionsIcon.image = [UIImage imageNamed:@"ggp_icon_post_options_indicator"];
    
    self.postOptionsHitContainer.userInteractionEnabled = YES;
    UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareIconTapped)];
    [self.postOptionsHitContainer addGestureRecognizer:shareTap];
}

- (void)shareIconTapped {
    [self.cellDelegate didTapPostOptionsWithPromotion:self.promotion];
}

@end
