//
//  GGPHoursTests.m
//  GGP Malls
//
//  Created by Janet Lin on 12/15/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPExceptionHours.h"
#import "GGPHours.h"
#import "GGPHours+Tests.h"
#import "NSDate+GGPAdditions.h"
#import <Overcoat/Overcoat.h>

@interface GGPHoursTests : XCTestCase

@property GGPHours *hours;
@property NSDictionary *jsonDictionary;

@end

@implementation GGPHoursTests

- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"hours" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.hours = (GGPHours *)[MTLJSONAdapter modelOfClass:GGPHours.class fromJSONDictionary:self.jsonDictionary error:nil];
}

- (void)tearDown {
    self.hours = nil;
    self.jsonDictionary = nil;
    [super tearDown];
}

- (void)testHour {
    XCTAssertNotNil(self.hours);
    XCTAssertNotNil(self.hours.openTime);
    XCTAssertEqualObjects(self.hours.openTime, self.jsonDictionary[@"openTime"]);
    XCTAssertEqualObjects(self.hours.closeTime, self.jsonDictionary[@"closeTime"]);
    XCTAssertEqual(self.hours.isOpen, [self.jsonDictionary[@"open"] boolValue]);
    XCTAssertEqualObjects(self.hours.startDay, self.jsonDictionary[@"startDay"]);
    XCTAssertEqualObjects(self.hours.endDay, self.jsonDictionary[@"endDay"]);
}

- (void)testPrettyPrintOpenHoursRange {
    id mockHours = OCMPartialMock(self.hours);
    [OCMStub([mockHours openTime]) andReturn:@"10:00"];
    [OCMStub([mockHours closeTime]) andReturn:@"21:30"];
    
    NSString *result = [self.hours prettyPrintOpenHoursRange];
    XCTAssertEqualObjects(result, @"10:00 am \u2013 9:30 pm");
}

- (NSDate *)dateForString:(NSString *)dateString {
    NSDateFormatter *yearMonthDayFormatter = [NSDateFormatter new];
    [yearMonthDayFormatter setDateFormat:@"yyyy-MM-dd"];
    return [yearMonthDayFormatter dateFromString:dateString];
}

- (void)testTodaysHoursNoValidException {
    id mockOHE = OCMPartialMock([GGPExceptionHours new]);
    [OCMStub([mockOHE isValidForDate:OCMOCK_ANY]) andReturnValue:OCMOCK_VALUE(NO)];
    
    NSArray *mockTodaysHours = @[[GGPHours createTodayOperatingHours]];
    NSArray *mockExceptionHours = @[mockOHE];
    
    XCTAssertEqualObjects([GGPHours openHoursForDate:[NSDate new] hours:mockTodaysHours andExceptionHours:mockExceptionHours], mockTodaysHours);
}

- (void)testTodaysHoursHasValidException {
    id mockOHE = OCMPartialMock([GGPExceptionHours new]);
    [OCMStub([mockOHE isValidForDate:OCMOCK_ANY]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockOHE isOpen]) andReturnValue:OCMOCK_VALUE(YES)];
    
    NSArray *mockTodaysHours = @[[GGPHours createTodayOperatingHours]];
    NSArray *mockExceptionHours = @[mockOHE];
    
    XCTAssertEqualObjects([GGPHours openHoursForDate:[NSDate new] hours:mockTodaysHours andExceptionHours:mockExceptionHours], mockExceptionHours);
}

@end
