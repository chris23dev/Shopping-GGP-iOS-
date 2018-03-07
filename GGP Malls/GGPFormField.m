//
//  GGPFormField.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/7/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFormField.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>

static NSInteger const kValidPasswordLength = 8;
static NSInteger const kValidZipCodeLength = 5;
static NSString *const kRFC2822RegEx = @"(?:[A-Za-z0-9!#$%\\&amp;'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&amp;'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[A-Za-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";

@interface GGPFormField ()

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *floatingLabelTextField;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainer;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *showHideButton;
@property (weak, nonatomic) IBOutlet UIImageView *passwordValidationImage;

@property (strong, nonatomic) UIColor *textFieldTextColor;
@property (strong, nonatomic) UIColor *floatingLabelTextColor;
@property (strong, nonatomic) UIColor *floatingLabelActiveTextColor;
@property (strong, nonatomic) UIColor *textFieldBorderColor;
@property (strong, nonatomic) UIColor *errorColor;

@property (assign, nonatomic) BOOL isValid;

@end

@implementation GGPFormField

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:@"GGPFormField" owner:self options:nil].firstObject;
    if (self) {
        self.textFieldTextColor = [UIColor blackColor];
        self.floatingLabelTextColor = [UIColor grayColor];
        self.floatingLabelActiveTextColor = [UIColor grayColor];
        self.textFieldBorderColor = [UIColor ggp_lightGray];
        self.errorColor = [UIColor redColor];
        [self configureControls];
    }
    return self;
}

- (void)configureControls {
    self.backgroundColor = [UIColor clearColor];
    [self configureTextFieldContainer];
    [self configureTextField];
    [self configureErrorLabel];
    [self configureShowHideButton];
    [self configureDefaultStyle];
}

- (void)configureTextFieldContainer {
    self.textFieldContainer.layer.cornerRadius = 4;
    self.textFieldContainer.layer.borderWidth = 1;
    self.textFieldContainer.backgroundColor = [UIColor whiteColor];
}

- (void)configureTextField {
    self.floatingLabelTextField.font = [UIFont ggp_regularWithSize:14];
    self.floatingLabelTextField.floatingLabelFont = [UIFont ggp_regularWithSize:10];
    self.floatingLabelTextField.backgroundColor = [UIColor clearColor];
    self.floatingLabelTextField.borderStyle = UITextBorderStyleNone;
    self.floatingLabelTextField.floatingLabelYPadding = 5;
    self.floatingLabelTextField.tintColor = [UIColor grayColor];
    self.floatingLabelTextField.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)configureWithBackgroundColor:(UIColor *)backgroundColor andTintColor:(UIColor *)tintColor {
    self.textFieldContainer.backgroundColor = backgroundColor;
    self.textFieldTextColor = tintColor;
    self.floatingLabelTextColor = tintColor;
    self.floatingLabelActiveTextColor = tintColor;
    self.textFieldBorderColor = tintColor;
    
    [self configureDefaultStyle];
}

- (void)configureErrorLabel {
    self.errorLabel.backgroundColor = [UIColor clearColor];
    self.errorLabel.font = [UIFont ggp_mediumWithSize:14];
    self.errorLabel.textColor = [UIColor ggp_red];
}

- (void)configureShowHideButton {
    self.showHideButton.hidden = YES;
    self.showHideButton.titleLabel.font = [UIFont ggp_mediumWithSize:12];
    [self.showHideButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.showHideButton setTitle:[@"FORM_FIELD_SHOW" ggp_toLocalized] forState:UIControlStateNormal];
}

- (void)configureDefaultStyle {
    self.errorLabel.textColor = [UIColor grayColor];
    self.floatingLabelTextField.textColor = self.textFieldTextColor;
    self.floatingLabelTextField.floatingLabelTextColor = self.floatingLabelTextColor;
    self.floatingLabelTextField.floatingLabelActiveTextColor = self.floatingLabelActiveTextColor;
    self.textFieldContainer.layer.borderColor = self.textFieldBorderColor.CGColor;
    
    [self configurePlaceholder];
    
    [self.floatingLabelTextField layoutSubviews];
}

