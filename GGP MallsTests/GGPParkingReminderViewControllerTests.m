//
//  GGPParkingReminderViewControllerTests.m
//  GGP Malls
//
//  Created by Janet Lin on 1/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPMallRepository.h"
#import "GGPMapController.h"
#import "GGPMapControllerDelegate.h"
#import "GGPParkingReminder.h"
#import "GGPParkingReminderCardDelegate.h"
#import "GGPParkingReminderCardViewController.h"
#import "GGPParkingReminderViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPParkingReminderViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPParkingReminderViewController *parkingReminderViewController;

@end

@interface GGPParkingReminderViewController (Testing)

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (weak, nonatomic) IBOutlet UIView *cardContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *ghostPinMarker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardContainerViewHeightConstraint;

@property (strong, nonatomic) GGPMapController *mapController;
@property (strong, nonatomic) GGPParkingReminderCardViewController *cardViewController;
@property (strong, nonatomic) GGPMall *mall;

- (void)configureMap;
- (void)configureMapView;
- (void)configureLocationServices;
- (void)displayLocationNotEnabledAlert;
- (void)configureNewParkingLocation:(CLLocation *)location;
- (void)configureViewForDefaultState;
- (void)configureViewForExistingReminder:(GGPParkingReminder *)reminder;
- (void)saveParkingReminderAtLocation:(CLLocation *)location;
- (void)didDetermineLocation:(CLLocation *)location;
- (void)clearReminderTapped;
- (void)placePinTapped;
- (BOOL)locationServicesEnabled;
- (void)resetMapView;

@end

@implementation GGPParkingReminderViewControllerTests

- (void)setUp {
    [super setUp];
    self.parkingReminderViewController = [GGPParkingReminderViewController new];
    [self.parkingReminderViewController view];
}

- (void)tearDown {
    self.parkingReminderViewController = nil;
    [super tearDown];
}

- (void)testOutletsInitialized {
    XCTAssertNotNil(self.parkingReminderViewController.scrollView);
    XCTAssertNotNil(self.parkingReminderViewController.contentView);
    XCTAssertNotNil(self.parkingReminderViewController.mapContainerView);
    XCTAssertNotNil(self.parkingReminderViewController.cardContainerView);
}

- (void)testConfigureMap {
    id mockMapController = OCMClassMock([GGPMapController class]);
    
    [OCMStub([mockMapController alloc]) andReturn:mockMapController];
    [OCMStub([mockMapController initWithMapOptions:OCMOCK_ANY andContainerView:self.parkingReminderViewController.mapContainerView]) andReturn:mockMapController];
    OCMExpect([mockMapController displayAnchorTenantMarkers]);
    
    [self.parkingReminderViewController configureMap];
    
    XCTAssertNotNil(self.parkingReminderViewController.mapController);
    OCMVerifyAll(mockMapController);
    
    [mockMapController stopMocking];
}

- (void)testConfigureLocationServicesEnabled {
    id mockLocationService = OCMClassMock([CLLocationManager class]);
    [OCMStub([mockLocationService authorizationStatus]) andReturnValue:OCMOCK_VALUE(kCLAuthorizationStatusAuthorizedWhenInUse)];
    
    id mockController = OCMPartialMock(self.parkingReminderViewController);
    [[mockController reject] displayLocationNotEnabledAlert];
    
    [self.parkingReminderViewController viewWillAppear:YES];
    
    OCMVerifyAll(mockController);
    
    [mockLocationService stopMocking];
}

- (void)testConfigureLocationServicesNotEnabled {
    id mockLocationService = OCMClassMock([CLLocationManager class]);
    [OCMStub([mockLocationService authorizationStatus]) andReturnValue:OCMOCK_VALUE(kCLAuthorizationStatusDenied)];
    
    id mockController = OCMPartialMock(self.parkingReminderViewController);
    OCMExpect([mockController displayLocationNotEnabledAlert]);
    
    [self.parkingReminderViewController configureMapView];
    
    OCMVerifyAll(mockController);
    
    [mockLocationService stopMocking];
}

- (void)testConfigureNewParkingLocation {
    id mockLocation = OCMPartialMock([CLLocation new]);
    id mockMapController = OCMPartialMock([GGPMapController new]);
    id mockController = OCMPartialMock(self.parkingReminderViewController);
    
    [OCMStub([mockController mapController]) andReturn:mockMapController];
    
    [self.parkingReminderViewController configureNewParkingLocation:mockLocation];
    
    OCMVerifyAll(mockMapController);
}

- (void)testConfigureViewForExistingReminder {
    id mockLocation = OCMPartialMock([CLLocation new]);
    NSString *mockNote = @"mock note";
    
    GGPParkingReminder *reminder = [[GGPParkingReminder alloc] initWithLocation:mockLocation andNote:mockNote];
    
    id mockParkingController = OCMPartialMock(self.parkingReminderViewController);
    id mockCardController = OCMPartialMock(self.parkingReminderViewController.cardViewController);
    id mockMapController = OCMPartialMock([GGPMapController new]);
    
    [OCMStub([mockParkingController mapController]) andReturn:mockMapController];
    OCMExpect([mockCardController configureForExistingLocationWithNote:mockNote]);
    OCMExpect([mockMapController fitToLocations:OCMOCK_ANY]);
    OCMExpect([mockMapController displayParkingPinAtLocation:mockLocation]);
    
    [self.parkingReminderViewController configureViewForExistingReminder:reminder];
    
    XCTAssertEqual(self.parkingReminderViewController.cardContainerViewHeightConstraint.constant, 200);
    
    OCMVerifyAll(mockCardController);
    OCMVerifyAll(mockMapController);
}

