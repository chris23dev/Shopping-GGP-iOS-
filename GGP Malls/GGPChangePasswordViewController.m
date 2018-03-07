//
//  GGPChangePasswordViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/4/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPBackButton.h"
#import "GGPChangePasswordViewController.h"
#import "GGPFormField.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPChangePasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *oldPasswordContainer;
@property (weak, nonatomic) IBOutlet UIView *passwordContainer;
@property (weak, nonatomic) IBOutlet UIView *confirmPasswordContainer;

@property (strong, nonatomic) GGPFormField *oldPasswordField;
@property (strong, nonatomic) GGPFormField *passwordField;
@property (strong, nonatomic) GGPFormField *confirmPasswordField;
@property (strong, nonatomic) UIBarButtonItem *updateButton;
@property (assign, nonatomic) BOOL userHasChanges;

@end

@implementation GGPChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)configureControls {
    self.title = [@"CHANGE_PASSWORD_TITLE" ggp_toLocalized];
    self.view.backgroundColor = [UIColor ggp_lightGray];
    
    [self configureNavigationBar];
    [self configureOldPasswordField];
    [self configurePasswordField];
    [self configureConfirmPasswordField];
}

- (void)configureOldPasswordField {
    self.oldPasswordField = [GGPFormField new];
    self.oldPasswordField.textField.delegate = self;
    [self ggp_configureAndAddFormField:self.oldPasswordField withPlaceholder:[@"CHANGE_PASSWORD_OLD_PASSWORD" ggp_toLocalized] andErrorMessage:[@"CHANGE_PASSWORD_ERROR_NOT_RECOGNIZED" ggp_toLocalized] toContainer:self.oldPasswordContainer];
    self.oldPasswordField.secureTextEntry = YES;
}

- (void)configurePasswordField {
    self.passwordField = [GGPFormField new];
    self.passwordField.textField.delegate = self;
    [self ggp_configureAndAddFormField:self.passwordField withPlaceholder:[@"CHANGE_PASSWORD_NEW_PASSWORD" ggp_toLocalized] andErrorMessage:[@"FORM_FIELD_PASSWORD_LENGTH_INVALID_ERROR" ggp_toLocalized] toContainer:self.passwordContainer];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.useValidationImage = YES;
}

- (void)configureConfirmPasswordField {
    self.confirmPasswordField = [GGPFormField new];
    self.confirmPasswordField.textField.delegate = self;
    [self ggp_configureAndAddFormField:self.confirmPasswordField withPlaceholder:[@"CHANGE_PASSWORD_REENTER_NEW_PASSWORD" ggp_toLocalized] andErrorMessage:[@"FORM_FIELD_PASSWORD_MISMATCH_ERROR" ggp_toLocalized] toContainer:self.confirmPasswordContainer];
    self.confirmPasswordField.secureTextEntry = YES;
    self.confirmPasswordField.useValidationImage = YES;
}

- (void)configureNavigationBar {
    __weak typeof(self) weakSelf = self;
    [self.navigationController ggp_configureWithDarkText];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[GGPBackButton alloc] initWithTapHandler:^{
        [weakSelf ggp_accountBackButtonPressedForState:self.userHasChanges];
    }];
    
    self.updateButton = [[UIBarButtonItem alloc] initWithTitle:[@"CHANGE_PASSWORD_UPDATE" ggp_toLocalized] style:UIBarButtonItemStylePlain target:self action:@selector(updateButtonTapped)];
    [self.updateButton setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                                NSFontAttributeName: [UIFont ggp_mediumWithSize:14]} forState:UIControlStateNormal];
}

- (void)setUserHasChanges:(BOOL)userHasChanges {
    _userHasChanges = userHasChanges;
    self.navigationItem.rightBarButtonItem = userHasChanges ? self.updateButton : nil;
}

- (void)updateButtonTapped {
    [self.oldPasswordField validatePasswordAndLength:NO];
    [self.passwordField validatePasswordAndLength:YES];
    [self.confirmPasswordField validateConfirmationPasswordWithPassword:self.passwordField.text];
    
    BOOL isValid = self.oldPasswordField.isValid && self.passwordField.isValid && self.confirmPasswordField.isValid;
    
    if (isValid) {
        __weak typeof(self) weakSelf = self;
        [GGPAccount updateCurrentPassword:self.oldPasswordField.text toPassword:self.passwordField.text withCompletion:^(NSError *error) {
            [weakSelf onUpdatePasswordComplete:error];
        }];
    }
}

- (void)onUpdatePasswordComplete:(NSError *)error {
    if (!error) {
        [[GGPAnalytics shared] trackAction:GGPAnalyticsActionAccountChangePassword withData:nil];
        
        [self resetFields];
        [self ggp_displayAlertWithTitle:nil andMessage:[@"CHANGE_PASSWORD_SUCCESS" ggp_toLocalized]];
    } else if (error.code == GGPAccountInvalidLoginCredentialsErrorCode) {
        self.oldPasswordField.errorMessage = [@"CHANGE_PASSWORD_ERROR_NOT_RECOGNIZED" ggp_toLocalized];
        [self.oldPasswordField showError];
    } else {
        [self ggp_displayAlertWithTitle:nil andMessage:[@"ALERT_GENERIC_ERROR_MESSAGE" ggp_toLocalized]];
    }
}

- (void)resetFields {
    self.userHasChanges = NO;
    [self.oldPasswordField clearField];
    [self.passwordField clearField];
    [self.confirmPasswordField clearField];
    [self.view endEditing:YES];
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.userHasChanges = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
