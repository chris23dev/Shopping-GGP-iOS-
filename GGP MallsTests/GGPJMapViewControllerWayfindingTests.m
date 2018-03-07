//
//  GGPJmapViewControllerWayfindingTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJmapViewController+Highlighting.h"
#import "GGPJMapViewController+Wayfinding.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPLevelSelectorCollectionViewController.h"
#import "GGPTenant.h"
#import "GGPWayfindingFloor.h"
#import "GGPWayfindingMover.h"
#import "GGPWayfindingPathView.h"
#import <JMap/JMap.h>

@interface GGPJMapViewControllerWayfindingTests : XCTestCase

@property (strong, nonatomic) GGPJMapViewController *mapController;

@end

@interface GGPJMapViewController (Testing)

@property (strong, nonatomic) GGPLevelSelectorCollectionViewController *levelSelectorCollectionViewController;
@property (strong, nonatomic) JMapContainerView *mapView;

@property (strong, nonatomic) GGPTenant *wayfindingStartTenant;
@property (strong, nonatomic) GGPTenant *wayfindingEndTenant;
@property (strong, nonatomic) JMapFloor *wayfindingStartFloor;
@property (strong, nonatomic) JMapFloor *wayfindingEndFloor;
@property (strong, nonatomic) UIImageView *startPinImageView;
@property (strong, nonatomic) UIImageView *endPinImageView;
@property (strong, nonatomic) NSArray *wayfindingFloors;
@property (strong, nonatomic) GGPWayfindingFloor *currentWayfindingFloor;

- (void)zoomToTenant:(GGPTenant *)tenant onFloor:(JMapFloor *)floor withIcons:(BOOL)shouldShowIcons andHighlight:(BOOL)shouldHighlight;
- (void)updateUnitLabelsWithScale:(NSNumber *)newScale;
- (void)moveToFloor:(JMapFloor *)tenantFloor;
- (JMapDestination *)retrieveDestinationFromLeaseId:(NSInteger)leaseId;
- (void)updateEndPinLocation;
- (void)configureWayfindingView;
- (void)placeStartPin;
- (void)placeEndPin;
- (JMapFloor *)floorForTenant:(GGPTenant *)tenant closestToFloor:(JMapFloor *)targetFloor;
- (CGRect)rectForPoint:(CGPoint)point;
- (CGPoint)mapPointForTenant:(GGPTenant *)tenant onFloor:(JMapFloor *)floor;
- (void)zoomToFloorPath:(JMapPathPerFloor *)floorPath onFloor:(JMapFloor *)floor;
- (NSArray *)wayfindPathsForSelectedTenants;
- (JMapWaypoint *)waypointForTenant:(GGPTenant *)tenant onFloor:(JMapFloor *)floor;
- (NSMutableArray *)createPathViewsForPaths:(NSArray *)wayfindPaths;
- (void)startWayfindingRoute;
- (void)animatePathViewForWayfindingFloor:(GGPWayfindingFloor *)wayfindingFloor;
- (NSArray *)createWayfindingFloors;
- (GGPWayfindingFloor *)wayfindingFloorForJmapFloor:(JMapFloor *)jmapFloor;
- (void)addMoversForFloor:(GGPWayfindingFloor *)floor;
- (void)addMoverIcon:(UIImageView *)moverImageView ForInstruction:(JMapTextDirectionInstruction *)instruction withDirection:(GGPWayfindingMoverDirection)direction;
- (GGPWayfindingFloor *)wayfindingFloorWithOrder:(NSInteger)order;
- (void)jMapTapAtXY:(NSValue *)atXY;
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
- (BOOL)hasNextFloor;

@end

@implementation GGPJMapViewControllerWayfindingTests

- (void)setUp {
    [super setUp];
    self.mapController = [GGPJMapViewController new];
}

- (void)tearDown {
    self.mapController = nil;
    [super tearDown];
}

