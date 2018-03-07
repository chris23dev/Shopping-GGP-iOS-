//
//  GGPRegisterPreferencesViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPCheckboxButton.h"
#import "GGPFormField.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPPreferencesToggleViewController.h"
#import "GGPRegisterPreferencesViewController.h"
#import "GGPUser.h"
#import "UIView+GGPAdditions.h"

@interface GGPRegisterPreferencesViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPRegisterPreferencesViewController *viewController;

@end

@interface GGPRegisterPreferencesViewController (Tests)

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *toggleContainer;
@property (weak, nonatomic) IBOutlet UIView *termsRow;
@property (weak, nonatomic) IBOutlet UITextView *termsTextView;
@property (weak, nonatomic) IBOutlet GGPCheckboxButton *termsButton;
@property (weak, nonatomic) IBOutlet UILabel *termsErrorLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet GGPCheckboxButton *sweepstakesCheckbox;

@property (strong, nonatomic) GGPPreferencesToggleViewController *toggleViewController;
@property (strong, nonatomic) GGPUser *user;

- (void)validateTerms;
- (void)updateUser;
- (void)configureDefaultToggleState;
- (void)onRegisterComplete:(NSError *)error;
- (void)enterSweepstakes;
- (void)onSweepstakesRegisterComplete:(NSError *)error;
- (void)displayRegisterConfirmationAlert;
- (void)displaySweepstakesConfirmationAlert;

@end

@implementation GGPRegisterPreferencesViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [GGPRegisterPreferencesViewController new];
    [self.viewController view];
}

- (void)tearDown {
    self.viewController = nil;
    [super tearDown];
}

- (void)testValidateConsentIsChecked {
    self.viewController.termsButton.selected = YES;
    id mockErrorLabel = OCMPartialMock(self.viewController.termsErrorLabel);
    OCMExpect([mockErrorLabel ggp_collapseVertically]);
    
    [self.viewController validateTerms];
    
    OCMVerifyAll(mockErrorLabel);
}

- (void)testDefaultToggleState {
    [self.viewController configureDefaultToggleState];
    
    XCTAssertTrue(self.viewController.toggleViewController.emailCheckbox.isSelected);
    XCTAssertTrue(self.viewController.toggleViewController.smsCheckbox.isSelected);
}

- (void)testUpdateUser {
    GGPUser *testUser = [GGPUser new];
    NSString *expectedPhone = @"1112223333";
    NSString *expectedMallName = @"mockMall";
    NSString *expectedMallId = @"100";
    
    id mockMall = OCMPartialMock([GGPMall new]);
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    [OCMStub([mockMall mallId]) andReturnValue:OCMOCK_VALUE(expectedMallId.integerValue)];
    [OCMStub([mockMall name]) andReturn:expectedMallName];
    
    self.viewController.user = testUser;
    self.viewController.toggleViewController.emailCheckbox.selected = NO;
    self.viewController.toggleViewController.smsCheckbox.selected = YES;
    self.viewController.toggleViewController.smsField.text = expectedPhone;
    
    [self.viewController updateUser];
    
    XCTAssertFalse(testUser.isEmailSubscribed);
    XCTAssertTrue(testUser.isSmsSubscribed);
    XCTAssertTrue(testUser.agreedToTerms);
    XCTAssertEqualObjects(testUser.mobilePhone, expectedPhone);
    XCTAssertEqualObjects(testUser.originMallId, expectedMallId);
    XCTAssertEqualObjects(testUser.originMallName, expectedMallName);
    
    [mockMallManager stopMocking];
}

- (void)testRegisterCompleteSweepstakesSuccess {
    self.viewController.sweepstakesCheckbox.selected = YES;
    
    id mockController = OCMPartialMock(self.viewController);
    
    [OCMStub([mockController enterSweepstakes]) andDo:^(NSInvocation *invocation) {
        [self.viewController onSweepstakesRegisterComplete:nil];
    }];
    OCMExpect([mockController displaySweepstakesConfirmationAlert]);
    
    [self.viewController onRegisterComplete:nil];
    
    OCMVerifyAll(mockController);
}

- (void)testRegisterCompleteSweepstakesFailure {
    self.viewController.sweepstakesCheckbox.selected = YES;
    
    id mockController = OCMPartialMock(self.viewController);
    
    [OCMStub([mockController enterSweepstakes]) andDo:^(NSInvocation *invocation) {
        [self.viewController onSweepstakesRegisterComplete:[NSError new]];
    }];
    OCMExpect([mockController displayRegisterConfirmationAlert]);
    
    [self.viewController onRegisterComplete:nil];
    
    OCMVerifyAll(mockController);
}

- (void)testRegisterCompleteSweepstakesNotEntered {
    self.viewController.sweepstakesCheckbox.selected = NO;
    
    id mockController = OCMPartialMock(self.viewController);
    
    OCMExpect([mockController displayRegisterConfirmationAlert]);
    
    [self.viewController onRegisterComplete:nil];
    
    OCMVerifyAll(mockController);
}

@end
