//
//  GGPResetPasswordViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPFormField.h"
#import "GGPResetPasswordViewController.h"
#import "GGPSpinner.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPResetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *emailContainer;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (strong, nonatomic) GGPFormField *emailField;

@end

@implementation GGPResetPasswordViewController

- (instancetype)init {
    return [self initWithNibName:@"GGPResetPasswordViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"RESET_PASSWORD_TITLE" ggp_toLocalized];
    [self configureControls];
    [self styleControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)configureControls {
    [self configureDescription];
    [self configureEmailField];
    [self configureSubmitButton];
}

- (void)configureDescription {
    self.descriptionLabel.text = [@"RESET_PASSWORD_DESCRIPTION" ggp_toLocalized];
    self.descriptionLabel.font = [UIFont ggp_regularWithSize:16];
}

- (void)configureEmailField {
    self.emailField = [GGPFormField new];
    [self ggp_configureAndAddFormField:self.emailField withPlaceholder:[@"RESET_PASSWORD_EMAIL_PLACEHOLDER" ggp_toLocalized] andErrorMessage:[@"FORM_FIELD_EMPTY_EMAIL_ERROR" ggp_toLocalized] toContainer:self.emailContainer];
}

- (void)configureSubmitButton {
    [self.submitButton ggp_styleAsDarkActionButton];
    [self.submitButton setTitle:[@"RESET_PASSWORD_SUBMIT" ggp_toLocalized] forState:UIControlStateNormal];
}

- (void)configureNavigationBar {
    [self.navigationController ggp_configureWithLightText];
    self.navigationController.navigationBar.barTintColor = [UIColor ggp_modalHeaderColor];
}

- (void)styleControls {
    self.view.backgroundColor = [UIColor ggp_extraLightGray];
}

#pragma mark - IB Actions

- (IBAction)submitButtonTapped:(id)sender {
    [self.emailField validateEmail];
    
    if (self.emailField.isValid) {
        [GGPSpinner showForView:self.view];
        
        [GGPAccount resetPasswordForEmail:self.emailField.text withCompletion:^(NSError *error) {
            [GGPSpinner hideForView:self.view];
            
            if (!error) {
                [self ggp_displayAlertWithTitle:[@"RESET_PASSWORD_EMAIL_SENT_ALERT_TITLE" ggp_toLocalized] message:[@"RESET_PASSWORD_EMAIL_SENT_ALERT_MESSAGE" ggp_toLocalized] actionTitle:[@"RESET_PASSWORD_ACTION_OK" ggp_toLocalized] andCompletion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } else if (error.code == GGPAccountEmailDoesNotExistErrorCode) {
                [self ggp_displayAlertWithTitle:nil andMessage:[@"RESET_PASSWORD_NO_EMAIL_ERROR" ggp_toLocalized]];
            } else {
                [self ggp_displayAlertWithTitle:nil andMessage:[@"ALERT_GENERIC_ERROR_MESSAGE" ggp_toLocalized]];
            }
        }];
    }
}

@end
