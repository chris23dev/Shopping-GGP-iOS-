//
//  NSDate+GGPAdditions.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "NSArray+GGPAdditions.h"

static NSString* const kShortDateFormat = @"MMM d";
static NSString* const kDateWithShortDayFormat = @"EEE, MMM d";
static NSString* const kDateWithFullDayFormat = @"EEEE, MMM d";
static NSString* const kDateWithYearFormat = @"MMM d, yyyy";
static NSString *const kISODateFormat = @"yyyy-MM-dd'T'HH:mm";
static NSInteger const kNumberOfDaysBeforeOngoing = 90;
static NSInteger const kMinutesToRound = 59;
static NSInteger const kDaysInWeek = 7;

static NSString *const kEnDashCharacter = @"\u2013";

@implementation NSDate (GGPAdditions)

#pragma mark - BOOL

- (BOOL)ggp_isBeforeDate:(NSDate *)date {
    NSComparisonResult result = [[NSCalendar currentCalendar] compareDate:self toDate:date toUnitGranularity:NSCalendarUnitDay];
    return result == NSOrderedAscending;
}

- (BOOL)ggp_isAfterDate:(NSDate *)date {
    NSComparisonResult result = [[NSCalendar currentCalendar] compareDate:self toDate:date toUnitGranularity:NSCalendarUnitDay];
    return result == NSOrderedDescending;
}

- (BOOL)ggp_isOnOrBeforeDate:(NSDate *)date {
    return [self ggp_isOnOrBeforeDate:date withGranularity:NSCalendarUnitDay];
}

- (BOOL)ggp_isOnOrAfterDate:(NSDate *)date {
    return [self ggp_isOnOrAfterDate:date withGranularity:NSCalendarUnitDay];
}

- (BOOL)ggp_isOnOrBeforeDate:(NSDate *)date withGranularity:(NSCalendarUnit)calendarUnit {
    NSComparisonResult result = [[NSCalendar currentCalendar] compareDate:self toDate:date toUnitGranularity:calendarUnit];
    return result != NSOrderedDescending;
}

- (BOOL)ggp_isOnOrAfterDate:(NSDate *)date withGranularity:(NSCalendarUnit)calendarUnit {
    NSComparisonResult result = [[NSCalendar currentCalendar] compareDate:self toDate:date toUnitGranularity:calendarUnit];
    return result != NSOrderedAscending;
}

- (BOOL)ggp_isEqualToDate:(NSDate *)date withGranularity:(NSCalendarUnit)calendarUnit {
    NSComparisonResult result = [[NSCalendar currentCalendar] compareDate:self toDate:date toUnitGranularity:calendarUnit];
    return result == NSOrderedSame;
}

- (BOOL)ggp_isBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate withGranularity:(NSCalendarUnit)calendarUnit {
    return [self ggp_isOnOrAfterDate:startDate withGranularity:calendarUnit] && [self ggp_isOnOrBeforeDate:endDate withGranularity:calendarUnit];
}

- (BOOL)ggp_isToday {
    return [[NSCalendar currentCalendar] isDateInToday:self];
}

- (BOOL)ggp_isEqualToDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    NSDateComponents *startComponent = [calendar components:unitFlags fromDate:self];
    NSDateComponents *endComponent = [calendar components:unitFlags fromDate:date];
    return startComponent.month == endComponent.month && startComponent.day == endComponent.day && startComponent.hour == endComponent.hour;
}

- (BOOL)ggp_hasSameMonthAndDayAsDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *startComponent = [calendar components:unitFlags fromDate:self];
    NSDateComponents *endComponent = [calendar components:unitFlags fromDate:date];
    return startComponent.month == endComponent.month && startComponent.day == endComponent.day;
}

- (BOOL)ggp_hasSameHourAsDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitHour;
    NSDateComponents *startComponent = [calendar components:unitFlags fromDate:self];
    NSDateComponents *endComponent = [calendar components:unitFlags fromDate:date];
    return startComponent.hour == endComponent.hour;
}

#pragma mark - NSDate

+ (NSDate *)ggp_addYears:(NSInteger)numberOfYears toDate:(NSDate *)date {
    NSDateComponents *yearComponent = [NSDateComponents new];
    yearComponent.year = numberOfYears;
    return [[NSCalendar currentCalendar] dateByAddingComponents:yearComponent toDate:date options:0];
}

+ (NSDate *)ggp_subtractDays:(NSInteger)numberOfDays fromDate:(NSDate *)fromDate {
    return [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:-numberOfDays toDate:fromDate options:0];
}

