//
//  GGPParkingViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingViewController.h"
#import "GGPParkingGaragesViewController.h"
#import "GGPFindYourCarViewController.h"
#import "GGPParkingInfoViewController.h"
#import "GGPParkingMapViewController.h"
#import "GGPParkingReminderViewController.h"

@interface GGPParkingViewControllerTests : XCTestCase

@property GGPParkingViewController *parkingViewController;

@end

@interface GGPParkingViewController (Testing)

- (NSArray *)ribbonItemsForParkAssist;
- (NSArray *)ribbonItemsForParkingAvailability;
- (NSArray *)ribbonItemsForParkingDisabled;

@end

@implementation GGPParkingViewControllerTests

- (void)setUp {
    [super setUp];
    self.parkingViewController = [GGPParkingViewController new];
}

- (void)tearDown {
    self.parkingViewController = nil;
    [super tearDown];
}

- (void)testRibbonItemsForParkAssist {
    NSArray *items = [self.parkingViewController ribbonItemsForParkAssist];
    
    XCTAssertEqual(items.count, 3);
    XCTAssertEqual(GGPParkingGaragesViewController.class, ((NSObject *)items[0]).class);
    XCTAssertEqual(GGPFindYourCarViewController.class, ((NSObject *)items[1]).class);
    XCTAssertEqual(GGPParkingInfoViewController.class, ((NSObject *)items[2]).class);
}

- (void)testRibbonItemsForParkingAvailability {
    NSArray *items = [self.parkingViewController ribbonItemsForParkingAvailability];
    
    XCTAssertEqual(items.count, 3);
    XCTAssertEqual(GGPParkingMapViewController.class, ((NSObject *)items[0]).class);
    XCTAssertEqual(GGPParkingReminderViewController.class, ((NSObject *)items[1]).class);
    XCTAssertEqual(GGPParkingInfoViewController.class, ((NSObject *)items[2]).class);
}

- (void)testRibbonItemsForParkingDisabled {
    NSArray *items = [self.parkingViewController ribbonItemsForParkingDisabled];
    
    XCTAssertEqual(items.count, 2);
    XCTAssertEqual(GGPParkingReminderViewController.class, ((NSObject *)items[0]).class);
    XCTAssertEqual(GGPParkingInfoViewController.class, ((NSObject *)items[1]).class);
}

@end
