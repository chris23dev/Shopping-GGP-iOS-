//
//  GGPSiteLoginViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAuthenticationController.h"
#import "GGPFormField.h"
#import "GGPResetPasswordViewController.h"
#import "GGPSiteLoginViewController.h"
#import "GGPSpinner.h"
#import "NSAttributedString+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <MessageUI/MessageUI.h>

@interface GGPSiteLoginViewController () <UITextViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailContainerTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *emailContainer;
@property (weak, nonatomic) IBOutlet UIView *passwordContainer;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *forgotPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UITextView *emailSupportTextView;

@property (strong, nonatomic) GGPFormField *emailField;
@property (strong, nonatomic) GGPFormField *passwordField;
@property (assign, nonatomic) BOOL isValid;

@end

@implementation GGPSiteLoginViewController

- (instancetype)init {
    return [self initWithNibName:@"GGPSiteLoginViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    [self styleControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)configureControls {
    [self configureFormFields];
    [self configureLoginButton];
    [self configureForgotPasswordButton];
    [self configureEmailSupportTextView];
}

- (void)configureFormFields {
    self.emailField = [GGPFormField new];
    self.emailField.textField.keyboardType = UIKeyboardTypeEmailAddress;
    [self ggp_configureAndAddFormField:self.emailField withPlaceholder:[@"EMAIL_LOGIN_EMAIL_PLACEHOLDER" ggp_toLocalized] andErrorMessage:[@"EMAIL_LOGIN_EMPTY_EMAIL_ERROR" ggp_toLocalized] toContainer:self.emailContainer];
    
    self.passwordField = [GGPFormField new];
    self.passwordField.secureTextEntry = YES;
    [self ggp_configureAndAddFormField:self.passwordField withPlaceholder:[@"EMAIL_LOGIN_PASSWORD_PLACEHOLDER" ggp_toLocalized] andErrorMessage:[@"EMAIL_LOGIN_EMPTY_PASSWORD_ERROR" ggp_toLocalized] toContainer:self.passwordContainer];
}

- (void)configureLoginButton {
    [self.loginButton ggp_styleAsDarkActionButton];
    [self.loginButton setTitle:[@"EMAIL_LOGIN_BUTTON" ggp_toLocalized] forState:UIControlStateNormal];
}

- (void)configureForgotPasswordButton {
    self.forgotPasswordLabel.textColor = [UIColor ggp_darkGray];
    self.forgotPasswordLabel.font = [UIFont ggp_regularWithSize:14];
    self.forgotPasswordLabel.text = [@"EMAIL_LOGIN_FORGOT_PASSWORD" ggp_toLocalized];
    
    [self.forgotPasswordButton setTitleColor:[UIColor ggp_blue] forState:UIControlStateNormal];
    [self.forgotPasswordButton setTitle:[@"EMAIL_LOGIN_RESET_PASSWORD" ggp_toLocalized] forState:UIControlStateNormal];
    self.forgotPasswordButton.titleLabel.font = [UIFont ggp_regularWithSize:14];
}

- (void)configureEmailSupportTextView {
    self.emailSupportTextView.delegate = self;
    self.emailSupportTextView.editable = NO;
    self.emailSupportTextView.scrollEnabled = NO;
    self.emailSupportTextView.textContainer.lineFragmentPadding = 0;
    self.emailSupportTextView.textContainerInset = UIEdgeInsetsZero;
    self.emailSupportTextView.backgroundColor = [UIColor clearColor];
    self.emailSupportTextView.linkTextAttributes = @{ NSForegroundColorAttributeName:[UIColor ggp_blue] };
}

- (void)configureNavigationBar {
    self.title = [@"LOGIN_TITLE" ggp_toLocalized];
}

- (void)styleControls {
    self.view.backgroundColor = [UIColor ggp_extraLightGray];
    self.emailSupportTextView.attributedText = [NSAttributedString ggp_generateEmailSupportAttributedStringWithColor:[UIColor ggp_darkGray]];
}

- (void)presentEmailComposeController {
    if (![MFMailComposeViewController canSendMail]) {
        return;
    }
    
    MFMailComposeViewController *composeController = [MFMailComposeViewController new];
    composeController.mailComposeDelegate = self;
    [composeController setToRecipients:@[[@"EMAIL_SUPPORT_ADDRESS" ggp_toLocalized]]];
    
    [self presentViewController:composeController animated:YES completion:nil];
}

#pragma mark - Tap handlers

- (IBAction)loginButtonTapped:(id)sender {
    [self.emailField validateEmail];
    [self.passwordField validatePasswordAndLength:NO];
    
    self.isValid = self.emailField.isValid && self.passwordField.isValid;
    
    if (self.isValid) {
        [GGPSpinner showForView:self.view];
        
        [GGPAccount loginWithEmail:self.emailField.text andPassword:self.passwordField.text withCompletion:^(NSError *error) {
            [GGPSpinner hideForView:self.view];
            
            if (!error) {
                [self onLoginComplete];
            } else if (error.code == GGPAccountInvalidLoginCredentialsErrorCode) {
                [self ggp_displayAlertWithTitle:nil andMessage:[@"EMAIL_LOGIN_INVALID_ERROR" ggp_toLocalized]];
            } else {
                [self ggp_displayAlertWithTitle:nil andMessage:[@"ALERT_GENERIC_ERROR_MESSAGE" ggp_toLocalized]];
            }
        }];
    }
}

- (void)onLoginComplete {
    [[NSNotificationCenter defaultCenter] postNotificationName:GGPAuthenticationCompletedNotification object:nil];
}

- (IBAction)forgotPasswordButtonTapped:(id)sender {
    [self.navigationController pushViewController:[GGPResetPasswordViewController new] animated:YES];
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if (textView == self.emailSupportTextView) {
        [self presentEmailComposeController];
    }
    return NO;
}

#pragma mark MFMailComposeDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
