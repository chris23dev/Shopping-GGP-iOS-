//
//  GGPOnboardingWelcomeViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/31/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPOnboardingWelcomeViewController.h"
#import "GGPUser.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

static CGFloat const kLoadingDisplayDuration = 2.5;

@interface GGPOnboardingWelcomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GGPOnboardingWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureActivityIndicator];
    [self configureControls];
    [self configureDisplayTimer];
}

- (void)configureActivityIndicator {
    self.activityIndicator.color = [UIColor whiteColor];
    [self.activityIndicator startAnimating];
}

- (void)configureControls {
    GGPMall *selectedMall = [GGPMallManager shared].selectedMall;
    GGPUser *currentUser = [GGPAccount shared].currentUser;
    
    self.backgroundImageView.image = [UIImage imageNamed:@"ggp_onboarding_background"];
    
    self.welcomeLabel.numberOfLines = 0;
    self.welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel.font = [UIFont ggp_lightWithSize:32];
    self.welcomeLabel.textColor = [UIColor ggp_extraLightGray];
    self.welcomeLabel.text = [NSString stringWithFormat:[@"ONBOARDING_WELCOME_LABEL" ggp_toLocalized], selectedMall.name, currentUser.firstName];
    
    self.hoursLabel.font = [UIFont ggp_regularWithSize:19];
    self.hoursLabel.textColor = [UIColor ggp_extraLightGray];
    self.hoursLabel.text = selectedMall.formattedTodaysHoursString;
}

- (void)configureDisplayTimer {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kLoadingDisplayDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
