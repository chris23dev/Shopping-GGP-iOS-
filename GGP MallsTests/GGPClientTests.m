//
//  GGPClientTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 1/12/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPClient.h"
#import <AFOAuth2Manager/AFOAuth2Manager.h>

static NSString *const kUrl = @"ggp.com";
static NSString *const kEtag = @"Etag";

@interface GGPClientTests : XCTestCase

@property (strong, nonatomic) GGPClient *client;

@end

@interface GGPClient (Testing)

@property (strong, nonatomic) AFOAuthCredential *authenticationCredential;
@property (strong, nonatomic) AFOAuth2Manager *oAuth2Manager;
@property (strong, nonatomic) NSMutableDictionary *etagLookup;

- (BOOL)isValidCredential:(AFOAuthCredential *)credential;
- (void)authenticateWithCompletion:(nonnull void(^)())onCompletion;

@end

@implementation GGPClientTests

- (void)setUp {
    [super setUp];
    self.client = [GGPClient new];
}

- (void)tearDown {
    self.client = nil;
    [super tearDown];
}

- (void)testIsValidCredential {
    id mockExpired = OCMClassMock([AFOAuthCredential class]);
    [OCMStub([mockExpired isExpired]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockNotExpired = OCMClassMock([AFOAuthCredential class]);
    [OCMStub([mockExpired isExpired]) andReturnValue:OCMOCK_VALUE(NO)];
    
    XCTAssertFalse([self.client isValidCredential:nil]);
    XCTAssertFalse([self.client isValidCredential:mockExpired]);
    XCTAssertTrue([self.client isValidCredential:mockNotExpired]);
    
    [mockExpired stopMocking];
    [mockNotExpired stopMocking];
}

- (void)testHandleEtagForResponse {
    NSHTTPURLResponse *response;
    NSString *etag1 = @"etag1";
    NSString *etag2 = @"etag2";
    
    // response object is nil -> NO
    self.client.etagLookup = [NSMutableDictionary new];
    XCTAssertFalse([self.client handleEtagForResponse:nil]);
    
    // current etag and response etag are both nil -> NO
    self.client.etagLookup = [NSMutableDictionary new];
    response = [self responseWithEtag:nil];
    XCTAssertFalse([self.client handleEtagForResponse:response]);
    
    // current etag is not nil and response etag is nil -> NO
    self.client.etagLookup = [NSMutableDictionary new];
    [self.client.etagLookup setObject:etag1 forKey:kUrl];
    response = [self responseWithEtag:nil];
    XCTAssertFalse([self.client handleEtagForResponse:response]);
    
    // current etag and response etag are equal -> NO
    self.client.etagLookup = [NSMutableDictionary new];
    [self.client.etagLookup setObject:etag1 forKey:kUrl];
    response = [self responseWithEtag:etag1];
    XCTAssertFalse([self.client handleEtagForResponse:response]);
    
    // current etag and response etag are different -> YES
    self.client.etagLookup = [NSMutableDictionary new];
    [self.client.etagLookup setObject:etag1 forKey:kUrl];
    response = [self responseWithEtag:etag2];
    XCTAssertTrue([self.client handleEtagForResponse:response]);
    
    // current etag is nil, response etag is not nil -> NO
    self.client.etagLookup = [NSMutableDictionary new];
    response = [self responseWithEtag:etag1];
    XCTAssertFalse([self.client handleEtagForResponse:response]);
}

- (void)testEtagClearsWithMissingResponseEtag {
    self.client.etagLookup = [NSMutableDictionary new];
    [self.client.etagLookup setObject:@"etag" forKey:kUrl];
    
    NSHTTPURLResponse *response = [self responseWithEtag:nil];
    
    [self.client handleEtagForResponse:response];
    
    XCTAssertFalse([self.client.etagLookup.allKeys containsObject:kUrl]);
}

- (NSHTTPURLResponse *)responseWithEtag:(NSString *)etag {
    NSHTTPURLResponse *mockResponse = OCMClassMock(NSHTTPURLResponse.class);
    [OCMStub([mockResponse URL]) andReturn:[NSURL URLWithString:kUrl]];
    
    if (etag) {
        [OCMStub([mockResponse allHeaderFields]) andReturn:@{kEtag:etag}];
    }
    return mockResponse;
}

- (void)testFetchAppConfig {
    id mockClient = OCMPartialMock([GGPClient sharedInstance]);
    OCMExpect([mockClient GET:@"mobile-app/config" parameters:nil completion:OCMOCK_ANY]);
    [mockClient fetchAppConfigWithCompletion:nil];
    OCMVerifyAll(mockClient);
    [mockClient stopMocking];
}

- (void)testFetchEventsForMallId {
    NSInteger expectedMallId = 20;
    NSString *expectedRequestString = [NSString stringWithFormat:@"malls/%ld/events", (long)expectedMallId];
    
    id mockClient = OCMPartialMock([GGPClient sharedInstance]);
    OCMExpect([mockClient GET:expectedRequestString parameters:OCMOCK_ANY completion:OCMOCK_ANY]);
    [mockClient fetchEventsForMallId:expectedMallId withCompletion:nil];
    OCMVerifyAll(mockClient);
    [mockClient stopMocking];
}

- (void)testFetchMallWithId {
    NSInteger expectedMallId = 20;
    NSString *expectedString = [NSString stringWithFormat:@"malls/%ld", (long)expectedMallId];
    id mockClient = OCMPartialMock([GGPClient sharedInstance]);
    OCMExpect([mockClient GET:expectedString parameters:nil completion:OCMOCK_ANY]);
    [mockClient fetchMallFromMallId:expectedMallId withCompletion:nil];
    OCMVerify(mockClient);
    [mockClient stopMocking];
}

- (void)testFetcMallsFromLatitudeAndLongitude {
    double inputLatitude = 41.6213;
    double inputLongitude = -80.6723;
    NSDictionary *expectedParams = @{
                                     @"lat": [NSString stringWithFormat:@"%f", inputLatitude],
                                     @"long": [NSString stringWithFormat:@"%f", inputLongitude]
                                     };
    NSString *expectedRequest = @"malls/search/searchByLatLong/";
    id mockClient = OCMPartialMock([GGPClient sharedInstance]);
    OCMExpect([mockClient GET:expectedRequest parameters:expectedParams completion:OCMOCK_ANY]);
    [mockClient fetchMallsFromLatitude:inputLatitude andLongitude:inputLongitude withCompletion:nil];
    OCMVerify(mockClient);
    [mockClient stopMocking];
}

- (void)testFetchMovieTheatersForMallId {
    NSInteger expectedMallId = 20;
    NSString *expectedRequestString = [NSString stringWithFormat:@"malls/%ld/movie-theaters", (long)expectedMallId];
    
    id mockClient = OCMPartialMock([GGPClient sharedInstance]);
    OCMExpect([mockClient GET:expectedRequestString parameters:nil completion:OCMOCK_ANY]);
    [mockClient fetchMovieTheatersForMallId:expectedMallId withCompletion:nil];
    OCMVerifyAll(mockClient);
    [mockClient stopMocking];
}

- (void)testFetchSalesForMallId {
    NSInteger expectedMallId = 20;
    NSString *expectedRequestString = [NSString stringWithFormat:@"malls/%ld/sales", (long)expectedMallId];
    
    id mockClient = OCMPartialMock([GGPClient sharedInstance]);
    OCMExpect([mockClient GET:expectedRequestString parameters:OCMOCK_ANY completion:OCMOCK_ANY]);
    [mockClient fetchSalesForMallId:expectedMallId withCompletion:nil];
    OCMVerifyAll(mockClient);
    [mockClient stopMocking];
}

- (void)testFetchTenantsForMallId {
    NSInteger expectedMallId = 20;
    NSString *expectedRequestString = [NSString stringWithFormat:@"malls/%ld/stores", (long)expectedMallId];
    
    id mockClient = OCMPartialMock([GGPClient sharedInstance]);
    OCMExpect([mockClient GET:expectedRequestString parameters:nil completion:OCMOCK_ANY]);
    [mockClient fetchTenantsForMallId:expectedMallId withCompletion:nil];
    OCMVerifyAll(mockClient);
    [mockClient stopMocking];
}

@end
