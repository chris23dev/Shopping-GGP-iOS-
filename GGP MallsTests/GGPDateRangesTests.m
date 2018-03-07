//
//  GGPDateRangeTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMallManager.h"
#import "GGPMall.h"
#import "GGPDateRange.h"
#import "NSDate+GGPAdditions.h"

static NSString *const kBlackFridayCode = @"BLACK_FRIDAY_HOURS";
static NSString *const kHolidayHoursCode = @"HOLIDAY_HOURS";

@interface GGPDateRangeTests : XCTestCase

@end

@implementation GGPDateRangeTests

- (GGPDateRange *)blackFridayDateRange {
    NSDate *today = [NSDate new];
    NSDate *endDate = [NSDate ggp_addDays:1 toDate:today];
    
    NSDictionary *params = @{ @"code": kBlackFridayCode,
                              @"displayDate": today,
                              @"endDate": endDate };
    
    return [[GGPDateRange alloc] initWithDictionary:params error:nil];
}

- (GGPDateRange *)holidayHourDateRangeWithEndDate:(NSDate *)endDate {
    NSDate *today = [NSDate new];
    NSDictionary *params = @{ @"code": kHolidayHoursCode,
                              @"displayDate": today,
                              @"startDate": [NSDate ggp_addDays:30 toDate:today],
                              @"endDate": endDate };
    
    return [[GGPDateRange alloc] initWithDictionary:params error:nil];
}

#pragma mark - Black Friday

- (void)testNoBlackFridayHoursForEmptyDateRanges {
    XCTAssertFalse([GGPDateRange hasBlackFridayHoursFromDateRanges:@[]]);
}

- (void)testNoBlackFridayDateRangeForHolidayHours {
    NSArray *dateRanges = @[[self holidayHourDateRangeWithEndDate:[NSDate new]]];
    XCTAssertNil([GGPDateRange blackFridayDateRangeFromDateRanges:dateRanges]);
}

- (void)testHasBlackFridayDateRangeFromDateRanges {
    GGPDateRange *blackFridayDateRange = [self blackFridayDateRange];
    NSArray *dateRanges = @[blackFridayDateRange];
    XCTAssertNotNil([GGPDateRange blackFridayDateRangeFromDateRanges:dateRanges]);
}

- (void)testBlackFridayHoursRangeIsValid {
    NSArray *dateRanges = @[[self blackFridayDateRange]];
    XCTAssertTrue([GGPDateRange hasBlackFridayHoursFromDateRanges:dateRanges]);
}

#pragma mark - Holiday Hours

- (void)testNoHolidayHoursForEmptyDateRanges {
    XCTAssertFalse([GGPDateRange hasHolidayHoursFromDateRanges:@[]]);
}

- (void)testNoHolidayHoursForBlackFridayDateRange {
    NSArray *dateRanges = @[[self blackFridayDateRange]];
    XCTAssertNil([GGPDateRange holidayHoursDateRangeFromDateRanges:dateRanges]);
}

- (void)testHolidayHoursDateRangeIsInvalid {
    // end date must be 7 or more days after today
    NSDate *today = [NSDate new];
    NSDate *endDate = [NSDate ggp_addDays:1 toDate:today];

    GGPDateRange *holidayHourDateRange = [self holidayHourDateRangeWithEndDate:endDate];
    NSArray *dateRanges = @[holidayHourDateRange];
    XCTAssertFalse([GGPDateRange hasHolidayHoursFromDateRanges:dateRanges]);
}

- (void)testHolidayHoursDateRangeIsValid {
    // end date must be 7 or more days after today
    NSDate *today = [NSDate new];
    NSDate *endDate = [NSDate ggp_addDays:7 toDate:today];
    
    GGPDateRange *holidayHourDateRange = [self holidayHourDateRangeWithEndDate:endDate];
    NSArray *dateRanges = @[holidayHourDateRange];
    XCTAssertTrue([GGPDateRange hasHolidayHoursFromDateRanges:dateRanges]);
}

- (void)testHolidayHoursUrl {
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    id mockMall = OCMPartialMock([GGPMall new]);
    
    [OCMStub([mockMall websiteUrl]) andReturn:@"http://website.com"];
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    GGPDateRange *dateRange = OCMPartialMock([GGPDateRange new]);
    [OCMStub([dateRange url]) andReturn:@"some-url"];
    
    XCTAssertEqualObjects([dateRange hoursUrl], @"http://website.com/some-url");
}

@end
