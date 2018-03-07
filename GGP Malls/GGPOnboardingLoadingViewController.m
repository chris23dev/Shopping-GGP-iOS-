//
//  GGPOnboardingLoadingViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPOnboardingChooseMallViewController.h"
#import "GGPOnboardingLoadingViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

static CGFloat const kLoadingDisplayDuration = 2.0;

@interface GGPOnboardingLoadingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GGPOnboardingLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    [self configureDisplayTimer];
}

- (void)configureControls {
    self.backgroundImageView.image = [UIImage imageNamed:@"ggp_onboarding_background"];
    self.iconImageView.image = [UIImage imageNamed:@"ggp_icon_bag_logo"];
    [self configureLabels];
}

- (void)configureLabels {
    self.headingLabel.numberOfLines = 0;
    self.headingLabel.textAlignment = NSTextAlignmentCenter;
    self.headingLabel.font = [UIFont ggp_blackWithSize:19];
    self.headingLabel.textColor = [UIColor whiteColor];
    self.headingLabel.text = [@"ONBOARDING_LOADING_TITLE" ggp_toLocalized];
    
    self.secondaryLabel.numberOfLines = 0;
    self.secondaryLabel.textAlignment = NSTextAlignmentCenter;
    self.secondaryLabel.font = [UIFont ggp_regularWithSize:19];
    self.secondaryLabel.textColor = [UIColor ggp_timberWolfGray];
    self.secondaryLabel.text = [@"ONBOARDING_LOADING_INFO_LABEL" ggp_toLocalized];
    
    [self configureActivityIndicator];
}

- (void)configureActivityIndicator {
    self.activityIndicator.color = [UIColor whiteColor];
    [self.activityIndicator startAnimating];
}

- (void)configureDisplayTimer {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kLoadingDisplayDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        [self.navigationController pushViewController:[GGPOnboardingChooseMallViewController new] animated:YES];
    });
}

@end
