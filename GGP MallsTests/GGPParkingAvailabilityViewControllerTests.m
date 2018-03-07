//
//  GGPParkingAvailabilityViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingAvailabilityViewController.h"
#import "NSDate+GGPAdditions.h"

@interface GGPParkingAvailabilityViewControllerTests : XCTestCase

@property GGPParkingAvailabilityViewController *viewController;

@end

@interface GGPParkingAvailabilityViewController (Testing)

@property (assign, nonatomic) NSInteger arrivalTimeHour;
@property (strong, nonatomic) NSDate *arrivalDate;

- (NSDate *)constructedArrivalDate;

@end

@implementation GGPParkingAvailabilityViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [GGPParkingAvailabilityViewController new];
}

- (void)tearDown {
    self.viewController = nil;
    [super tearDown];
}

- (void)testConstructedDateIsNow {
    NSDate *arrivalDate = [NSDate ggp_createDateWithMinutes:0 hour:10 day:10 month:10 year:2010];
    
    id mockViewController = OCMPartialMock(self.viewController);
    [OCMStub([mockViewController arrivalTimeHour]) andReturnValue:@(0)];
    [OCMStub([mockViewController arrivalDate]) andReturn:arrivalDate];
    
    XCTAssertEqualObjects([self.viewController constructedArrivalDate], arrivalDate);
    
}

@end
