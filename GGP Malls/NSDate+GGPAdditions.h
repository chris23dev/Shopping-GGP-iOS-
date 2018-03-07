//
//  NSDate+GGPAdditions.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (GGPAdditions)

#pragma mark - BOOL

- (BOOL)ggp_isToday;
- (BOOL)ggp_isBeforeDate:(NSDate *)date;
- (BOOL)ggp_isAfterDate:(NSDate *)date;
- (BOOL)ggp_isOnOrBeforeDate:(NSDate *)date;
- (BOOL)ggp_isOnOrAfterDate:(NSDate *)date;
- (BOOL)ggp_isBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate withGranularity:(NSCalendarUnit)calendarUnit;
- (BOOL)ggp_isEqualToDate:(NSDate *)date withGranularity:(NSCalendarUnit)calendarUnit;

#pragma mark - NSDate

+ (NSDate *)ggp_addYears:(NSInteger)numberOfYears toDate:(NSDate *)date;
+ (NSDate *)ggp_addDays:(NSInteger)numberOfDays toDate:(NSDate *)toDate;
+ (NSDate *)ggp_addHours:(NSInteger)numberOfHours toDate:(NSDate *)toDate;
+ (NSDate *)ggp_subtractDays:(NSInteger)numberOfDays fromDate:(NSDate *)fromDate;
+ (NSDate *)ggp_createDateWithMinutes:(NSInteger)minutes hour:(NSInteger)hour day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;
+ (NSDate *)ggp_roundDate:(NSDate *)date toNextHourWithMinutesThreshold:(NSInteger)minutesToRound;
+ (NSDate *)ggp_dateBySettingTimeZone:(NSString *)timeZone forDate:(NSDate *)date;
+ (NSDate *)ggp_dateBySettingHour:(NSInteger)hour forDate:(NSDate *)date;

#pragma mark - NSInteger

+ (NSInteger)ggp_daysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSInteger)ggp_integerYear;
- (NSInteger)ggp_integerMonth;
- (NSInteger)ggp_integerHour;
- (NSInteger)ggp_integerDay;

#pragma mark - NSString

+ (NSString *)ggp_currentYear;
+ (NSString *)ggp_prettyPrintStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;
+ (NSString *)ggp_formatTimeRangeForStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (NSString *)ggp_formatDateWithoutDayString:(NSDate *)date;
+ (NSString *)ggp_formatDateWithDayString:(NSDate *)date;
+ (NSString *)ggp_formatDateWithDayString:(NSDate *)date includeFullDay:(BOOL)includeFullDay;
- (NSString *)ggp_formatUserBirthday;
- (NSString *)ggp_shortDayStringFromDate;
- (NSString *)ggp_longDayStringFromDate;
- (NSString *)ggp_isoTimeStringForTimeZone:(NSString *)timeZone;
- (NSString *)ggp_monthString;

#pragma mark - NSArray

+ (NSArray *)ggp_upcomingWeekDatesForStartDate:(NSDate *)startDate;
+ (NSArray *)ggp_upcomingDatesForStartDate:(NSDate *)startDate forNumberOfDays:(NSInteger)numberOfDays;
+ (NSArray *)ggp_datesByMonthArrayForDates:(NSArray *)dates;

@end
