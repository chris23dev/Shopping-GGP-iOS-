//
//  GGPHolidayHoursCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPHours.h"
#import "GGPMallHourCell.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "GGPExceptionHours.h"
#import "UIView+GGPAdditions.h"

NSString *const GGPMallHourCellReuseIdentifier = @"GGPMallHourCellReuseIdentifier";

@interface GGPMallHourCell ()

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameBottomConstraint;

@end

@implementation GGPMallHourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureCell];
}

- (void)configureCell {
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    
    self.dayLabel.textAlignment = NSTextAlignmentLeft;
    self.dayLabel.font = [UIFont ggp_regularWithSize:15];
    self.dayLabel.textColor = [UIColor ggp_mediumGray];
    
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    self.dateLabel.font = [UIFont ggp_regularWithSize:15];
    self.dateLabel.textColor = [UIColor ggp_mediumGray];
    
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont ggp_regularWithSize:15];
    self.nameLabel.textColor = [UIColor blackColor];
    
    self.hourLabel.numberOfLines = 0;
    self.hourLabel.textAlignment = NSTextAlignmentRight;
    self.hourLabel.font = [UIFont ggp_regularWithSize:15];
    self.hourLabel.textColor = [UIColor ggp_mediumGray];
}

- (void)configureWithHours:(NSArray *)hours date:(NSDate *)date isActive:(BOOL)isActive {
    self.dateLabel.text = [NSDate ggp_formatDateWithoutDayString:date].capitalizedString;
    [self configureHoursLabelForHours:hours];
    [self configureNameLabelForHours:hours];
    [self configureLabelsForActiveState:isActive];
}

- (void)configureHoursLabelForHours:(NSArray *)hours {
    self.dayLabel.text = [self dayLabelForHours:hours];
    self.hourLabel.text = [self formattedOpenHoursStringForHours:hours];
}

- (NSString *)dayLabelForHours:(NSArray *)hours {
    GGPHours *hour = hours.firstObject;
    return hour.startDay.capitalizedString;
}

- (NSString *)formattedOpenHoursStringForHours:(NSArray *)hours {
    NSString *finalHourString = @"";
    for (GGPHours *hour in hours) {
        NSString *hourLabel = [NSString stringWithFormat:@"%@\n", hour.prettyPrintOpenHoursRange];
        finalHourString = [finalHourString stringByAppendingString:hourLabel];
        
    }
    return [finalHourString ggp_removeTrailingNewLine];
}

- (void)configureNameLabelForHours:(NSArray *)hours {
    GGPExceptionHours *hour = hours.firstObject;
    if ([hour isKindOfClass:GGPExceptionHours.class] && hour.holidayName) {
        self.nameLabel.text = hour.holidayName;
        self.nameBottomConstraint.constant = 10;
    } else {
        self.nameLabel.text = nil;
        self.nameBottomConstraint.constant = 2;
    }
}

- (void)configureLabelsForActiveState:(BOOL)isActive {
    UIColor *colorForActiveState = isActive ? [UIColor blackColor] : [UIColor ggp_mediumGray];
    self.dayLabel.textColor = colorForActiveState;
    self.dateLabel.textColor = colorForActiveState;
    self.hourLabel.textColor = colorForActiveState;
}

@end
