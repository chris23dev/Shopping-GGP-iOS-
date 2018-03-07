//
//  GGPUserInformationViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAccountInfoViewController.h"
#import "GGPBackButton.h"
#import "GGPEmailVerificationClient.h"
#import "GGPFormField.h"
#import "GGPFormFieldDelegate.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPUser.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static CGFloat const kDefaultGenderRow = 0;

@interface GGPAccountInfoViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, GGPFormFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *firstNameContainer;
@property (weak, nonatomic) IBOutlet UIView *lastNameContainer;
@property (weak, nonatomic) IBOutlet UIView *emailContainer;
@property (weak, nonatomic) IBOutlet UILabel *emailDisclaimerLabel;
@property (weak, nonatomic) IBOutlet UIView *genderContainer;
@property (weak, nonatomic) IBOutlet UIView *birthdayContainer;
@property (weak, nonatomic) IBOutlet UIView *zipCodeContainer;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@property (weak, nonatomic) IBOutlet UILabel *socialDisclaimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *deleteAccountHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *deleteAccountBodyLabel;

@property (strong, nonatomic) GGPFormField *firstNameField;
@property (strong, nonatomic) GGPFormField *lastNameField;
@property (strong, nonatomic) GGPFormField *emailField;
@property (strong, nonatomic) GGPFormField *genderField;
@property (strong, nonatomic) GGPFormField *birthdateField;
@property (strong, nonatomic) GGPFormField *zipCodeField;

@property (strong, nonatomic) NSArray *genders;
@property (strong, nonatomic) UIPickerView *genderPickerView;
@property (strong, nonatomic) UIDatePicker *birthdatePicker;
@property (assign, nonatomic) BOOL userHasChanges;

@end

@implementation GGPAccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    [self configureDisclaimersForLoginProvider];
    [self updateTextFieldsForUser:[GGPAccount shared].currentUser];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self configureNavigationBar];
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenMyInformation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)configureControls {
    self.title = [@"USER_INFO_TITLE" ggp_toLocalized];
    self.view.backgroundColor = [UIColor ggp_lightGray];
    self.containerView.backgroundColor = [UIColor ggp_lightGray];
    [self configureFormFields];
    [self configureSocialDisclaimerLabel];
    [self configureDeleteAccountLabel];
}

- (void)configureNavigationBar {
    __weak typeof(self) weakSelf = self;
    [self.navigationController ggp_configureWithDarkText];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[GGPBackButton alloc] initWithTapHandler:^{
        [weakSelf ggp_accountBackButtonPressedForState:self.userHasChanges];
    }];
}

- (void)configureFormFields {
    [self configureFirstNameField];
    [self configureLastNameField];
    [self configureEmailField];
    [self configureGenderField];
    [self configureBirthdateField];
    [self configureZipCodeField];
}

- (void)configureFirstNameField {
    self.firstNameField = [GGPFormField new];
    self.firstNameField.textField.delegate = self;
    [self ggp_configureAndAddFormField:self.firstNameField withPlaceholder:[@"USER_INFO_FIRST_NAME_PLACEHOLDER" ggp_toLocalized] andErrorMessage:[@"REGISTER_FIRST_NAME_ERROR" ggp_toLocalized] toContainer:self.firstNameContainer];
}

- (void)configureLastNameField {
    self.lastNameField = [GGPFormField new];
    self.lastNameField.textField.delegate = self;
    [self ggp_configureAndAddFormField:self.lastNameField withPlaceholder:[@"USER_INFO_LAST_NAME_PLACEHOLDER" ggp_toLocalized] andErrorMessage:[@"REGISTER_LAST_NAME_ERROR" ggp_toLocalized] toContainer:self.lastNameContainer];
}

- (void)configureEmailDisclaimerLabel {
    self.emailDisclaimerLabel.numberOfLines = 0;
    self.emailDisclaimerLabel.font = [UIFont ggp_regularWithSize:11];
    self.emailDisclaimerLabel.textColor = [UIColor ggp_darkGray];
    self.emailDisclaimerLabel.text = [@"USER_INFO_ACCOUNT_DISCLAIMER_LABEL" ggp_toLocalized];
    [self.emailDisclaimerLabel sizeToFit];
}

- (void)configureEmailField {
    [self configureEmailDisclaimerLabel];
    self.emailField = [GGPFormField new];
    self.emailField.textField.delegate = self;
    [self ggp_configureAndAddFormField:self.emailField withPlaceholder:[@"USER_INFO_EMAIL_PLACEHOLDER" ggp_toLocalized] andErrorMessage:[@"EMAIL_LOGIN_EMPTY_EMAIL_ERROR" ggp_toLocalized] toContainer:self.emailContainer];
}

