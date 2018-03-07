//
//  NSDate+GGPAdditionsTests.m
//  GGP Malls
//
//  Created by Janet Lin on 1/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "NSDate+GGPAdditions.h"

static NSString *const kEnDashCharacter = @"\u2013";

@interface NSDate_GGPAdditionsTests : XCTestCase

@property NSDate *yesterday;
@property NSDate *today;
@property NSDate *tomorrow;
@property NSDate *ninetyDaysFuture;

@end

@implementation NSDate_GGPAdditionsTests

- (void)setUp {
    self.today = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
    self.yesterday = [NSDate ggp_subtractDays:1 fromDate:self.today];
    self.tomorrow = [NSDate ggp_addDays:1 toDate:self.today];
    self.ninetyDaysFuture = [NSDate ggp_addDays:90 toDate:self.today];
}

- (void)tearDown {
    self.today = nil;
    self.yesterday = nil;
    self.tomorrow = nil;
    self.ninetyDaysFuture = nil;
}

- (void)testIsBeforeDate {
    XCTAssertTrue([self.yesterday ggp_isBeforeDate:self.tomorrow]);
    XCTAssertFalse([self.yesterday ggp_isBeforeDate:self.yesterday]);
    XCTAssertFalse([self.tomorrow ggp_isBeforeDate:self.yesterday]);
}

- (void)testIsAfterDate {
    XCTAssertFalse([self.yesterday ggp_isAfterDate:self.tomorrow]);
    XCTAssertFalse([self.yesterday ggp_isAfterDate:self.yesterday]);
    XCTAssertTrue([self.tomorrow ggp_isAfterDate:self.yesterday]);
}

- (void)testIsOnOrBeforeDate {
    XCTAssertTrue([self.today ggp_isOnOrBeforeDate:self.today]);
    XCTAssertTrue([self.tomorrow ggp_isOnOrBeforeDate:self.tomorrow]);
    XCTAssertFalse([self.tomorrow ggp_isOnOrBeforeDate:self.yesterday]);
}

- (void)testIsOnOrAfterDate {
    XCTAssertFalse([self.yesterday ggp_isOnOrAfterDate:self.tomorrow]);
    XCTAssertTrue([self.tomorrow ggp_isOnOrAfterDate:self.today]);
    XCTAssertTrue([self.tomorrow ggp_isOnOrAfterDate:self.yesterday]);
}

- (void)testIsBetweenStartAndEndDate {
    XCTAssertTrue([self.today ggp_isBetweenStartDate:self.yesterday andEndDate:self.tomorrow withGranularity:NSCalendarUnitDay]);
    XCTAssertFalse([self.yesterday ggp_isBetweenStartDate:self.tomorrow andEndDate:self.tomorrow withGranularity:NSCalendarUnitDay]);
}

- (void)testDaysFromNow {
    NSDate *now = [NSDate date];
    XCTAssertEqual(0, [NSDate ggp_daysFromDate:now toDate:now]);
    XCTAssertEqual(1, [NSDate ggp_daysFromDate:now toDate:[NSDate ggp_addDays:1 toDate:now]]);
    XCTAssertEqual(3, [NSDate ggp_daysFromDate:now toDate:[NSDate ggp_addDays:3 toDate:now]]);
    XCTAssertEqual(3, [NSDate ggp_daysFromDate:now toDate:[NSDate ggp_addDays:-3 toDate:now]]);
}

- (void)testNSDatePrettyPrintOnlyEndDate {
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:nil andEndDate:self.tomorrow], [NSDate ggp_formatDateWithDayString:self.tomorrow].uppercaseString);
}

- (void)testNSDatePrettyPrintStartDate {
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.tomorrow andEndDate:nil], [NSDate ggp_formatDateWithDayString:self.tomorrow].uppercaseString);
}

- (void)testNSDatePrettyPrintNoDatesAvailable {
    XCTAssertNil([NSDate ggp_prettyPrintStartDate:nil andEndDate:nil]);
}

- (void)testNSDatePrettyPrintDifferentDatesBothInFuture {
    NSDate *futureDate = [NSDate ggp_addDays:1 toDate:self.tomorrow];
    NSString *expectedString = [NSString stringWithFormat:@"%@ %@ %@", [NSDate ggp_formatDateWithoutDayString:self.tomorrow ], kEnDashCharacter, [NSDate ggp_formatDateWithoutDayString:futureDate]];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.tomorrow andEndDate:futureDate], expectedString);
}

- (void)testNSDatePrettyPrintSameDateIsToday {
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.today andEndDate:self.today], @"TODAY");
}