- (void)testResetWayfindingData {
    self.mapController.wayfindingStartTenant = [GGPTenant new];
    self.mapController.wayfindingStartFloor = [JMapFloor new];
    self.mapController.wayfindingEndTenant = [GGPTenant new];
    self.mapController.wayfindingEndFloor = [JMapFloor new];
    
    [self.mapController resetWayfindingData];
    
    XCTAssertNil(self.mapController.wayfindingStartTenant);
    XCTAssertNil(self.mapController.wayfindingStartFloor);
    XCTAssertNil(self.mapController.wayfindingEndTenant);
    XCTAssertNil(self.mapController.wayfindingEndFloor);
}

- (void)testConfigureWayfindingStartTenant {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    id mockFloor = OCMPartialMock([JMapFloor new]);
    id mockController = OCMPartialMock(self.mapController);
    OCMExpect([mockController updateEndPinLocation]);
    OCMExpect([mockController placeStartPin]);
    OCMExpect([mockController configureWayfindingView]);
    
    [self.mapController configureWayfindingStartTenant:mockTenant onFloor:mockFloor];
    
    XCTAssertEqual(self.mapController.wayfindingStartTenant, mockTenant);
    XCTAssertEqual(self.mapController.wayfindingStartFloor, mockFloor);
    OCMVerifyAll(mockController);
}

- (void)testConfigureWayfindingEndTenant {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    id mockController = OCMPartialMock(self.mapController);
    OCMExpect([mockController updateEndPinLocation]);
    OCMExpect([mockController configureWayfindingView]);
    
    [self.mapController configureWayfindingEndTenant:mockTenant];
    
    XCTAssertEqual(self.mapController.wayfindingEndTenant, mockTenant);
    OCMVerifyAll(mockController);
}

- (void)testConfigureWayfindingViewOnlyStartTenant {
    self.mapController.wayfindingStartTenant = [GGPTenant new];
    id mockController = OCMPartialMock(self.mapController);
    OCMExpect([mockController zoomToTenant:self.mapController.wayfindingStartTenant onFloor:self.mapController.wayfindingStartFloor withIcons:NO andHighlight:NO]);
    
    [self.mapController configureWayfindingView];
    
    OCMVerifyAll(mockController);
}

- (void)testConfigureWayfindingViewOnlyEndTenant {
    self.mapController.wayfindingEndTenant = [GGPTenant new];
    id mockController = OCMPartialMock(self.mapController);
    OCMExpect([mockController zoomToTenant:self.mapController.wayfindingEndTenant onFloor:self.mapController.wayfindingEndFloor withIcons:NO andHighlight:NO]);
    
    [self.mapController configureWayfindingView];
    
    OCMVerifyAll(mockController);
}

- (void)testConfigureWayfindingViewBothTenants {
    self.mapController.wayfindingStartTenant = [GGPTenant new];
    self.mapController.wayfindingEndTenant = [GGPTenant new];
    id mockController = OCMPartialMock(self.mapController);
    OCMExpect([mockController startWayfindingRoute]);
    
    [self.mapController configureWayfindingView];
    
    OCMVerifyAll(mockController);
}

- (void)testConfigureWayfindingViewNoTenants {
    self.mapController.wayfindingStartTenant = nil;
    self.mapController.wayfindingEndTenant = nil;
    
    id mockMapView = OCMPartialMock(self.mapController.mapView);
    
    [[mockMapView reject] hideAllIcons];
    
    [self.mapController configureWayfindingView];
    
    OCMVerifyAll(mockMapView);
}

- (void)testUpdateEndPinLocation {
    JMapFloor *expectedFloor = [JMapFloor new];
    self.mapController.wayfindingStartFloor = [JMapFloor new];
    self.mapController.wayfindingEndTenant = [GGPTenant new];
    id mockController = OCMPartialMock(self.mapController);
    [OCMStub([mockController floorForTenant:OCMOCK_ANY closestToFloor:OCMOCK_ANY]) andReturn:expectedFloor];
    OCMExpect([mockController placeEndPin]);
    
    [self.mapController updateEndPinLocation];
    
    XCTAssertEqual(self.mapController.wayfindingEndFloor, expectedFloor);
    OCMVerifyAll(mockController);
}

