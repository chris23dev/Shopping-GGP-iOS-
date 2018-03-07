//
//  GGPFormField.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/7/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFormFieldDelegate.h"
#import <UIKit/UIKit.h>

@interface GGPFormField : UIView

@property (weak, nonatomic) id <GGPFormFieldDelegate> formFieldDelegate;

@property (strong, nonatomic, readonly) UITextField *textField;
@property (strong, nonatomic) NSString *errorMessage;
@property (strong, nonatomic) NSString *placeholder;
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) BOOL secureTextEntry;
@property (assign, nonatomic) BOOL useValidationImage;
@property (assign, nonatomic, readonly) BOOL isValid;

- (void)showError;
- (void)hideError;
- (void)validateEmail;
- (void)validateName;
- (UIToolbar *)toolbarForFormField;
- (UIToolbar *)toolbarForFormFieldWithClearButton:(BOOL)hasClearButton;
- (void)validateConfirmationPasswordWithPassword:(NSString *)password;
- (void)validatePasswordAndLength:(BOOL)checkForLEngth;
- (void)validatePhoneNumberForSelectedState:(BOOL)smsIsSelected;
- (void)validateZipCode;
- (void)clearField;

- (void)configureWithBackgroundColor:(UIColor *)backgroundColor andTintColor:(UIColor *)tintColor;

@end
