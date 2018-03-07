//
//  GGPRegisterPreferencesViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAuthenticationController.h"
#import "GGPCheckboxButton.h"
#import "GGPFeedbackManager.h"
#import "GGPFormField.h"
#import "GGPLoginViewController.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMallRepository.h"
#import "GGPModalViewController.h"
#import "GGPNavigationController.h"
#import "GGPPreferencesToggleViewController.h"
#import "GGPRegisterPreferencesViewController.h"
#import "GGPSpinner.h"
#import "GGPSweepstakesClient.h"
#import "GGPUser.h"
#import "GGPWebViewController.h"
#import "NSAttributedString+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <MessageUI/MessageUI.h>

@interface GGPRegisterPreferencesViewController () <UITextFieldDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *toggleContainer;
@property (weak, nonatomic) IBOutlet UIView *termsRow;
@property (weak, nonatomic) IBOutlet GGPCheckboxButton *termsButton;
@property (weak, nonatomic) IBOutlet UITextView *termsTextView;
@property (weak, nonatomic) IBOutlet UILabel *termsErrorLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *sweepstakesRow;
@property (weak, nonatomic) IBOutlet UITextView *sweepstakesTextView;
@property (weak, nonatomic) IBOutlet GGPCheckboxButton *sweepstakesCheckbox;
@property (weak, nonatomic) IBOutlet UITextView *emailSupportTextView;

@property (strong, nonatomic) GGPPreferencesToggleViewController *toggleViewController;
@property (assign, nonatomic) BOOL isValid;
@property (strong, nonatomic) GGPUser *user;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *registrationToken;
@property (strong, nonatomic) NSString *provider;

@end

@implementation GGPRegisterPreferencesViewController

- (instancetype)init {
    return [super initWithNibName:@"GGPRegisterPreferencesViewController" bundle:nil];
}

- (instancetype)initWithUser:(GGPUser *)user andPassword:(NSString *)password {
    self = [self init];
    if (self) {
        self.user = user;
        self.password = password;
    }
    return self;
}

- (instancetype)initWithUser:(GGPUser *)user provider:(NSString *)provider andRegistrationToken:(NSString *)registrationToken {
    self = [self init];
    if (self) {
        self.user = user;
        self.registrationToken = registrationToken;
        self.provider = provider;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchSweepstakes];
    [self configureControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenAccount];
}

- (void)fetchSweepstakes {
    [GGPMallRepository fetchSweepstakesWithCompletion:^(GGPSweepstakes *sweepstakes) {
        if (sweepstakes) {
            [self configureSweepstakesRow];
        } else {
            [self.sweepstakesRow ggp_collapseVertically];
        }
    }];
}

- (void)configureNavigationBar {
    [self.navigationController ggp_configureWithDarkText];
    self.navigationController.navigationBar.barTintColor = [UIColor ggp_lightGray];
}

- (void)configureControls {
    self.title = [@"REGISTER_TITLE" ggp_toLocalized];
    
    [self configureToggleViewController];
    [self configureTermsButtonAndLabel];
    [self configureTermsErrorLabel];
    [self configureDoneButton];
    [self configureEmailSupportTextView];
    
    [self styleControls];
}

- (void)styleControls {
    self.view.backgroundColor = [UIColor ggp_extraLightGray];
    self.containerView.backgroundColor = [UIColor ggp_extraLightGray];
    self.termsTextView.attributedText = [NSAttributedString ggp_generateTermsAttributedStringWithColor:[UIColor ggp_darkGray]];
    self.emailSupportTextView.attributedText = [NSAttributedString ggp_generateEmailSupportAttributedStringWithColor:[UIColor ggp_darkGray]];
}

- (void)configureToggleViewController {
    self.toggleContainer.backgroundColor = [UIColor clearColor];
    self.toggleViewController = [GGPPreferencesToggleViewController new];
    [self ggp_addChildViewController:self.toggleViewController toPlaceholderView:self.toggleContainer];
    [self configureDefaultToggleState];
}

- (void)configureDefaultToggleState {
    self.toggleViewController.smsCheckbox.selected = YES;
    [self.toggleViewController configureSMSFieldForState:YES];
    self.toggleViewController.emailCheckbox.selected = YES;
}

- (void)configureTermsButtonAndLabel {
    self.termsTextView.delegate = self;
    self.termsTextView.editable = NO;
    self.termsTextView.scrollEnabled = NO;
    self.termsTextView.textContainer.lineFragmentPadding = 0;
    self.termsTextView.textContainerInset = UIEdgeInsetsZero;
    self.termsTextView.backgroundColor = [UIColor clearColor];
    self.termsTextView.linkTextAttributes = @{ NSForegroundColorAttributeName:[UIColor ggp_blue],
                                               NSFontAttributeName:[UIFont ggp_regularWithSize:14] };
}

