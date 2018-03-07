//
//  UIViewController+GGPDirectionsTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/2/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPTenant.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPDirections.h"

@interface UIViewControllerGGPDirectionsTests : XCTestCase

@property UIViewController *viewController;

@end

@interface UIViewController (Testing)

- (NSString *)directionsLabelForTenant:(GGPTenant *)tenant;
- (NSString *)serializedTenantName:(NSString *)tenantName;

@end

@implementation UIViewControllerGGPDirectionsTests

- (void)setUp {
    [super setUp];
    self.viewController = [UIViewController new];
}

- (void)tearDown {
    self.viewController = nil;
    [super tearDown];
}

- (void)testDirectionsLabelNoProximity {
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    id mockTenant = OCMClassMock([GGPTenant class]);
    
    [OCMStub([mockMapController parkingLocationDescriptionForTenant:mockTenant]) andReturn:@""];
    
    NSString *tenantLabel = [self.viewController directionsLabelForTenant:mockTenant];
    NSString *expectedLabel = [@"DETAILS_DIRECTIONS_NON_PROXIMITY" ggp_toLocalized];
    XCTAssertEqualObjects(tenantLabel, expectedLabel);
}

- (void)testDirectionsLabelWithProximity {
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    id mockTenant = OCMClassMock([GGPTenant class]);
    NSString *expectedParkingDescription = @"Park near Macy's";
    
    [OCMStub([mockTenant name]) andReturn:@"Name"];
    [OCMStub([mockMapController parkingLocationDescriptionForTenant:mockTenant]) andReturn:expectedParkingDescription];
    
    NSString *tenantLabel = [self.viewController directionsLabelForTenant:mockTenant];
    NSString *expectedLabel = [NSString stringWithFormat:[@"DETAILS_DIRECTIONS_WITH_PROXIMITY" ggp_toLocalized], expectedParkingDescription];
    XCTAssertEqualObjects(tenantLabel, expectedLabel);
}

- (void)testSerializedTenantName {
    NSString *initialString = @"Abercrombie & Fitch";
    GGPTenant *mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant name]) andReturn:initialString];
    NSString *expectedString = @"Abercrombie and Fitch";
    XCTAssertEqualObjects([self.viewController serializedTenantName:mockTenant.name], expectedString);
}

@end
