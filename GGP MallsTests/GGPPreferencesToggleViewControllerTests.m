//
//  GGPPreferencesToggleViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPCheckboxButton.h"
#import "GGPFormField.h"
#import "GGPPreferencesToggleViewController.h"
#import "GGPUser.h"
#import "UIColor+GGPAdditions.h"

@interface GGPPreferencesToggleViewControllerTests : XCTestCase

@property GGPPreferencesToggleViewController *viewController;

@end

@interface GGPPreferencesToggleViewController (Testing)

@property IBOutlet UIView *smsContainer;
@property IBOutlet UILabel *smsDisclaimer;

@property GGPUser *user;
@property GGPFormField *smsField;
@property BOOL userHasChanges;

- (void)configureEmailToggle;
- (void)configureSMSToggleAndField;
- (void)configureSMSFieldForState:(BOOL)isSmsSubscribed;

@end

@implementation GGPPreferencesToggleViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [GGPPreferencesToggleViewController new];
    [self.viewController view];
}

- (void)tearDown {
    self.viewController = nil;
    [super tearDown];
}

- (void)testViewDidLoad {
    id mockAccount = OCMPartialMock([GGPAccount shared]);
    id mockUser = OCMPartialMock([GGPUser new]);
    [OCMStub([mockAccount currentUser]) andReturn:mockUser];
    [self.viewController viewDidLoad];
    XCTAssertNotNil(self.viewController.user);
}

- (void)testConfigureEmailToggle {
    id mockViewController = OCMPartialMock(self.viewController);
    GGPUser *mockUser = OCMPartialMock([GGPUser new]);
    
    [OCMStub([mockUser isEmailSubscribed]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockViewController user]) andReturn:mockUser];
    
    [self.viewController configureEmailToggle];
    
    XCTAssertTrue(self.viewController.emailCheckbox.isSelected);
}

- (void)testConfigureSMSToggleAndField {
    id mockViewController = OCMPartialMock(self.viewController);
    GGPUser *mockUser = OCMPartialMock([GGPUser new]);
    NSString *expectedPhone = @"222-222-2222";
    
    [OCMStub([mockUser isSmsSubscribed]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockUser mobilePhone]) andReturn:expectedPhone];
    [OCMStub([mockViewController user]) andReturn:mockUser];
    
    [self.viewController configureSMSToggleAndField];
    
    XCTAssertTrue(self.viewController.smsCheckbox.isSelected);
    XCTAssertEqualObjects(self.viewController.smsField.text, expectedPhone);
    XCTAssertEqual(self.viewController.smsField.textField.keyboardType, UIKeyboardTypePhonePad);
}

- (void)testConfigureSMSFieldForState {
    BOOL smsNotSubscribed = NO;
    [self.viewController configureSMSFieldForState:smsNotSubscribed];
    XCTAssertTrue(self.viewController.smsContainer.hidden);
    XCTAssertTrue(self.viewController.smsDisclaimer.hidden);
}

@end
