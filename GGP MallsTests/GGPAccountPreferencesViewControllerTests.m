//
//  GGPAccountPreferencesViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAccountPreferencesViewController.h"
#import "GGPFormField.h"
#import "GGPMall.h"
#import "GGPPreferencesToggleViewController.h"
#import "NSString+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <XCTest/XCTest.h>

@interface GGPAccountPreferencesViewControllerTests : XCTestCase

@property GGPAccountPreferencesViewController *viewController;

@end

@interface GGPAccountPreferencesViewController (Testing)

@property GGPPreferencesToggleViewController *preferencesToggleViewController;
@property GGPFormField *smsField;
@property BOOL userHasChanges;
@property GGPMall *updatedPreferredMall;

- (void)onUpdateComplete:(NSError *)error;
- (void)backButtonPressedForState:(BOOL)userHasChanges;
- (void)configureNavigationBar;
- (void)saveButtonTapped;
- (BOOL)hasPreferredMallUpdates;

@end

@implementation GGPAccountPreferencesViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [GGPAccountPreferencesViewController new];
    [self.viewController view];
}

- (void)tearDown {
    self.viewController = nil;
    [super tearDown];
}

- (void)testTabBarHidden {
    id mockTabController = OCMPartialMock([UITabBarController new]);
    id mockController = OCMPartialMock(self.viewController);
    
    [OCMStub([mockController tabBarController]) andReturn:mockTabController];
    
    [self.viewController viewWillAppear:NO];
    
    XCTAssertTrue(self.viewController.tabBarController.tabBar.hidden);
}

- (void)testConfigureNavigationBar {
    id mockNavigationController = OCMPartialMock([UINavigationController new]);
    OCMExpect([mockNavigationController ggp_configureWithDarkText]);
    
    id mockViewController = OCMPartialMock(self.viewController);
    [OCMStub([mockViewController navigationController]) andReturn:mockNavigationController];
    
    [self.viewController configureNavigationBar];
    
    XCTAssertNotNil(self.viewController.navigationItem.leftBarButtonItem);
    
    OCMVerifyAll(mockNavigationController);
}

- (void)testUpdateButtonTapped {
    id mockViewController = OCMPartialMock(self.viewController);
    id mockToggleViewController = OCMPartialMock(self.viewController.preferencesToggleViewController);
    UISwitch *mockSwitch = OCMPartialMock([UISwitch new]);
    id mockSMSField = OCMPartialMock([GGPFormField new]);
    
    [OCMStub([mockSwitch isOn]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockToggleViewController smsField]) andReturn:mockSMSField];
    [OCMStub([mockViewController preferencesToggleViewController]) andReturn:mockToggleViewController];
    
    OCMExpect([mockSMSField validatePhoneNumberForSelectedState:mockSwitch.isOn]);
    
    [self.viewController saveButtonTapped];
    
    OCMVerifyAll(mockSMSField);
}

- (void)testUpdatePasswordCompleteNoError {
    id mockController = OCMPartialMock(self.viewController);
    OCMExpect([mockController ggp_displayAlertWithTitle:nil andMessage:[@"ACCOUNT_PREFERENCES_SUCCESS" ggp_toLocalized]]);
    
    [self.viewController onUpdateComplete:nil];
    
    OCMVerifyAll(mockController);
}

- (void)testUpdatePasswordCompleteInvalidError {
    id mockError = OCMPartialMock([NSError new]);
    [OCMStub([mockError code]) andReturnValue:OCMOCK_VALUE(GGPAccountInvalidLoginCredentialsErrorCode)];
    
    [self.viewController onUpdateComplete:mockError];
    
    XCTAssertTrue(self.viewController.userHasChanges);
}

- (void)testUpdatePasswordCompleteGenericError {
    id mockError = OCMPartialMock([NSError new]);
    [OCMStub([mockError code]) andReturnValue:OCMOCK_VALUE(500)];
    
    id mockController = OCMPartialMock(self.viewController);
    OCMExpect([mockController ggp_displayAlertWithTitle:nil andMessage:[@"ALERT_GENERIC_ERROR_MESSAGE" ggp_toLocalized]]);
    
    [self.viewController onUpdateComplete:mockError];
    
    OCMVerifyAll(mockController);
}

- (void)testHasPreferredMallUpdates {
    XCTAssertFalse([self.viewController hasPreferredMallUpdates]);
    self.viewController.updatedPreferredMall = [GGPMall new];
    XCTAssertTrue([self.viewController hasPreferredMallUpdates]);
}

@end
