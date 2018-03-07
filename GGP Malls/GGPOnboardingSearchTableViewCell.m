//
//  GGPOnboardingSearchTableViewCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/1/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAddress.h"
#import "GGPMall.h"
#import "GGPOnboardingSearchTableViewCell.h"
#import "UIColor+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPOnboardingSearchTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *mallNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mallLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *mallDistanceLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end

@implementation GGPOnboardingSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
    [self styleControls];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureCellWithMall:(GGPMall *)mall andIsLastCellInSection:(BOOL)isLastCell {
    self.mallNameLabel.text = mall.name;
    
    self.mallLocationLabel.hidden = !mall.cityStateAddress.length;
    self.mallLocationLabel.text = mall.cityStateAddress;
    
    self.separatorView.hidden = isLastCell;
    
    if (mall.distance) {
        self.mallDistanceLabel.text = mall.distanceString;
        [self.mallDistanceLabel ggp_expandHorizontally];
    } else  {
        [self.mallDistanceLabel ggp_collapseHorizontally];
    }
}

- (void)styleControls {
    self.backgroundColor = [UIColor clearColor];
    
    self.mallNameLabel.textColor = [UIColor ggp_extraLightGray];
    self.mallDistanceLabel.textColor = [UIColor ggp_timberWolfGray];
    self.mallLocationLabel.textColor = [UIColor ggp_pastelGray];
    
    self.separatorView.backgroundColor = [UIColor ggp_manateeGray];
}

- (void)configureControls {
    self.mallNameLabel.font = [UIFont ggp_regularWithSize:17];
    self.mallDistanceLabel.font = [UIFont ggp_lightWithSize:17];
    self.mallLocationLabel.font = [UIFont ggp_regularWithSize:13];
}

@end
