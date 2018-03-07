//
//  GGPOnboardingRegisterViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPOnboardingLoginViewController.h"
#import "GGPOnboardingRegisterInfoViewController.h"
#import "GGPOnboardingRegisterViewController.h"
#import "GGPRegisterViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"

@interface GGPRegisterViewController (Onboarding)

@property (weak, nonatomic) IBOutlet UIButton *emailRegisterButton;
@property (weak, nonatomic) IBOutlet UILabel *existingMemberLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *sweepstakesDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;

- (void)onRegistrationComplete;

@end

@interface GGPOnboardingRegisterViewController ()

@end

@implementation GGPOnboardingRegisterViewController

- (instancetype)init {
    self = [super initWithNibName:@"GGPRegisterViewController" bundle:[NSBundle mainBundle]];
    return self;
}

- (void)styleControls {
    self.backgroundImageView.image = [UIImage imageNamed:@"ggp_onboarding_background"];
    
    self.emailRegisterButton.backgroundColor = [UIColor ggp_pastelGray];
    [self.emailRegisterButton setTitleColor:[UIColor ggp_darkGray] forState:UIControlStateNormal];
    
    self.existingMemberLabel.textColor = [UIColor ggp_pastelGray];
    self.sweepstakesDescriptionLabel.textColor = [UIColor ggp_pastelGray];
    self.viewLabel.textColor = [UIColor ggp_pastelGray];
}

- (void)configureNavigationBar {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController ggp_configureWithLightText];
    [self.navigationController ggp_configureAsTransparent:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:[@"ONBOARDING_CANCEL" ggp_toLocalized] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped)];
    [cancelButton setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                NSFontAttributeName: [UIFont ggp_regularWithSize:14]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)loginTapped {
    [self.navigationController pushViewController:[GGPOnboardingLoginViewController new] animated:YES];
}

- (void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)siteRegisterTapped:(id)sender {
    [self.navigationController pushViewController:[GGPOnboardingRegisterInfoViewController new] animated:YES];
}

- (void)displayRegistrationWithSocialInfo:(GGPSocialInfo *)socialInfo provider:(NSString *)provider andRegistrationToken:(NSString *)registrationToken {
    GGPOnboardingRegisterInfoViewController *registerViewController = [[GGPOnboardingRegisterInfoViewController alloc] initWithSocialInfo:socialInfo provider:provider andRegistrationToken:registrationToken];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)onRegistrationComplete {
    [super onRegistrationComplete];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
