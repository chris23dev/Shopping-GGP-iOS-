//
//  GGPJmapViewControllerHighlightingTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJmapViewController+Highlighting.h"
#import "GGPJmapViewcontroller+Levels.h"
#import "GGPJMapViewController+Parking.h"
#import "GGPTenant.h"
#import "GGPTenantDetailCardViewController.h"
#import "GGPTenantDetailViewController.h"
#import <JMap/JMap.h>

@interface GGPJMapViewControllerHighlightingTests : XCTestCase

@property (strong, nonatomic) GGPJMapViewController *jMapViewController;

@end

@interface GGPJMapViewController (Testing)

@property (weak, nonatomic) IBOutlet UIView *levelSelectorContainer;
@property (weak, nonatomic) IBOutlet UIView *detailCardContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailCardContainerBottomConstraint;

@property (strong, nonatomic) JMapContainerView *mapView;
@property (strong, nonatomic) NSArray *allDestinations;
@property (strong, nonatomic) NSMutableArray *highlightedDestinations;
@property (strong, nonatomic) GGPTenantDetailCardViewController *tenantDetailCardViewController;
@property (assign, nonatomic) BOOL isParkingAvailabilityActive;

- (void)highlightSelectedDestination:(JMapDestination *)selectedDestination;
- (void)highlightTappedDestination:(JMapDestination *)tappedDestination;
- (void)highlightTenants:(NSArray *)tenants;
- (void)unhighlightUnitsBasedOnFilters;
- (NSInteger)activeFilterCountForFloor:(JMapFloor *)floor;

@end

@implementation GGPJMapViewControllerHighlightingTests

- (void)setUp {
    [super setUp];
    self.jMapViewController = [GGPJMapViewController new];
}

- (void)tearDown {
    self.jMapViewController = nil;
    [super tearDown];
}

- (void)testUnhighlightUnitWithinFilteredList {
    id mockJMapViewController = OCMPartialMock(self.jMapViewController);
    id mockDestionation = OCMClassMock([JMapDestination class]);
    NSArray *mockAllDestinations = @[mockDestionation];
    NSMutableArray *mockFilteredDestinations = [@[mockDestionation] mutableCopy];
    
    self.jMapViewController.allDestinations = mockAllDestinations;
    self.jMapViewController.highlightedDestinations = mockFilteredDestinations;
    
    OCMExpect([mockJMapViewController highlightSelectedDestination:mockDestionation]);
    
    [self.jMapViewController unhighlightUnitsBasedOnFilters];
    
    OCMVerifyAll(mockJMapViewController);
}

- (void)testUnhighlightUnitNotWithinFilteredList {
    id mockMapView = OCMPartialMock(self.jMapViewController.mapView);
    id mockNonFilteredDestionation = OCMClassMock([JMapDestination class]);
    id mockFilteredDestination = OCMClassMock([JMapDestination class]);
    NSArray *mockAllDestinations = @[mockNonFilteredDestionation];
    NSMutableArray *mockFilteredDestinations = [@[mockFilteredDestination] mutableCopy];
    
    OCMExpect([mockMapView setDestinationUnHighlight:mockNonFilteredDestionation]);
    
    self.jMapViewController.allDestinations = mockAllDestinations;
    self.jMapViewController.highlightedDestinations = mockFilteredDestinations;
    [self.jMapViewController unhighlightUnitsBasedOnFilters];
    
    OCMVerifyAll(mockMapView);
}

