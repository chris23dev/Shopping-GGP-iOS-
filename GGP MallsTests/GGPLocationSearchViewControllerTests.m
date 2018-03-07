//
//  GGPLocationSearchViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//
#import "GGPClient.h"
#import "GGPLocationSearchViewController.h"
#import "GGPMall.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

@interface GGPLocationSearchViewControllerTests : XCTestCase

@property GGPLocationSearchViewController *locationSearchViewController;
@property id mockLocationManager;
@property id mockLocationSearchViewController;
@property BOOL isUpdatingLocation;

@end

@interface GGPLocationSearchViewController (Testing)

@property NSArray *malls;
@property NSArray *searchResults;
@property CLLocationManager *locationManager;
@property CLLocation *location;

- (void)searchWithLocation:(CLLocation *)location locationName:(NSString *)locationName andSearch:(NSString *)search;

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;

- (BOOL)shouldCreateNewLocationManager;
- (BOOL)isValidCharacter:(unichar)character;

@end

@implementation GGPLocationSearchViewControllerTests

- (void)setUp {
    [super setUp];
    self.isUpdatingLocation = NO;
    self.locationSearchViewController = [GGPLocationSearchViewController new];
    [self setupMocks];
    [self.locationSearchViewController view];
}

- (void)tearDown {
    self.locationSearchViewController = nil;
    self.mockLocationSearchViewController = nil;
    [self tearDownMocks];
    [super tearDown];
}

- (void)setupMocks {
    id mockLocationManager = OCMClassMock(CLLocationManager.class);
    
    __weak typeof(self) weakSelf = self;
    
    [OCMStub([mockLocationManager startUpdatingLocation]) andDo:^(NSInvocation *invocation) {
        weakSelf.isUpdatingLocation = YES;
    }];
    
    [OCMStub([mockLocationManager stopUpdatingLocation]) andDo:^(NSInvocation *invocation) {
        weakSelf.isUpdatingLocation = NO;
    }];
    
    [OCMStub(ClassMethod([mockLocationManager authorizationStatus])) andReturnValue:OCMOCK_VALUE(kCLAuthorizationStatusAuthorizedWhenInUse)];
    
    self.mockLocationManager = mockLocationManager;
    self.locationSearchViewController.locationManager = mockLocationManager;
    
    id mockViewController = OCMPartialMock(self.locationSearchViewController);
    [OCMStub([mockViewController shouldCreateNewLocationManager]) andReturnValue:OCMOCK_VALUE(NO)];
    
    self.mockLocationSearchViewController = mockViewController;
}

- (void)tearDownMocks {
    OCMVerify(self.mockLocationSearchViewController);
    OCMVerify(self.mockLocationManager);
    [self.mockLocationSearchViewController stopMocking];
    [self.mockLocationManager stopMocking];
    self.mockLocationSearchViewController = nil;
    self.mockLocationManager = nil;
}

- (void)testIsCharacterValid {
    XCTAssertFalse([self.locationSearchViewController isValidCharacter:'/']);
    XCTAssertFalse([self.locationSearchViewController isValidCharacter:'^']);
    XCTAssertFalse([self.locationSearchViewController isValidCharacter:'\\']);
    XCTAssertTrue([self.locationSearchViewController isValidCharacter:' ']);
    XCTAssertTrue([self.locationSearchViewController isValidCharacter:'3']);
    XCTAssertTrue([self.locationSearchViewController isValidCharacter:'a']);
    XCTAssertTrue([self.locationSearchViewController isValidCharacter:'A']);
    XCTAssertTrue([self.locationSearchViewController isValidCharacter:'\'']);
    XCTAssertTrue([self.locationSearchViewController isValidCharacter:'-']);
    XCTAssertTrue([self.locationSearchViewController isValidCharacter:'.']);
}

- (void)testSearchWithLocationWithBadLocation {
    [self.mockLocationSearchViewController searchWithLocation:nil locationName:@"searchtext" andSearch:OCMOCK_ANY];
    XCTAssertNil(self.locationSearchViewController.searchResults);
}

