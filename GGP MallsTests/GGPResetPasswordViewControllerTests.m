//
//  GGPResetPasswordViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPResetPasswordViewController.h"
#import "UINavigationController+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import "GGPFormField.h"
#import "GGPAccount.h"

@interface GGPResetPasswordViewController ()

@property (strong, nonatomic) GGPFormField *emailField;
- (IBAction)submitButtonTapped:(id)sender;

@end

@interface GGPResetPasswordViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPResetPasswordViewController *resetController;

@end

@implementation GGPResetPasswordViewControllerTests

- (void)setUp {
    [super setUp];
    self.resetController = [GGPResetPasswordViewController new];
    [self.resetController view];
}

- (void)tearDown {
    self.resetController = nil;
    [super tearDown];
}

- (void)testSubmitButtonTappedIsValidEmail {
    id mockEmailField = OCMPartialMock([GGPFormField new]);
    OCMExpect([mockEmailField validateEmail]);
    [OCMStub([mockEmailField isValid]) andReturnValue:OCMOCK_VALUE(YES)];
    
    self.resetController.emailField = mockEmailField;
    
    id mockAccount = OCMClassMock([GGPAccount class]);
    OCMExpect([mockAccount resetPasswordForEmail:OCMOCK_ANY withCompletion:OCMOCK_ANY]);
    
    [self.resetController submitButtonTapped:nil];
    
    OCMVerifyAll(mockEmailField);
    OCMVerifyAll(mockAccount);
    
    [mockAccount stopMocking];
}

- (void)testSubmitButtonTappedIsNotValidEmail {
    id mockEmailField = OCMPartialMock([GGPFormField new]);
    OCMExpect([mockEmailField validateEmail]);
    [OCMStub([mockEmailField isValid]) andReturnValue:OCMOCK_VALUE(NO)];
    
    self.resetController.emailField = mockEmailField;
    
    id mockAccount = OCMClassMock([GGPAccount class]);
    [[mockAccount reject] resetPasswordForEmail:OCMOCK_ANY withCompletion:OCMOCK_ANY];
    
    [self.resetController submitButtonTapped:nil];
    
    OCMVerifyAll(mockEmailField);
    OCMVerifyAll(mockAccount);
    
    [mockAccount stopMocking];
}

@end