- (void)testHighlightUnits {
//    id mockJMapViewController = OCMPartialMock(self.jMapViewController);
//    id mockMapView = OCMPartialMock(self.jMapViewController.mapView);
//    JMapDestination *mockDestination = OCMClassMock([JMapDestination class]);
//    GGPTenant *mockTenant = OCMClassMock([GGPTenant class]);
//    NSArray *mockFilteredTenants = @[mockTenant];
//    
//    [OCMStub([mockTenant leaseId]) andReturnValue:@(1234)];
//    [OCMStub([mockJMapViewController retrieveDestinationFromLeaseId:mockTenant.leaseId]) andReturn:mockDestination];
//    
//    XCTAssertFalse(self.jMapViewController.highlightedDestinations.count);
//    
//    XCTestExpectation *highlightSelectedDestinationExpectation = [self expectationWithDescription:@"highlightSelectedDestination"];
//    [OCMStub([mockJMapViewController highlightSelectedDestination:OCMOCK_ANY]) andDo:^(NSInvocation *invocation) {
//        [highlightSelectedDestinationExpectation fulfill];
//    }];
//    
//    XCTestExpectation *unhighlightAllUnitsExpectation = [self expectationWithDescription:@"unhighlightAllUnits"];
//    [OCMStub([mockMapView unhighlightAllUnits]) andDo:^(NSInvocation *invocation) {
//        [unhighlightAllUnitsExpectation fulfill];
//    }];
//    
//    [self.jMapViewController highlightTenants:mockFilteredTenants];
//    
//    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testTappedUnitWithNoTenant {
    id mockTenantDetailCardViewController = OCMPartialMock([GGPTenantDetailCardViewController new]);
    id mockDestination = OCMPartialMock([JMapDestination new]);
    
    OCMExpect([mockTenantDetailCardViewController resetMapView]);
    
    [self.jMapViewController handleTappedDestination:mockDestination];
    
    OCMVerify(mockTenantDetailCardViewController);
}

- (void)testTappedUnitHasFilteredDestinations {
    id mockJMapViewController = OCMPartialMock(self.jMapViewController);
    id mockDestination = OCMPartialMock([JMapDestination new]);
    NSMutableArray *mockFilteredDestinations = [@[@"mock filter"] mutableCopy];
    
    OCMExpect([mockJMapViewController unhighlightUnitsBasedOnFilters]);
    
    self.jMapViewController.highlightedDestinations = mockFilteredDestinations;
    [self.jMapViewController handleTappedDestination:mockDestination];
    
    OCMVerifyAll(mockJMapViewController);
}

- (void)testTappedUnitHasNoFilteredDestinations {
    id mockMapView = OCMPartialMock(self.jMapViewController.mapView);
    id mockDestination = OCMPartialMock([JMapDestination new]);
    NSMutableArray *mockFilteredDestinations = [NSMutableArray new];
    
    OCMExpect([mockMapView unhighlightAllUnits]);
    
    self.jMapViewController.highlightedDestinations = mockFilteredDestinations;
    [self.jMapViewController handleTappedDestination:mockDestination];
    
    OCMVerifyAll(mockMapView);
}

- (void)testTappedUnitHasNoDetailCardWithTenant {
    id mockJMapViewController = OCMPartialMock(self.jMapViewController);
    id mockDelegate = OCMProtocolMock(@protocol(GGPJMapViewControllerDelegate));
    id mockTenant = OCMClassMock(GGPTenant.class);
    id mockDestination = OCMPartialMock([JMapDestination new]);
    
    OCMStub([mockDelegate tenantFromLeaseId:OCMOCK_ANY]).andReturn(mockTenant);
    
    OCMExpect([mockJMapViewController displayDetailCardForTenant:mockTenant]);
    OCMExpect([mockJMapViewController highlightTappedDestination:OCMOCK_ANY]);
    
    self.jMapViewController.mapViewControllerDelegate = mockDelegate;
    self.jMapViewController.tenantDetailCardViewController = nil;
    [self.jMapViewController handleTappedDestination:mockDestination];
    
    OCMVerifyAll(mockJMapViewController);
}

- (void)testTappedUnitHasExistingDetailCardWithTenant {
    id mockJMapViewController = OCMPartialMock(self.jMapViewController);
    id mockTenantDetailCardViewController = OCMPartialMock([GGPTenantDetailCardViewController new]);
    id mockDelegate = OCMProtocolMock(@protocol(GGPJMapViewControllerDelegate));
    id mockTenant = OCMPartialMock([GGPTenant new]);
    id mockDestination = OCMPartialMock([JMapDestination new]);
    
    OCMStub([mockDelegate tenantFromLeaseId:OCMOCK_ANY]).andReturn(mockTenant);
    
    OCMExpect([mockTenantDetailCardViewController updateWithTenant:mockTenant]);
    OCMExpect([mockJMapViewController highlightTappedDestination:OCMOCK_ANY]);
    
    self.jMapViewController.mapViewControllerDelegate = mockDelegate;
    self.jMapViewController.tenantDetailCardViewController = mockTenantDetailCardViewController;
    [self.jMapViewController handleTappedDestination:mockDestination];
    
    OCMVerifyAll(mockTenantDetailCardViewController);
    OCMVerifyAll(mockJMapViewController);
}

