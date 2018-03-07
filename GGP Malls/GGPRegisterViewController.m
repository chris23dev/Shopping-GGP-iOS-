//
//  GGPRegisterViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/7/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAuthenticationController.h"
#import "GGPButton.h"
#import "GGPLoginViewController.h"
#import "GGPMallRepository.h"
#import "GGPModalViewController.h"
#import "GGPRegisterInfoViewController.h"
#import "GGPRegisterViewController.h"
#import "GGPSpinner.h"
#import "GGPSweepstakes.h"
#import "GGPWebViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"

static NSInteger const kButtonRadius = 5;
static NSInteger const kButtonFontSize = 18;

@interface GGPRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIView *facebookContainer;
@property (weak, nonatomic) IBOutlet UIImageView *facebookImageView;
@property (weak, nonatomic) IBOutlet UILabel *facebookLabel;
@property (weak, nonatomic) IBOutlet UIView *googleContainer;
@property (weak, nonatomic) IBOutlet UIImageView *googleImageView;
@property (weak, nonatomic) IBOutlet UILabel *googleLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *googleButton;
@property (weak, nonatomic) IBOutlet UIButton *emailRegisterButton;
@property (weak, nonatomic) IBOutlet UILabel *existingMemberLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *sweepstakesDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UILabel *termsLabel;

@end

@implementation GGPRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"REGISTER_TITLE" ggp_toLocalized];
    [self fetchSweepstakes];
    [self configureControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenRegister];
}

- (void)fetchSweepstakes {
    [GGPMallRepository fetchSweepstakesWithCompletion:^(GGPSweepstakes *sweepstakes) {
        if (sweepstakes) {
            [self configureSweepstakesInfo];
        } else {
            [self.sweepstakesDescriptionLabel ggp_collapseVertically];
            [self.viewLabel ggp_collapseVertically];
            [self.termsLabel ggp_collapseVertically];
        }
        
        [self configureControls];
    }];
}

- (void)configureControls {
    [self configureFacebookControl];
    [self configureGoogleControl];
    [self configureEmailControl];
    [self configureLoginControl];
    
    [self styleControls];
}

- (void)styleControls {
    self.view.backgroundColor = [UIColor ggp_extraLightGray];
    self.backgroundImageView.hidden = YES;
    
    [self.googleContainer ggp_addBorderWithWidth:1 andColor:[UIColor ggp_lightGray]];
    [self.emailRegisterButton ggp_addBorderWithWidth:1 andColor:[UIColor ggp_lightGray]];
    
    self.existingMemberLabel.textColor = [UIColor ggp_darkGray];
    self.sweepstakesDescriptionLabel.textColor = [UIColor ggp_darkGray];
    self.viewLabel.textColor = [UIColor ggp_darkGray];
}

- (void)configureNavigationBar {
    [self.navigationController ggp_configureWithLightText];
    self.navigationController.navigationBar.barTintColor = [UIColor ggp_modalHeaderColor];
}

- (void)configureFacebookControl {
    [self.facebookContainer ggp_addBorderRadius:kButtonRadius];
    self.facebookContainer.backgroundColor = [UIColor ggp_facebookBackground];
    self.facebookLabel.font = [UIFont ggp_boldWithSize:kButtonFontSize];
    self.facebookLabel.textColor = [UIColor whiteColor];
    self.facebookLabel.text = [@"REGISTER_FACEBOOK_BUTTON" ggp_toLocalized];
    self.facebookImageView.image = [UIImage imageNamed:@"ggp_white_facebook"];
}

- (void)configureGoogleControl {
    [self.googleContainer ggp_addBorderRadius:kButtonRadius];
    self.googleContainer.backgroundColor = [UIColor ggp_googleBackground];
    self.googleLabel.font = [UIFont ggp_boldWithSize:kButtonFontSize];
    self.googleLabel.textColor = [UIColor ggp_googleFontColor];
    self.googleLabel.text = [@"REGISTER_GOOGLE_BUTTON" ggp_toLocalized];
    self.googleImageView.image = [UIImage imageNamed:@"ggp_icon_google"];
}