- (void)testPlaceStartPin {
    UIView *mockFloorView = [UIView new];
    CGPoint mockPoint = CGPointMake(10, 10);
    self.mapController.wayfindingStartTenant = [GGPTenant new];
    self.mapController.startPinImageView = [UIImageView new];
    
    id mockController = OCMPartialMock(self.mapController);
    id mockMapView = OCMPartialMock(self.mapController.mapView);
    [OCMStub([mockMapView floorViewFromSequence:OCMOCK_ANY]) andReturn:mockFloorView];
    [OCMStub([mockController mapPointForTenant:OCMOCK_ANY onFloor:OCMOCK_ANY]) andReturnValue:OCMOCK_VALUE(mockPoint)];
    OCMExpect([mockMapView addWayFindView:self.mapController.startPinImageView atXY:mockPoint forFloorId:mockFloorView]);
    
    [self.mapController placeStartPin];
    
    OCMVerifyAll(mockMapView);
}

- (void)testPlaceEndPin {
    UIView *mockFloorView = [UIView new];
    CGPoint mockPoint = CGPointMake(10, 10);
    self.mapController.wayfindingEndTenant = [GGPTenant new];
    self.mapController.endPinImageView = [UIImageView new];
    
    id mockController = OCMPartialMock(self.mapController);
    id mockMapView = OCMPartialMock(self.mapController.mapView);
    [OCMStub([mockMapView floorViewFromSequence:OCMOCK_ANY]) andReturn:mockFloorView];
    [OCMStub([mockController mapPointForTenant:OCMOCK_ANY onFloor:OCMOCK_ANY]) andReturnValue:OCMOCK_VALUE(mockPoint)];
    OCMExpect([mockMapView addWayFindView:self.mapController.endPinImageView atXY:mockPoint forFloorId:mockFloorView]);
    
    [self.mapController placeEndPin];
    
    OCMVerifyAll(mockMapView);
}

- (void)testZoomToFloorPathOnFloor {
    id mockController = OCMPartialMock(self.mapController);
    id mockMapView = OCMPartialMock(self.mapController.mapView);
    id mockFloor = OCMPartialMock([JMapFloor new]);
    id mockPath = OCMPartialMock([JMapPathPerFloor new]);
    id mockLevelController = OCMPartialMock([GGPLevelSelectorCollectionViewController new]);
    [OCMStub([mockController levelSelectorCollectionViewController]) andReturn:mockLevelController];
    
    OCMExpect([[mockController ignoringNonObjectArgs] rectForPoint:CGPointZero]);
    OCMExpect([[mockMapView ignoringNonObjectArgs] zoomToRect:CGRectZero animated:NO]);
    OCMExpect([mockLevelController updateWithSelectedFloor:mockFloor]);
    
    [self.mapController zoomToFloorPath:mockPath onFloor:mockFloor];
    
    OCMVerifyAll(mockController);
    OCMVerifyAll(mockMapView);
}

- (void)testWayfindPathsForSelectedTenants {
    id mockStartTenant = OCMPartialMock([GGPTenant new]);
    id mockEndTenant = OCMPartialMock([GGPTenant new]);
    id mockStartFloor = OCMPartialMock([JMapFloor new]);
    id mockEndFloor = OCMPartialMock([JMapFloor new]);
    
    self.mapController.wayfindingStartTenant = mockStartTenant;
    self.mapController.wayfindingStartFloor = mockStartFloor;
    self.mapController.wayfindingEndTenant = mockEndTenant;
    self.mapController.wayfindingEndFloor = mockEndFloor;
    
    id mockController = OCMPartialMock(self.mapController);
    id mockMapView = OCMPartialMock(self.mapController.mapView);
    
    OCMExpect([mockController waypointForTenant:mockStartTenant onFloor:mockStartFloor]);
    OCMExpect([mockController waypointForTenant:mockEndTenant onFloor:mockEndFloor]);
    OCMExpect([mockMapView findPathForWaypoint:OCMOCK_ANY toWaypoint:OCMOCK_ANY accessibility:OCMOCK_ANY]);
    
    [self.mapController wayfindPathsForSelectedTenants];
    
    OCMVerifyAll(mockController);
    OCMVerifyAll(mockMapView);
}