- (void)testNSDatePrettyPrintSameDateIsYesterday {
    NSDate *sameDate = self.yesterday;
    NSString *expectedString = [NSString stringWithFormat:@"%@", [NSDate ggp_formatDateWithDayString:sameDate].uppercaseString];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:sameDate andEndDate:sameDate], expectedString);
}

- (void)testNSDatePrettyPrintSameDateIsTomorrow {
    NSString *expectedString = [NSString stringWithFormat:@"%@", [NSDate ggp_formatDateWithDayString:self.tomorrow].uppercaseString];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.tomorrow andEndDate:self.tomorrow], expectedString);
}

- (void)testNSDatePrettyPrintStartDateIsBeforeTodayEndDateIsAfterToday {
    NSString *expectedString = [NSString stringWithFormat:@"NOW %@ %@", kEnDashCharacter, [NSDate ggp_formatDateWithoutDayString:self.tomorrow]];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.yesterday andEndDate:self.tomorrow], expectedString);
}

- (void)testNSDatePrettyPrintStartDateIsTodayEndDateIsAfterToday {
    NSString *expectedString = [NSString stringWithFormat:@"NOW %@ %@", kEnDashCharacter, [NSDate ggp_formatDateWithoutDayString:self.tomorrow]];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.yesterday andEndDate:self.tomorrow], expectedString);
}

- (void)testNSDatePrettyPrintStartDateIsAfterTodayEndDateIsAfterToday {
    NSString *expectedString = [NSString stringWithFormat:@"%@", [NSDate ggp_formatDateWithDayString:self.tomorrow]].uppercaseString;
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.tomorrow andEndDate:self.tomorrow], expectedString);
}

- (void)testNSDatePrettyPrintStartDateIsBeforeTodayEndDateIsMoreThanNinetyDays {
    NSString *expectedString = [NSString stringWithFormat:@"ONGOING"];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.yesterday andEndDate:self.ninetyDaysFuture], expectedString);
}

- (void)testNSDatePrettyPrintStartDateIsTodayEndDateIsMoreThanNinetyDays {
    NSString *expectedString = [NSString stringWithFormat:@"ONGOING"];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.today andEndDate:self.ninetyDaysFuture], expectedString);
}

- (void)testNSDatePrettyPrintStartDateIsAfterTodayEndDateIsMoreThanNinetyDays {
    NSString *expectedString = [NSString stringWithFormat:@"%@ %@ %@", [NSDate ggp_formatDateWithoutDayString:self.tomorrow], kEnDashCharacter, [NSDate ggp_formatDateWithoutDayString:self.ninetyDaysFuture]];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.tomorrow andEndDate:self.ninetyDaysFuture], expectedString);
}

- (void)testNSDatePrettyPrintSameDateIsTodayWithTime {
    NSDate *futureTime = [NSDate ggp_addHours:3 toDate:self.today];
    NSString *expectedString = [NSString stringWithFormat:@"TODAY: %@",
                                [NSDate ggp_formatTimeRangeForStartDate:self.today endDate:futureTime]];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.today andEndDate:futureTime], expectedString);
}

- (void)testNSDatePrettyPrintSameDateIsAfterTodayWithDayAndTime {
    NSDate *futureTime = [NSDate ggp_addHours:3 toDate:self.tomorrow];
    NSString *expectedString = [NSString stringWithFormat:@"%@: %@",
                                [NSDate ggp_formatDateWithDayString:self.tomorrow].uppercaseString,
                                [NSDate ggp_formatTimeRangeForStartDate:self.tomorrow endDate:futureTime]];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.tomorrow andEndDate:futureTime], expectedString);
}

- (void)testNSDatePrettyPrintStartDateIsBeforeTodayWithTimeEndDateIsMoreThanNinetyDaysWithTime {
    self.ninetyDaysFuture = [NSDate ggp_addHours:3 toDate:self.ninetyDaysFuture];
    NSString *expectedString = [NSString stringWithFormat:@"ONGOING: %@", [NSDate ggp_formatTimeRangeForStartDate:self.yesterday endDate:self.ninetyDaysFuture]];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.yesterday andEndDate:self.ninetyDaysFuture], expectedString);
}

- (void)testNSDatePrettyPrintStartDateIsTodayWithTimeEndDateIsMoreThanNinetyDaysWithTime {
    self.ninetyDaysFuture = [NSDate ggp_addHours:3 toDate:self.ninetyDaysFuture];
    NSString *expectedString = [NSString stringWithFormat:@"ONGOING: %@", [NSDate ggp_formatTimeRangeForStartDate:self.today endDate:self.ninetyDaysFuture]];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.today andEndDate:self.ninetyDaysFuture], expectedString);
}

