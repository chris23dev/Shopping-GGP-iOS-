//
//  GGPJmapViewControllerParkingTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapViewController+Parking.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPParkingLot.h"
#import "GGPParkingLotOccupancy.h"
#import "GGPParkingLotThreshold.h"
#import "GGPTenant.h"
#import "NSDate+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import <JMap/JMap.h>

@interface GGPJMapViewController ()

@property (strong, nonatomic) JMapContainerView *mapView;
@property (strong, nonatomic) NSArray *parkingLots;
@property (strong, nonatomic) NSArray *parkingLayerWaypoints;

- (UIColor *)colorForOccupancyPercentage:(NSInteger)occupancyPercentage fromThresholds:(NSArray *)thresholds;
- (NSArray *)waypointsForParkingLayer;
- (NSArray *)waypointsInShape:(NSDictionary *)shape;
- (NSArray *)closestParkingLotsToTenant:(GGPTenant *)tenant;
- (GGPParkingLot *)parkingLotForWaypointUnitNumber:(NSString *)unitNumber;
- (NSDictionary *)parkingDistanceLookupForTenant:(GGPTenant *)tenant;
- (NSArray *)closestUnitNumbersToTenant:(GGPTenant *)tenant;

@end

@interface GGPJmapViewControllerParkingTests : XCTestCase

@property (strong, nonatomic) GGPJMapViewController *mapController;

@end

@implementation GGPJmapViewControllerParkingTests

- (void)setUp {
    [super setUp];
    self.mapController = [GGPJMapViewController new];
}

- (void)tearDown {
    self.mapController = nil;
    [super tearDown];
}

- (void)testColorForOccupancyPercentage {
    GGPParkingLotThreshold *greenThreshold = [self parkingLotThresholdWithMin:0 max:50 colorHex:@"00ff00" andAlpha:100];
    GGPParkingLotThreshold *redThreshold = [self parkingLotThresholdWithMin:51 max:100 colorHex:@"ff0000" andAlpha:100];
    NSArray *thresholds = @[greenThreshold, redThreshold];
    
    UIColor *green = [UIColor ggp_colorFromHexString:@"00ff00" andAlpha:1];
    UIColor *red = [UIColor ggp_colorFromHexString:@"ff0000" andAlpha:1];
    
    XCTAssertEqualObjects(green, [self.mapController colorForOccupancyPercentage:0 fromThresholds:thresholds]);
    XCTAssertEqualObjects(green, [self.mapController colorForOccupancyPercentage:25 fromThresholds:thresholds]);
    XCTAssertEqualObjects(green, [self.mapController colorForOccupancyPercentage:50 fromThresholds:thresholds]);
    XCTAssertEqualObjects(red, [self.mapController colorForOccupancyPercentage:51 fromThresholds:thresholds]);
    XCTAssertEqualObjects(red, [self.mapController colorForOccupancyPercentage:75 fromThresholds:thresholds]);
    XCTAssertEqualObjects(red, [self.mapController colorForOccupancyPercentage:100 fromThresholds:thresholds]);
    XCTAssertNil([self.mapController colorForOccupancyPercentage:101 fromThresholds:thresholds]);
}

- (GGPParkingLotThreshold *)parkingLotThresholdWithMin:(NSInteger)min max:(NSInteger)max colorHex:(NSString *)colorHex andAlpha:(NSInteger)alpha {
    GGPParkingLotThreshold *threshold = [GGPParkingLotThreshold new];
    threshold.minPercentage = min;
    threshold.maxPercentage = max;
    threshold.colorHex = colorHex;
    threshold.alphaPercentage = alpha;
    
    return threshold;
}

- (void)testWaypointsForParkingLayer {
    NSDictionary *mockShape1 = @{@"test" : @"1"};
    NSDictionary *mockShape2 = @{@"test" : @"2"};
    JMapWaypoint *mockWaypoint1 = [JMapWaypoint new];
    JMapWaypoint *mockWaypoint2 = [JMapWaypoint new];
    JMapWaypoint *mockWaypoint3 = [JMapWaypoint new];
    
    NSArray *mockShapes = @[mockShape1, mockShape2];
    
    id mockController = OCMPartialMock(self.mapController);
    id mockMapView = OCMPartialMock([JMapContainerView new]);
    
    [OCMStub([mockController mapView]) andReturn:mockMapView];
    [OCMStub([mockMapView getAllShapesDataFromLayerName:OCMOCK_ANY]) andReturn:mockShapes];
    [OCMStub([mockController waypointsInShape:mockShape1]) andReturn:@[mockWaypoint1]];
    [OCMStub([mockController waypointsInShape:mockShape2]) andReturn:@[mockWaypoint2, mockWaypoint3]];
    
    NSArray *result = [self.mapController waypointsForParkingLayer];
    
    XCTAssertEqual(result.count, 3);
}

- (void)testWaypointsInShape {
    NSDictionary *mockShape = @{@"waypoint-unit" : @[@(1), @(2), @(3)]};
    JMapWaypoint *mockWaypoint1 = OCMPartialMock([JMapWaypoint new]);
    JMapWaypoint *mockWaypoint2 = OCMPartialMock([JMapWaypoint new]);
    
    id mockController = OCMPartialMock(self.mapController);
    id mockMapView = OCMPartialMock([JMapContainerView new]);
    
    [OCMStub([mockWaypoint1 unitNumber]) andReturn:@"1"];
    [OCMStub([mockWaypoint2 unitNumber]) andReturn:@"2"];
    
    [OCMStub([mockController mapView]) andReturn:mockMapView];
    [OCMStub([mockMapView getWayPointById:@(1)]) andReturn:mockWaypoint1];
    [OCMStub([mockMapView getWayPointById:@(2)]) andReturn:mockWaypoint2];
    [OCMStub([mockMapView getWayPointById:@(3)]) andReturn:nil];
    
    [OCMStub([mockController parkingLotForWaypointUnitNumber:@"1"]) andReturn:[GGPParkingLot new]];
    [OCMStub([mockController parkingLotForWaypointUnitNumber:@"2"]) andReturn:nil];
    
    NSArray *result = [self.mapController waypointsInShape:mockShape];
    
    XCTAssertEqual(result.count, 1);
}

- (void)testClosestUnitNumbersToTenant {
    NSDictionary *distanceLookup = @{
                                     @"1": @(10),
                                     @"2": @(40),
                                     @"3": @(30),
                                     @"4": @(20)
                                     };
    
    id mockController = OCMPartialMock(self.mapController);
    
    [OCMStub([mockController parkingDistanceLookupForTenant:OCMOCK_ANY]) andReturn:distanceLookup];
    
    NSArray *result = [self.mapController closestUnitNumbersToTenant:[GGPTenant new]];
    
    XCTAssertEqual(result.count, 4);
    XCTAssertEqualObjects(result[0], @"1");
    XCTAssertEqualObjects(result[1], @"4");
    XCTAssertEqualObjects(result[2], @"3");
    XCTAssertEqualObjects(result[3], @"2");
}

@end