- (void)testDisplayDetailCardForTenant {
    [self.jMapViewController view];
    id mockTenantDetailViewController = OCMPartialMock([GGPTenantDetailViewController new]);
    id mockTenant = OCMPartialMock([GGPTenant new]);
    
    OCMExpect([mockTenantDetailViewController initWithTenantDetails:mockTenant]);
    
    [self.jMapViewController displayDetailCardForTenant:mockTenant];
    
    XCTAssertNotNil(self.jMapViewController.detailCardContainer);
    XCTAssertNotNil(self.jMapViewController.tenantDetailCardViewController);
    XCTAssertEqual(self.jMapViewController.detailCardContainerBottomConstraint.constant, 0);
    XCTAssertFalse(self.jMapViewController.detailCardContainer.hidden);
    XCTAssertTrue(self.jMapViewController.levelSelectorContainer.hidden);
    
    OCMVerify(mockTenantDetailViewController);
    [mockTenantDetailViewController stopMocking];
}

- (void)testActiveFilterCountForFloor {
    id mockMapViewController = OCMPartialMock(self.jMapViewController);
    id mockMapView = OCMPartialMock(self.jMapViewController.mapView);
    id mockFloor = OCMPartialMock([JMapFloor new]);
    
    id mockDestination1 = OCMPartialMock([JMapDestination new]);
    id mockDestination2 = OCMPartialMock([JMapDestination new]);
    id mockDestination3 = OCMPartialMock([JMapDestination new]);
    
    id mockDestinations = @[mockDestination1, mockDestination2];
    id mockHighlightedDestinations = @[mockDestination1, mockDestination3];
    
    [OCMStub([mockMapView getDestinationsByFloorSequence:OCMOCK_ANY]) andReturn:mockDestinations];
    [OCMStub([mockMapViewController highlightedDestinations]) andReturn:mockHighlightedDestinations];
    
    XCTAssertEqual([self.jMapViewController activeFilterCountForFloor:mockFloor], 1);
}

- (void)testFilterTextForFloorParkingActive {
    id mockController = OCMPartialMock(self.jMapViewController);
    
    [OCMStub([mockController isParkingAvailabilityActive]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockFloor1 = OCMClassMock([JMapFloor class]);
    id mockFloor2 = OCMClassMock([JMapFloor class]);
    
    [OCMStub([mockController parkingAvailabileForFloor:mockFloor1]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockController parkingAvailabileForFloor:mockFloor2]) andReturnValue:OCMOCK_VALUE(NO)];
    
    XCTAssertEqualObjects([self.jMapViewController filterTextForFloor:mockFloor1], @"P");
    XCTAssertNil([self.jMapViewController filterTextForFloor:mockFloor2]);
}

- (void)testFilterTextForFloorParkingInactive {
    id mockController = OCMPartialMock(self.jMapViewController);
    
    [OCMStub([mockController isParkingAvailabilityActive]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockFloor1 = OCMClassMock([JMapFloor class]);
    id mockFloor2 = OCMClassMock([JMapFloor class]);
    
    [OCMStub([mockController activeFilterCountForFloor:mockFloor1]) andReturnValue:OCMOCK_VALUE(5)];
    [OCMStub([mockController activeFilterCountForFloor:mockFloor2]) andReturnValue:OCMOCK_VALUE(0)];
    
    XCTAssertEqualObjects([self.jMapViewController filterTextForFloor:mockFloor1], @"5");
    XCTAssertNil([self.jMapViewController filterTextForFloor:mockFloor2]);
}

@end