- (void)testStartWayfindingRoute {
    id mockController = OCMPartialMock(self.mapController);
    id mockFloor1 = OCMPartialMock([GGPWayfindingFloor new]);
    id mockFloor2 = OCMPartialMock([GGPWayfindingFloor new]);
    id mockJmapFloor = OCMPartialMock([JMapFloor new]);
    
    [OCMStub([mockFloor1 jmapFloor]) andReturn:mockJmapFloor];
    [OCMStub([mockController createWayfindingFloors]) andReturn:@[mockFloor1, mockFloor2]];
    OCMStub([mockController addMoversForFloor:OCMOCK_ANY]);

    OCMExpect([mockController moveToFloor:mockJmapFloor]);
    
    [self.mapController startWayfindingRoute];
    
    XCTAssertEqual(self.mapController.currentWayfindingFloor, mockFloor1);
    OCMVerifyAll(mockController);
}

- (void)testCreatePathViewsForPaths {
    id mockPath1 = OCMPartialMock([JMapPathPerFloor new]);
    id mockPath2 = OCMPartialMock([JMapPathPerFloor new]);
    [OCMStub([mockPath1 seq]) andReturn:@(1)];
    [OCMStub([mockPath2 seq]) andReturn:@(2)];
    NSArray *mockPaths = @[mockPath1, mockPath2];
    
    id mockMapView = OCMPartialMock(self.mapController.mapView);
    OCMExpect([mockMapView floorViewFromSequence:@(1)]);
    OCMExpect([mockMapView floorViewFromSequence:@(2)]);
    OCMExpect([mockMapView getLevelBySequence:1]);
    OCMExpect([mockMapView getLevelBySequence:2]);
    
    NSArray *resultPathViews = [self.mapController createPathViewsForPaths:mockPaths];
    
    XCTAssertEqual(resultPathViews.count, 2);
    
    GGPWayfindingPathView *firstPath = resultPathViews.firstObject;
    
    XCTAssertNotNil(firstPath.pathPerFloor);
    XCTAssertEqual(firstPath.animationDelegate, self.mapController);
}

- (void)testAnimatePathViewForWayfindingFloor {
    id mockFloor = OCMPartialMock([GGPWayfindingFloor new]);
    GGPWayfindingPathView *mockPathView = OCMPartialMock([GGPWayfindingPathView new]);
    
    [OCMStub([mockFloor pathView]) andReturn:mockPathView];
    
    OCMExpect([mockPathView animatePath]);
    
    [self.mapController animatePathViewForWayfindingFloor:mockFloor];
    
    XCTAssertEqual(mockPathView.animationDelegate, self.mapController);
    OCMVerifyAll((id)mockPathView);
}

