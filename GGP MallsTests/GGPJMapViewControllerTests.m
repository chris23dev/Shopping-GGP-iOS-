//
//  GGPJMapViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPDirectoryViewController.h"
#import "GGPFilterItem.h"
#import "GGPJMapViewController.h"
#import "GGPJmapViewController+Highlighting.h"
#import "GGPJMapViewControllerDelegate.h"
#import "GGPLevelCell.h"
#import "GGPLevelSelectorCollectionViewController.h"
#import "GGPMall.h"
#import "GGPTenant.h"
#import "GGPTenantDetailCardViewController.h"
#import "GGPTenantDetailViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import <Foundation/Foundation.h>
#import <JMap/JMap.h>
#import <UIKit/UIKit.h>

@interface GGPJMapViewController (Testing) <JMapDelegate, JMapDataSource, GGPJMapViewControllerDelegate>

@property (strong, nonatomic) JMapContainerView *mapView;
@property (strong, nonatomic) NSArray *allDestinations;
@property (strong, nonatomic) NSMutableArray *allUnitLabelVCs;
@property (strong, nonatomic) NSArray *floors;
@property (strong, nonatomic) NSDate *lastScaleFactorChange;
@property (strong, nonatomic) GGPTenant *tenantToDisplay;
@property (strong, nonatomic) GGPTenantDetailCardViewController *tenantDetailCardViewController;
@property (strong, nonatomic) GGPLevelSelectorCollectionViewController *levelSelectorCollectionViewController;
@property (strong, nonatomic) NSMutableArray *highlightedDestinations;

@property (weak, nonatomic) IBOutlet UIView *detailCardContainer;
@property (weak, nonatomic) IBOutlet UIView *levelSelectorContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailCardContainerBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelContainerWidthConstraint;

- (void)configureMapView;
- (void)configureLevelSelection;
- (void)updateFloorSelection;
- (void)moveToFloor:(JMapFloor *)tenantFloor;
- (void)resetMapView;
- (void)displayDetailCardForTenant:(GGPTenant *)tenant;
- (void)updateExistingDetailCardWithNewTenant:(GGPTenant *)tenant;
- (void)handleTappedDestination:(JMapDestination *)destination;
- (void)highlightTappedDestination:(JMapDestination *)destination;
- (void)updateLevelContainerWidthAndHeightForFloors:(NSArray *)floors;
- (void)unhighlightUnitsBasedOnFilters;
- (void)highlightSelectedDestination:(JMapDestination *)selectedDestination;

- (NSString *)leaseIdFromDestinationClientId:(NSString *)destinationClientId;
- (JMapDestination *)retrieveDestinationFromLeaseId:(NSInteger)leaseId;
- (NSString *)retrieveFormattedStringForProximity:(NSString *)proximityName;

@end

@interface GGPJMapViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPJMapViewController *jMapViewController;
@property (assign, nonatomic) NSInteger mallId;

@end

@implementation GGPJMapViewControllerTests

- (void)setUp {
    [super setUp];
    self.mallId = 1016;
    self.jMapViewController = [GGPJMapViewController new];
    [self.jMapViewController view];
}

- (void)tearDown {
    self.jMapViewController = nil;
    [super tearDown];
}

- (void)testInitialization {
    id mockMapVC = OCMPartialMock(self.jMapViewController);
    [OCMStub([mockMapVC configureMapView]) andDo:nil];
    [self.jMapViewController view];
    
    XCTAssertNotNil(self.jMapViewController.allUnitLabelVCs);
    XCTAssertNotNil(self.jMapViewController.lastScaleFactorChange);
    XCTAssertNotNil(self.jMapViewController.detailCardContainer);
    XCTAssertNotNil(self.jMapViewController.levelSelectorContainer);
    
    [mockMapVC stopMocking];
}

- (void)testMapViewDataReady {
    id mockMapView = OCMPartialMock(self.jMapViewController.mapView);
    
    OCMExpect([mockMapView getDestinations]);
    OCMExpect([mockMapView getLevels]);
    [self.jMapViewController jMapViewDataReady:nil withVenuData:nil didFailLoadWithError:nil];
    
    OCMVerifyAll(mockMapView);
}