+ (NSDate *)ggp_addDays:(NSInteger)numberOfDays toDate:(NSDate *)toDate {
    return [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:numberOfDays toDate:toDate options:0];
}

+ (NSDate *)ggp_addHours:(NSInteger)numberOfHours toDate:(NSDate *)toDate {
    return [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitHour value:numberOfHours toDate:toDate options:0];
}

+ (NSDate *)ggp_roundDate:(NSDate *)date toNextHourWithMinutesThreshold:(NSInteger)minutesToRound {
    NSInteger minutes = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:date].minute;
    return minutes >= minutesToRound ? [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMinute value:60-minutes toDate:date options:0] : date;
}

+ (NSDate *)ggp_createDateWithMinutes:(NSInteger)minutes hour:(NSInteger)hour day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:minutes];
    [components setHour:hour];
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

+ (NSDate *)ggp_dateBySettingHour:(NSInteger)hour forDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateBySettingHour:hour minute:0 second:0 ofDate:date options:0];
}

+ (NSDate *)ggp_startOfDayForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar startOfDayForDate:date];
}

#pragma mark - NSInteger

+ (NSInteger)ggp_daysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSDate *from;
    NSDate *to;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&from interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&to interval:NULL forDate:toDate];
    
    return abs((int)[calendar components:NSCalendarUnitDay fromDate:from toDate:to options:0].day);
}


- (NSInteger)ggp_integerYear {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self].year;
}

- (NSInteger)ggp_integerMonth {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self].month;
}

- (NSInteger)ggp_integerDay {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self].day;
}

- (NSInteger)ggp_integerHour {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self].hour;
}

- (NSInteger)ggp_integerMinutes {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self].minute;
}

#pragma mark - NSString

+ (NSString *)ggp_currentYear {
    NSDateFormatter *yearFormatter = [NSDateFormatter new];
    yearFormatter.dateFormat = @"yyyy";
    return [yearFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)ggp_prettyPrintStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    if ([endDate ggp_integerMinutes] == kMinutesToRound) {
        endDate = [NSDate ggp_startOfDayForDate:endDate];
    }
    
    if (!startDate && !endDate) {
        return nil;
    } else if (!startDate) {
        startDate = endDate;
    } else if (!endDate) {
        endDate = startDate;
    }
    
    NSString *timeRange = [self ggp_formatTimeRangeForStartDate:startDate endDate:endDate];
    BOOL includeDayOfWeek = timeRange != nil;
    NSString *dateRange = [self ggp_formatPromotionDateRange:startDate endDate:endDate includeDayOfWeek:includeDayOfWeek];
    NSString *dateRangeWithTimeRange = [NSString stringWithFormat:@"%@: %@", dateRange, timeRange];
    return [NSString stringWithFormat:@"%@", timeRange.length ? dateRangeWithTimeRange : dateRange];
}

+ (NSString *)ggp_formatTimeRangeForStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSDateFormatter *dayFormatter = [NSDateFormatter new];
    dayFormatter.timeStyle = kCFDateFormatterShortStyle;
    if ([startDate ggp_hasSameHourAsDate:endDate]) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@ %@ %@", [[dayFormatter stringFromDate:startDate] uppercaseString], kEnDashCharacter, [[dayFormatter stringFromDate:endDate] uppercaseString]];
}

+ (NSString *)ggp_formatPromotionDateRange:(NSDate *)startDate endDate:(NSDate *)endDate includeDayOfWeek:(BOOL)includeDayOfWeek {
    BOOL usesSingleDateRange = !startDate || !endDate || [startDate ggp_hasSameMonthAndDayAsDate:endDate];
    return usesSingleDateRange ? [self ggp_formatSingleDateRange:startDate endDate:endDate] : [self ggp_formatMultiDayDateRange:startDate endDate:endDate includeDayOfWeek:includeDayOfWeek];
}

+ (NSString *)ggp_formatSingleDateRange:(NSDate *)startDate endDate:(NSDate *)endDate {
    if (!startDate && !endDate) {
        return nil;
    }
    
    NSDate *today = [NSDate new];
    NSDate *singleDate = startDate ? startDate : endDate;
    return [singleDate ggp_hasSameMonthAndDayAsDate:today] ? [@"DATE_TODAY_STRING" ggp_toLocalized] : [self ggp_formatDateWithDayString:singleDate].uppercaseString;
}

+ (NSString *)ggp_formatDateWithDayString:(NSDate *)date {
    return [self ggp_formatDateWithDayString:date includeFullDay:NO];
}