- (void)testWayfindingFloorForJmapFloor {
    GGPWayfindingFloor *mockWayfindingFloor1 = OCMPartialMock([GGPWayfindingFloor new]);
    GGPWayfindingFloor *mockWayfindingFloor2 = OCMPartialMock([GGPWayfindingFloor new]);
    JMapFloor *mockJmapFloor1 = OCMPartialMock([JMapFloor new]);
    JMapFloor *mockJmapFloor2 = OCMPartialMock([JMapFloor new]);
    
    [OCMStub([mockJmapFloor1 mapId]) andReturn:@(1)];
    [OCMStub([mockJmapFloor2 mapId]) andReturn:@(2)];
    
    [OCMStub([mockWayfindingFloor1 jmapFloor]) andReturn:mockJmapFloor1];
    [OCMStub([mockWayfindingFloor2 jmapFloor]) andReturn:mockJmapFloor2];
    
    self.mapController.wayfindingFloors = @[mockWayfindingFloor1, mockWayfindingFloor2];
    
    XCTAssertEqual([self.mapController wayfindingFloorForJmapFloor:mockJmapFloor1], mockWayfindingFloor1);
    XCTAssertEqual([self.mapController wayfindingFloorForJmapFloor:mockJmapFloor2], mockWayfindingFloor2);
}

- (void)testAddMoversForFloorCurrentInstructionIsMover {
    id mockController = OCMPartialMock(self.mapController);
    id mockFloor1 = OCMPartialMock([GGPWayfindingFloor new]);
    id mockFloor2 = OCMPartialMock([GGPWayfindingFloor new]);
    JMapTextDirectionInstruction *mockInstruction1 = OCMPartialMock([JMapTextDirectionInstruction new]);
    JMapTextDirectionInstruction *mockInstruction2 = OCMPartialMock([JMapTextDirectionInstruction new]);
    JMapTextDirectionInstruction *mockInstruction3 = OCMPartialMock([JMapTextDirectionInstruction new]);
    JMapTextDirectionInstruction *mockInstruction4 = OCMPartialMock([JMapTextDirectionInstruction new]);
    
    [OCMStub([mockInstruction2 type]) andReturn:@"mover"];
    
    [OCMStub([mockFloor1 textDirections]) andReturn:@[mockInstruction1, mockInstruction2]];
    [OCMStub([mockFloor2 textDirections]) andReturn:@[mockInstruction3, mockInstruction4]];
    
    [OCMStub([[mockController ignoringNonObjectArgs] wayfindingFloorWithOrder:0]) andReturn:mockFloor2];
    
    OCMExpect([mockController addMoverIcon:OCMOCK_ANY ForInstruction:mockInstruction2 withDirection:GGPWayfindingMoverDirectionForward]);
    OCMExpect([mockController addMoverIcon:OCMOCK_ANY ForInstruction:mockInstruction3 withDirection:GGPWayfindingMoverDirectionBackward]);
    
    [self.mapController addMoversForFloor:mockFloor1];
    
    OCMVerifyAll(mockController);
}

- (void)testAddMoversForFloorCurrentInstructionIsNotMover {
    id mockController = OCMPartialMock(self.mapController);
    id mockFloor1 = OCMPartialMock([GGPWayfindingFloor new]);
    id mockFloor2 = OCMPartialMock([GGPWayfindingFloor new]);
    JMapTextDirectionInstruction *mockInstruction1 = OCMPartialMock([JMapTextDirectionInstruction new]);
    JMapTextDirectionInstruction *mockInstruction2 = OCMPartialMock([JMapTextDirectionInstruction new]);
    JMapTextDirectionInstruction *mockInstruction3 = OCMPartialMock([JMapTextDirectionInstruction new]);
    JMapTextDirectionInstruction *mockInstruction4 = OCMPartialMock([JMapTextDirectionInstruction new]);
    
    [OCMStub([mockInstruction2 type]) andReturn:@"not a mover"];
    
    [OCMStub([mockFloor1 textDirections]) andReturn:@[mockInstruction1, mockInstruction2]];
    [OCMStub([mockFloor2 textDirections]) andReturn:@[mockInstruction3, mockInstruction4]];
    
    [OCMStub([[mockController ignoringNonObjectArgs] wayfindingFloorWithOrder:0]) andReturn:mockFloor2];
    
    [[[mockController reject] ignoringNonObjectArgs] addMoverIcon:OCMOCK_ANY ForInstruction:OCMOCK_ANY withDirection:0];
    
    [self.mapController addMoversForFloor:mockFloor1];
    
    OCMVerifyAll(mockController);
}