- (void)configureErrorStyle {
    self.errorLabel.textColor = self.errorColor;
    self.floatingLabelTextField.textColor = self.errorColor;
    self.floatingLabelTextField.floatingLabelTextColor = self.errorColor;
    self.floatingLabelTextField.floatingLabelActiveTextColor = self.errorColor;
    self.textFieldContainer.layer.borderColor = self.errorColor.CGColor;
    
    [self.floatingLabelTextField layoutSubviews];
}

- (void)configurePlaceholder {
    if (!self.floatingLabelTextField.placeholder) {
        return;
    }
    
    NSDictionary *attributes = @{ NSForegroundColorAttributeName: self.textFieldTextColor,
                                  NSFontAttributeName: [UIFont ggp_regularWithSize:16] };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.floatingLabelTextField.placeholder attributes:attributes];
    
    self.floatingLabelTextField.attributedPlaceholder = attributedString;
}

- (void)setErrorMessage:(NSString *)errorMessage {
    _errorMessage = errorMessage;
    self.errorLabel.text = errorMessage;
    [self.errorLabel sizeToFit];
    [self.errorLabel ggp_collapseVertically];
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.floatingLabelTextField.placeholder = placeholder;
}

- (NSString *)text {
    return self.floatingLabelTextField.text;
}

- (UITextField *)textField {
    return self.floatingLabelTextField;
}

- (void)setText:(NSString *)text {
    self.floatingLabelTextField.text = text;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    _secureTextEntry = secureTextEntry;
    self.showHideButton.hidden = NO;
    
    __weak typeof(self) weakSelf = self;
    [UIView performWithoutAnimation:^{
        
        BOOL resumeResponder = NO;
        if ([weakSelf.floatingLabelTextField isFirstResponder]) {
            resumeResponder = YES;
            [weakSelf.floatingLabelTextField resignFirstResponder];
        }
        
        [weakSelf.floatingLabelTextField setSecureTextEntry:secureTextEntry];
        
        if (resumeResponder) {
            [weakSelf.floatingLabelTextField becomeFirstResponder];
        }
    }];
}

- (UIToolbar *)toolbarForFormField {
    return [self toolbarForFormFieldWithClearButton:NO];
}

- (UIToolbar *)toolbarForFormFieldWithClearButton:(BOOL)hasClearButton {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 37)];
    NSMutableArray *items = [NSMutableArray new];
    
    if (hasClearButton) {
        UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:[@"FORM_FIELD_TOOLBAR_CLEAR" ggp_toLocalized] style:UIBarButtonItemStylePlain target:self action:@selector(clearValueForField:)];
        [items addObject:clearButton];
    }
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [items addObject:flexibleSpace];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:[@"FORM_FIELD_TOOLBAR_DONE" ggp_toLocalized] style:UIBarButtonItemStyleDone target:self action:@selector(dismissPickerForField:)];
    [items addObject:doneButton];
    
    toolbar.items = items;
    return toolbar;
}

- (void)dismissPickerForField:(UIBarButtonItem *)sender {
    GGPFormField *formField = sender.target;
    [formField.textField resignFirstResponder];
}

- (void)clearValueForField:(UIBarButtonItem *)sender {
    GGPFormField *formField = sender.target;
    UITextField *textField = formField.textField;
    if (formField.text.length) {
        [self.formFieldDelegate clearButtonTappedForFormField:formField];
        [textField resignFirstResponder];
    }
}

- (void)setUseValidationImage:(BOOL)useValidationImage {
    _useValidationImage = useValidationImage;
    [self.errorLabel ggp_expandVertically];
    self.errorLabel.textColor = [UIColor grayColor];
    [self.floatingLabelTextField addTarget:self action:@selector(passwordFieldDidChange) forControlEvents:UIControlEventEditingChanged];
}

- (void)passwordFieldDidChange {
    if (self.floatingLabelTextField.text.length >= kValidPasswordLength) {
        self.passwordValidationImage.image = [UIImage imageNamed:@"ggp_icon_password_valid"];
        [self configureDefaultStyle];
    } else if (self.floatingLabelTextField.text.length > 0){
        self.passwordValidationImage.image = [UIImage imageNamed:@"ggp_icon_password_invalid"];
    } else {
        self.passwordValidationImage.image = nil;
    }
}

