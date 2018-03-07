//
//  GGPFormFieldTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFormField.h"
#import "GGPFormFieldDelegate.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>

@interface GGPFormFieldTests : XCTestCase

@property (strong, nonatomic) GGPFormField *formField;

@end

@interface GGPFormField (Testing)

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *floatingLabelTextField;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainer;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *showHideButton;

@property id<GGPFormFieldDelegate> formFieldDelegate;
@property BOOL isValid;

- (void)configureDefaultStyle;
- (void)configureErrorStyle;
- (void)validateEmail;
- (void)validateNameField;
- (void)validatePassword;
- (void)passwordFieldDidChange;
- (void)clearValueForField:(UIBarButtonItem *)sender;

- (IBAction)showHideButtonTapped:(id)sender;

@end

@implementation GGPFormFieldTests

- (void)setUp {
    [super setUp];
    self.formField = [GGPFormField new];
}

- (void)tearDown {
    self.formField = nil;
    [super tearDown];
}

- (void)testInitalization {
    XCTAssertNotNil(self.formField.textField);
    XCTAssertNotNil(self.formField.textFieldContainer);
    XCTAssertNotNil(self.formField.errorLabel);
    XCTAssertNotNil(self.formField.showHideButton);
}

- (void)testTextFieldPlaceholder {
    self.formField.placeholder = @"placeholder test";
    XCTAssertEqualObjects(self.formField.textField.placeholder, @"placeholder test");
}

- (void)testTextFieldText {
    self.formField.text = @"text test";
    XCTAssertEqualObjects(self.formField.textField.text, @"text test");
}

- (void)testErrorMessage {
    id mockErrorLabel = OCMPartialMock(self.formField.errorLabel);
    OCMExpect([mockErrorLabel ggp_collapseVertically]);
    
    self.formField.errorMessage = @"mock error";
    
    XCTAssertEqualObjects(self.formField.errorLabel.text, @"mock error");
    OCMVerifyAll(mockErrorLabel);
}

- (void)testShowError {
    id mockErrorLabel = OCMPartialMock(self.formField.errorLabel);
    OCMExpect([mockErrorLabel ggp_expandVertically]);
    
    id mockFormField = OCMPartialMock(self.formField);
    OCMExpect([mockFormField configureErrorStyle]);
    
    [self.formField showError];
    
    OCMVerifyAll(mockErrorLabel);
    OCMVerifyAll(mockFormField);
}

- (void)testHideError {
    id mockErrorLabel = OCMPartialMock(self.formField.errorLabel);
    OCMExpect([mockErrorLabel ggp_collapseVertically]);
    
    id mockFormField = OCMPartialMock(self.formField);
    OCMExpect([mockFormField configureDefaultStyle]);
    
    [self.formField hideError];
    
    OCMVerifyAll(mockErrorLabel);
    OCMVerifyAll(mockFormField);
}

- (void)testEmailIsValid {
    NSString *validEmail = @"test@test.com";
    self.formField.text = validEmail;
    [self.formField validateEmail];
    XCTAssertTrue(self.formField.isValid);
}

- (void)testEmailIsNotValid {
    NSString *invalidEmail = @"test.test.com";
    self.formField.text = invalidEmail;
    [self.formField validateEmail];
    XCTAssertFalse(self.formField.isValid);
    
    invalidEmail = @"";
    self.formField.text = invalidEmail;
    [self.formField validateEmail];
    XCTAssertFalse(self.formField.isValid);
}

- (void)testValidateEmailHasErrorEmpty {
    id mockField = OCMPartialMock(self.formField);
    OCMExpect([mockField showError]);
    
    self.formField.text = @"";
    [self.formField validateEmail];
    
    OCMVerifyAll(mockField);
    
    XCTAssertEqualObjects(self.formField.errorLabel.text, [@"FORM_FIELD_EMPTY_EMAIL_ERROR" ggp_toLocalized]);
}

- (void)testValidateEmailHasErrorInvalid {
    id mockField = OCMPartialMock(self.formField);
    OCMExpect([mockField showError]);
    
    self.formField.text = @"invalidemail";
    [self.formField validateEmail];
    
    OCMVerifyAll(mockField);
    XCTAssertEqualObjects(self.formField.errorLabel.text, [@"FORM_FIELD_INVALID_EMAIL_ERROR" ggp_toLocalized]);
}

- (void)testNameIsValid {
    NSString *validName = @"Goodname";
    self.formField.text = validName;
    [self.formField validateName];
    XCTAssertTrue(self.formField.isValid);
}

