//
//  GGPHours.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/9/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPExceptionHours.h"
#import "GGPHours.h"
#import "NSArray+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

static NSString *const kEnDash = @"\u2013";

@implementation GGPHours

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"isOpen": @"open",
              @"openTime": @"openTime",
              @"closeTime": @"closeTime",
              @"startDay": @"startDay",
              @"endDay": @"endDay" };
}

- (NSString *)prettyPrintOpenHoursRange {
    NSDateFormatter *hourFormatter = [NSDateFormatter new];
    hourFormatter.dateFormat = @"HH:mm";
    NSDate *startDate = [hourFormatter dateFromString:self.openTime];
    NSDate *endDate = [hourFormatter dateFromString:self.closeTime];
    
    NSDateFormatter *displayFormatter = [NSDateFormatter new];
    displayFormatter.dateFormat = @"h:mm a";
    [displayFormatter setAMSymbol:@"am"];
    [displayFormatter setPMSymbol:@"pm"];
    
    NSString *startString = [displayFormatter stringFromDate:startDate];
    NSString *endString = [displayFormatter stringFromDate:endDate];
    
    return self.isOpen ? [NSString stringWithFormat:@"%@ %@ %@", startString, kEnDash, endString] : [@"DETAILS_HOURS_CLOSED_LABEL" ggp_toLocalized];
}

/**
 *  Pretty print start date for hours
 *
 *  @return start / end dates come back from the server as: "MON" "TUES", etc. 
    Convert em to nice full string dates by converting to date and then extracting dateFromString
 */
- (NSString *)prettyPrintStartDate {
    NSDateFormatter *weekdayFormatter = [NSDateFormatter new];
    [weekdayFormatter setDateFormat:@"EEEE"];
    NSDate *date = [weekdayFormatter dateFromString:self.startDay];
    return [date ggp_longDayStringFromDate];
}

/**
 *  @return operating hours for input date unless exception hours exist for specified date, returns exception hours
 *          operating hours may be empty, but isOpen should indicate whether closed for input date
 *          returns nil if no hours/exception hours are specified
 */
+ (NSArray *)openHoursForDate:(NSDate *)date hours:(NSArray *)hours andExceptionHours:(NSArray *)exceptionHours {
    for (GGPExceptionHours *hoursException in exceptionHours) {
        if ([hoursException isValidForDate:date]) {
            return @[hoursException];
        }
    }
    
    NSString *currentWeekday = [date ggp_shortDayStringFromDate];
    return [hours ggp_arrayWithFilter:^BOOL(GGPHours *hours) {
        return [hours.startDay isEqualToString:currentWeekday];
    }];
}

- (NSDate *)dateForStartDay {
    NSDate *today = [NSDate date];
    for (NSDate *date in [NSDate ggp_upcomingWeekDatesForStartDate:today]) {
        if ([self.startDay isEqualToString:[date ggp_shortDayStringFromDate]]) {
            return date;
        }
    }
    return nil;
}

@end
