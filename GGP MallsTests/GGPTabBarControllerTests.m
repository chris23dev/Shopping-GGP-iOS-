//
//  GGPTabBarControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAuthenticationController.h"
#import "GGPDirectoryViewController.h"
#import "GGPHomeViewController.h"
#import "GGPMoreViewController.h"
#import "GGPNavigationController.h"
#import "GGPParkingReminder.h"
#import "GGPParkingReminderViewController.h"
#import "GGPShoppingViewController.h"
#import "GGPTabBarController.h"
#import "GGPQuickActions.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPTabBarController (Testing)

@property (strong, nonatomic) UINavigationController *homeNavController;
@property (strong, nonatomic) UINavigationController *shoppingNavController;
@property (strong, nonatomic) UINavigationController *directoryNavController;
@property (strong, nonatomic) UINavigationController *parkingNavController;
@property (strong, nonatomic) UINavigationController *moreNavController;

@property (strong, nonatomic) UITabBarItem *parkingUnsetTab;
@property (strong, nonatomic) UITabBarItem *parkingSetTab;

- (void)parkingReminderUpdated:(NSNotification *)notification;
- (BOOL)hasSavedParkingReminder;
- (void)selectNavController:(UINavigationController *)navController;

@end

@interface GGPTabBarControllerTests : XCTestCase

@property (strong, nonatomic) GGPTabBarController *tabBarController;

@end

@implementation GGPTabBarControllerTests

- (void)setUp {
    [super setUp];
    self.tabBarController = [GGPTabBarController new];
    [self.tabBarController view];
}

- (void)tearDown {
    self.tabBarController = nil;
    [super tearDown];
}

- (void)testParkingReminderUpdatedHasReminder {
    NSNotification *mockNotification = [[NSNotification alloc] initWithName:@"" object:nil userInfo:@{GGPParkingReminderNotificationHasSavedReminderKey : @(YES)}];
    
    [self.tabBarController parkingReminderUpdated:mockNotification];
    
    XCTAssertEqual(self.tabBarController.parkingNavController.tabBarItem, self.tabBarController.parkingSetTab);
}

- (void)testParkingReminderUpdatedNoReminder {
    NSNotification *mockNotification = [[NSNotification alloc] initWithName:@"" object:nil userInfo:@{GGPParkingReminderNotificationHasSavedReminderKey : @(NO)}];
    
    [self.tabBarController parkingReminderUpdated:mockNotification];
    
    XCTAssertEqual(self.tabBarController.parkingNavController.tabBarItem, self.tabBarController.parkingUnsetTab);
}

- (void)testHasSavedParkingReminderValid {
    id mockReminder = OCMClassMock([GGPParkingReminder class]);
    [OCMStub([mockReminder retrieveSavedReminder]) andReturn:mockReminder];
    [OCMStub([mockReminder isValid]) andReturnValue:OCMOCK_VALUE(YES)];
    
    XCTAssertTrue([self.tabBarController hasSavedParkingReminder]);
}

- (void)testHasSavedParkingReminderInvalid {
    id mockReminder = OCMClassMock([GGPParkingReminder class]);
    [OCMStub([mockReminder retrieveSavedReminder]) andReturn:mockReminder];
    [OCMStub([mockReminder isValid]) andReturnValue:OCMOCK_VALUE(NO)];
    
    XCTAssertFalse([self.tabBarController hasSavedParkingReminder]);
}

- (void)testHasSavedParkingReminderNone {
    id mockReminder = OCMClassMock([GGPParkingReminder class]);
    [OCMStub([mockReminder retrieveSavedReminder]) andReturn:nil];
    
    XCTAssertFalse([self.tabBarController hasSavedParkingReminder]);
}

- (void)testHandleQuickActionTypeHome {
    id mockTabBar = OCMPartialMock(self.tabBarController);
    OCMExpect([mockTabBar selectNavController:self.tabBarController.homeNavController]);
    BOOL handled = [mockTabBar handleQuickActionType:GGPQuickActionTypeHome];
    
    XCTAssertTrue(handled);
    OCMVerifyAll(mockTabBar);
}

- (void)testHandleQuickActionTypeDirectory {
    id mockTabBar = OCMPartialMock(self.tabBarController);
    OCMExpect([mockTabBar selectNavController:self.tabBarController.directoryNavController]);
    BOOL handled = [mockTabBar handleQuickActionType:GGPQuickActionTypeDirectory];
    
    XCTAssertTrue(handled);
    OCMVerifyAll(mockTabBar);
}

- (void)testHandleQuickActionTypeShopping {
    id mockTabBar = OCMPartialMock(self.tabBarController);
    OCMExpect([mockTabBar selectNavController:self.tabBarController.shoppingNavController]);
    BOOL handled = [mockTabBar handleQuickActionType:GGPQuickActionTypeShopping];
    
    XCTAssertTrue(handled);
    OCMVerifyAll(mockTabBar);
}

- (void)testHandleQuickActionTypeParking {
    id mockTabBar = OCMPartialMock(self.tabBarController);
    OCMExpect([mockTabBar selectNavController:self.tabBarController.parkingNavController]);
    BOOL handled = [mockTabBar handleQuickActionType:GGPQuickActionTypeParking];
    
    XCTAssertTrue(handled);
    OCMVerifyAll(mockTabBar);
}

- (void)testHandleQuickActionTypeInvalid {
    BOOL handled = [self.tabBarController handleQuickActionType:@"invalid"];
    XCTAssertFalse(handled);
}

@end