- (void)testConfigureViewLocationDisabledHasValidReminder {
    id mockController = OCMPartialMock(self.parkingReminderViewController);
    id mockReminder = OCMClassMock([GGPParkingReminder class]);
    
    [OCMStub([mockController locationServicesEnabled]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockReminder retrieveSavedReminder]) andReturn:mockReminder];
    [OCMStub([mockReminder isValid]) andReturnValue:OCMOCK_VALUE(YES)];
    
    OCMExpect([mockController displayLocationNotEnabledAlert]);
    OCMExpect([mockController configureViewForExistingReminder:mockReminder]);
    
    [self.parkingReminderViewController configureMapView];
    
    OCMVerifyAll(mockController);
    
    [mockReminder stopMocking];
}

- (void)testConfigureViewLocationDisabledHasInvalidReminder {
    id mockController = OCMPartialMock(self.parkingReminderViewController);
    id mockReminder = OCMClassMock([GGPParkingReminder class]);
    id mockCardController = OCMPartialMock(self.parkingReminderViewController.cardViewController);
    
    [OCMStub([mockController locationServicesEnabled]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockReminder retrieveSavedReminder]) andReturn:mockReminder];
    [OCMStub([mockReminder isValid]) andReturnValue:OCMOCK_VALUE(NO)];
    
    OCMExpect([mockController displayLocationNotEnabledAlert]);
    OCMExpect([mockCardController configureForDefaultState]);
    
    [self.parkingReminderViewController configureMapView];
    
    OCMVerifyAll(mockController);
    
    [mockReminder stopMocking];
}

- (void)testConfigureViewLocationDisabledNoReminder {
    id mockController = OCMPartialMock(self.parkingReminderViewController);
    id mockReminder = OCMClassMock([GGPParkingReminder class]);
    id mockCardController = OCMPartialMock(self.parkingReminderViewController.cardViewController);
    
    [OCMStub([mockController locationServicesEnabled]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockReminder retrieveSavedReminder]) andReturn:nil];
    
    OCMExpect([mockController displayLocationNotEnabledAlert]);
    OCMExpect([mockCardController configureForDefaultState]);
    
    [self.parkingReminderViewController configureMapView];
    
    OCMVerifyAll(mockController);
    
    [mockReminder stopMocking];
}

- (void)testDidDetermineLocationNoSavedReminder {
    id mockLocation = OCMPartialMock([CLLocation new]);
    id mockController = OCMPartialMock(self.parkingReminderViewController);
    id mockReminder = OCMClassMock([GGPParkingReminder class]);
    
    [OCMStub([mockReminder retrieveSavedReminder]) andReturn:nil];
    
    OCMExpect([mockController configureNewParkingLocation:mockLocation]);
    
    [self.parkingReminderViewController didDetermineLocation:mockLocation];
    
    OCMVerifyAll(mockController);
    
    [mockReminder stopMocking];
}

- (void)testDidDetermineLocationHasValidReminder {
    id mockLocation = OCMPartialMock([CLLocation new]);
    id mockReminder = OCMPartialMock([GGPParkingReminder new]);
    id mockController = OCMPartialMock(self.parkingReminderViewController);
    
    [OCMStub([mockReminder retrieveSavedReminder]) andReturn:mockReminder];
    [OCMStub([mockReminder isValid]) andReturnValue:OCMOCK_VALUE(YES)];
    
    OCMExpect([mockController configureViewForExistingReminder:mockReminder]);
    
    [self.parkingReminderViewController didDetermineLocation:mockLocation];
    
    OCMVerifyAll(mockController);
}

- (void)testDidDetermineLocationHasInvalidReminder {
    id mockLocation = OCMPartialMock([CLLocation new]);
    id mockReminder = OCMPartialMock([GGPParkingReminder new]);
    id mockController = OCMPartialMock(self.parkingReminderViewController);
    
    [OCMStub([mockReminder retrieveSavedReminder]) andReturn:mockReminder];
    [OCMStub([mockReminder isValid]) andReturnValue:OCMOCK_VALUE(NO)];
    
    OCMExpect([mockController configureNewParkingLocation:mockLocation]);
    
    [self.parkingReminderViewController didDetermineLocation:mockLocation];
    
    OCMVerifyAll(mockController);
}

- (void)testClearReminderTapped {
    id mockController = OCMPartialMock(self.parkingReminderViewController);
    
    [OCMStub([mockController locationServicesEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    OCMExpect([mockController resetMapView]);
    
    [self.parkingReminderViewController clearReminderTapped];
    
    XCTAssertEqual(self.parkingReminderViewController.ghostPinMarker.alpha, 0.5);
    
    OCMVerifyAll(mockController);
}

- (void)testPlacePinTapped {
    [self.parkingReminderViewController placePinTapped];
    XCTAssertEqual(self.parkingReminderViewController.ghostPinMarker.alpha, 0);
}

@end
