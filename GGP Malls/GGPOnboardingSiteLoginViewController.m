//
//  GGPOnboardingSiteLoginViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFormField.h"
#import "GGPOnboardingResetPasswordViewController.h"
#import "GGPOnboardingSiteLoginViewController.h"
#import "GGPOnboardingWelcomeViewController.h"
#import "NSAttributedString+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"

@interface GGPSiteLoginViewController (Onboarding)

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *forgotPasswordLabel;
@property (weak, nonatomic) IBOutlet UITextView *emailSupportTextView;

@property (strong, nonatomic) GGPFormField *emailField;
@property (strong, nonatomic) GGPFormField *passwordField;

- (void)onLoginComplete;

@end

@implementation GGPOnboardingSiteLoginViewController

- (void)configureNavigationBar {
    self.title = [@"LOGIN_TITLE" ggp_toLocalized];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}

- (void)styleControls {
    self.backgroundImageView.image = [UIImage imageNamed:@"ggp_onboarding_background"];
    [self.emailField configureWithBackgroundColor:[UIColor clearColor]
                                              andTintColor:[UIColor ggp_extraLightGray]];
    [self.passwordField configureWithBackgroundColor:[UIColor clearColor]
                                                 andTintColor:[UIColor ggp_extraLightGray]];
    self.forgotPasswordLabel.textColor = [UIColor ggp_extraLightGray];
    self.emailSupportTextView.attributedText = [NSAttributedString ggp_generateEmailSupportAttributedStringWithColor:[UIColor ggp_extraLightGray]];
}

- (void)onLoginComplete {
    [super onLoginComplete];
    [self.navigationController pushViewController:[GGPOnboardingWelcomeViewController new] animated:YES];
}

- (IBAction)forgotPasswordButtonTapped:(id)sender {
    [self.navigationController pushViewController:[GGPOnboardingResetPasswordViewController new] animated:YES];
}

@end
