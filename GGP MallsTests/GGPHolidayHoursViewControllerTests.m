//
//  GGPHolidayHoursViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPHolidayHoursViewController.h"
#import "NSDate+GGPAdditions.h"

@interface GGPHolidayHoursViewControllerTests : XCTestCase

@property GGPHolidayHoursViewController *tableViewController;

@end

@interface GGPHolidayHoursViewController (Testing)

- (NSDate *)determineStartDateFromHolidayStartDate:(NSDate *)holidayStartDate;

@end

@implementation GGPHolidayHoursViewControllerTests

- (void)setUp {
    [super setUp];
    self.tableViewController = [GGPHolidayHoursViewController new];
}

- (void)tearDown {
    self.tableViewController = nil;
    [super tearDown];
}

- (void)testDetermineStartDateFromHolidayStartDate {
    NSDate *today = [NSDate new];
    NSDate *nextWeek = [NSDate ggp_addDays:7 toDate:today];
    
    // holiday start falls within current week, use next week for holiday start date
    NSDate *startDate = today;
    XCTAssertEqual([self.tableViewController determineStartDateFromHolidayStartDate:startDate].ggp_integerDay, nextWeek.ggp_integerDay);
    
    startDate = [NSDate ggp_addDays:1 toDate:today];
    XCTAssertEqual([self.tableViewController determineStartDateFromHolidayStartDate:startDate].ggp_integerDay, nextWeek.ggp_integerDay);
    
    startDate = [NSDate ggp_addDays:2 toDate:today];
    XCTAssertEqual([self.tableViewController determineStartDateFromHolidayStartDate:startDate].ggp_integerDay, nextWeek.ggp_integerDay);
    
    startDate = [NSDate ggp_addDays:3 toDate:today];
    XCTAssertEqual([self.tableViewController determineStartDateFromHolidayStartDate:startDate].ggp_integerDay, nextWeek.ggp_integerDay);
    
    startDate = [NSDate ggp_addDays:4 toDate:today];
    XCTAssertEqual([self.tableViewController determineStartDateFromHolidayStartDate:startDate].ggp_integerDay, nextWeek.ggp_integerDay);
    
    startDate = [NSDate ggp_addDays:5 toDate:today];
    XCTAssertEqual([self.tableViewController determineStartDateFromHolidayStartDate:startDate].ggp_integerDay, nextWeek.ggp_integerDay);
    
    startDate = [NSDate ggp_addDays:6 toDate:today];
    XCTAssertEqual([self.tableViewController determineStartDateFromHolidayStartDate:startDate].ggp_integerDay, nextWeek.ggp_integerDay);
    
    startDate = [NSDate ggp_addDays:7 toDate:today];
    XCTAssertEqual([self.tableViewController determineStartDateFromHolidayStartDate:startDate].ggp_integerDay, nextWeek.ggp_integerDay);
    
    // holiday start date falls after the last day of current week, use holiday start date
    startDate = [NSDate ggp_addDays:8 toDate:today];
    XCTAssertEqual([self.tableViewController determineStartDateFromHolidayStartDate:startDate].ggp_integerDay, startDate.ggp_integerDay);
}

@end