- (void)configureTermsErrorLabel {
    self.termsErrorLabel.font = [UIFont ggp_mediumWithSize:11];
    self.termsErrorLabel.textColor = [UIColor redColor];
    self.termsErrorLabel.text = [@"REGISTER_PREFERENCES_CONSENT_ERROR" ggp_toLocalized];
    self.termsErrorLabel.numberOfLines = 0;
    [self.termsErrorLabel sizeToFit];
    [self.termsErrorLabel ggp_collapseVertically];
}

- (void)configureSweepstakesRow {
    self.sweepstakesTextView.delegate = self;
    self.sweepstakesTextView.editable = NO;
    self.sweepstakesTextView.scrollEnabled = NO;
    self.sweepstakesTextView.textContainer.lineFragmentPadding = 0;
    self.sweepstakesTextView.textContainerInset = UIEdgeInsetsZero;
    self.sweepstakesTextView.backgroundColor = [UIColor clearColor];
    self.sweepstakesTextView.linkTextAttributes = @{ NSForegroundColorAttributeName:[UIColor ggp_blue],
                                                     NSFontAttributeName:[UIFont ggp_regularWithSize:14] };
    self.sweepstakesTextView.attributedText = [NSAttributedString ggp_generateSweepstakesAttributedStringWithColor:[self sweepstakesTextColor]];
}

- (UIColor *)sweepstakesTextColor {
    return [UIColor ggp_darkGray];
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

- (void)validateTerms {
    if (self.termsButton.isSelected) {
        [self.termsErrorLabel ggp_collapseVertically];
    } else {
        [self.termsErrorLabel ggp_expandVertically];
    }
}

- (void)configureDoneButton {
    [self.doneButton ggp_styleAsDarkActionButton];
    [self.doneButton setTitle:[@"REGISTER_PREFERENCES_DONE" ggp_toLocalized] forState:UIControlStateNormal];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if (textView == self.emailSupportTextView) {
        [self presentEmailComposeController];
        return NO;
    }
    
    GGPWebViewController *webViewController;
    
    if (textView == self.sweepstakesTextView) {
        webViewController = [[GGPWebViewController alloc] initWithTitle:[@"REGISTER_SWEEPSTAKES_TERMS" ggp_toLocalized] urlString:[@"REGISTER_SWEEPSTAKES_TERMS_LINK" ggp_toLocalized] andAnalyticsConst:GGPAnalyticsScreenPrivacy];
    } else {
        webViewController = [[GGPWebViewController alloc] initWithTitle:[@"PRIVACY_TERMS_TITLE" ggp_toLocalized] urlString:[@"PRIVACY_POLICY_URL" ggp_toLocalized] andAnalyticsConst:GGPAnalyticsScreenPrivacy];
    }
    
    [self.navigationController presentViewController:[[GGPModalViewController alloc] initWithRootViewController:webViewController andOnClose:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }] animated:YES completion:nil];
    
    return NO;
}

#pragma mark - Done button tapped

- (IBAction)doneButtonTapped:(id)sender {
    [self validateTerms];
    [self.toggleViewController.smsField
     validatePhoneNumberForSelectedState:self.toggleViewController.smsCheckbox.isSelected];
    
    BOOL isValid = self.toggleViewController.smsField.isValid && self.termsButton.isSelected;
    
    if (isValid) {
        [GGPSpinner showForView:self.view];
        [self updateUser];
        
        if (self.provider) {
            [self registerSocialUser];
        } else {
            [self registerSiteUser];
        }
    }
}

- (void)updateUser {
    self.user.isEmailSubscribed = self.toggleViewController.emailCheckbox.isSelected;
    self.user.isSmsSubscribed = self.toggleViewController.smsCheckbox.isSelected;
    self.user.mobilePhone = self.user.isSmsSubscribed ? self.toggleViewController.smsField.text : @"";
    self.user.agreedToTerms = YES;
    
    GGPMall *currentMall = [GGPMallManager shared].selectedMall;
    self.user.originMallId = [NSString stringWithFormat:@"%ld", (long)currentMall.mallId];
    self.user.originMallName = currentMall.name;
}

- (void)onRegisterComplete:(NSError *)error {
    if (!error) {
        if (self.sweepstakesCheckbox.isSelected) {
            [self enterSweepstakes];
        } else {
            [self displayRegisterConfirmationAlert];
        }
    } else {
        [self ggp_displayAlertWithTitle:nil andMessage:[@"ALERT_GENERIC_ERROR_MESSAGE" ggp_toLocalized]];
    }
}

- (void)enterSweepstakes {
    [[GGPSweepstakesClient sharedInstance] postSweepstakesEntryForUser:self.user withCompletion:^(NSError *error) {
        [self onSweepstakesRegisterComplete:error];
    }];
}

- (void)onSweepstakesRegisterComplete:(NSError *)error {
    if (!error) {
        [self displaySweepstakesConfirmationAlert];
    } else {
        [self displayRegisterConfirmationAlert];
    }
}

- (void)displayRegisterConfirmationAlert {
    [GGPSpinner hideForView:self.view];
    [self ggp_displayAlertWithTitle:[NSString stringWithFormat:[@"REGISTER_CONFIRMATION_TITLE" ggp_toLocalized], self.user.firstName] message:[@"REGISTER_CONFIRMATION_MESSAGE" ggp_toLocalized] actionTitle:[@"REGISTER_CONFIRMATION_DONE" ggp_toLocalized] andCompletion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:GGPAuthenticationCompletedNotification object:nil];
        [GGPFeedbackManager trackAction];
    }];
}

