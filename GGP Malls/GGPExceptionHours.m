//
//  GGPExceptionHours.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/24/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPExceptionHours.h"
#import "NSDate+GGPAdditions.h"

static NSString *const kMonthDayYearFormat = @"MM/dd/yyyy";
static NSString *const kYearMonthDayFormat = @"yyyy-MM-dd";

@implementation GGPExceptionHours

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"isOpen": @"open",
              @"openTime": @"openTime",
              @"closeTime": @"closeTime",
              @"startMonthDay": @"startMonthDay",
              @"endMonthDay": @"endMonthDay",
              @"validUntilDate": @"validUntilDate",
              @"holidayName": @"holidayName", };
}

- (NSString *)startDay {
    return [[self dateForStartDay] ggp_shortDayStringFromDate];
}

- (BOOL)isValidForDate:(NSDate *)date {
    NSDateFormatter *monthDayFormatter = [NSDateFormatter new];
    [monthDayFormatter setDateFormat:kMonthDayYearFormat];
    NSDateFormatter *yearMonthDayFormatter = [NSDateFormatter new];
    [yearMonthDayFormatter setDateFormat:kYearMonthDayFormat];
    
    NSString *specifiedYear = [NSString stringWithFormat:@"%ld", (long)[[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:date]];
    
    NSDate *validUntilDate = [yearMonthDayFormatter dateFromString:self.validUntilDate];
    NSDate *startDate = [monthDayFormatter dateFromString:[NSString stringWithFormat:@"%@/%@", self.startMonthDay, specifiedYear]];
    
    if ([validUntilDate ggp_isBeforeDate:date]) {
        return NO;
    }
    
    return [date ggp_isEqualToDate:startDate withGranularity:NSCalendarUnitDay];
}

- (NSDate *)dateForStartDay {
    NSDateFormatter *monthDayFormatter = [NSDateFormatter new];
    [monthDayFormatter setDateFormat:kMonthDayYearFormat];
    
    NSDate *startDate = [monthDayFormatter dateFromString:[NSString stringWithFormat:@"%@/%@", self.startMonthDay, [NSDate ggp_currentYear]]];
    
    if ([startDate ggp_isBeforeDate:[NSDate date]]) {
        startDate = [NSDate ggp_addYears:1 toDate:startDate];
    }
    
    return startDate;
}

@end
