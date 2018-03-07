//
//  GGPMapControllerTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMapController.h"
#import "GGPMapControllerDelegate.h"
#import "GGPMapPlaceMarker.h"
#import "GGPTenant.h"
#import <GoogleMaps/GoogleMaps.h>

@interface GGPMapController (Testing)
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) NSMutableArray *placeMarkers;
@property (strong, nonatomic) NSMutableArray *polygons;
@property (strong, nonatomic) GMSMarker *parkingMarker;
@property (strong, nonatomic) GGPMapOptions *mapOptions;
@property (strong, nonatomic) GMSMarker *ghostPinMarker;

- (void)addPlaceMarkersForTenants:(NSArray *)tenants;
- (void)startObservingLocationForMapView:(GMSMapView *)mapView;
- (NSArray *)anchorTenantsFromTenants:(NSArray *)tenants;
- (GMSMarker *)configureGhostPinMarker;
@end

@interface GGPMapControllerTests : XCTestCase
@property (strong, nonatomic) GGPMapController *mapController;
@end

@implementation GGPMapControllerTests

- (void)setUp {
    [super setUp];
    self.mapController = [[GGPMapController alloc] initWithMapOptions:[GGPMapOptions new] andContainerView:[UIView new]];
}

- (void)tearDown {
    self.mapController = nil;
    [super tearDown];
}

- (void)testCreateValidPolygon {
    NSString *encodedPolyline = @"!123+abc!";
    GMSPath *expectedPath = [GMSPath pathFromEncodedPath:encodedPolyline];
    
    [self.mapController addPolygonWithPolyline:encodedPolyline andFillColor:[UIColor whiteColor]];
    GMSPolygon *polygon = self.mapController.polygons.firstObject;
    
    XCTAssertEqualObjects(expectedPath.encodedPath, polygon.path.encodedPath);
    XCTAssertEqualObjects([UIColor whiteColor], polygon.fillColor);
    XCTAssertEqualObjects(self.mapController.mapView, polygon.map);
}

- (void)testCreateInvalidPolygon {
    NSString *invalidPolyline = @"not a polyline";
    
    [self.mapController addPolygonWithPolyline:invalidPolyline andFillColor:[UIColor whiteColor]];
    
    XCTAssertEqual(0, self.mapController.polygons.count);
}

- (void)testAddPlaceMarkersForTenants {
    GGPTenant *akira = [self mockTenantWithName:@"Akira" latitude:@(1) andLongitude:@(2)];
    GGPTenant *jcrew = [self mockTenantWithName:@"JCrew" latitude:@(3) andLongitude:@(4)];
    
    [self.mapController addPlaceMarkersForTenants:@[akira, jcrew]];
    
    GMSMarker *akiraMarker = self.mapController.placeMarkers[0];
    GMSMarker *jcrewMarker = self.mapController.placeMarkers[1];
    
    XCTAssertEqualObjects(@"Akira", ((GGPMapPlaceMarker *)akiraMarker.iconView).text);
    XCTAssertEqual(1, akiraMarker.position.latitude);
    XCTAssertEqual(2, akiraMarker.position.longitude);
    XCTAssertEqualObjects(self.mapController.mapView, akiraMarker.map);
    
    XCTAssertEqualObjects(@"JCrew", ((GGPMapPlaceMarker *)jcrewMarker.iconView).text);
    XCTAssertEqual(3, jcrewMarker.position.latitude);
    XCTAssertEqual(4, jcrewMarker.position.longitude);
    XCTAssertEqualObjects(self.mapController.mapView, jcrewMarker.map);
}

- (GGPTenant *)mockTenantWithName:(NSString *)name latitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude {
    GGPTenant *mockClass = OCMClassMock(GGPTenant.class);
    [OCMStub([mockClass name]) andReturn:name];
    [OCMStub([mockClass latitude]) andReturn:latitude];
    [OCMStub([mockClass longitude]) andReturn:longitude];
    
    return mockClass;
}

- (void)testAnchorTenantsFromTenants {
    id anchor1 = OCMPartialMock([GGPTenant new]);
    id anchor2 = OCMPartialMock([GGPTenant new]);
    id notAnchor = OCMPartialMock([GGPTenant new]);
    
    [OCMStub([anchor1 unitType]) andReturn:@"ANCHOR"];
    [OCMStub([anchor2 unitType]) andReturn:@"ANCHOR"];
    [OCMStub([notAnchor unitType]) andReturn:@"STORE"];
    
    NSArray *tenants = @[anchor1, anchor2, notAnchor];
    NSArray *anchors = [self.mapController anchorTenantsFromTenants:tenants];
    
    XCTAssertEqual(2, anchors.count);
    XCTAssertTrue([anchors containsObject:anchor1]);
    XCTAssertTrue([anchors containsObject:anchor2]);
}

- (void)testDisplayParkingPinAtLocation {
    CLLocationCoordinate2D mockCoordinate = CLLocationCoordinate2DMake(20, 20);
    CLLocation *mockLocation = [[CLLocation alloc] initWithCoordinate:mockCoordinate
                                                             altitude:0
                                                   horizontalAccuracy:0
                                                     verticalAccuracy:0 
                                                            timestamp:[NSDate new]];
    
    [self.mapController displayParkingPinAtLocation:mockLocation];
    
    XCTAssertEqual(self.mapController.parkingMarker.position.latitude, mockCoordinate.latitude);
    XCTAssertEqual(self.mapController.parkingMarker.map, self.mapController.mapView);
    
}

- (void)testResetParkingPinHasLocation {
    id mockMapView = OCMPartialMock([GMSMapView new]);
    id mockController = OCMPartialMock(self.mapController);
    id mockDelegate = OCMProtocolMock(@protocol(GGPMapControllerDelegate));
    id mockLocation = OCMPartialMock([CLLocation new]);
    
    [OCMStub([mockController mapView]) andReturn:mockMapView];
    [OCMStub([mockController mapDelegate]) andReturn:mockDelegate];
    [OCMStub([mockMapView myLocation]) andReturn:mockLocation];
    
    OCMExpect([mockDelegate didDetermineLocation:mockLocation]);
    
    [self.mapController resetParkingPinLocation];
    
    OCMVerifyAll(mockDelegate);
}

- (void)testResetParkingPinNoLocation {
    id mockMapView = OCMPartialMock([GMSMapView new]);
    id mockController = OCMPartialMock(self.mapController);
    
    [OCMStub([mockController mapView]) andReturn:mockMapView];
    [OCMStub([mockMapView myLocation]) andReturn:nil];
    
    OCMExpect([mockController startObservingLocationForMapView:mockMapView]);
    
    [self.mapController resetParkingPinLocation];
    
    OCMVerifyAll(mockController);
}

@end
