//
//  GGPSiteLoginViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPFormField.h"
#import "GGPSiteLoginViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"

@interface GGPSiteLoginViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPSiteLoginViewController *emailLoginController;

@end

@interface GGPSiteLoginViewController (Testing)

@property (strong, nonatomic) GGPFormField *emailField;
@property (strong, nonatomic) GGPFormField *passwordField;

- (IBAction)loginButtonTapped:(id)sender;

@end

@implementation GGPSiteLoginViewControllerTests

- (void)setUp {
    [super setUp];
    self.emailLoginController = [GGPSiteLoginViewController new];
    [self.emailLoginController view];
}

- (void)tearDown {
    self.emailLoginController = nil;
    [super tearDown];
}

- (void)testLoginButtonTappedIsValid {
    id mockEmailField = OCMPartialMock(self.emailLoginController.emailField);
    id mockPasswordField = OCMPartialMock(self.emailLoginController.passwordField);
    id mockAccount = OCMClassMock([GGPAccount class]);
    
    OCMExpect([mockEmailField validateEmail]);
    OCMExpect([mockPasswordField validatePasswordAndLength:NO]);
    [OCMStub([mockEmailField isValid]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockPasswordField isValid]) andReturnValue:OCMOCK_VALUE(YES)];
    
    OCMExpect([mockAccount loginWithEmail:self.emailLoginController.emailField.text andPassword:self.emailLoginController.passwordField.text withCompletion:OCMOCK_ANY]);
    
    [self.emailLoginController loginButtonTapped:nil];
    
    OCMVerifyAll(mockEmailField);
    OCMVerifyAll(mockPasswordField);
    OCMVerifyAll(mockAccount);
    
    [mockAccount stopMocking];
}

- (void)testLoginButtonTappedIsNotValid {
    id mockEmailField = OCMPartialMock(self.emailLoginController.emailField);
    id mockPasswordField = OCMPartialMock(self.emailLoginController.passwordField);
    id mockAccount = OCMClassMock([GGPAccount class]);
    
    OCMExpect([mockEmailField validateEmail]);
    OCMExpect([mockPasswordField validatePasswordAndLength:NO]);
    [OCMStub([mockEmailField isValid]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockPasswordField isValid]) andReturnValue:OCMOCK_VALUE(NO)];
    
    [[mockAccount reject] loginWithEmail:self.emailLoginController.emailField.text andPassword:self.emailLoginController.passwordField.text withCompletion:OCMOCK_ANY];
    
    [self.emailLoginController loginButtonTapped:nil];
    
    OCMVerifyAll(mockEmailField);
    OCMVerifyAll(mockPasswordField);
    OCMVerifyAll(mockAccount);
    
    [mockAccount stopMocking];
}

@end
