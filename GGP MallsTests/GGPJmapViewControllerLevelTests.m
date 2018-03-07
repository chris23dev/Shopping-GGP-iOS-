//
//  GGPJmapViewControllerLevelsTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapViewController.h"
#import "GGPJmapViewcontroller+Levels.h"
#import "GGPJMapViewController+Wayfinding.h"
#import "GGPLevelCell.h"
#import "GGPLevelSelectorCollectionViewController.h"
#import "GGPTenant.h"
#import <JMap/JMap.h>

@interface GGPJMapViewControllerLevelsTests : XCTestCase

@property (strong, nonatomic) GGPJMapViewController *jMapViewController;
@property (assign, nonatomic) NSInteger mallId;

@end

@interface GGPJMapViewController (Testing)

@property (weak, nonatomic) IBOutlet UIView *levelSelectorContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelContainerWidthConstraint;

@property (strong, nonatomic) JMapContainerView *mapView;
@property (strong, nonatomic) GGPLevelSelectorCollectionViewController *levelSelectorCollectionViewController;
@property (assign, nonatomic) BOOL isWayfindingRouteActive;
@property (strong, nonatomic) NSArray *floors;
@property (strong, nonatomic) NSMutableArray *reversedFloors;

- (void)configureMapView;
- (void)moveToFloor:(JMapFloor *)tenantFloor;
- (void)updateLevelContainerWidthAndHeightForFloors:(NSArray *)floors;
- (JMapFloor *)allParkingFloor;
- (void)updateLevelSelectorForParking;

@end

@implementation GGPJMapViewControllerLevelsTests

- (void)setUp {
    [super setUp];
    self.jMapViewController = [GGPJMapViewController new];
    [self.jMapViewController view];
}

- (void)tearDown {
    self.jMapViewController = nil;
    [super tearDown];
}

- (void)testMoveToFloorDifferentFloor {
    JMapFloor *mockFloor1 = OCMPartialMock([JMapFloor new]);
    JMapFloor *mockFloor2 = OCMPartialMock([JMapFloor new]);
    [OCMStub([mockFloor1 floorSequence]) andReturn:@(1)];
    [OCMStub([mockFloor2 floorSequence]) andReturn:@(2)];
    [OCMStub([mockFloor2 mapId]) andReturn:@(12345)];
    
    id mockMapView = OCMPartialMock(self.jMapViewController.mapView);
    [OCMStub([mockMapView currentFloor]) andReturn:mockFloor1];
    
    id mockMapVC = OCMPartialMock(self.jMapViewController);
    [OCMStub([mockMapVC configureMapView]) andDo:nil];
    
    [self.jMapViewController view];
    
    OCMExpect([mockMapView setLevelById:@(12345)]);
    
    [self.jMapViewController moveToFloor:mockFloor2];
    
    OCMVerifyAll(mockMapView);
}

- (void)testMoveToFloorSameFloor {
    JMapFloor *mockFloor1 = OCMPartialMock([JMapFloor new]);
    id mockMapView = OCMPartialMock(self.jMapViewController.mapView);
    
    [OCMStub([mockFloor1 floorSequence]) andReturn:@(1)];
    [OCMStub([mockMapView currentFloor]) andReturn:mockFloor1];
    
    id mockMapVC = OCMPartialMock(self.jMapViewController);
    [OCMStub([mockMapVC configureMapView]) andDo:nil];
    
    [self.jMapViewController view];
    
    [[mockMapView reject] setLevelById:OCMOCK_ANY];
    
    [self.jMapViewController moveToFloor:mockFloor1];
    
    OCMVerifyAll(mockMapView);
}

- (void)testMoveToFloorWayfindingRouteActive {
    id mockFloor = OCMPartialMock([JMapFloor new]);
    id mockMapController = OCMPartialMock(self.jMapViewController);
    
    [OCMStub([mockMapController isWayfindingRouteActive]) andReturnValue:OCMOCK_VALUE(YES)];
    
    OCMExpect([mockMapController updateWayfindingFloorForJmapFloor:mockFloor]);
    
    [self.jMapViewController moveToFloor:mockFloor];
    
    OCMVerifyAll(mockMapController);
}

