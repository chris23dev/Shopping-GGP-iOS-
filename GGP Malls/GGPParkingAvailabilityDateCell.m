//
//  GGPParkingAvailabilityDateCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingAvailabilityDateCell.h"
#import "NSDate+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"

NSString *const GGPParkingAvailabilityDateCellReuseIdentifier = @"GGPParkingAvailabilityDateCellReuseIdentifier";
NSInteger const GGPParkingAvailabilityDateCellWidth = 80;
NSInteger const GGPParkingAvailabilityDateCellHeight = 80;

@interface GGPParkingAvailabilityDateCell ()

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *border;
@property (weak, nonatomic) IBOutlet UIView *dropShadowView;

@end

@implementation GGPParkingAvailabilityDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureInitialState];
}

- (void)configureInitialState {
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel.font = [UIFont ggp_regularWithSize:10];
    
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.font = [UIFont ggp_lightWithSize:38];
    
    [self.dropShadowView ggp_addGradientLayerWithStartColor:[UIColor blackColor] andEndColor:[UIColor ggp_extraLightGray]];
}

- (void)configureNonSelectedState {
    self.backgroundColor = [UIColor whiteColor];
    self.dayLabel.textColor = [UIColor ggp_blue];
    self.dateLabel.textColor = [UIColor ggp_blue];
    self.dropShadowView.hidden = YES;
}

- (void)configureSelectedState {
    self.backgroundColor = [UIColor ggp_extraLightGray];
    self.dayLabel.textColor = [UIColor blackColor];
    self.dateLabel.textColor = [UIColor blackColor];
    self.dropShadowView.hidden = NO;
}

- (void)configureWithDate:(NSDate *)date isLastCell:(BOOL)isLastCell isSelected:(BOOL)isSelected {
    if (isSelected) {
        [self configureSelectedState];
    } else {
        [self configureNonSelectedState];
    }
    
    self.border.backgroundColor = isLastCell ?
        [UIColor clearColor] :
        [UIColor ggp_colorFromHexString:@"d7d7d7"];
    self.dayLabel.text = [date ggp_longDayStringFromDate].uppercaseString;
    self.dateLabel.text = @([date ggp_integerDay]).stringValue;
}

@end