- (void)clearField {
    self.text = nil;
    self.passwordValidationImage.image = nil;
}

#pragma mark - Error handling

- (void)showError {
    [self.errorLabel ggp_expandVertically];
    [self configureErrorStyle];
}

- (void)hideError {
    [self.errorLabel ggp_collapseVertically];
    [self configureDefaultStyle];
}

- (void)updateErrorLabelForValidity:(BOOL)isValid {
    if (isValid && self.useValidationImage) {
        [self configureDefaultStyle];
        self.errorLabel.textColor = [UIColor grayColor];
    } else if (isValid) {
        [self hideError];
    } else {
        [self showError];
    }
}

#pragma mark - Validations

- (void)validateEmail {
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kRFC2822RegEx];
    self.isValid = [regExPredicate evaluateWithObject:self.text];
    
    if (!self.text.length) {
        self.errorMessage = [@"FORM_FIELD_EMPTY_EMAIL_ERROR" ggp_toLocalized];
    } else if (!self.isValid) {
        self.errorMessage = [@"FORM_FIELD_INVALID_EMAIL_ERROR" ggp_toLocalized];
    }
    
    [self updateErrorLabelForValidity:self.isValid];
}

- (void)validateName {
    self.isValid = self.text.length;
    [self updateErrorLabelForValidity:self.isValid];
}

- (void)validatePasswordAndLength:(BOOL)checkForValidLength {
    self.isValid = YES;
    
    if (!self.text.length && !checkForValidLength) {
        self.isValid = NO;
        self.errorMessage = [@"FORM_FIELD_EMPTY_PASSWORD_ERROR" ggp_toLocalized];
    } else if (self.text.length < kValidPasswordLength && checkForValidLength) {
        self.isValid = NO;
        self.errorMessage = [@"FORM_FIELD_PASSWORD_LENGTH_INVALID_ERROR" ggp_toLocalized];
    }
    
    [self updateErrorLabelForValidity:self.isValid];
}

- (void)validateConfirmationPasswordWithPassword:(NSString *)password {
    [self validatePasswordAndLength:YES];
    self.isValid = self.isValid && [password isEqualToString:self.text];
    
    if (!self.text.length) {
        self.errorMessage = [@"FORM_FIELD_EMPTY_CONFIRM_PASSWORD_ERROR" ggp_toLocalized];
    } else if (![self.text isEqualToString:password]) {
        self.errorMessage = [@"FORM_FIELD_PASSWORD_MISMATCH_ERROR" ggp_toLocalized];
    }
    
    [self updateErrorLabelForValidity:self.isValid];
}

- (void)validatePhoneNumberForSelectedState:(BOOL)smsIsSelected {
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:nil];
    NSRange inputRange = NSMakeRange(0, [self.floatingLabelTextField.text length]);
    NSArray *matches = [detector matchesInString:self.floatingLabelTextField.text options:0 range:inputRange];
    
    self.isValid = NO;
    
    if (matches.count) {
        NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
        self.isValid = [result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length;
    }
    
    if (!self.text.length) {
        self.errorMessage = [@"FORM_FIELD_PHONE_ERROR_EMPTY" ggp_toLocalized];
    } else if (!self.isValid) {
        self.errorMessage = [@"FORM_FIELD_PHONE_ERROR_INVALID" ggp_toLocalized];
    }
    
    if (!smsIsSelected) {
        self.isValid = YES;
    }
    
    [self updateErrorLabelForValidity:self.isValid];
}

- (void)validateZipCode {
    self.isValid = !self.text.length || self.text.length == kValidZipCodeLength;
    
    if (!self.isValid) {
        self.errorMessage = [@"FORM_FIELD_ZIPCODE_INVALID" ggp_toLocalized];
    }
    
    [self updateErrorLabelForValidity:self.isValid];
}

#pragma mark - IBActions

- (IBAction)showHideButtonTapped:(id)sender {
    self.secureTextEntry = !self.floatingLabelTextField.isSecureTextEntry;
    NSString *title = self.floatingLabelTextField.isSecureTextEntry ? [@"FORM_FIELD_SHOW" ggp_toLocalized] : [@"FORM_FIELD_HIDE" ggp_toLocalized];
    [self.showHideButton setTitle:title forState:UIControlStateNormal];
}

@end
