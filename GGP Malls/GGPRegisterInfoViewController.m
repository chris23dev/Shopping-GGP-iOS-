//
//  GGPSiteRegisterViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPEmailVerificationClient.h"
#import "GGPFormField.h"
#import "GGPRegisterInfoViewController.h"
#import "GGPRegisterPreferencesViewController.h"
#import "GGPSocialInfo.h"
#import "GGPSpinner.h"
#import "GGPUser.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPRegisterInfoViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *emailContainer;
@property (weak, nonatomic) IBOutlet UIView *firstNameContainer;
@property (weak, nonatomic) IBOutlet UIView *lastNameContainer;
@property (weak, nonatomic) IBOutlet UILabel *requiredFieldsLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *passwordContainer;
@property (weak, nonatomic) IBOutlet UIView *confirmPasswordContainer;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) GGPFormField *emailField;
@property (strong, nonatomic) GGPFormField *firstNameField;
@property (strong, nonatomic) GGPFormField *lastNameField;
@property (strong, nonatomic) GGPFormField *passwordField;
@property (strong, nonatomic) GGPFormField *confirmPasswordField;

@property (strong, nonatomic) GGPSocialInfo *socialInfo;
@property (strong, nonatomic) NSString *provider;
@property (strong, nonatomic) NSString *registrationToken;

@end

@implementation GGPRegisterInfoViewController

