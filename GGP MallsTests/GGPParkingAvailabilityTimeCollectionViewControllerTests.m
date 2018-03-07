//
//  GGPParkingAvailabilityTimeCollectionViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/1/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingAvailabilityTimeCellData.h"
#import "GGPParkingAvailabilityTimeCollectionViewController.h"
#import "NSDate+GGPAdditions.h"

@interface GGPParkingAvailabilityTimeCollectionViewControllerTests : XCTestCase

@property GGPParkingAvailabilityTimeCollectionViewController *collectionViewController;

@end

@interface GGPParkingAvailabilityTimeCollectionViewController (Testing)

@property (strong, nonatomic) NSMutableArray *times;
@property (assign, nonatomic) NSInteger selectedRow;
@property (assign, nonatomic) BOOL hasNowCell;

- (void)configureWithSelectedDate:(NSDate *)selectedDate;
- (NSInteger)incrementNowSelectedRow;
- (NSInteger)decrementNowSelectedRow;

@end

@implementation GGPParkingAvailabilityTimeCollectionViewControllerTests

- (void)setUp {
    [super setUp];
    self.collectionViewController = [GGPParkingAvailabilityTimeCollectionViewController new];
    [self.collectionViewController view];
}

- (void)tearDown {
    self.collectionViewController = nil;
    [super tearDown];
}

- (void)testConfigureWithSelectedDateRemoveNowCellNotToday {
    NSDate *tomorrow = [NSDate ggp_addDays:1 toDate:[NSDate new]];
    self.collectionViewController.hasNowCell = YES;
    [self.collectionViewController configureWithSelectedDate:tomorrow];
    XCTAssertFalse(self.collectionViewController.hasNowCell);
}

- (void)testConfigureWithSelectedDateAddNowCellIsToday {
    NSDate *today = [NSDate new];
    self.collectionViewController.hasNowCell = NO;
    [self.collectionViewController configureWithSelectedDate:today];
    XCTAssertTrue(self.collectionViewController.hasNowCell);
}

- (void)testConfigureWithSelectedDateRejectRemoveNowCellNotToday {
    NSDate *tomorrow = [NSDate ggp_addDays:1 toDate:[NSDate new]];
    self.collectionViewController.hasNowCell = NO;
    self.collectionViewController.times = @[ [[GGPParkingAvailabilityTimeCellData alloc] initWithTitle:@"title" andTapHandler:nil] ].mutableCopy;
    [self.collectionViewController configureWithSelectedDate:tomorrow];
    XCTAssertFalse(self.collectionViewController.hasNowCell);
    XCTAssertEqual(self.collectionViewController.times.count, 1);
}

- (void)testConfigureWithSelectedDateRejectAddNowCellIsToday {
    NSDate *today = [NSDate new];
    self.collectionViewController.hasNowCell = YES;
    self.collectionViewController.times = @[ [[GGPParkingAvailabilityTimeCellData alloc] initWithTitle:@"title" andTapHandler:nil] ].mutableCopy;
    [self.collectionViewController configureWithSelectedDate:today];
    XCTAssertTrue(self.collectionViewController.hasNowCell);
    XCTAssertEqual(self.collectionViewController.times.count, 1);
}

- (void)testIncrementSelectedRow {
    self.collectionViewController.selectedRow = 3;
    XCTAssertEqual([self.collectionViewController incrementNowSelectedRow], 0);
    
    self.collectionViewController.selectedRow = 2;
    XCTAssertEqual([self.collectionViewController incrementNowSelectedRow], 3);
}

- (void)testDecrementSelectedRow {
    self.collectionViewController.selectedRow = 0;
    XCTAssertEqual([self.collectionViewController decrementNowSelectedRow], 0);
    
    self.collectionViewController.selectedRow = 2;
    XCTAssertEqual([self.collectionViewController decrementNowSelectedRow], 1);
}

@end
