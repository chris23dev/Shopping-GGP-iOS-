//
//  GGPAccountInfoViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAccountInfoViewController.h"
#import "GGPFormField.h"
#import "GGPUser.h"
#import "UIView+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPAccountInfoViewControllerTests : XCTestCase

@property GGPAccountInfoViewController *viewController;

@end

@interface GGPAccountInfoViewController (Testing)

@property (weak, nonatomic) IBOutlet UIView *firstNameContainer;
@property (weak, nonatomic) IBOutlet UIView *lastNameContainer;
@property (weak, nonatomic) IBOutlet UIView *emailContainer;
@property (weak, nonatomic) IBOutlet UILabel *emailDisclaimerLabel;
@property (weak, nonatomic) IBOutlet UIView *genderContainer;
@property (weak, nonatomic) IBOutlet UIView *birthdayContainer;
@property (weak, nonatomic) IBOutlet UIView *zipCodeContainer;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@property (weak, nonatomic) IBOutlet UILabel *socialDisclaimerLabel;

@property GGPUser *user;
@property GGPFormField *birthdateField;
@property GGPFormField *firstNameField;
@property GGPFormField *lastNameField;
@property GGPFormField *genderField;
@property BOOL userHasChanges;

- (void)configureUserInfoDisclaimerLabel;
- (void)configureDisclaimersForLoginProvider;
- (GGPUser *)updatedUserFromFormValues;
- (void)updateTextFieldsForUser:(GGPUser *)user;
- (void)backButtonPressed;

@end

@implementation GGPAccountInfoViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [GGPAccountInfoViewController new];
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

- (void)testUpdateFieldsForUser {
    GGPUser *user = [[GGPUser alloc] initWithDictionary:@{ @"profile" : @{
                                                                   @"firstName": @"test",
                                                                   @"lastName": @"test",
                                                                   @"gender": @"female"
                                                                   }
                                                           }];
    
    [self.viewController updateTextFieldsForUser:user];
    
    XCTAssertNotNil(self.viewController.firstNameField.text);
    XCTAssertNotNil(self.viewController.lastNameField.text);
    XCTAssertNotNil(self.viewController.genderField.text);
}

- (void)testConfigureDatePickerWithUserDate {
    GGPUser *mockUser = [[GGPUser alloc] initWithDictionary: @{ @"profile" : @{
                                                                        @"birthYear": @(1990)
                                                                        }
                                                                }];
    id mockAccount = OCMPartialMock([GGPAccount shared]);
    id mockDatePicker = OCMPartialMock([UIDatePicker new]);
    
    [OCMStub([mockAccount currentUser]) andReturn:mockUser];
    OCMExpect([mockDatePicker setDate:OCMOCK_ANY]);
    OCMVerify(mockDatePicker);
    [mockAccount stopMocking];
}

- (void)testUpdateUserFromFormValues {
    NSString *expectedFirstName = @"First";
    NSString *expectedLastName = @"Last";
    NSString *expectedGenderInput = @"Unspecified";
    NSString *expectedGenderOutput = @"u";
    self.viewController.firstNameField.text = expectedFirstName;
    self.viewController.lastNameField.text = expectedLastName;
    self.viewController.genderField.text = expectedGenderInput;
    GGPUser *updatedUser = [self.viewController updatedUserFromFormValues];
    XCTAssertEqualObjects(updatedUser.firstName, expectedFirstName);
    XCTAssertEqualObjects(updatedUser.lastName, expectedLastName);
    XCTAssertEqualObjects(updatedUser.gender, expectedGenderOutput);
}

- (void)testConfigureEmailDisclaimerLabelIsSocial {
    id mockUser = OCMPartialMock([GGPUser new]);
    id mockAccount = OCMPartialMock([GGPAccount shared]);
    id mockEmailDisclaimerLabel = OCMPartialMock(self.viewController.emailDisclaimerLabel);
    
    [OCMStub([mockUser loginProvider]) andReturn:@"googleplus"];
    [OCMStub([mockAccount currentUser]) andReturn:mockUser];
    
    OCMExpect([mockEmailDisclaimerLabel ggp_collapseVertically]);
    
    [self.viewController configureDisclaimersForLoginProvider];
    
    OCMVerifyAll(mockEmailDisclaimerLabel);
    [mockAccount stopMocking];
}

- (void)testConfigureSocialDisclaimerLabelNotSocial {
    id mockUser = OCMPartialMock([GGPUser new]);
    id mockAccount = OCMPartialMock([GGPAccount shared]);
    id socialDisclaimerLabel = OCMPartialMock(self.viewController.socialDisclaimerLabel);
    
    [OCMStub([mockUser loginProvider]) andReturn:@"site"];
    [OCMStub([mockAccount currentUser]) andReturn:mockUser];
    
    OCMExpect([socialDisclaimerLabel ggp_collapseVertically]);
    
    [self.viewController configureDisclaimersForLoginProvider];
    
    OCMVerifyAll(socialDisclaimerLabel);
    [mockAccount stopMocking];
}

@end
