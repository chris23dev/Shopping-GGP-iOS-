//
//  GGPMovieDatesCell.m
//  GGP Malls
//
//  Created by Janet Lin on 2/3/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMovieDatesCell.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

CGFloat const GGPMovieDatesCellWidth = 73;
CGFloat const GGPMovieDatesCellHeight = 73;
NSString *const GGPMovieDatesCellReuseIdentifier = @"GGPMovieDatesCellReuseIdentifier";

@interface GGPMovieDatesCell ()
@property (weak, nonatomic) IBOutlet UIView *contentContainerView;
@property (weak, nonatomic) IBOutlet UIView *dateMonthContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *activeArrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *dayOfTheWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedBottomBorderView;
@property (weak, nonatomic) IBOutlet UIView *selectedLeftBorderView;
@property (weak, nonatomic) IBOutlet UIView *selectedRightBorderView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation GGPMovieDatesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureControls {
    self.backgroundColor = [UIColor clearColor];
    self.contentContainerView.backgroundColor = [UIColor whiteColor];
    self.monthLabel.font = [UIFont ggp_regularWithSize:12];
    self.dayOfTheWeekLabel.font = [UIFont ggp_boldWithSize:12];
    self.dayOfTheWeekLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont ggp_boldWithSize:25];
}

- (void)configureWithDate:(NSDate *)date isActive:(BOOL)isActive {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE"];
    self.dayOfTheWeekLabel.text = [[formatter stringFromDate:date] uppercaseString];
    
    [formatter setDateFormat:@"d"];
    self.dateLabel.text = [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"MMM"];
    self.monthLabel.text = [[formatter stringFromDate:date] uppercaseString];
    
    if (isActive) {
        [self setActiveStyle];
    } else {
        [self setInactiveStyle];
    }
}

- (void)setActiveStyle {
    self.activeArrowImageView.hidden = NO;
    self.selectedBottomBorderView.backgroundColor = [UIColor ggp_colorFromHexString:@"#C1C1C1"];
    self.selectedLeftBorderView.backgroundColor = [UIColor ggp_colorFromHexString:@"#C1C1C1"];
    self.selectedRightBorderView.backgroundColor = [UIColor ggp_colorFromHexString:@"#C1C1C1"];
    self.dateMonthContainerView.backgroundColor = [UIColor whiteColor];
    self.dayOfTheWeekLabel.backgroundColor = [UIColor ggp_blue];
    
    self.monthLabel.textColor = [UIColor ggp_darkGray];
    self.dateLabel.textColor = [UIColor ggp_darkGray];
}

- (void)setInactiveStyle {
    self.activeArrowImageView.hidden = YES;
    self.selectedBottomBorderView.backgroundColor = [UIColor clearColor];
    self.selectedRightBorderView.backgroundColor = [UIColor clearColor];
    self.selectedLeftBorderView.backgroundColor = [UIColor clearColor];
    self.dateMonthContainerView.backgroundColor = [UIColor ggp_colorFromHexString:@"#3C3C3C"];
    self.dayOfTheWeekLabel.backgroundColor = [UIColor ggp_colorFromHexString:@"#262626"];
    
    self.monthLabel.textColor = [UIColor whiteColor];
    self.dateLabel.textColor = [UIColor whiteColor];
}

@end
