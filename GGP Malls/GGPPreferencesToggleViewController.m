//
//  GGPPreferencesToggleViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPCheckboxButton.h"
#import "GGPFormField.h"
#import "GGPPreferencesToggleViewController.h"
#import "GGPUser.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPPreferencesToggleViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *smsLabel;
@property (weak, nonatomic) IBOutlet UIView *smsContainer;
@property (weak, nonatomic) IBOutlet UILabel *smsDisclaimer;

@property (strong, nonatomic) GGPUser *user;
@property (strong, nonatomic) GGPFormField *smsField;
@property (assign, nonatomic) BOOL userHasChanges;

@end

@implementation GGPPreferencesToggleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [GGPAccount shared].currentUser;
    [self configureControls];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self configureSMSFieldForState:self.smsCheckbox.isSelected];
}

- (void)configureControls {
    self.view.backgroundColor = [UIColor clearColor];
    [self configureEmailToggle];
    [self configureSMSToggleAndField];
}

- (void)configureEmailToggle {
    self.emailCheckbox.selected = self.user.isEmailSubscribed;
    self.emailCheckbox.tapHandler = ^void() {
        self.userHasChanges = YES;
    };
    
    self.emailLabel.font = [UIFont ggp_regularWithSize:14];
    self.emailLabel.text = [@"PREFERENCES_TOGGLE_EMAIL_LABEL" ggp_toLocalized];
}

- (void)configureSMSToggleAndField {
    self.smsCheckbox.selected = self.user.isSmsSubscribed;
    self.smsCheckbox.tapHandler = ^void() {
        self.userHasChanges = YES;
        [self configureSMSFieldForState:self.smsCheckbox.isSelected];
    };
    
    self.smsLabel.font = [UIFont ggp_regularWithSize:14];
    self.smsLabel.text = [@"PREFERENCES_TOGGLE_SMS_LABEL" ggp_toLocalized];
    
    self.smsField = [GGPFormField new];
    self.smsField.textField.delegate = self;
    self.smsField.textField.keyboardType = UIKeyboardTypePhonePad;
    self.smsField.textField.inputAccessoryView = [self.smsField toolbarForFormField];
    self.smsField.text = self.user.mobilePhone;
    [self ggp_configureAndAddFormField:self.smsField withPlaceholder:[@"PREFERENCES_TOGGLE_SMS_PLACEHOLDER" ggp_toLocalized] andErrorMessage:[@"FORM_FIELD_PHONE_ERROR_EMPTY" ggp_toLocalized] toContainer:self.smsContainer];
    
    self.smsDisclaimer.font = [UIFont ggp_lightWithSize:10];
    self.smsDisclaimer.textColor = [UIColor ggp_darkGray];
    self.smsDisclaimer.text = [@"PREFERENCES_TOGGLE_SMS_DISCLAIMER" ggp_toLocalized];
    [self.smsDisclaimer sizeToFit];
}

- (void)configureSMSFieldForState:(BOOL)isOn {
    if (!isOn) {
        [self.smsContainer ggp_collapseVertically];
        [self.smsDisclaimer ggp_collapseVertically];
        [self.smsField.textField resignFirstResponder];
    } else {
        [self.smsContainer ggp_expandVertically];
        [self.smsDisclaimer ggp_expandVertically];
    }
}

- (void)setUserHasChanges:(BOOL)userHasChanges {
    _userHasChanges = userHasChanges;
    if (self.userHasChanges) {
        [self.toggleDelegate toggleValueChanged];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.userHasChanges = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
