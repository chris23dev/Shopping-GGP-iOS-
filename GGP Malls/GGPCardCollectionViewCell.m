//
//  GGPCardCollectionViewCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCardCollectionViewCell.h"
#import "GGPEvent.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPLogoImageView.h"
#import "GGPMallManager.h"
#import "GGPPromotion.h"
#import "GGPSale.h"
#import "GGPTenant.h"
#import "GGPWayfindingViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

NSString *const GGPCardCollectionViewCellReuseIdentifier = @"GGPCardCollectionViewCellReuseIdentifier";
CGFloat const GGPCardCollectionViewCellHeight = 210;
static NSInteger const kBorderRadius = 20;

@interface GGPCardCollectionViewCell ()

@property (weak, nonatomic) IBOutlet GGPLogoImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *imageViewContainer;
@property (weak, nonatomic) IBOutlet UIView *guideMeContainer;
@property (weak, nonatomic) IBOutlet UIImageView *guideMeImageView;

@property (strong, nonatomic) GGPTenant *tenant;

@end

@implementation GGPCardCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureControls {
    self.backgroundColor = [UIColor clearColor];

    self.linkLabel.numberOfLines = 0;
    self.linkLabel.textColor = [UIColor ggp_darkGray];
    self.linkLabel.font = [UIFont ggp_regularWithSize:16];
    
    self.detailLabel.textColor = [UIColor ggp_gray];
    self.detailLabel.font = [UIFont ggp_regularWithSize:14];
    
    [self.imageViewContainer ggp_addBorderWithWidth:1 andColor:[UIColor ggp_lightGray]];
    self.imageViewContainer.backgroundColor = [UIColor whiteColor];
    self.imageView.backgroundColor = [UIColor whiteColor];
}

- (void)configureGuideMe {
    self.guideMeContainer.backgroundColor = [UIColor ggp_blue];
    self.guideMeContainer.layer.cornerRadius = kBorderRadius;
    
    self.guideMeImageView.backgroundColor = [UIColor clearColor];
    self.guideMeImageView.image = [UIImage imageNamed:@"ggp_icon_guide_me"];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(handleWayfindingTap)];
    [self.guideMeContainer addGestureRecognizer:tapRecognizer];
}

- (void)configureWithPromotion:(GGPPromotion *)promotion {
    [self configureImageViewWithURL:promotion.imageUrl andDefaultTitle:promotion.title];
    self.linkLabel.text = promotion.title;
    self.detailLabel.text = promotion.promotionDates;
    self.guideMeContainer.hidden = YES;
}

- (void)configureWithTenant:(GGPTenant *)tenant {
    self.tenant = tenant;
    
    [self configureImageViewWithURL:tenant.tenantLogoUrl andDefaultTitle:tenant.name];
    self.linkLabel.text = tenant.name;
    
    // If no location description comes back, use an empty space in order to keep our constraints consistent
    NSString *locationDescription = [[GGPJMapManager shared].mapViewController locationDescriptionForTenant:tenant];
    self.detailLabel.text = locationDescription.length > 0 ? locationDescription : @" ";
    
    [self configureGuideMe];
    
    self.guideMeContainer.hidden = ![[GGPJMapManager shared] wayfindingAvailableForTenant:self.tenant];
}

- (void)configureImageViewWithURL:(NSURL *)url andDefaultTitle:(NSString *)title {
    [self.imageView setImageWithURL:url defaultName:title];
}

- (void)handleWayfindingTap {
    if (self.onWayfindingTapped) {
        self.onWayfindingTapped(self.tenant);
    }
}

@end