- (void)testMoveToFloorWayfindingRouteNotActive {
    id mockFloor = OCMPartialMock([JMapFloor new]);
    id mockMapController = OCMPartialMock(self.jMapViewController);
    
    [OCMStub([mockMapController isWayfindingRouteActive]) andReturnValue:OCMOCK_VALUE(NO)];
    
    [[mockMapController reject] updateWayfindingFloorForJmapFloor:mockFloor];
    
    [self.jMapViewController moveToFloor:mockFloor];
    
    OCMVerifyAll(mockMapController);
}

- (void)testConfigureLevelContainerHeight {
    id mockFloor1 = OCMClassMock(JMapFloor.class);
    id mockFloor2 = OCMClassMock(JMapFloor.class);
    NSArray *mockFloors = @[mockFloor1, mockFloor2];
    [self.jMapViewController updateLevelContainerWidthAndHeightForFloors:mockFloors];
    XCTAssertEqual(self.jMapViewController.levelContainerHeightConstraint.constant, GGPLevelCellHeight * mockFloors.count);
}

- (void)testConfigureLevelContainerWidth {
    id mockFloor = OCMClassMock([JMapFloor class]);
    [OCMStub([mockFloor description]) andReturn:@"MEZZANIINNEE"];
    NSArray *mockFloors = @[mockFloor];
    GGPLevelSelectorCollectionViewController *mockLevelSelectorViewController = OCMPartialMock([[GGPLevelSelectorCollectionViewController alloc] initWithFloors:mockFloors selectedIndex:0]);
    CGFloat cellWidth = mockLevelSelectorViewController.cellWidth;
    self.jMapViewController.levelSelectorCollectionViewController = mockLevelSelectorViewController;
    
    [self.jMapViewController updateLevelContainerWidthAndHeightForFloors:mockFloors];
    
    XCTAssertEqual(self.jMapViewController.levelContainerWidthConstraint.constant, cellWidth);
}

- (void)testFloorForTenantClosestToFloorOnLowerFloor {
    id targetFloor = OCMPartialMock([JMapFloor new]);
    [OCMStub([targetFloor floorSequence]) andReturn:@(5)];
    
    id tenantFloor1 = OCMPartialMock([JMapFloor new]);
    id tenantFloor2 = OCMPartialMock([JMapFloor new]);
    [OCMStub([tenantFloor1 floorSequence]) andReturn:@(1)];
    [OCMStub([tenantFloor2 floorSequence]) andReturn:@(2)];
    
    id mockController = OCMPartialMock(self.jMapViewController);
    [OCMStub([mockController floorsForTenant:OCMOCK_ANY]) andReturn:@[tenantFloor1, tenantFloor2]];
    
    JMapFloor *resultFloor = [self.jMapViewController floorForTenant:[GGPTenant new] closestToFloor:targetFloor];
    
    XCTAssertEqual(resultFloor, tenantFloor2);
}

- (void)testFloorForTenantClosestToFloorOnHigherFloor {
    id targetFloor = OCMPartialMock([JMapFloor new]);
    [OCMStub([targetFloor floorSequence]) andReturn:@(5)];
    
    id tenantFloor1 = OCMPartialMock([JMapFloor new]);
    id tenantFloor2 = OCMPartialMock([JMapFloor new]);
    [OCMStub([tenantFloor1 floorSequence]) andReturn:@(6)];
    [OCMStub([tenantFloor2 floorSequence]) andReturn:@(7)];
    
    id mockController = OCMPartialMock(self.jMapViewController);
    [OCMStub([mockController floorsForTenant:OCMOCK_ANY]) andReturn:@[tenantFloor1, tenantFloor2]];
    
    JMapFloor *resultFloor = [self.jMapViewController floorForTenant:[GGPTenant new] closestToFloor:targetFloor];
    
    XCTAssertEqual(resultFloor, tenantFloor1);
}

