//
//  GGPChangePasswordViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPBackButton.h"
#import "GGPChangePasswordViewController.h"
#import "GGPFormField.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UIView *oldPasswordContainer;
@property (weak, nonatomic) IBOutlet UIView *passwordContainer;
@property (weak, nonatomic) IBOutlet UIView *confirmPasswordContainer;

@property (strong, nonatomic) GGPFormField *oldPasswordField;
@property (strong, nonatomic) GGPFormField *passwordField;
@property (strong, nonatomic) GGPFormField *confirmPasswordField;
@property (assign, nonatomic) BOOL userHasChanges;

- (void)configureOldPasswordField;
- (void)configurePasswordField;
- (void)configureConfirmPasswordField;
- (void)configureNavigationBar;
- (void)updateButtonTapped;
- (void)backButtonTapped;
- (void)onUpdatePasswordComplete:(NSError *)error;
- (void)resetFields;

@end

@interface GGPChangePasswordViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPChangePasswordViewController *passwordController;

@end

@implementation GGPChangePasswordViewControllerTests

- (void)setUp {
    [super setUp];
    self.passwordController = [GGPChangePasswordViewController new];
    [self.passwordController view];
}

- (void)tearDown {
    self.passwordController = nil;
    [super tearDown];
}

- (void)testInitialization {
    XCTAssertNotNil(self.passwordController.oldPasswordContainer);
    XCTAssertNotNil(self.passwordController.passwordContainer);
    XCTAssertNotNil(self.passwordController.confirmPasswordField);
    XCTAssertNotNil(self.passwordController.oldPasswordField);
    XCTAssertNotNil(self.passwordController.passwordField);
    XCTAssertNotNil(self.passwordController.confirmPasswordField);
}

- (void)testFormFieldsConfiguration {
    [self.passwordController configureOldPasswordField];
    [self.passwordController configurePasswordField];
    [self.passwordController configureConfirmPasswordField];
    
    XCTAssertTrue(self.passwordController.oldPasswordField.secureTextEntry);
    XCTAssertFalse(self.passwordController.oldPasswordField.useValidationImage);
    
    XCTAssertTrue(self.passwordController.passwordField.secureTextEntry);
    XCTAssertTrue(self.passwordController.passwordField.useValidationImage);
    
    XCTAssertTrue(self.passwordController.confirmPasswordField.secureTextEntry);
    XCTAssertTrue(self.passwordController.confirmPasswordField.useValidationImage);
}

- (void)testConfigureNavigationBar {
    id mockNavigationController = OCMPartialMock([UINavigationController new]);
    OCMExpect([mockNavigationController ggp_configureWithDarkText]);
    
    id mockPasswordController = OCMPartialMock(self.passwordController);
    [OCMStub([mockPasswordController navigationController]) andReturn:mockNavigationController];
    
    [self.passwordController configureNavigationBar];
    
    XCTAssertNotNil(self.passwordController.navigationItem.leftBarButtonItem);
    
    OCMVerifyAll(mockNavigationController);
}

- (void)testUpdateButtonTapped {
    id mockOldPasswordField = OCMPartialMock(self.passwordController.oldPasswordField);
    id mockPasswordField = OCMPartialMock(self.passwordController.passwordField);
    id mockConfirmPasswordField = OCMPartialMock(self.passwordController.confirmPasswordField);
    
    OCMExpect([mockOldPasswordField validatePasswordAndLength:NO]);
    OCMExpect([mockPasswordField validatePasswordAndLength:YES]);
    OCMExpect([mockConfirmPasswordField validateConfirmationPasswordWithPassword:OCMOCK_ANY]);
    
    [self.passwordController updateButtonTapped];
    
    OCMVerifyAll(mockOldPasswordField);
    OCMVerifyAll(mockPasswordField);
    OCMVerifyAll(mockConfirmPasswordField);
}

- (void)testUpdatePasswordCompleteNoError {
    id mockController = OCMPartialMock(self.passwordController);
    OCMExpect([mockController ggp_displayAlertWithTitle:nil andMessage:[@"CHANGE_PASSWORD_SUCCESS" ggp_toLocalized]]);
    OCMExpect([mockController resetFields]);
    
    [self.passwordController onUpdatePasswordComplete:nil];
    
    OCMVerifyAll(mockController);
}

- (void)testUpdatePasswordCompleteInvalidError {
    id mockError = OCMPartialMock([NSError new]);
    [OCMStub([mockError code]) andReturnValue:OCMOCK_VALUE(GGPAccountInvalidLoginCredentialsErrorCode)];
    
    [self.passwordController onUpdatePasswordComplete:mockError];
    
    XCTAssertEqualObjects(self.passwordController.oldPasswordField.errorMessage, [@"CHANGE_PASSWORD_ERROR_NOT_RECOGNIZED" ggp_toLocalized]);
}

- (void)testUpdatePasswordCompleteGenericError {
    id mockError = OCMPartialMock([NSError new]);
    [OCMStub([mockError code]) andReturnValue:OCMOCK_VALUE(500)];
    
    id mockController = OCMPartialMock(self.passwordController);
    OCMExpect([mockController ggp_displayAlertWithTitle:nil andMessage:[@"ALERT_GENERIC_ERROR_MESSAGE" ggp_toLocalized]]);
    
    [self.passwordController onUpdatePasswordComplete:mockError];
    
    OCMVerifyAll(mockController);
}

- (void)testSetUserHasChangesYes {
    self.passwordController.userHasChanges = YES;
    
    XCTAssertNotNil(self.passwordController.navigationItem.rightBarButtonItem);
}

- (void)testSetUserHasChangesNo {
    self.passwordController.userHasChanges = NO;
    
    XCTAssertNil(self.passwordController.navigationItem.rightBarButtonItem);
}

@end
