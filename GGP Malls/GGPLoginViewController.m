//
//  GGPLoginViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 3/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAuthenticationController.h"
#import "GGPLoginViewController.h"
#import "GGPRegisterPreferencesViewController.h"
#import "GGPSiteLoginViewController.h"
#import "GGPRegisterInfoViewController.h"
#import "GGPSpinner.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"

static NSInteger kButtonRadius = 5;
static NSInteger kButtonFontSize = 18;

@interface GGPLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *facebookContainerTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *facebookContainer;
@property (weak, nonatomic) IBOutlet UIImageView *facebookImageView;
@property (weak, nonatomic) IBOutlet UILabel *facebookLabel;
@property (weak, nonatomic) IBOutlet UIView *googleContainer;
@property (weak, nonatomic) IBOutlet UIImageView *googleImageView;
@property (weak, nonatomic) IBOutlet UILabel *googleLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *googleButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;

@end

@implementation GGPLoginViewController

- (instancetype)init {
    return [self initWithNibName:@"GGPLoginViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"LOGIN_TITLE" ggp_toLocalized];
    [self configureControls];
    [self styleControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenAccount];
}

- (void)configureNavigationBar {
    [self.navigationController ggp_configureWithLightText];
    self.navigationController.navigationBar.barTintColor = [UIColor ggp_modalHeaderColor];
}

- (void)configureControls {
    [self configureSocialButtons];
    [self configureEmailButton];
}

- (void)configureSocialButtons {
    self.facebookContainer.backgroundColor = [UIColor ggp_facebookBackground];
    [self.facebookContainer ggp_addBorderRadius:kButtonRadius];
    self.facebookLabel.font = [UIFont ggp_boldWithSize:kButtonFontSize];
    self.facebookLabel.textColor = [UIColor whiteColor];
    self.facebookLabel.text = [@"LOGIN_FACEBOOK" ggp_toLocalized];
    self.facebookImageView.image = [UIImage imageNamed:@"ggp_white_facebook"];
    
    self.googleContainer.backgroundColor = [UIColor ggp_googleBackground];
    [self.googleContainer ggp_addBorderRadius:kButtonRadius];
    self.googleLabel.font = [UIFont ggp_boldWithSize:kButtonFontSize];
    self.googleLabel.textColor = [UIColor ggp_googleFontColor];
    self.googleLabel.text = [@"LOGIN_GOOGLE" ggp_toLocalized];
    self.googleImageView.image = [UIImage imageNamed:@"ggp_icon_google"];
}

- (void)configureEmailButton {
    [self.emailButton ggp_styleAsLightActionButton];
    [self.emailButton setTitle:[@"LOGIN_EMAIL" ggp_toLocalized] forState:UIControlStateNormal];
}

- (void)styleControls {
    self.view.backgroundColor = [UIColor ggp_extraLightGray];
}

- (IBAction)facebookTapped:(id)sender {
    [self loginWithProvider:GGPAccountFacebookProvider];
}

- (IBAction)googleTapped:(id)sender {
    [self loginWithProvider:GGPAccountGoogleProvider];
}

- (IBAction)emailTapped:(id)sender {
    [self.navigationController pushViewController:[GGPSiteLoginViewController new] animated:YES];
}

- (void)loginWithProvider:(NSString *)provider {
    [GGPSpinner showForView:self.view];
    [GGPAccount loginWithProvider:provider withPresenter:self onCompletion:^(GGPSocialInfo *socialInfo, NSString *registrationToken, NSError *error) {
        [GGPSpinner hideForView:self.view];
        if (error) {
            GGPLogError(@"Unable to login to %@: %@", provider, error);
        } else if (registrationToken) {
            GGPLogInfo(@"Successful login to %@, need to complete", provider);
            [self displayRegistrationWithSocialInfo:socialInfo provider:provider andRegistrationToken:registrationToken];
        }  else {
            GGPLogInfo(@"Successful login to %@, already registered", provider);
            [self trackLoginForProvider:provider];
            [self onSocialLoginComplete];
        }
    }];
}

- (void)displayRegistrationWithSocialInfo:(GGPSocialInfo *)socialInfo provider:(NSString *)provider andRegistrationToken:(NSString *)registrationToken {
    GGPRegisterInfoViewController *registerViewController = [[GGPRegisterInfoViewController alloc] initWithSocialInfo:socialInfo provider:provider andRegistrationToken:registrationToken];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)onSocialLoginComplete {
    [[NSNotificationCenter defaultCenter] postNotificationName:GGPAuthenticationCompletedNotification object:nil];
}

- (void)trackLoginForProvider:(NSString *)provider {
    NSString *providerDescription = @"";
    
    if ([provider isEqualToString:GGPAccountGoogleProvider]) {
        providerDescription = GGPAnalyticsContextDataAuthTypeGoogle;
    } else if ([provider isEqualToString:GGPAccountFacebookProvider]) {
        providerDescription = GGPAnalyticsContextDataAuthTypeFacebook;
    }

    NSDictionary *contextData = @ { GGPAnalyticsContextDataAccountAuthType : providerDescription };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionLogin withData:contextData];
}

@end