- (void)testContentScaleChangeShouldUpdate {
    NSDate *pastDate = [[NSDate date] dateByAddingTimeInterval:-60];
    self.jMapViewController.lastScaleFactorChange = pastDate;
    id mockMapVC = OCMPartialMock(self.jMapViewController);
    id mockFloor = OCMPartialMock([JMapFloor new]);
    OCMExpect([mockMapVC jMapViewContentScaleFactor:@(1) onFloor:mockFloor]);
    
    [self.jMapViewController jMapViewContentScaleFactorChange:@(1) onFloor:mockFloor];
    
    OCMVerifyAll(mockMapVC);
    XCTAssertNotEqualObjects(self.jMapViewController.lastScaleFactorChange, pastDate);
    
    [mockMapVC stopMocking];
}

- (void)testContentScaleChangeShouldNotUpdate {
    NSDate *currentDate = [NSDate date];
    self.jMapViewController.lastScaleFactorChange = currentDate;
    id mockMapVC = OCMPartialMock(self.jMapViewController);
    id mockFloor = OCMPartialMock([JMapFloor new]);
    [[mockMapVC reject] jMapViewContentScaleFactor:@(1) onFloor:mockFloor];
    
    [self.jMapViewController jMapViewContentScaleFactorChange:@(1) onFloor:mockFloor];
    
    OCMVerifyAll(mockMapVC);
    XCTAssertEqualObjects(self.jMapViewController.lastScaleFactorChange, currentDate);
    
    [mockMapVC stopMocking];
}

- (void)testLeaseIdFromDestinationClientId {
    id mockDestination = OCMClassMock([JMapDestination class]);
    [OCMStub([mockDestination clientId]) andReturn:@"12345-111"];
    XCTAssertEqualObjects([self.jMapViewController leaseIdFromDestinationClientId:[mockDestination clientId]], @"12345");
}

- (void)testRetrieveDestinationFromLeaseId {
    id mockDestination1 = OCMClassMock([JMapDestination class]);
    id mockDestination2 = OCMClassMock([JMapDestination class]);
    id mockDestination3 = OCMClassMock([JMapDestination class]);
    id mockDestination4 = OCMClassMock([JMapDestination class]);
    
    [OCMStub([mockDestination1 clientId]) andReturn:@"1234-777"];
    [OCMStub([mockDestination2 clientId]) andReturn:@"MANUAL"];
    [OCMStub([mockDestination3 clientId]) andReturn:@"555"];
    [OCMStub([mockDestination4 clientId]) andReturn:nil];
    
    self.jMapViewController.allDestinations = @[mockDestination4, mockDestination1, mockDestination2, mockDestination3];
    
    XCTAssertEqualObjects([self.jMapViewController retrieveDestinationFromLeaseId:1234], mockDestination1);
    XCTAssertEqualObjects([self.jMapViewController retrieveDestinationFromLeaseId:555], mockDestination3);
    XCTAssertEqualObjects([self.jMapViewController retrieveDestinationFromLeaseId:66], nil);
}

- (void)testLocationDescriptionForTenant {
    id mockMapViewController = OCMPartialMock(self.jMapViewController);
    JMapDestination *mockDestination = OCMClassMock([JMapDestination class]);
    JMapProximities *mockProximity = OCMClassMock([JMapProximities class]);
    NSString *expectedLocation = @"Level 1";
    
    [OCMStub([mockDestination level]) andReturn:expectedLocation];
    [OCMStub([mockDestination destinationProximities]) andReturn:@[mockProximity]];
    [OCMStub([[mockMapViewController ignoringNonObjectArgs] retrieveDestinationFromLeaseId:0]) andReturn:mockDestination];
    
    NSString *result = [self.jMapViewController locationDescriptionForTenant:nil];
    XCTAssertEqualObjects(result, expectedLocation);
}

- (void)testLocationDescriptionForTenantAnchorTenant {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    
    [OCMStub([mockTenant isAnchor]) andReturnValue:OCMOCK_VALUE(YES)];
    
    NSString *result = [self.jMapViewController locationDescriptionForTenant:mockTenant];
    XCTAssertEqualObjects(result, [@"DETAILS_ANCHOR_STORE" ggp_toLocalized]);
}