- (void)testWayfindingFloorWithOrder {
    id mockWayfindingFloor1 = OCMPartialMock([GGPWayfindingFloor new]);
    id mockWayfindingFloor2 = OCMPartialMock([GGPWayfindingFloor new]);
    id mockWayfindingFloor3 = OCMPartialMock([GGPWayfindingFloor new]);
    
    [OCMStub([mockWayfindingFloor1 order]) andReturnValue:OCMOCK_VALUE(1)];
    [OCMStub([mockWayfindingFloor2 order]) andReturnValue:OCMOCK_VALUE(2)];
    [OCMStub([mockWayfindingFloor3 order]) andReturnValue:OCMOCK_VALUE(3)];
    
    self.mapController.wayfindingFloors = @[mockWayfindingFloor1, mockWayfindingFloor2, mockWayfindingFloor3];
    
    XCTAssertEqual([self.mapController wayfindingFloorWithOrder:1], mockWayfindingFloor1);
    XCTAssertEqual([self.mapController wayfindingFloorWithOrder:2], mockWayfindingFloor2);
    XCTAssertEqual([self.mapController wayfindingFloorWithOrder:3], mockWayfindingFloor3);
}

- (void)testJmapTapAtXYInsideMoverForwardDirection {
    id mockController = OCMPartialMock(self.mapController);
    id mockWayfindingFloor = OCMPartialMock([GGPWayfindingFloor new]);
    GGPWayfindingMover *mockMover = OCMPartialMock([GGPWayfindingMover new]);
    
    [OCMStub([mockMover mapRect]) andReturnValue:OCMOCK_VALUE(CGRectMake(0, 0, 30, 30))];
    [OCMStub([mockMover floorOrder]) andReturnValue:OCMOCK_VALUE(3)];
    [OCMStub([mockMover direction]) andReturnValue:OCMOCK_VALUE(GGPWayfindingMoverDirectionForward)];
    [OCMStub([mockWayfindingFloor movers]) andReturn:@[mockMover]];
    
    NSValue *mockTapPoint = [NSValue valueWithCGPoint:CGPointMake(20, 10)];
    self.mapController.currentWayfindingFloor = mockWayfindingFloor;
    
    OCMExpect([mockController wayfindingFloorWithOrder:4]);
    
    [self.mapController jMapTapAtXY:mockTapPoint];
    
    OCMVerifyAll(mockController);
}

- (void)testJmapTapAtXYInsideMoverBackwardDirection {
    id mockController = OCMPartialMock(self.mapController);
    id mockWayfindingFloor = OCMPartialMock([GGPWayfindingFloor new]);
    GGPWayfindingMover *mockMover = OCMPartialMock([GGPWayfindingMover new]);
    
    [OCMStub([mockMover mapRect]) andReturnValue:OCMOCK_VALUE(CGRectMake(0, 0, 30, 30))];
    [OCMStub([mockMover floorOrder]) andReturnValue:OCMOCK_VALUE(3)];
    [OCMStub([mockMover direction]) andReturnValue:OCMOCK_VALUE(GGPWayfindingMoverDirectionBackward)];
    [OCMStub([mockWayfindingFloor movers]) andReturn:@[mockMover]];
    
    NSValue *mockTapPoint = [NSValue valueWithCGPoint:CGPointMake(20, 10)];
    self.mapController.currentWayfindingFloor = mockWayfindingFloor;
    
    OCMExpect([mockController wayfindingFloorWithOrder:2]);
    
    [self.mapController jMapTapAtXY:mockTapPoint];
    
    OCMVerifyAll(mockController);
}

