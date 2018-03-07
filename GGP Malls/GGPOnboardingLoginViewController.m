//
//  GGPOnboardingLoginViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPOnboardingLoginViewController.h"
#import "GGPOnboardingSiteLoginViewController.h"
#import "GGPOnboardingWelcomeViewController.h"
#import "GGPOnboardingRegisterInfoViewController.h"
#import "GGPSocialInfo.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"

@interface GGPLoginViewController (Onboarding)

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;

- (void)onSocialLoginComplete;

@end

@implementation GGPOnboardingLoginViewController

- (void)configureNavigationBar {
    self.title = [@"LOGIN_TITLE" ggp_toLocalized];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController ggp_configureAsTransparent:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:[@"ONBOARDING_CANCEL" ggp_toLocalized] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped)];
    
    [cancelButton setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                            NSFontAttributeName: [UIFont ggp_regularWithSize:14] }
                                forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)styleControls {
    self.backgroundImageView.image = [UIImage imageNamed:@"ggp_onboarding_background"];
}

- (void)configureEmailButton {
    [self.emailButton ggp_styleAsLightActionButton];
    [self.emailButton setTitle:[@"LOGIN_EMAIL" ggp_toLocalized] forState:UIControlStateNormal];
    self.emailButton.backgroundColor = [UIColor ggp_pastelGray];
    [self.emailButton setTitleColor:[UIColor ggp_darkGray] forState:UIControlStateNormal];
}

- (void)cancelButtonTapped {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)emailTapped:(id)sender {
    [self.navigationController pushViewController:[GGPOnboardingSiteLoginViewController new] animated:YES];
}

- (void)onSocialLoginComplete {
    [super onSocialLoginComplete];
    [self.navigationController pushViewController:[GGPOnboardingWelcomeViewController new] animated:YES];
}

- (void)displayRegistrationWithSocialInfo:(GGPSocialInfo *)socialInfo provider:(NSString *)provider andRegistrationToken:(NSString *)registrationToken {
    GGPOnboardingRegisterInfoViewController *registerViewController = [[GGPOnboardingRegisterInfoViewController alloc] initWithSocialInfo:socialInfo provider:provider andRegistrationToken:registrationToken];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

@end
