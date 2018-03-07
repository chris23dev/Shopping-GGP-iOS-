//
//  GGPRegisterInfoViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPFormField.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPRegisterInfoViewController.h"
#import "GGPSocialInfo.h"
#import "GGPUser.h"

@interface GGPRegisterInfoViewController ()

@property (strong, nonatomic) GGPFormField *emailField;
@property (strong, nonatomic) GGPFormField *firstNameField;
@property (strong, nonatomic) GGPFormField *lastNameField;

@property (strong, nonatomic) NSString *registrationToken;
@property (strong, nonatomic) GGPUser *user;
@property (strong, nonatomic) GGPSocialInfo *socialInfo;

- (void)checkForExistingEmail;
- (BOOL)emailHasChanged;
- (GGPUser *)createUser;

@end

@interface GGPRegisterInfoViewControllerTests : XCTestCase

@property GGPRegisterInfoViewController *registerController;

@end

@implementation GGPRegisterInfoViewControllerTests

- (void)setUp {
    [super setUp];
    self.registerController = [GGPRegisterInfoViewController new];
    [self.registerController view];
}

- (void)tearDown {
    self.registerController = nil;
    [super tearDown];
}

- (void)testCreateUser {
    self.registerController.firstNameField.text = @"first name";
    self.registerController.lastNameField.text = @"last name";
    self.registerController.emailField.text = @"test@email.com";
    
    GGPUser *resultUser = [self.registerController createUser];
    
    XCTAssertEqualObjects(resultUser.firstName, @"first name");
    XCTAssertEqualObjects(resultUser.lastName, @"last name");
    XCTAssertEqualObjects(resultUser.email, @"test@email.com");
}

- (void)testCheckForExistingEmailSocialNotChanged {
    id mockController = OCMPartialMock(self.registerController);
    [OCMStub([mockController emailHasChanged]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockController socialInfo]) andReturn:[GGPSocialInfo new]];
    
    id mockAccount = OCMClassMock([GGPAccount class]);
    OCMExpect([mockAccount checkEmailAvailabilityForProvider:OCMOCK_ANY andRegistrationToken:OCMOCK_ANY withCompletion:OCMOCK_ANY]);
    
    [self.registerController checkForExistingEmail];
    
    OCMVerifyAll(mockAccount);
    
    [mockAccount stopMocking];
}

- (void)testCheckForExistingEmailSocialChanged {
    id mockController = OCMPartialMock(self.registerController);
    [OCMStub([mockController emailHasChanged]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockController socialInfo]) andReturn:[GGPSocialInfo new]];
    
    id mockAccount = OCMClassMock([GGPAccount class]);
    OCMExpect([mockAccount checkEmailAvailability:OCMOCK_ANY withCompletion:OCMOCK_ANY]);
    
    [self.registerController checkForExistingEmail];
    
    OCMVerifyAll(mockAccount);
    
    [mockAccount stopMocking];
}

- (void)testCheckForExistingEmailSite {
    id mockController = OCMPartialMock(self.registerController);
    [OCMStub([mockController emailHasChanged]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockController socialInfo]) andReturn:nil];
    
    id mockAccount = OCMClassMock([GGPAccount class]);
    OCMExpect([mockAccount checkEmailAvailability:OCMOCK_ANY withCompletion:OCMOCK_ANY]);
    
    [self.registerController checkForExistingEmail];
    
    OCMVerifyAll(mockAccount);
    
    [mockAccount stopMocking];
}

@end
