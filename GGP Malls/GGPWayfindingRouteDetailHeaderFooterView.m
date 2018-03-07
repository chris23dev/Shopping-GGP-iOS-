//
//  GGPWayfindingRouteDetailHeaderFooterView.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/17/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController+Wayfinding.h"
#import "GGPTenant.h"
#import "GGPWayfindingRouteDetailHeaderFooterView.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UILabel+GGPAdditions.h"
#import <JMap/JMap.h>


NSString* const GGPWayfindingRouteDetailHeaderFooterViewReuseIdentifier = @"GGPWayfindingRouteDetailHeaderFooterViewReuseIdentifier";
CGFloat const kWayfindingHeaderFooterViewHeight = 60;
CGFloat const kWayfindingFooterDisclaimerPadding = 50;

@interface GGPWayfindingRouteDetailHeaderFooterView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *tenantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenantLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;
@property (strong, nonatomic) GGPTenant *tenant;
@property (assign, nonatomic) BOOL isFooterView;

@end

@implementation GGPWayfindingRouteDetailHeaderFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureLabels];
}

- (void)configureLabels {
    [self configureDisclaimerLabel];
    [self configureTenantNameLabel];
    [self configureTenantLevelLabel];
}

- (CGFloat)configureHeightFromDisclaimer {
    NSInteger labelHeight = [self.disclaimerLabel ggp_contentHeight];
    return kWayfindingHeaderFooterViewHeight + labelHeight + kWayfindingFooterDisclaimerPadding;
}

- (void)configureViewHeight {
    CGFloat viewHeight = self.isFooterView ? [self configureHeightFromDisclaimer] : kWayfindingHeaderFooterViewHeight;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, viewHeight);
}

- (void)configureDisclaimerLabel {
    self.disclaimerLabel.hidden = YES;
    self.disclaimerLabel.numberOfLines = 0;
    self.disclaimerLabel.font = [UIFont ggp_regularWithSize:11];
    self.disclaimerLabel.textColor = [UIColor ggp_darkGray];
}

- (void)configureTenantNameLabel {
    self.tenantNameLabel.font = [UIFont ggp_regularWithSize:16];
    self.tenantNameLabel.textColor = [UIColor ggp_darkGray];
}

- (void)configureTenantLevelLabel {
    self.tenantLevelLabel.font = [UIFont ggp_regularWithSize:12];
    self.tenantLevelLabel.textColor = [UIColor ggp_darkGray];
}

- (NSString *)getLocationNameForFloor {
    JMapFloor *floor = self.isFooterView ? [[GGPJMapManager shared].mapViewController wayfindingEndFloor] : [[GGPJMapManager shared].mapViewController wayfindingStartFloor];
    return floor.locationName;
}

- (void)configureWithTenant:(GGPTenant *)tenant isFooterView:(BOOL)isFooterView {
    self.tenant = tenant;
    self.isFooterView = isFooterView;
    self.tenantNameLabel.text = self.tenant.name;
    self.tenantLevelLabel.text = [self getLocationNameForFloor];
    
    NSString *imageString = self.isFooterView ? @"ggp_icon_direction_end_pin" : @"ggp_icon_direction_start_pin";
    self.iconImageView.image = [UIImage imageNamed:imageString];
    
    if (self.isFooterView) {
        self.disclaimerLabel.hidden = NO;
        self.disclaimerLabel.text = [@"WAYFINDING_DIRECTION_LIST_DISCLAIMER" ggp_toLocalized];
        [self.disclaimerLabel sizeToFit];
    }
    
    [self configureViewHeight];
}

@end