- (void)testNameIsNotValid {
    NSString *invalidName = @"";
    self.formField.text = invalidName;
    [self.formField validateName];
    XCTAssertFalse(self.formField.isValid);
}

- (void)testValidateValidPasswordLengthValid {
    NSString *validPassword = @"password";
    id mockField = OCMPartialMock(self.formField);
    OCMExpect([mockField hideError]);
    
    self.formField.text = validPassword;
    [self.formField validatePasswordAndLength:YES];
    
    OCMVerifyAll(mockField);
}


- (void)testValidatePasswordWithoutLengthValid {
    NSString *validPassword = @"pass";
    id mockField = OCMPartialMock(self.formField);
    OCMExpect([mockField hideError]);
    
    self.formField.text = validPassword;
    [self.formField validatePasswordAndLength:NO];
    
    OCMVerifyAll(mockField);
}

- (void)testValidateEmptyPasswordWithoutLengthInvalid {
    NSString *invalidPassword = @"";
    id mockField = OCMPartialMock(self.formField);
    OCMExpect([mockField showError]);
    
    self.formField.text = invalidPassword;
    [self.formField validatePasswordAndLength:NO];
    
    OCMVerifyAll(mockField);
    XCTAssertEqualObjects(self.formField.errorLabel.text, [@"FORM_FIELD_EMPTY_PASSWORD_ERROR" ggp_toLocalized]);
}

- (void)testValidateInvalidPasswordLengthHasError {
    NSString *invalidPassword = @"pass";
    id mockField = OCMPartialMock(self.formField);
    OCMExpect([mockField showError]);
    
    self.formField.text = invalidPassword;
    [self.formField validatePasswordAndLength:YES];
    
    OCMVerifyAll(mockField);
    XCTAssertEqualObjects(self.formField.errorLabel.text, [@"FORM_FIELD_PASSWORD_LENGTH_INVALID_ERROR" ggp_toLocalized]);
}

- (void)testValidateEmptyConfirmPasswordHasError {
    NSString *confirmPassword = @"";
    NSString *password = @"";
    id mockField = OCMPartialMock(self.formField);
    OCMExpect([mockField showError]);
    
    self.formField.text = confirmPassword;
    [self.formField validateConfirmationPasswordWithPassword:password];
    
    OCMVerifyAll(mockField);
    XCTAssertEqualObjects(self.formField.errorLabel.text, [@"FORM_FIELD_EMPTY_CONFIRM_PASSWORD_ERROR" ggp_toLocalized]);
}

- (void)testValidateInvalidConfirmPasswordMatchError {
    NSString *confirmPassword = @"password";
    NSString *password = @"passw0rd";
    id mockField = OCMPartialMock(self.formField);
    OCMExpect([mockField showError]);
    
    self.formField.text = confirmPassword;
    [self.formField validateConfirmationPasswordWithPassword:password];
    
    OCMVerifyAll(mockField);
    XCTAssertEqualObjects(self.formField.errorLabel.text, [@"FORM_FIELD_PASSWORD_MISMATCH_ERROR" ggp_toLocalized]);
}

- (void)testValidateValidConfirmationPassword {
    NSString *confirmPassword = @"password";
    NSString *password = @"password";
    id mockField = OCMPartialMock(self.formField);
    OCMExpect([mockField hideError]);
    
    self.formField.text = confirmPassword;
    [self.formField validateConfirmationPasswordWithPassword:password];
    
    OCMVerifyAll(mockField);
}

- (void)testShowHideButtonTappedWhenHidden {
    self.formField.textField.secureTextEntry = YES;
    
    [self.formField showHideButtonTapped:nil];
    
    XCTAssertFalse(self.formField.textField.secureTextEntry);
    XCTAssertEqualObjects(self.formField.showHideButton.currentTitle, [@"FORM_FIELD_HIDE" ggp_toLocalized]);
}

- (void)testShowHideButtonTappedWhenShown {
    self.formField.textField.secureTextEntry = NO;
    
    [self.formField showHideButtonTapped:nil];
    
    XCTAssertTrue(self.formField.textField.secureTextEntry);
    XCTAssertEqualObjects(self.formField.showHideButton.currentTitle, [@"FORM_FIELD_SHOW" ggp_toLocalized]);
}

