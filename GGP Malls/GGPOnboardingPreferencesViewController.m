//
//  GGPOnboardingPreferencesViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/31/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCheckboxButton.h"
#import "GGPFormField.h"
#import "GGPOnboardingPreferencesViewController.h"
#import "GGPOnboardingWelcomeViewController.h"
#import "GGPPreferencesToggleViewController.h"
#import "GGPSpinner.h"
#import "NSAttributedString+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPRegisterPreferencesViewController (Onboarding)

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextView *termsTextView;
@property (weak, nonatomic) IBOutlet UITextView *sweepstakesTextView;
@property (weak, nonatomic) IBOutlet GGPCheckboxButton *sweepstakesCheckbox;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextView *emailSupportTextView;

@property (strong, nonatomic) GGPPreferencesToggleViewController *toggleViewController;

- (void)enterSweepstakes;

@end

@interface GGPPreferencesToggleViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *smsLabel;
@property (weak, nonatomic) IBOutlet UILabel *smsDisclaimer;

@property (strong, nonatomic) GGPFormField *smsField;

@end

@interface GGPOnboardingPreferencesViewController ()

@end

@implementation GGPOnboardingPreferencesViewController

- (void)configureNavigationBar {
    [self.navigationController ggp_configureWithLightText];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:[@"ONBOARDING_CANCEL" ggp_toLocalized] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped)];
    
    NSDictionary *attributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSFontAttributeName: [UIFont ggp_regularWithSize:14] };
    
    [cancelButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)styleControls {
    self.backgroundImageView.image = [UIImage imageNamed:@"ggp_onboarding_background"];
    self.containerView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    self.termsTextView.attributedText = [NSAttributedString ggp_generateTermsAttributedStringWithColor:[UIColor ggp_extraLightGray]];
    self.emailSupportTextView.attributedText = [NSAttributedString ggp_generateEmailSupportAttributedStringWithColor:[UIColor ggp_extraLightGray]];
    
    self.toggleViewController.emailLabel.textColor = [UIColor ggp_extraLightGray];
    self.toggleViewController.smsLabel.textColor = [UIColor ggp_extraLightGray];
    self.toggleViewController.smsDisclaimer.textColor = [UIColor ggp_extraLightGray];
    self.toggleViewController.smsDisclaimer.font = [UIFont ggp_lightWithSize:10];
    [self.toggleViewController.smsField configureWithBackgroundColor:[UIColor clearColor] andTintColor:[UIColor ggp_extraLightGray]];
}

- (UIColor *)sweepstakesTextColor {
    return [UIColor ggp_extraLightGray];
}

- (void)onRegisterComplete:(NSError *)error {
    if (!error) {
        if (self.sweepstakesCheckbox.isSelected) {
            [self enterSweepstakes];
        } else {
            [GGPSpinner hideForView:self.view];
            [self.navigationController pushViewController:[GGPOnboardingWelcomeViewController new] animated:YES];
        }
    } else {
        [GGPSpinner hideForView:self.view];
        [self ggp_displayAlertWithTitle:nil andMessage:[@"ALERT_GENERIC_ERROR_MESSAGE" ggp_toLocalized]];
    }
}

- (void)onSweepstakesRegisterComplete:(NSError *)error {
    [GGPSpinner hideForView:self.view];
    if (!error) {
        [self ggp_displayAlertWithTitle:[@"REGISTER_SWEEPSTAKES_ALERT_TITLE" ggp_toLocalized] message:[@"REGISTER_SWEEPSTAKES_ALERT_CONFIRMATION" ggp_toLocalized] actionTitle:[@"REGISTER_SWEEPSTAKES_ALERT_CLOSE" ggp_toLocalized] andCompletion:^{
            [self.navigationController pushViewController:[GGPOnboardingWelcomeViewController new] animated:YES];
        }];
    } else {
        [self.navigationController pushViewController:[GGPOnboardingWelcomeViewController new] animated:YES];
    }
}

- (void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