- (void)testRetrieveFormattedStringForProximitySingleLevel {
    id mockMapVC = OCMPartialMock(self.jMapViewController);
    [OCMStub([mockMapVC floors]) andReturn:@[@""]];
    
    NSString *tenantName = @"macys";
    NSString *expectedString = [NSString stringWithFormat:@"Near %@", tenantName];
    XCTAssertEqualObjects([self.jMapViewController retrieveFormattedStringForProximity:tenantName], expectedString);
}

- (void)testRetrieveFormattedStringForProximityMultiLevel {
    id mockMapVC = OCMPartialMock(self.jMapViewController);
    [OCMStub([mockMapVC floors]) andReturn:@[@"", @""]];
    
    NSString *tenantName = @"macys";
    NSString *expectedString = [NSString stringWithFormat:@", near %@", tenantName];
    XCTAssertEqualObjects([self.jMapViewController retrieveFormattedStringForProximity:tenantName], expectedString);
}

- (void)testRetrieveFormattedStringForProximityNil {
    id mockMapVC = OCMPartialMock(self.jMapViewController);
    [OCMStub([mockMapVC floors]) andReturn:@[@""]];

    XCTAssertEqualObjects([self.jMapViewController retrieveFormattedStringForProximity:nil], @"");
}

- (void)testResetMapViewAndFiltersNoWithoutFilteredDestinations {
    id mockMapView = OCMPartialMock(self.jMapViewController.mapView);
    NSMutableArray *mockFilteredDestinations = [NSMutableArray new];
    
    self.jMapViewController.highlightedDestinations = mockFilteredDestinations;

    OCMExpect([mockMapView unhighlightAllUnits]);
    
    [self.jMapViewController resetMapView];
    
    XCTAssertNotNil(self.jMapViewController.highlightedDestinations);
    
    OCMVerifyAll(mockMapView);
}

- (void)testResetMapViewAndFiltersNoWithFilteredDestinations {
    id mockMapViewController = OCMPartialMock(self.jMapViewController);
    NSMutableArray *mockFilteredDestinations = [@[@"mock filter"] mutableCopy];
    
    self.jMapViewController.highlightedDestinations = mockFilteredDestinations;
    
    OCMExpect([mockMapViewController unhighlightUnitsBasedOnFilters]);
    
    [self.jMapViewController resetMapView];
    
    XCTAssertNotNil(self.jMapViewController.highlightedDestinations);
    
    OCMVerifyAll(mockMapViewController);
}

- (void)testResetMapViewAndFiltersYesWithFilteredDestinations {
    id mockMapView = OCMPartialMock(self.jMapViewController.mapView);
    NSMutableArray *mockFilteredDestinations = [@[@"mock filter"] mutableCopy];
    
    self.jMapViewController.highlightedDestinations = mockFilteredDestinations;
    
    OCMExpect([mockMapView unhighlightAllUnits]);
    
    [self.jMapViewController resetMapViewAndFilters:YES];
    
    XCTAssertEqual(self.jMapViewController.highlightedDestinations.count, 0);
    
    OCMVerifyAll(mockMapView);
}

- (void)testResetMapView {
    id mockMapView = OCMPartialMock(self.jMapViewController.mapView);
    id mockView = OCMClassMock(UIView.class);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [OCMStub([[mockView ignoringNonObjectArgs] animateWithDuration:0 animations:OCMOCK_ANY completion:OCMOCK_ANY]) andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(BOOL finished) = nil;
        [invocation getArgument:&completionHandler atIndex:4];
        completionHandler(YES);
        [expectation fulfill];
    }];
    
    OCMExpect([mockMapView unhighlightAllUnits]);
    
    [self.jMapViewController resetMapViewAndFilters:YES];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
    
    XCTAssertNil(self.jMapViewController.tenantDetailCardViewController);
    XCTAssertTrue(self.jMapViewController.detailCardContainer.hidden);
    XCTAssertFalse(self.jMapViewController.levelSelectorContainer.hidden);
    
    OCMVerifyAll(mockMapView);
    
    [mockView stopMocking];
}

@end