- (void)testJmapTapAtXYOutsideMover {
    id mockController = OCMPartialMock(self.mapController);
    id mockWayfindingFloor = OCMPartialMock([GGPWayfindingFloor new]);
    GGPWayfindingMover *mockMover = OCMPartialMock([GGPWayfindingMover new]);
    
    [OCMStub([mockMover mapRect]) andReturnValue:OCMOCK_VALUE(CGRectMake(0, 0, 30, 30))];
    [OCMStub([mockWayfindingFloor movers]) andReturn:@[mockMover]];
    
    NSValue *mockTapPoint = [NSValue valueWithCGPoint:CGPointMake(200, 10)];
    self.mapController.currentWayfindingFloor = mockWayfindingFloor;
    
    [[[mockController reject] ignoringNonObjectArgs] wayfindingFloorWithOrder:0];
    
    [self.mapController jMapTapAtXY:mockTapPoint];
    
    OCMVerifyAll(mockController);
}

- (void)testAnimationDidStopHasNextFloor {
    id mockController = OCMPartialMock(self.mapController);
    id mockWayfindingFloor = OCMPartialMock([GGPWayfindingFloor new]);
    id mockMover1 = OCMPartialMock([GGPWayfindingMover new]);
    id mockMover2 = OCMPartialMock([GGPWayfindingMover new]);
    
    [OCMStub([mockController hasNextFloor]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockWayfindingFloor movers]) andReturn:@[mockMover1, mockMover2]];
    [OCMStub([mockController currentWayfindingFloor]) andReturn:mockWayfindingFloor];
    
    [[mockMover1 reject] animatePulse];
    OCMExpect([mockMover2 animatePulse]);
    
    [self.mapController animationDidStop:nil finished:YES];
    
    OCMVerifyAll(mockMover1);
    OCMVerifyAll(mockMover2);
}

- (void)testAnimationDidStopNoNextFloor {
    id mockController = OCMPartialMock(self.mapController);
    id mockWayfindingFloor = OCMPartialMock([GGPWayfindingFloor new]);
    id mockMover1 = OCMPartialMock([GGPWayfindingMover new]);
    id mockMover2 = OCMPartialMock([GGPWayfindingMover new]);
    
    [OCMStub([mockController hasNextFloor]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockWayfindingFloor movers]) andReturn:@[mockMover1, mockMover2]];
    [OCMStub([mockController currentWayfindingFloor]) andReturn:mockWayfindingFloor];
    
    [[mockMover1 reject] animatePulse];
    [[mockMover2 reject] animatePulse];
    
    [self.mapController animationDidStop:nil finished:YES];
    
    OCMVerifyAll(mockMover1);
    OCMVerifyAll(mockMover2);
}

- (void)testUpdateWayfindingFloorForJmapFloor {
    id mockController = OCMPartialMock(self.mapController);
    id mockWayfindingFloor = OCMPartialMock([GGPWayfindingFloor new]);
    
    [OCMStub([mockController wayfindingFloorForJmapFloor:OCMOCK_ANY]) andReturn:mockWayfindingFloor];
    
    OCMExpect([mockController zoomToFloorPath:OCMOCK_ANY onFloor:OCMOCK_ANY]);
    OCMExpect([mockController animatePathViewForWayfindingFloor:mockWayfindingFloor]);
    
    [self.mapController updateWayfindingFloorForJmapFloor:[JMapFloor new]];
    
    XCTAssertEqual(self.mapController.currentWayfindingFloor, mockWayfindingFloor);
    OCMVerifyAll(mockController);
}

- (void)testUpdateWayfindingFloorForJmapFloorIsNil {
    id mockController = OCMPartialMock(self.mapController);
    
    [OCMStub([mockController wayfindingFloorForJmapFloor:OCMOCK_ANY]) andReturn:nil];
    
    [[mockController reject] zoomToFloorPath:OCMOCK_ANY onFloor:OCMOCK_ANY];
    [[mockController reject] animatePathViewForWayfindingFloor:OCMOCK_ANY];
    
    [self.mapController updateWayfindingFloorForJmapFloor:[JMapFloor new]];
    
    OCMVerifyAll(mockController);
}

@end
