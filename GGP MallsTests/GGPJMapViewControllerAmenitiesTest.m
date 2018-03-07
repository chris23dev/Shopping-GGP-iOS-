//
//  GGPJMapViewControllerAmenitiesTest.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapViewController+Amenities.h"
#import "GGPAmenityCollectionViewController.h"
#import "GGPAmenity.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <JMap/JMap.h>

@interface GGPJMapViewController ()

@property (weak, nonatomic) IBOutlet UIView *amenitiesContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amenitiesContainerWidthConstraint;
@property (strong, nonatomic) JMapContainerView *mapView;
@property (strong, nonatomic) NSArray *mallAmenityTypes;
@property (strong, nonatomic) NSArray *mallAmenities;
@property (strong, nonatomic) NSArray *selectedAmenityWaypoints;

- (NSArray *)filterableAmenities;
- (BOOL)mallHasAmenityType:(NSString *)type;
- (NSArray *)amenityTypesForMall;

@end

@interface GGPJMapViewControllerAmenitiesTest : XCTestCase

@property (strong, nonatomic) GGPJMapViewController *jmapViewController;

@end

@implementation GGPJMapViewControllerAmenitiesTest

- (void)setUp {
    [super setUp];
    self.jmapViewController = [GGPJMapViewController new];
}

- (void)tearDown {
    self.jmapViewController = nil;
    [super tearDown];
}

- (void)testMallHasAmenityType {
    self.jmapViewController.mallAmenityTypes = @[@"Men's Restroom", @"ATM"];
    
    XCTAssertTrue([self.jmapViewController mallHasAmenityType:@"Restroom"]);
    XCTAssertTrue([self.jmapViewController mallHasAmenityType:@"ATM"]);
    XCTAssertFalse([self.jmapViewController mallHasAmenityType:@"Kiosk"]);
}

- (void)testFilterableAmenities {
    self.jmapViewController.mallAmenityTypes = @[@"Men's Restroom", @"ATM", @"Mall Management", @"Kiosk"];
    XCTAssertEqual([self.jmapViewController filterableAmenities].count, 4);
    
    self.jmapViewController.mallAmenityTypes = @[@"Men's Restroom", @"ATM", @"Mall Management", @"Food"];
    XCTAssertEqual([self.jmapViewController filterableAmenities].count, 3);
}

- (void)testAmenityExistsOnFloor {
    JMapWaypoint *mockWaypoint1 = OCMPartialMock([JMapWaypoint new]);
    JMapWaypoint *mockWaypoint2 = OCMPartialMock([JMapWaypoint new]);
    
    [OCMStub([mockWaypoint1 mapId]) andReturn:@(1)];
    [OCMStub([mockWaypoint2 mapId]) andReturn:@(2)];
    
    self.jmapViewController.selectedAmenityWaypoints = @[mockWaypoint1, mockWaypoint2];
    
    JMapFloor *mockFloor1 = OCMPartialMock([JMapFloor new]);
    JMapFloor *mockFloor3 = OCMPartialMock([JMapFloor new]);
    
    [OCMStub([mockFloor1 mapId]) andReturn:@(1)];
    [OCMStub([mockFloor3 mapId]) andReturn:@(3)];
    
    XCTAssertTrue([self.jmapViewController amenityExistsOnFloor:mockFloor1]);
    XCTAssertFalse([self.jmapViewController amenityExistsOnFloor:mockFloor3]);
    
}

@end
