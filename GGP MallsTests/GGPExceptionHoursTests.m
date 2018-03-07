//
//  GGPExceptionHoursTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/24/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPExceptionHours.h"
#import "NSDate+GGPAdditions.h"

@interface GGPExceptionHoursTests : XCTestCase

@end

@implementation GGPExceptionHoursTests

- (void)testIsExceptionValidForDate {
    GGPExceptionHours *mockOHE = OCMPartialMock([GGPExceptionHours new]);
    [OCMStub([mockOHE startMonthDay]) andReturn:@"06/27"];
    
    NSDate *date = [NSDate ggp_createDateWithMinutes:0 hour:0 day:27 month:6 year:2016];
    
    XCTAssertTrue([mockOHE isValidForDate:date]);
}

- (void)testIsExceptionNotValidForDate {
    GGPExceptionHours *mockOHE = OCMPartialMock([GGPExceptionHours new]);
    [OCMStub([mockOHE startMonthDay]) andReturn:@"06/27"];
    
    NSDate *date = [NSDate ggp_createDateWithMinutes:0 hour:0 day:28 month:6 year:2016];
    
    XCTAssertFalse([mockOHE isValidForDate:date]);
}

- (void)testIsExceptionValidPastValidDate {
    GGPExceptionHours *mockHours = OCMPartialMock([GGPExceptionHours new]);
    [OCMStub([mockHours validUntilDate]) andReturn:@"2000-12-12"];
    
    XCTAssertEqual([mockHours isValidForDate:[NSDate date]], NO);
}

- (void)testDateForStartDayCurrentYear {
    GGPExceptionHours *mockHours = OCMPartialMock([GGPExceptionHours new]);
    id mockDate = OCMClassMock([NSDate class]);
    
    [OCMStub([mockDate date]) andReturn:[NSDate ggp_createDateWithMinutes:0 hour:0 day:14 month:12 year:2016]];
    [OCMStub([mockHours startMonthDay]) andReturn:@"12/15"];
    
    NSDate *expected = [NSDate ggp_createDateWithMinutes:0 hour:0 day:15 month:12 year:2016];
    NSDate *result = [mockHours dateForStartDay];
    
    XCTAssertTrue([result ggp_isEqualToDate:expected withGranularity:NSCalendarUnitDay]);
    
    [mockDate stopMocking];
}

- (void)testDateForStartDayNextYear {
    GGPExceptionHours *mockHours = OCMPartialMock([GGPExceptionHours new]);
    id mockDate = OCMClassMock([NSDate class]);
    
    [OCMStub([mockDate date]) andReturn:[NSDate ggp_createDateWithMinutes:0 hour:0 day:14 month:12 year:2016]];
    [OCMStub([mockHours startMonthDay]) andReturn:@"1/15"];
    
    NSDate *expected = [NSDate ggp_createDateWithMinutes:0 hour:0 day:15 month:1 year:2017];
    NSDate *result = [mockHours dateForStartDay];
    
    XCTAssertTrue([result ggp_isEqualToDate:expected withGranularity:NSCalendarUnitDay]);
    
    [mockDate stopMocking];
}

@end