+ (NSString *)ggp_formatDateWithDayString:(NSDate *)date includeFullDay:(BOOL)includeFullDay {
    NSDateFormatter *dayFormatter = [NSDateFormatter new];
    dayFormatter.dateFormat = includeFullDay ? kDateWithFullDayFormat : kDateWithShortDayFormat;
    return [dayFormatter stringFromDate:date];
}

+ (NSString *)ggp_formatDateWithoutDayString:(NSDate *)date {
    NSDateFormatter *rangeFormatter = [NSDateFormatter new];
    rangeFormatter.dateFormat = kShortDateFormat;
    return [[rangeFormatter stringFromDate:date] uppercaseString];
}

+ (NSString *)ggp_formatMultiDayDateRange:(NSDate *)startDate endDate:(NSDate *)endDate includeDayOfWeek:(BOOL)includeDayOfWeek {
    NSDate *today = [NSDate new];
    NSDate *ongoingCutOffDate = [self ggp_addDays:kNumberOfDaysBeforeOngoing toDate:today];
    NSString *startString;
    NSString *endString;
    
    if ([startDate ggp_isOnOrBeforeDate:today]) {
        if ([endDate ggp_isOnOrAfterDate:ongoingCutOffDate]) {
            return [@"DATE_ONGOING_STRING" ggp_toLocalized];
        }
        startString = [@"DATE_NOW_STRING" ggp_toLocalized];
    } else {
        startString = includeDayOfWeek ? [self ggp_formatDateWithDayString:startDate].uppercaseString : [self ggp_formatDateWithoutDayString:startDate];
    }
    
    endString = includeDayOfWeek ? [self ggp_formatDateWithDayString:endDate].uppercaseString : [self ggp_formatDateWithoutDayString:endDate];
    
    return [NSString stringWithFormat:@"%@ %@ %@", startString, kEnDashCharacter, endString];
}

- (NSString *)ggp_formatUserBirthday {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateWithYearFormat];
    return [formatter stringFromDate:self];
}

- (NSString *)ggp_shortDayStringFromDate {
    NSDateFormatter *weekdayFormatter = [NSDateFormatter new];
    [weekdayFormatter setDateFormat:@"EEE"];
    return [weekdayFormatter stringFromDate:self].uppercaseString;
}

- (NSString *)ggp_longDayStringFromDate {
    NSDateFormatter *weekdayFormatter = [NSDateFormatter new];
    [weekdayFormatter setDateFormat:@"EEEE"];
    return [weekdayFormatter stringFromDate:self];
}

- (NSString *)ggp_monthString {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"MMMM";
    return [dateFormatter stringFromDate:self];
}

#pragma mark - NSArray

+ (NSArray *)ggp_upcomingWeekDatesForStartDate:(NSDate *)startDate {
    return [self ggp_upcomingDatesForStartDate:startDate forNumberOfDays:kDaysInWeek];
}

+ (NSArray *)ggp_upcomingDatesForStartDate:(NSDate *)startDate forNumberOfDays:(NSInteger)numberOfDays {
    NSMutableArray *dates = [NSMutableArray new];
    for (int iteration = 0; iteration < numberOfDays; iteration++) {
        [dates addObject:[NSDate ggp_addDays:iteration toDate:startDate]];
    }
    return dates;
}

+ (NSArray *)ggp_datesByMonthArrayForDates:(NSArray *)dates {
    NSMutableArray *arrayOfMonths = [NSMutableArray new];
    NSMutableArray *currentMonth = [NSMutableArray new];
    dates = [dates ggp_sortListAscendingForKey:@"self"];
    
    NSDate *firstMonth = dates.firstObject;
    NSInteger currentMonthInteger = firstMonth.ggp_integerMonth;
    
    for (NSDate *date in dates) {
        if (date.ggp_integerMonth != currentMonthInteger) {
            [arrayOfMonths addObject:currentMonth];
            
            currentMonth = [NSMutableArray new];
            currentMonthInteger = [date ggp_integerMonth];
        }
        [currentMonth addObject:date];
    }
    
    [arrayOfMonths addObject:currentMonth];
    return arrayOfMonths;
}

#pragma mark - Parking

+ (NSDate *)ggp_dateBySettingTimeZone:(NSString *)timeZone forDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = kISODateFormat;
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:timeZone];
    return [dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
}

- (NSString *)ggp_isoTimeStringForTimeZone:(NSString *)timeZone {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = kISODateFormat;
    
    if (timeZone) {
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:timeZone];
    }
    
    return [dateFormatter stringFromDate:self];
}

@end