- (void)testSetValidationImage {
    id mockErrorLabel = OCMPartialMock(self.formField.errorLabel);
    
    OCMExpect([mockErrorLabel ggp_expandVertically]);
    
    self.formField.useValidationImage = YES;
    
    XCTAssertTrue(self.formField.useValidationImage);
    XCTAssertEqualObjects(self.formField.errorLabel.textColor, [UIColor grayColor]);
    
    OCMVerifyAll(mockErrorLabel);
}

- (void)testValidatePhoneNumberIsValid {
    self.formField.text = @"2199399393";
    [self.formField validatePhoneNumberForSelectedState:YES];
    XCTAssertTrue(self.formField.isValid);
    
    self.formField.text = @"219 939 9393";
    [self.formField validatePhoneNumberForSelectedState:YES];
    XCTAssertTrue(self.formField.isValid);
    
    self.formField.text = @"219-939-9393";
    [self.formField validatePhoneNumberForSelectedState:YES];
    XCTAssertTrue(self.formField.isValid);
    
    self.formField.text = @"12199399393";
    [self.formField validatePhoneNumberForSelectedState:YES];
    XCTAssertTrue(self.formField.isValid);
}

- (void)testValidatePhoneNumberIsInvalid {
    self.formField.text = @"21999";
    [self.formField validatePhoneNumberForSelectedState:YES];
    XCTAssertFalse(self.formField.isValid);
    
    self.formField.text = @"abcabcabcd";
    [self.formField validatePhoneNumberForSelectedState:YES];
    XCTAssertFalse(self.formField.isValid);
    
    self.formField.text = @"2199399393a";
    [self.formField validatePhoneNumberForSelectedState:YES];
    XCTAssertFalse(self.formField.isValid);
}

- (void)testZipCodeIsValid {
    self.formField.text = @"12345";
    [self.formField validateZipCode];
    XCTAssertTrue(self.formField.isValid);
    
    self.formField.text = @"";
    [self.formField validateZipCode];
    XCTAssertTrue(self.formField.isValid);
}

- (void)testZipCodeIsInvalid {
    self.formField.text = @"1234";
    [self.formField validateZipCode];
    XCTAssertFalse(self.formField.isValid);
}

- (void)testConfigureToolbarWithoutClear {
    id mockFormField = OCMPartialMock([GGPFormField new]);
    OCMExpect([mockFormField toolbarForFormFieldWithClearButton:NO]);
    [mockFormField toolbarForFormField];
    OCMVerifyAll(mockFormField);
}

- (void)testClearFieldWithTextValue {
    id mockBarButtonItem = OCMClassMock([UIBarButtonItem class]);
    id mockFormFieldDelegate = OCMProtocolMock(@protocol(GGPFormFieldDelegate));
    GGPFormField *mockFormField = OCMPartialMock([GGPFormField new]);
    UITextField *mockTextField = OCMPartialMock([UITextField new]);
    
    [OCMStub([mockFormField formFieldDelegate]) andReturn:mockFormFieldDelegate];
    [OCMStub([mockFormField text]) andReturn:@"TEXT"];
    [OCMStub([mockFormField textField]) andReturn:mockTextField];
    [OCMStub([mockBarButtonItem target]) andReturn:mockFormField];
    
    OCMExpect([mockFormFieldDelegate clearButtonTappedForFormField:mockFormField]);
    
    [mockFormField clearValueForField:mockBarButtonItem];
    
    XCTAssertFalse(mockFormField.textField.text.length);
    OCMVerifyAll(mockFormFieldDelegate);
    
    [mockBarButtonItem stopMocking];
}

- (void)testClearFieldWithOutValue {
    id mockBarButtonItem = OCMClassMock([UIBarButtonItem class]);
    id mockFormFieldDelegate = OCMProtocolMock(@protocol(GGPFormFieldDelegate));
    GGPFormField *mockFormField = OCMPartialMock([GGPFormField new]);
    UITextField *mockTextField = OCMPartialMock([UITextField new]);
    
    [OCMStub([mockFormField formFieldDelegate]) andReturn:mockFormFieldDelegate];
    [OCMStub([mockFormField textField]) andReturn:mockTextField];
    [OCMStub([mockBarButtonItem target]) andReturn:mockFormField];
    
    [[mockFormFieldDelegate reject] clearButtonTappedForFormField:mockFormField];
    
    [mockFormField clearValueForField:mockBarButtonItem];
    
    OCMVerifyAll(mockFormFieldDelegate);
    
    [mockBarButtonItem stopMocking];
}

@end
