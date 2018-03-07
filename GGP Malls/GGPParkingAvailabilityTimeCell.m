//
//  GGPParkingAvailabilityTimeCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCellData.h"
#import "GGPParkingAvailabilityTimeCell.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"


NSString *const GGPParkingAvailabilityTimeCellReuseIdentifier = @"GGPParkingAvailabilityTimeCellReuseIdentifier";
NSInteger const GGPParkingAvailabilityTimeCellHeight = 80;

@interface GGPParkingAvailabilityTimeCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;
@property (weak, nonatomic) IBOutlet UIView *border;
@property (weak, nonatomic) IBOutlet UIView *dropShadowView;

@end

@implementation GGPParkingAvailabilityTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureInitialState];
}

- (void)configureInitialState {
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont ggp_regularWithSize:10];
    
    [self.dropShadowView ggp_addGradientLayerWithStartColor:[UIColor blackColor] andEndColor:[UIColor ggp_extraLightGray]];
}

- (void)configureNonSelectedState {
    self.backgroundColor = [UIColor whiteColor];
    self.timeLabel.textColor = [UIColor ggp_blue];
    self.dropShadowView.hidden = YES;
}

- (void)configureSelectedState {
    self.backgroundColor = [UIColor ggp_extraLightGray];
    self.timeLabel.textColor = [UIColor blackColor];
    self.dropShadowView.hidden = NO;
}

- (void)configureWithTimeData:(GGPCellData *)timeData isLastCell:(BOOL)isLastCell isSelected:(BOOL)isSelected {
    if (isSelected) {
        [self configureSelectedState];
    } else {
        [self configureNonSelectedState];
    }
    
    self.border.backgroundColor = isLastCell ? [UIColor clearColor] : [UIColor ggp_colorFromHexString:@"d7d7d7"];
    self.timeIcon.image = isSelected ? timeData.activeImage : timeData.inactiveImage;
    self.timeLabel.text = timeData.title.uppercaseString;
}

@end