- (void)testNSDatePrettyPrintStartDateIsBeforeTodayWithTimeEndDateIsAfterTodayWithDayAndTime {
    self.tomorrow = [NSDate ggp_addHours:3 toDate:self.tomorrow];
    NSString *expectedString = [NSString stringWithFormat:@"NOW %@ %@: %@",
                                kEnDashCharacter,
                                [NSDate ggp_formatDateWithDayString:self.tomorrow].uppercaseString,
                                [NSDate ggp_formatTimeRangeForStartDate:self.today endDate:self.tomorrow]];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.yesterday andEndDate:self.tomorrow], expectedString);
}

- (void)testNSDatePrettyPrintStartDateIsTodayWithTimeEndDateIsAfterTodayWithDayAndTime {
    self.tomorrow = [NSDate ggp_addHours:3 toDate:self.tomorrow];
    NSString *expectedString = [NSString stringWithFormat:@"NOW %@ %@: %@",
                                kEnDashCharacter,
                                [NSDate ggp_formatDateWithDayString:self.tomorrow].uppercaseString,
                                [NSDate ggp_formatTimeRangeForStartDate:self.today endDate:self.tomorrow]];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.today andEndDate:self.tomorrow], expectedString);
}

- (void)testNSDatePrettyPrintStartDateIsAfterTodayWithTimeEndDateIsAfterTodayWithDayAndTime {
    self.tomorrow = [NSDate ggp_addHours:3 toDate:self.tomorrow];
    NSDate *futureDate = [NSDate ggp_addDays:3 toDate:self.today];
    NSString *expectedString = [NSString stringWithFormat:@"%@ %@ %@: %@",
                                [NSDate ggp_formatDateWithDayString:self.tomorrow].uppercaseString,
                                kEnDashCharacter,
                                [NSDate ggp_formatDateWithDayString:futureDate].uppercaseString,
                                [NSDate ggp_formatTimeRangeForStartDate:self.tomorrow endDate:futureDate]];
    XCTAssertEqualObjects([NSDate ggp_prettyPrintStartDate:self.tomorrow andEndDate:futureDate], expectedString);
}

- (void)testCreateDateWithMinutesHoursDaysMonthsYear {
    NSInteger minutes = 20;
    NSInteger hour = 05;
    NSInteger day = 10;
    NSInteger month = 10;
    NSInteger year = 1989;
    NSDate *expectedDate = [NSDate ggp_createDateWithMinutes:minutes hour:hour day:day month:month year:year];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:expectedDate];
    XCTAssertEqual(components.minute, minutes);
    XCTAssertEqual(components.hour, hour);
    XCTAssertEqual(components.day, day);
    XCTAssertEqual(components.month, month);
    XCTAssertEqual(components.year, year);
}

- (void)testIntegerYearFromDate {
    NSDate *date = [NSDate ggp_createDateWithMinutes:0 hour:0 day:10 month:10 year:1989];
    XCTAssertEqual([date ggp_integerYear], 1989);
}

- (void)testIntegerMonthFromDate {
    NSDate *date = [NSDate ggp_createDateWithMinutes:0 hour:0 day:10 month:10 year:1989];
    XCTAssertEqual([date ggp_integerMonth], 10);
}

- (void)testIntegerHourFromDate {
    NSDate *date = [NSDate ggp_createDateWithMinutes:0 hour:14 day:0 month:0 year:1989];
    XCTAssertEqual([date ggp_integerHour], 14);
}

- (void)testIntegerDayFromDate {
    NSDate *date = [NSDate ggp_createDateWithMinutes:0 hour:0 day:10 month:10 year:1989];
    XCTAssertEqual([date ggp_integerDay], 10);
}

- (void)testRoundEndDateMinutesEqualsThreshold {
    NSDate *endDate = [NSDate ggp_createDateWithMinutes:59 hour:23 day:9 month:9 year:2000];
    NSDate *roundedDate = [NSDate ggp_roundDate:endDate toNextHourWithMinutesThreshold:59];
    
    NSDate *expectedDate = [NSDate ggp_createDateWithMinutes:0 hour:0 day:10 month:9 year:2000];
    
    XCTAssertTrue([expectedDate isEqualToDate:roundedDate]);
}

