//
//  GGPHeroViewControllerTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPHeroViewController.h"
#import "GGPHero.h"
#import "GGPNotificationConstants.h"

@interface GGPHeroViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPHeroViewController *heroViewController;

@end

@interface GGPHeroViewController (Testing)

- (void)urlLabelTapped;
- (void)handleScreenUrlComponents:(NSArray *)urlComponents;
- (void)handleCampaignUrlComponents:(NSArray *)urlComponents;
@property (strong, nonatomic) GGPHero *hero;

@end

@implementation GGPHeroViewControllerTests

- (void)setUp {
    [super setUp];
    self.heroViewController = [GGPHeroViewController new];
}

- (void)tearDown {
    self.heroViewController = nil;
    [super tearDown];
}

- (void)testUrlTappedWithUrl {
    GGPHero *hero = [GGPHero new];
    hero.url = @"http://hero.com";
    
    id mockHeroViewController = OCMPartialMock(self.heroViewController);
    [OCMStub([mockHeroViewController hero]) andReturn:hero];
    
    OCMReject([mockHeroViewController handleScreenUrlComponents:[OCMArg any]]);
    [mockHeroViewController urlLabelTapped];
    OCMVerifyAll(mockHeroViewController);
}

- (void)testUrlTappedWithScreen {
    GGPHero *hero = [GGPHero new];
    hero.url = @"screen:PARKING";
    
    id mockHeroViewController = OCMPartialMock(self.heroViewController);
    [OCMStub([mockHeroViewController hero]) andReturn:hero];
    
    OCMExpect([mockHeroViewController handleScreenUrlComponents:[OCMArg any]]);
    OCMReject([mockHeroViewController handleCampaignUrlComponents:[OCMArg any]]);
    
    [mockHeroViewController urlLabelTapped];
    
    OCMVerifyAll(mockHeroViewController);
}

- (void)testUrlTappedWithCampaign {
    GGPHero *hero = [GGPHero new];
    hero.url = @"campaign:BLACK_FRIDAY";
    
    id mockHeroViewController = OCMPartialMock(self.heroViewController);
    [OCMStub([mockHeroViewController hero]) andReturn:hero];
    
    OCMExpect([mockHeroViewController handleCampaignUrlComponents:[OCMArg any]]);
    OCMReject([mockHeroViewController handleScreenUrlComponents:[OCMArg any]]);
    
    [mockHeroViewController urlLabelTapped];
    
    OCMVerifyAll(mockHeroViewController);
}

- (void)testHandleParkingScreenUrlComponents {
    id mock = OCMObserverMock();
    [[NSNotificationCenter defaultCenter] addMockObserver:mock name:GGPHeroParkingNotification object:nil];
    OCMExpect([mock notificationWithName:GGPHeroParkingNotification object:nil]);
    
    [self.heroViewController handleScreenUrlComponents:@[@"screen", @"PARKING"]];
    
    OCMVerifyAll(mock);
}

- (void)testHandleDirectoryScreenUrlComponents {
    id mock = OCMObserverMock();
    [[NSNotificationCenter defaultCenter] addMockObserver:mock name:GGPHeroDirectoryNotification object:nil];
    OCMExpect([mock notificationWithName:GGPHeroDirectoryNotification object:nil]);
    
    [self.heroViewController handleScreenUrlComponents:@[@"screen", @"DIRECTORY"]];
    
    OCMVerifyAll(mock);
}

@end