- (void)configureGenderPicker {
    self.genders = @[ [@"USER_INFO_GENDER_DEFAULT" ggp_toLocalized],
                      [@"USER_INFO_GENDER_FEMALE" ggp_toLocalized],
                      [@"USER_INFO_GENDER_MALE" ggp_toLocalized],
                      [@"USER_INFO_GENDER_UNSPECIFIED" ggp_toLocalized] ];
    self.genderPickerView = [UIPickerView new];
    self.genderPickerView.dataSource = self;
    self.genderPickerView.delegate = self;
}

- (void)configureGenderField {
    [self configureGenderPicker];
    self.genderField = [GGPFormField new];
    self.genderField.formFieldDelegate = self;
    self.genderField.textField.delegate = self;
    self.genderField.textField.inputView = self.genderPickerView;
    self.genderField.textField.inputAccessoryView = [self.genderField toolbarForFormFieldWithClearButton:NO];
    self.genderField.textField.rightViewMode = UITextFieldViewModeAlways;
    [self ggp_configureAndAddFormField:self.genderField withPlaceholder:[@"USER_INFO_GENDER_PLACEHOLDER" ggp_toLocalized] andErrorMessage:@"" toContainer:self.genderContainer];
}

- (void)configureDatePicker {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [NSDateComponents new];
    NSDate *today = [NSDate new];
    [components setYear:-100];
    self.birthdatePicker = [UIDatePicker new];
    self.birthdatePicker.minimumDate = [gregorian dateByAddingComponents:components toDate:today  options:0];
    self.birthdatePicker.maximumDate = today;
    [self.birthdatePicker addTarget:self action:@selector(updateBirthDate) forControlEvents:UIControlEventValueChanged];
    if ([GGPAccount shared].currentUser.birthYear > 0) {
        [self.birthdatePicker setDate:[GGPAccount shared].currentUser.birthdate];
    }
}

- (void)configureBirthdateField {
    [self configureDatePicker];
    self.birthdateField = [GGPFormField new];
    self.birthdatePicker.datePickerMode = UIDatePickerModeDate;
    self.birthdateField.formFieldDelegate = self;
    self.birthdateField.textField.delegate = self;
    self.birthdateField.textField.inputView = self.birthdatePicker;
    self.birthdateField.textField.inputAccessoryView = [self.birthdateField toolbarForFormFieldWithClearButton:YES];
    self.birthdateField.textField.rightViewMode = UITextFieldViewModeAlways;
    [self ggp_configureAndAddFormField:self.birthdateField withPlaceholder:[@"USER_INFO_BIRTHDAY_PLACEHOLDER" ggp_toLocalized] andErrorMessage:@"" toContainer:self.birthdayContainer];
}

- (void)configureZipCodeField {
    self.zipCodeField = [GGPFormField new];
    self.zipCodeField.textField.delegate = self;
    self.zipCodeField.textField.inputAccessoryView = [self.zipCodeField toolbarForFormField];
    self.zipCodeField.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self ggp_configureAndAddFormField:self.zipCodeField withPlaceholder:[@"USER_INFO_ZIPCODE_PLACEHOLDER" ggp_toLocalized] andErrorMessage:[@"USER_INFO_ZIPCODE_INVALID" ggp_toLocalized] toContainer:self.zipCodeContainer];
}

- (void)configureSocialDisclaimerLabel {
    self.socialDisclaimerLabel.numberOfLines = 0;
    self.socialDisclaimerLabel.font = [UIFont ggp_regularWithSize:14];
    self.socialDisclaimerLabel.textColor = [UIColor ggp_darkGray];
    self.socialDisclaimerLabel.text = [@"USER_INFO_DISCLAIMER_LABEL" ggp_toLocalized];
    [self.socialDisclaimerLabel sizeToFit];
    self.seperatorView.backgroundColor = [UIColor ggp_darkGray];
}

- (void)configureDeleteAccountLabel {
    self.deleteAccountHeadingLabel.font = [UIFont ggp_regularWithSize:20];
    self.deleteAccountHeadingLabel.textColor = [UIColor blackColor];
    self.deleteAccountHeadingLabel.text = [@"USER_INFO_DELETE_ACCOUNT_HEADING" ggp_toLocalized];
    
    self.deleteAccountBodyLabel.numberOfLines = 0;
    self.deleteAccountBodyLabel.font = [UIFont ggp_regularWithSize:14];
    self.deleteAccountBodyLabel.textColor = [UIColor ggp_darkGray];
    self.deleteAccountBodyLabel.text = [NSString stringWithFormat:[@"USER_INFO_DELETE_ACCOUNT_BODY" ggp_toLocalized], [GGPMallManager shared].selectedMall.name];
}

- (void)configureDisclaimersForLoginProvider {
    if ([GGPAccount shared].currentUser.isSocialLogin) {
        [self.emailDisclaimerLabel ggp_collapseVertically];
    } else {
       [self.socialDisclaimerLabel ggp_collapseVertically];
    }
}