- (instancetype)initWithSocialInfo:(GGPSocialInfo *)socialInfo provider:(NSString *)provider andRegistrationToken:(NSString *)registrationToken {
    self = [super init];
    if (self) {
        self.socialInfo = socialInfo;
        self.provider = provider;
        self.registrationToken = registrationToken;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"REGISTER_TITLE" ggp_toLocalized];
    [self configureControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)configureControls {
    [self configureEmailControl];
    [self configureFirstNameControl];
    [self configureLastNameControl];
    
    if (self.socialInfo) {
        [self configureSocialControls];
    } else {
        [self configureSiteControls];
    }
    
    [self configureRequiredFieldsLabel];
    [self configureNextButton];
    
    [self styleControls];
}

- (void)configureSiteControls {
    [self configurePasswordControl];
    [self configureConfirmPasswordControl];
}

- (void)configureSocialControls {
    [self.passwordContainer ggp_collapseVertically];
    [self.confirmPasswordContainer ggp_collapseVertically];
    
    self.emailField.text = self.socialInfo.email;
    self.firstNameField.text = self.socialInfo.firstName;
    self.lastNameField.text = self.socialInfo.lastName;
}

- (void)styleControls {
    self.backgroundImageView.hidden = YES;
    self.containerView.backgroundColor = [UIColor ggp_extraLightGray];
    self.view.backgroundColor = [UIColor ggp_extraLightGray];
}

- (void)configureNavigationBar {
    [self.navigationController ggp_configureWithDarkText];
    self.navigationController.navigationBar.barTintColor = [UIColor ggp_lightGray];
}

- (void)configureEmailControl {
    self.emailField = [GGPFormField new];
    self.emailField.textField.keyboardType = UIKeyboardTypeEmailAddress;
    NSString *placeholder = [@"REGISTER_EMAIL_LABEL" ggp_toLocalized];
    NSString *errorMessage = [@"FORM_FIELD_EMPTY_EMAIL_ERROR" ggp_toLocalized];
    [self ggp_configureAndAddFormField:self.emailField withPlaceholder:placeholder andErrorMessage:errorMessage toContainer:self.emailContainer];
}

- (void)configureFirstNameControl {
    self.firstNameField = [GGPFormField new];
    NSString *placeholder = [@"REGISTER_FIRST_NAME_LABEL" ggp_toLocalized];
    NSString *errorMessage = [@"REGISTER_FIRST_NAME_ERROR" ggp_toLocalized];
    [self ggp_configureAndAddFormField:self.firstNameField withPlaceholder:placeholder andErrorMessage:errorMessage toContainer:self.firstNameContainer];
}

- (void)configureLastNameControl {
    self.lastNameField = [GGPFormField new];
    NSString *placeholder = [@"REGISTER_LAST_NAME_LABEL" ggp_toLocalized];
    NSString *errorMessage = [@"REGISTER_LAST_NAME_ERROR" ggp_toLocalized];
    [self ggp_configureAndAddFormField:self.lastNameField withPlaceholder:placeholder andErrorMessage:errorMessage toContainer:self.lastNameContainer];
}

- (void)configurePasswordControl {
    self.passwordField = [GGPFormField new];
    NSString *placeholder = [@"REGISTER_PASSWORD" ggp_toLocalized];
    NSString *errorMessage = [@"FORM_FIELD_PASSWORD_LENGTH_INVALID_ERROR" ggp_toLocalized];
    [self ggp_configureAndAddFormField:self.passwordField withPlaceholder:placeholder andErrorMessage:errorMessage toContainer:self.passwordContainer];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.useValidationImage = YES;
}

- (void)configureConfirmPasswordControl {
    self.confirmPasswordField = [GGPFormField new];
    NSString *placeholder = [@"REGISTER_PASSWORD_CONFIRM" ggp_toLocalized];
    NSString *errorMessage = [@"FORM_FIELD_EMPTY_CONFIRM_PASSWORD_ERROR" ggp_toLocalized];
    [self ggp_configureAndAddFormField:self.confirmPasswordField withPlaceholder:placeholder andErrorMessage:errorMessage toContainer:self.confirmPasswordContainer];
    self.confirmPasswordField.secureTextEntry = YES;
}

- (void)configureRequiredFieldsLabel {
    self.requiredFieldsLabel.text = [@"REGISTER_REQUIRED_FIELD" ggp_toLocalized];
    self.requiredFieldsLabel.font = [UIFont ggp_regularWithSize:14];
    self.requiredFieldsLabel.textColor = [UIColor grayColor];
}

- (void)configureNextButton {
    [self.nextButton ggp_styleAsDarkActionButton];
    [self.nextButton setTitle:[@"REGISTER_NEXT_BUTTON" ggp_toLocalized] forState:UIControlStateNormal];
}

- (IBAction)nextButtonTapped:(id)sender {
    BOOL isValid = self.socialInfo ? [self validateSocialFields] : [self validateAllFields];
    
    if (isValid) {
        [self checkForExistingEmail];
    }
}

- (BOOL)validateAllFields {
    [self validateSocialFields];
    [self validatePasswordFields];
    
    return self.emailField.isValid  &&
            self.firstNameField.isValid &&
            self.lastNameField.isValid &&
            self.passwordField.isValid &&
            self.confirmPasswordField.isValid;
}

- (BOOL)validateSocialFields {
    [self.emailField validateEmail];
    [self.firstNameField validateName];
    [self.lastNameField validateName];
    
    return self.emailField.isValid  && self.firstNameField.isValid && self.lastNameField.isValid;
}

- (BOOL)validatePasswordFields {
    [self.passwordField validatePasswordAndLength:YES];
    [self.confirmPasswordField validateConfirmationPasswordWithPassword:self.passwordField.text];
    
    return self.passwordField.isValid && self.confirmPasswordField.isValid;
}

- (void)checkForExistingEmail {
    [GGPSpinner showForView:self.view];
    if (self.socialInfo && ![self emailHasChanged]) {
        [GGPAccount checkEmailAvailabilityForProvider:self.provider andRegistrationToken:self.registrationToken withCompletion:^(NSError *error, BOOL emailAvailable) {
            [self onEmailCheckCompleteForEmailAvailable:emailAvailable];
        }];
    } else {
        [GGPAccount checkEmailAvailability:self.emailField.text withCompletion:^(NSError *error, BOOL emailAvailable) {
            [self onEmailCheckCompleteForEmailAvailable:emailAvailable];
        }];
    }
}

- (BOOL)emailHasChanged {
    return ![self.socialInfo.email isEqualToString:self.emailField.text];
}

- (void)onEmailCheckCompleteForEmailAvailable:(BOOL)emailAvailable {
    if (emailAvailable) {
        [self verifyEmail:self.emailField.text];
    } else {
        [GGPSpinner hideForView:self.view];
        [self ggp_displayAlertWithTitle:nil andMessage:[@"REGISTER_EMAIL_EXISTS_ERROR" ggp_toLocalized]];
    }
}

- (void)verifyEmail:(NSString *)email {
    [[GGPEmailVerificationClient shared] verifyEmail:email withCompletion:^(BOOL isValidEmail) {
        [GGPSpinner hideForView:self.view];
        if (isValidEmail) {
            [self displayPreferencesScreenForUser:[self createUser]];
        } else {
            [self ggp_displayAlertWithTitle:nil andMessage:[@"ALERT_ENTER_VALID_EMAIL" ggp_toLocalized]];
        }
    }];
}

- (void)displayPreferencesScreenForUser:(GGPUser *)user {
    if (self.socialInfo) {
        [self.navigationController pushViewController:[[GGPRegisterPreferencesViewController alloc] initWithUser:user provider:self.provider andRegistrationToken:self.registrationToken] animated:YES];
    } else {
        [self.navigationController pushViewController:[[GGPRegisterPreferencesViewController alloc] initWithUser:user andPassword:self.passwordField.text] animated:YES];
    }
}

- (GGPUser *)createUser {
    GGPUser *user = [GGPUser new];
    user.email = self.emailField.text;
    user.firstName = self.firstNameField.text;
    user.lastName = self.lastNameField.text;
    return user;
}

@end