- (void)testRoundEndDateMinutesGreaterThanThreshold {
    NSDate *endDate = [NSDate ggp_createDateWithMinutes:50 hour:23 day:9 month:9 year:2000];
    NSDate *roundedDate = [NSDate ggp_roundDate:endDate toNextHourWithMinutesThreshold:45];
    
    NSDate *expectedDate = [NSDate ggp_createDateWithMinutes:0 hour:0 day:10 month:9 year:2000];
    
    XCTAssertTrue([expectedDate isEqualToDate:roundedDate]);
}

- (void)testRoundedEndDateShouldNotRound {
    NSDate *endDate = [NSDate ggp_createDateWithMinutes:0 hour:23 day:9 month:9 year:2000];
    NSDate *roundedDate = [NSDate ggp_roundDate:endDate toNextHourWithMinutesThreshold:59];
    
    XCTAssertTrue([endDate isEqualToDate:roundedDate]);
}

- (void)testDateBySettingHour {
    NSDate *expectedDate = [NSDate ggp_dateBySettingHour:2 forDate:[NSDate new]];
    XCTAssertEqual([expectedDate ggp_integerHour], 2);
}

- (void)testIsoStringNoTimeZone {
    NSString *timeZone = nil;
    NSDate *arrivalDate = [NSDate ggp_createDateWithMinutes:0 hour:10 day:10 month:10 year:2016];
    NSDate *expectedDate = [NSDate ggp_dateBySettingTimeZone:timeZone forDate:arrivalDate];
    NSString *expectedString = [expectedDate ggp_isoTimeStringForTimeZone:timeZone];
    XCTAssertEqualObjects(expectedString, @"2016-10-10T10:00");
}

- (void)testSetTimeZoneLocal {
    NSString *timeZone = @"America/Chicago";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone: [NSTimeZone timeZoneWithName:timeZone]];
    
    NSDateComponents *timeZoneComps = [NSDateComponents new];
    timeZoneComps.year = 2016;
    timeZoneComps.month = 10;
    timeZoneComps.day = 10;
    timeZoneComps.hour = 10;
    NSDate *arrivalDate = [calendar dateFromComponents:timeZoneComps];
    
    NSDate *expectedDate = [NSDate ggp_dateBySettingTimeZone:timeZone forDate:arrivalDate];
    NSString *expectedString = [expectedDate ggp_isoTimeStringForTimeZone:timeZone];
    
    XCTAssertEqualObjects(expectedString, @"2016-10-10T10:00");
}

- (void)testSetTimeZoneCalifornia {
    NSString *timeZone = @"America/Los_Angeles";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone: [NSTimeZone timeZoneWithName:timeZone]];
    
    NSDateComponents *timeZoneComps = [NSDateComponents new];
    timeZoneComps.year = 2016;
    timeZoneComps.month = 10;
    timeZoneComps.day = 10;
    timeZoneComps.hour = 8;
    NSDate *arrivalDate = [calendar dateFromComponents:timeZoneComps];
    
    NSDate *expectedDate = [NSDate ggp_dateBySettingTimeZone:timeZone forDate:arrivalDate];
    NSString *expectedString = [expectedDate ggp_isoTimeStringForTimeZone:timeZone];
    XCTAssertEqualObjects(expectedString, @"2016-10-10T08:00");
}

- (void)testDatesByMonthArrayForDates {
    NSDate *september = [NSDate ggp_createDateWithMinutes:0 hour:0 day:10 month:9 year:2016];
    NSDate *september2 = [NSDate ggp_createDateWithMinutes:0 hour:0 day:12 month:9 year:2016];
    
    NSDate *october = [NSDate ggp_createDateWithMinutes:0 hour:0 day:10 month:10 year:2016];
    NSDate *october2 = [NSDate ggp_createDateWithMinutes:0 hour:0 day:12 month:10 year:2016];
    NSDate *october3 = [NSDate ggp_createDateWithMinutes:0 hour:0 day:13 month:10 year:2016];
    
    NSArray *allDates = @[october, september, october2, september2, october3];
    NSArray *sortedByMonthResult = [NSDate ggp_datesByMonthArrayForDates:allDates];
    
    NSArray *septemberMonthResult = sortedByMonthResult.firstObject;
    NSDate *septemberDateResult = septemberMonthResult.firstObject;
    
    NSArray *octoberMonthResult = sortedByMonthResult[1];
    NSDate *octoberDateResult = octoberMonthResult.firstObject;
    
    XCTAssertEqual(sortedByMonthResult.count, 2);
    XCTAssertEqual(septemberMonthResult.count, 2);
    XCTAssertEqual(octoberMonthResult.count, 3);
    
    XCTAssertEqual(septemberDateResult.ggp_integerMonth, 9);
    XCTAssertEqual(octoberDateResult.ggp_integerMonth, 10);
}

@end
