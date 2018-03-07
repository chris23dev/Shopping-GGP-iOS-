//
//  GGPSweepstakesClientTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/3/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPSweepstakesClient.h"
#import "GGPUser.h"

@interface GGPSweepstakesClientTests : XCTestCase

@property GGPSweepstakesClient *client;

@end

@interface GGPSweepstakesClient (Testing)

- (BOOL)isValidUser:(GGPUser *)user andMallName:(NSString *)mallName;

@end

@implementation GGPSweepstakesClientTests

- (void)setUp {
    [super setUp];
    self.client = [GGPSweepstakesClient new];
}

- (void)tearDown {
    self.client = nil;
    [super tearDown];
}

- (void)testIsValidUserAndMall {
    GGPUser *user = [GGPUser new];
    NSString *mallName = nil;
    
    user.firstName = @"first";
    user.lastName = @"last";
    user.email = @"email";
    mallName = @"mall";
    XCTAssertTrue([self.client isValidUser:user andMallName:mallName]);
    
    user.firstName = nil;
    user.lastName = @"last";
    user.email = @"email";
    mallName = @"mall";
    XCTAssertFalse([self.client isValidUser:user andMallName:mallName]);
    
    user.firstName = @"first";
    user.lastName = nil;
    user.email = @"email";
    mallName = @"mall";
    XCTAssertFalse([self.client isValidUser:user andMallName:mallName]);
    
    user.firstName = @"first";
    user.lastName = @"last";
    user.email = nil;
    mallName = @"mall";
    XCTAssertFalse([self.client isValidUser:user andMallName:mallName]);
    
    user.firstName = @"first";
    user.lastName = @"last";
    user.email = @"email";
    mallName = nil;
    XCTAssertFalse([self.client isValidUser:user andMallName:mallName]);
}

@end