- (void)testSearchBarSearchButtonClicked {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    NSString *searchString = @"searchLocation";
    id mockSearchBar = OCMClassMock(UISearchBar.class);
    OCMExpect([mockSearchBar resignFirstResponder]);
    [OCMExpect([mockSearchBar text]) andReturn:searchString];
    
    id mockGeoCoder = OCMClassMock(CLGeocoder.class);
    [OCMStub(ClassMethod([mockGeoCoder new])) andReturn:mockGeoCoder];
    [OCMStub([mockGeoCoder geocodeAddressString:searchString completionHandler:OCMOCK_ANY]) andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) = nil;
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(nil, nil);
        [expectation fulfill];
    }];
    
    [self.mockLocationSearchViewController searchBarSearchButtonClicked:mockSearchBar];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    OCMVerifyAll(mockSearchBar);
    OCMVerifyAll(mockGeoCoder);
    
    [mockSearchBar stopMocking];
    [mockGeoCoder stopMocking];
}

- (void)testSearchWithLocationReturningNoMalls {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    double latitude = -34.34234;
    double longitude = -32.23423;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    NSArray *malls = @[];
    id mockClient = OCMPartialMock([GGPClient sharedInstance]);
    
    [OCMStub([mockClient fetchMallsFromLatitude:latitude andLongitude:longitude withCompletion:OCMOCK_ANY]) andDo:^(NSInvocation *invocation) {
        void (^fetchMallsComplete)(NSArray *malls, NSError *error) = nil;
        [invocation getArgument:&fetchMallsComplete atIndex:4];
        fetchMallsComplete(malls, nil);
        [expectation fulfill];
    }];
    
    [self.mockLocationSearchViewController searchWithLocation:location locationName:@"searchtext" andSearch:@"search"];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    XCTAssertEqual(self.locationSearchViewController.searchResults, malls);
    
    [mockClient stopMocking];
}

- (void)testSearchWithValidLocation {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    double latitude = -34.34234;
    double longitude = -32.23423;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    NSArray *malls = @[[GGPMall new]];
    id mockClient = OCMPartialMock([GGPClient sharedInstance]);
    
    [OCMStub([mockClient fetchMallsFromLatitude:latitude andLongitude:longitude withCompletion:OCMOCK_ANY]) andDo:^(NSInvocation *invocation) {
        void (^fetchMallsComplete)(NSArray *malls, NSError *error) = nil;
        [invocation getArgument:&fetchMallsComplete atIndex:4];
        fetchMallsComplete(malls, nil);
        [expectation fulfill];
    }];
    
    [self.mockLocationSearchViewController searchWithLocation:location locationName:@"searchtext" andSearch:@"search"];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    XCTAssertEqualObjects(self.locationSearchViewController.searchResults, malls);
    
    [mockClient stopMocking];
}

- (void)testSortSearchResultMallsForLocation {
    id mockMall1 = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall1 distance]) andReturn:[NSNumber numberWithFloat:23.324]];
    
    id mockMall2 = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall2 distance]) andReturn:[NSNumber numberWithFloat:43.2]];
    
    id mockMall3 = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall3 distance]) andReturn:[NSNumber numberWithFloat:0.3223]];
    
    NSArray *mockResults = @[ mockMall1, mockMall3, mockMall2 ];
    NSArray *sortedArray = [mockResults ggp_sortListAscendingForKey:@"distance"];
    NSArray *expectedArray = @[ mockMall3, mockMall1, mockMall2 ];
    
    XCTAssertEqualObjects(sortedArray, expectedArray);
    
    [mockMall1 stopMocking];
    [mockMall2 stopMocking];
    [mockMall3 stopMocking];
}

#pragma mark - CLLocation

- (void)testLocationManagerDidUpdateLocation {
    OCMExpect([self.mockLocationSearchViewController searchWithLocation:OCMOCK_ANY locationName:[@"SELECT_MALL_HEADER_NEARBY_LOCATION_NAME_DEFAULT" ggp_toLocalized] andSearch:OCMOCK_ANY]);
    [self.mockLocationSearchViewController locationManager:self.mockLocationManager didUpdateLocations:@[]];
}

- (void)testLocationManagerDidChangeAuthorizationStatus {
    [self.mockLocationSearchViewController locationManager:self.mockLocationManager didChangeAuthorizationStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
    XCTAssertTrue(self.isUpdatingLocation);
}

- (void)testLocationManagerDidChangeAuthorizationStatusNotAuthorized {
    id mockLocationManager = OCMClassMock(CLLocationManager.class);
    [OCMStub(ClassMethod([mockLocationManager authorizationStatus])) andReturnValue:OCMOCK_VALUE(kCLAuthorizationStatusDenied)];
    [[mockLocationManager reject] startUpdatingLocation];
    self.locationSearchViewController.locationManager = mockLocationManager;
    [self.locationSearchViewController locationManager:self.mockLocationManager didChangeAuthorizationStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
    
    [mockLocationManager stopMocking];
}

@end