- (void)updateTextFieldsForUser:(GGPUser *)user {
    self.firstNameField.text = user.firstName;
    self.lastNameField.text = user.lastName;
    self.genderField.text = user.genderForDisplay;
    self.birthdateField.text = user.birthDateForDisplay;
    self.emailField.text = user.email;
    self.zipCodeField.text = user.zipCode;
}

- (void)setUserHasChanges:(BOOL)userHasChanges {
    _userHasChanges = userHasChanges;
    if (self.userHasChanges) {
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped)];
        self.navigationItem.rightBarButtonItem = saveButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - GGPFormField Delegate

- (void)clearButtonTappedForFormField:(GGPFormField *)formField {
    formField.text = @"";
    self.userHasChanges = YES;
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.userHasChanges = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.genders.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [UILabel new];
        label.font = [UIFont ggp_regularWithSize:16];
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.text = self.genders[row];
    return label;
}

#pragma mark - GenderPicker update

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *chosenGender = row == kDefaultGenderRow ? @"" : self.genders[row];
    self.genderField.text = chosenGender;
    self.userHasChanges = YES;
}

#pragma mark - DatePicker update

- (void)updateBirthDate {
    self.birthdateField.text = [self.birthdatePicker.date ggp_formatUserBirthday];
    self.userHasChanges = YES;
}

#pragma mark - Save user

- (GGPUser *)updatedUserFromFormValues {
    GGPUser *updatedUser = [GGPUser new];
    updatedUser.firstName = self.firstNameField.text;
    updatedUser.lastName = self.lastNameField.text;
    updatedUser.email = self.emailField.text;
    updatedUser.gender = self.genderField.text;
    updatedUser.birthdate = self.birthdateField.text.length ? self.birthdatePicker.date : nil;
    updatedUser.zipCode = self.zipCodeField.text;
    return updatedUser;
}

- (void)saveButtonTapped {
    [self.firstNameField validateName];
    [self.lastNameField validateName];
    [self.emailField validateEmail];
    [self.zipCodeField validateZipCode];
    
    BOOL isValid =  self.firstNameField.isValid &&
                    self.lastNameField.isValid &&
                    self.emailField.isValid &&
                    self.zipCodeField.isValid;

    if (isValid) {
        if ([self emailHasChanged]) {
            [self checkEmailAvailable];
        } else {
            [self saveUpdatedUser];
        }
    }
}

- (BOOL)emailHasChanged {
    return ![[GGPAccount shared].currentUser.email isEqualToString:self.emailField.text];
}

- (void)checkEmailAvailable {
    [GGPAccount checkEmailAvailability:self.emailField.text withCompletion:^(NSError *error, BOOL emailAvailable) {
        if (!error && emailAvailable) {
            [self verifyEmail:self.emailField.text];
        } else if (!error && !emailAvailable) {
            [self ggp_displayAlertWithTitle:nil andMessage:[@"USER_INFO_EMAIL_EXISTS_ERROR" ggp_toLocalized]];
        } else {
            [self ggp_displayAlertWithTitle:nil andMessage:[@"ALERT_GENERIC_ERROR_MESSAGE" ggp_toLocalized]];
        }
    }];
}

- (void)verifyEmail:(NSString *)email {
    [[GGPEmailVerificationClient shared] verifyEmail:email withCompletion:^(BOOL isValidEmail) {
        if (isValidEmail) {
            [self saveUpdatedUser];
        } else {
            [self ggp_displayAlertWithTitle:nil andMessage:[@"ALERT_ENTER_VALID_EMAIL" ggp_toLocalized]];
        }
    }];
}

- (void)saveUpdatedUser {
    self.userHasChanges = NO;
    GGPUser *updatedUser = [self updatedUserFromFormValues];
    NSDictionary *params = [updatedUser userProfileDictionary];
    
    [GGPAccount updateAccountInfoWithParameters:params shouldRemoveLoginId:![GGPAccount shared].currentUser.isSocialLogin andCompletion:^(NSError *error) {
        if (!error) {
            [[GGPAnalytics shared] trackAction:GGPAnalyticsActionAccountChangePersonalInfo withData:nil];
            [self ggp_displayAlertWithTitle:nil andMessage:[@"USER_INFO_UPDATE_SUCCESS" ggp_toLocalized]];
        } else {
            self.userHasChanges = YES;
            [self ggp_displayAlertWithTitle:nil message:[@"ALERT_GENERIC_ERROR_MESSAGE" ggp_toLocalized] actionTitle:[@"ALERT_OK" ggp_toLocalized] andCompletion:nil];
            GGPLogError(@"fail: %@", error);
        }
    }];
}

@end
