//
//  GGPOnboardingResetPasswordViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/31/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFormField.h"
#import "GGPOnboardingResetPasswordViewController.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"

@interface GGPResetPasswordViewController (Onboarding)

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) GGPFormField *emailField;

@end

@implementation GGPOnboardingResetPasswordViewController

- (void)styleControls {
    self.backgroundImageView.image = [UIImage imageNamed:@"ggp_onboarding_background"];
    self.descriptionLabel.textColor = [UIColor ggp_extraLightGray];
    [self.emailField configureWithBackgroundColor:[UIColor clearColor] andTintColor:[UIColor ggp_extraLightGray]];
}

- (void)configureNavigationBar {
    [self.navigationController ggp_configureWithLightText];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}

@end
