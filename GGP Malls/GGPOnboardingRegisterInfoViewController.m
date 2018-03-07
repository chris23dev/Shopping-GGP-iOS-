//
//  GGPOnboardingRegisterInfoViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/30/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFormField.h"
#import "GGPOnboardingPreferencesViewController.h"
#import "GGPOnboardingRegisterInfoViewController.h"
#import "GGPUser.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"

@interface GGPRegisterInfoViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *requiredFieldsLabel;

@property (strong, nonatomic) GGPSocialInfo *socialInfo;
@property (strong, nonatomic) NSString *provider;
@property (strong, nonatomic) NSString *registrationToken;

@property (strong, nonatomic) GGPFormField *emailField;
@property (strong, nonatomic) GGPFormField *firstNameField;
@property (strong, nonatomic) GGPFormField *lastNameField;
@property (strong, nonatomic) GGPFormField *passwordField;
@property (strong, nonatomic) GGPFormField *confirmPasswordField;

@end

@interface GGPOnboardingRegisterInfoViewController ()

@end

@implementation GGPOnboardingRegisterInfoViewController

- (instancetype)init {
    return [super initWithNibName:@"GGPRegisterInfoViewController" bundle:[NSBundle mainBundle]];
}

- (instancetype)initWithSocialInfo:(GGPSocialInfo *)socialInfo provider:(NSString *)provider andRegistrationToken:(NSString *)registrationToken {
    self = [self init];
    if (self) {
        self.socialInfo = socialInfo;
        self.provider = provider;
        self.registrationToken = registrationToken;
    }
    return self;
}

- (void)styleControls {
    self.view.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.image = [UIImage imageNamed:@"ggp_onboarding_background"];
    self.containerView.backgroundColor = [UIColor clearColor];
    self.requiredFieldsLabel.textColor = [UIColor ggp_extraLightGray];
    
    [self.emailField configureWithBackgroundColor:[UIColor clearColor]
                                     andTintColor:[UIColor ggp_extraLightGray]];
    [self.firstNameField configureWithBackgroundColor:[UIColor clearColor]
                                         andTintColor:[UIColor ggp_extraLightGray]];
    [self.lastNameField configureWithBackgroundColor:[UIColor clearColor]
                                        andTintColor:[UIColor ggp_extraLightGray]];
    [self.passwordField configureWithBackgroundColor:[UIColor clearColor]
                                        andTintColor:[UIColor ggp_extraLightGray]];
    [self.confirmPasswordField configureWithBackgroundColor:[UIColor clearColor]
                                               andTintColor:[UIColor ggp_extraLightGray]];
}

- (void)configureNavigationBar {
    [self.navigationController ggp_configureWithLightText];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:[@"ONBOARDING_CANCEL" ggp_toLocalized] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped)];
    [cancelButton setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                           NSFontAttributeName: [UIFont ggp_regularWithSize:14]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)displayPreferencesScreenForUser:(GGPUser *)user {
    if (self.socialInfo) {
        [self.navigationController pushViewController:[[GGPOnboardingPreferencesViewController alloc] initWithUser:user provider:self.provider andRegistrationToken:self.registrationToken] animated:YES];
    } else {
        [self.navigationController pushViewController:[[GGPOnboardingPreferencesViewController alloc] initWithUser:user andPassword:self.passwordField.text] animated:YES];
    }
}

- (void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