- (void)configureEmailControl {
    [self.emailRegisterButton ggp_styleAsLightActionButton];
    [self.emailRegisterButton setTitle:[@"REGISTER_EMAIL_BUTTON" ggp_toLocalized] forState:UIControlStateNormal];
}

- (void)configureLoginControl {
    self.existingMemberLabel.text = [@"ACCOUNT_ALREADY_MEMBER" ggp_toLocalized];
    self.existingMemberLabel.font = [UIFont ggp_regularWithSize:15];
    
    self.loginLabel.text = [@"ACCOUNT_LOGIN" ggp_toLocalized];
    self.loginLabel.textColor = [UIColor ggp_blue];
    self.loginLabel.font = [UIFont ggp_boldWithSize:15];
    self.loginLabel.userInteractionEnabled = YES;
    [self.loginLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginTapped)]];
}

- (void)configureSweepstakesInfo {
    self.sweepstakesDescriptionLabel.text = [@"REGISTER_SWEEPSTAKES_DESCRIPTION" ggp_toLocalized];
    self.sweepstakesDescriptionLabel.font = [UIFont ggp_regularWithSize:16];
    
    self.viewLabel.text = [@"REGISTER_SWEEPSTAKES_VIEW" ggp_toLocalized];
    self.viewLabel.font = [UIFont ggp_regularWithSize:13];
    
    self.termsLabel.text = [@"REGISTER_SWEEPSTAKES_TERMS" ggp_toLocalized];
    self.termsLabel.textColor = [UIColor ggp_blue];
    self.termsLabel.font = [UIFont ggp_boldWithSize:13];
    self.termsLabel.userInteractionEnabled = YES;
    [self.termsLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(termsTapped)]];
}

- (void)loginTapped {
    [self.navigationController pushViewController:[GGPLoginViewController new] animated:YES];
}

- (IBAction)facebookTapped:(id)sender {
    [self registerWithProvider:GGPAccountFacebookProvider];
}

- (IBAction)googleTapped:(id)sender {
    [self registerWithProvider:GGPAccountGoogleProvider];
}

- (IBAction)siteRegisterTapped:(id)sender {
    [self.navigationController pushViewController:[GGPRegisterInfoViewController new] animated:YES];
}

- (void)termsTapped {
    GGPModalViewController *modal = [[GGPModalViewController alloc] initWithRootViewController:[[GGPWebViewController alloc] initWithTitle:[@"REGISTER_SWEEPSTAKES_TERMS" ggp_toLocalized] urlString:[@"REGISTER_SWEEPSTAKES_TERMS_LINK" ggp_toLocalized] andAnalyticsConst:GGPAnalyticsScreenTermsConditions] andOnClose:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:modal animated:YES completion:nil];
}

- (void)registerWithProvider:(NSString *)provider {
    [GGPSpinner showForView:self.view];
    [GGPAccount loginWithProvider:provider withPresenter:self onCompletion:^(GGPSocialInfo *socialInfo, NSString *registrationToken, NSError *error) {
        [GGPSpinner hideForView:self.view];
        if (error) {
            GGPLogError(@"Unable to register to %@: %@", provider, error);
        } else if (registrationToken) {
            GGPLogInfo(@"Successful register to %@, need to complete", provider);
            [self displayRegistrationWithSocialInfo:socialInfo provider:provider andRegistrationToken:registrationToken];
        }  else {
            GGPLogInfo(@"Successful register to %@, already registered", provider);
            [self trackLoginForProvider:provider];
            [self onRegistrationComplete];
        }
    }];
}

- (void)displayRegistrationWithSocialInfo:(GGPSocialInfo *)socialInfo provider:(NSString *)provider andRegistrationToken:(NSString *)registrationToken {
    GGPRegisterInfoViewController *registerViewController = [[GGPRegisterInfoViewController alloc] initWithSocialInfo:socialInfo provider:provider andRegistrationToken:registrationToken];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)onRegistrationComplete {
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
