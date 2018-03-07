//
//  GGPParkingAvailabilityDateCollectionViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/4/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingAvailabilityDateCollectionViewController.h"

@interface GGPParkingAvailabilityDateCollectionViewControllerTests : XCTestCase

@property GGPParkingAvailabilityDateCollectionViewController *collectionViewController;

@end

@interface GGPParkingAvailabilityDateCollectionViewController (Testing)

@property (assign, nonatomic) CGFloat fractionalCellCount;

@end

@implementation GGPParkingAvailabilityDateCollectionViewControllerTests

- (void)setUp {
    [super setUp];
    self.collectionViewController = [GGPParkingAvailabilityDateCollectionViewController new];
    [self.collectionViewController view];
}

- (void)tearDown {
    self.collectionViewController = nil;
    [super tearDown];
}

- (void)testFractionalCellCountWithThreeCells {
    id mockCollectionViewController = OCMPartialMock(self.collectionViewController);
    
    // 240 would fit 3 cells exactly
    CGRect frame = CGRectMake(0, 0, 240, 80);
    
    [OCMStub([mockCollectionViewController collectionView]) andReturn:[[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[UICollectionViewFlowLayout new]]];
    
    XCTAssertEqual(self.collectionViewController.fractionalCellCount, 3.25);
}

- (void)testFractionalCellCountWithFourCells {
    id mockCollectionViewController = OCMPartialMock(self.collectionViewController);
    
    // 320 would fit 4 cells exactly
    CGRect frame = CGRectMake(0, 0, 320, 80);
    
    [OCMStub([mockCollectionViewController collectionView]) andReturn:[[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[UICollectionViewFlowLayout new]]];
    
    XCTAssertEqual(self.collectionViewController.fractionalCellCount, 4.25);
}

@end