- (void)displaySweepstakesConfirmationAlert {
    [GGPSpinner hideForView:self.view];
    [self ggp_displayAlertWithTitle:[NSString stringWithFormat:[@"REGISTER_SWEEPSTAKES_ALERT_TITLE" ggp_toLocalized], self.user.firstName] message:[@"REGISTER_SWEEPSTAKES_ALERT_CONFIRMATION" ggp_toLocalized] actionTitle:[@"REGISTER_SWEEPSTAKES_ALERT_CLOSE" ggp_toLocalized] andCompletion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:GGPAuthenticationCompletedNotification object:nil];
        [GGPFeedbackManager trackAction];
    }];
}

#pragma mark Site Registration

- (void)registerSiteUser {
    __weak typeof(self) weakSelf = self;
    [GGPAccount registerUser:self.user withPassword:self.password andCompletion:^(NSError *error) {
        if (!error) {
            [weakSelf trackSiteRegistration];
        }
        
        [weakSelf onRegisterComplete:error];
    }];
}

- (void)trackSiteRegistration {
    NSDictionary *contextDataLogin = @ { GGPAnalyticsContextDataAccountAuthType : GGPAnalyticsContextDataAuthTypeSite };
    NSDictionary *contextDataRegister = @{ GGPAnalyticsContextDataAccountAuthType : GGPAnalyticsContextDataAuthTypeSite,
                                           GGPAnalyticsContextDataAccountFormName : GGPAnalyticsContextDataAccountTypeSiteRegistration,
                                           GGPAnalyticsContextDataAccountLeadType : GGPAnalyticsContextDataAccountTypeSiteRegistration,
                                           GGPAnalyticsContextDataAccountLeadLevel : GGPAnalyticsContextDataLeadLevelTypeEmail,
                                           GGPAnalyticsContextDataAccountEmailOptIn: self.user.isEmailSubscribed ? @"true" : @"false",
                                           GGPAnalyticsContextDataAccountTextOptIn : self.user.isSmsSubscribed ? @"true" : @"false",
                                           GGPAnalyticsContextDataAccountSweepstakes : self.sweepstakesCheckbox.isSelected ? @"true" : @"false"
                                           };
    
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionLogin withData:contextDataLogin];
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionRegisterSubmit withData:contextDataRegister];
}

#pragma mark Social Registration

- (void)registerSocialUser {
    __weak typeof(self) weakSelf = self;
    [GGPAccount updateAccountInfoWithParameters:[GGPAccount dictionaryForUser:self.user andRegistrationToken:self.registrationToken] shouldRemoveLoginId:NO andCompletion:^(NSError *error) {
        if (!error) {
            [weakSelf finalizeSocialRegistration];
        } else {
            [GGPSpinner hideForView:self.view];
            [weakSelf ggp_displayAlertWithTitle:nil andMessage:[@"ALERT_GENERIC_ERROR_MESSAGE" ggp_toLocalized]];
            GGPLogError(@"fail: %@", error);
        }
    }];
}

- (void)finalizeSocialRegistration {
    __weak typeof(self) weakSelf = self;
    [GGPAccount finalizeRegistrationWithRegistrationToken:self.registrationToken andCompletion:^(NSError *error) {
        if (!error) {
            [weakSelf trackSocialRegistration];
        }
        [weakSelf onRegisterComplete:error];
    }];
}

- (void)trackSocialRegistration {
    NSString *providerDescription = @"";
    if ([self.provider isEqualToString:GGPAccountGoogleProvider]) {
        providerDescription = GGPAnalyticsContextDataAuthTypeGoogle;
    } else if ([self.provider isEqualToString:GGPAccountFacebookProvider]) {
        providerDescription = GGPAnalyticsContextDataAuthTypeFacebook;
    }
    
    NSDictionary *contextDataLogin = @ { GGPAnalyticsContextDataAccountAuthType : providerDescription };
    NSDictionary *contextDataRegister = @{ GGPAnalyticsContextDataAccountAuthType : providerDescription,
                                           GGPAnalyticsContextDataAccountFormName : GGPAnalyticsContextDataAccountTypeSiteRegistration,
                                           GGPAnalyticsContextDataAccountLeadType : GGPAnalyticsContextDataAccountTypeSiteRegistration,
                                           GGPAnalyticsContextDataAccountLeadLevel : GGPAnalyticsContextDataLeadLevelTypeEmail,
                                           GGPAnalyticsContextDataAccountEmailOptIn : self.user.isEmailSubscribed ? @"true" : @"false",
                                           GGPAnalyticsContextDataAccountTextOptIn : self.user.isSmsSubscribed ? @"true" : @"false" };
    
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionLogin withData:contextDataLogin];
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionRegisterSubmit withData:contextDataRegister];
}

#pragma mark MFMailComposeDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
