//
//  GGPParkingAvailabilityPopoverViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/1/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingAvailabilityPopoverViewController.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

@interface GGPParkingAvailabilityPopoverViewControllerTests : XCTestCase

@property GGPParkingAvailabilityPopoverViewController *popoverViewController;

@end

@interface GGPParkingAvailabilityPopoverViewController (Testing)

@property (strong, nonatomic) NSDate *selectedDate;
@property (copy, nonatomic) NSString *selectedTimeString;
@property (copy, nonatomic) NSString *arrivalTimeString;
@property (copy, nonatomic) NSString *arrivalDateString;

- (BOOL)shouldShowDateString;
- (void)configureSelectedTimeLabel;
- (NSDate *)constructedArrivalDate;

@end

@implementation GGPParkingAvailabilityPopoverViewControllerTests

- (void)setUp {
    [super setUp];
    self.popoverViewController = [GGPParkingAvailabilityPopoverViewController new];
    [self.popoverViewController view];
}

- (void)tearDown {
    self.popoverViewController = nil;
    [super tearDown];
}

- (void)testShouldShowDateString {
    self.popoverViewController.selectedTimeString = [@"PARKING_AVAILABILITY_EVENING" ggp_toLocalized];
    XCTAssertTrue(self.popoverViewController.shouldShowDateString);
}

- (void)testShouldHideDateString {
    self.popoverViewController.selectedTimeString = [@"PARKING_AVAILABILITY_NOW" ggp_toLocalized];
    XCTAssertFalse(self.popoverViewController.shouldShowDateString);
}

- (void)testCalculatedTimeStringIsNow {
    self.popoverViewController.selectedTimeString = [@"PARKING_AVAILABILITY_NOW" ggp_toLocalized];
    XCTAssertEqualObjects(self.popoverViewController.arrivalTimeString, [@"PARKING_AVAILABILITY_NOW" ggp_toLocalized]);
}

- (void)testCalculatedTimeStringIsFutureDate {
    self.popoverViewController.selectedDate = [NSDate ggp_addDays:1 toDate:[NSDate new]];
    self.popoverViewController.selectedTimeString = [@"PARKING_AVAILABILITY_EVENING" ggp_toLocalized];
    NSString *expectedString = [NSString stringWithFormat:[@"PARKING_AVAILABILITY_TIME_WITH_DATE" ggp_toLocalized], self.popoverViewController.selectedTimeString, self.popoverViewController.arrivalDateString];
    XCTAssertEqualObjects(self.popoverViewController.arrivalTimeString, expectedString);
}

@end
