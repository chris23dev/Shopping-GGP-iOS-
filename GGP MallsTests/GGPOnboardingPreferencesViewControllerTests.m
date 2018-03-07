//
//  GGPOnboardingPreferencesViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCheckboxButton.h"
#import "GGPOnboardingPreferencesViewController.h"
#import "GGPOnboardingWelcomeViewController.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPRegisterPreferencesViewController (Onboarding)

@property (weak, nonatomic) IBOutlet GGPCheckboxButton *sweepstakesCheckbox;

- (void)onRegisterComplete:(NSError *)error;
- (void)enterSweepstakes;
- (void)onSweepstakesRegisterComplete:(NSError *)error;

@end

@interface GGPOnboardingPreferencesViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPOnboardingPreferencesViewController *viewController;

@end

@implementation GGPOnboardingPreferencesViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [GGPOnboardingPreferencesViewController new];
    [self.viewController view];
}

- (void)tearDown {
    self.viewController = nil;
    [super tearDown];
}

- (void)testRegisterCompleteSweepstakesSuccess {
    self.viewController.sweepstakesCheckbox.selected = YES;
    
    id mockController = OCMPartialMock(self.viewController);
    
    [OCMStub([mockController enterSweepstakes]) andDo:^(NSInvocation *invocation) {
        [self.viewController onSweepstakesRegisterComplete:nil];
    }];
    OCMExpect([mockController ggp_displayAlertWithTitle:OCMOCK_ANY message:OCMOCK_ANY actionTitle:OCMOCK_ANY andCompletion:OCMOCK_ANY]);
    
    [self.viewController onRegisterComplete:nil];
    
    OCMVerifyAll(mockController);
}

- (void)testRegisterCompleteSweepstakesFailure {
    self.viewController.sweepstakesCheckbox.selected = YES;
    
    id mockController = OCMPartialMock(self.viewController);
    id mockNavController = OCMClassMock([UINavigationController class]);
    
    [OCMStub([mockController navigationController]) andReturn:mockNavController];
    [OCMStub([mockController enterSweepstakes]) andDo:^(NSInvocation *invocation) {
        [self.viewController onSweepstakesRegisterComplete:[NSError new]];
    }];
    OCMExpect([mockNavController pushViewController:[OCMArg isKindOfClass:[GGPOnboardingWelcomeViewController class]] animated:YES]);
    
    [self.viewController onRegisterComplete:nil];
    
    OCMVerifyAll(mockNavController);
}

- (void)testRegisterCompleteSweepstakesNotEntered {
    self.viewController.sweepstakesCheckbox.selected = NO;
    
    id mockController = OCMPartialMock(self.viewController);
    id mockNavController = OCMClassMock([UINavigationController class]);
    
    [OCMStub([mockController navigationController]) andReturn:mockNavController];
    OCMExpect([mockNavController pushViewController:[OCMArg isKindOfClass:[GGPOnboardingWelcomeViewController class]] animated:YES]);
    
    [self.viewController onRegisterComplete:nil];
    
    OCMVerifyAll(mockNavController);
}

@end