- (void)testFloorForTenantClosestToFloorOnSameFloor {
    id targetFloor = OCMPartialMock([JMapFloor new]);
    [OCMStub([targetFloor floorSequence]) andReturn:@(5)];
    
    id tenantFloor1 = OCMPartialMock([JMapFloor new]);
    id tenantFloor2 = OCMPartialMock([JMapFloor new]);
    id tenantFloor3 = OCMPartialMock([JMapFloor new]);
    [OCMStub([tenantFloor1 floorSequence]) andReturn:@(4)];
    [OCMStub([tenantFloor2 floorSequence]) andReturn:@(5)];
    [OCMStub([tenantFloor3 floorSequence]) andReturn:@(6)];
    
    id mockController = OCMPartialMock(self.jMapViewController);
    [OCMStub([mockController floorsForTenant:OCMOCK_ANY]) andReturn:@[tenantFloor1, tenantFloor2, tenantFloor3]];
    
    JMapFloor *resultFloor = [self.jMapViewController floorForTenant:[GGPTenant new] closestToFloor:targetFloor];
    
    XCTAssertEqual(resultFloor, tenantFloor2);
}

- (void)testFloorForTenantClosestToFloorSingleFloor {
    id targetFloor = OCMPartialMock([JMapFloor new]);
    [OCMStub([targetFloor floorSequence]) andReturn:@(5)];
    
    id tenantFloor1 = OCMPartialMock([JMapFloor new]);
    [OCMStub([tenantFloor1 floorSequence]) andReturn:@(4)];
    
    id mockController = OCMPartialMock(self.jMapViewController);
    [OCMStub([mockController floorsForTenant:OCMOCK_ANY]) andReturn:@[tenantFloor1]];
    
    JMapFloor *resultFloor = [self.jMapViewController floorForTenant:[GGPTenant new] closestToFloor:targetFloor];
    
    XCTAssertEqual(resultFloor, tenantFloor1);
}

- (void)testAllParkingFloor {
    GGPJMapViewController *mockController = OCMPartialMock(self.jMapViewController);
    id mockFloor1 = OCMPartialMock([JMapFloor new]);
    id mockFloor2 = OCMPartialMock([JMapFloor new]);
    id mockFloorAll = OCMPartialMock([JMapFloor new]);
    
    [OCMStub([mockController floors]) andReturn:@[mockFloor1, mockFloor2, mockFloorAll]];
    [OCMStub([mockFloor1 floorSequence]) andReturn:@(1)];
    [OCMStub([mockFloor2 floorSequence]) andReturn:@(2)];
    [OCMStub([mockFloorAll floorSequence]) andReturn:@(99)];
    
    XCTAssertEqual([self.jMapViewController allParkingFloor], mockFloorAll);
}

- (void)testRemoveParkingFloor {
    id mockFloor1 = OCMPartialMock([JMapFloor new]);
    id mockFloor2 = OCMPartialMock([JMapFloor new]);
    id mockFloorAll = OCMPartialMock([JMapFloor new]);
    
    [OCMStub([mockFloor1 floorSequence]) andReturn:@(1)];
    [OCMStub([mockFloor2 floorSequence]) andReturn:@(2)];
    [OCMStub([mockFloorAll floorSequence]) andReturn:@(99)];
    
    self.jMapViewController.floors = @[mockFloor1, mockFloor2, mockFloorAll];
    self.jMapViewController.reversedFloors = @[mockFloor1, mockFloor2, mockFloorAll].mutableCopy;
    
    [self.jMapViewController removeAllParkingFloor];
    
    XCTAssertFalse([self.jMapViewController.reversedFloors containsObject:mockFloorAll]);
}

- (void)testAddParkingFloor {
    id mockFloor1 = OCMPartialMock([JMapFloor new]);
    id mockFloor2 = OCMPartialMock([JMapFloor new]);
    id mockFloorAll = OCMPartialMock([JMapFloor new]);
    
    [OCMStub([mockFloor1 floorSequence]) andReturn:@(1)];
    [OCMStub([mockFloor2 floorSequence]) andReturn:@(2)];
    [OCMStub([mockFloorAll floorSequence]) andReturn:@(99)];
    
    self.jMapViewController.floors = @[mockFloor1, mockFloor2, mockFloorAll];
    self.jMapViewController.reversedFloors = @[mockFloor1, mockFloor2].mutableCopy;
    
    [self.jMapViewController updateLevelSelectorForParking];
    
    XCTAssertTrue([self.jMapViewController.reversedFloors containsObject:mockFloorAll]);
}

@end
