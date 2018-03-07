//
//  GGPOnboardingChooseMallViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPOnboardingChooseMallViewController.h"
#import "GGPOnboardingLocationSearchViewController.h"
#import "GGPOnboardingNameSearchViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPOnboardingChooseMallViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;


@property (weak, nonatomic) IBOutlet UIImageView *locationSearchIcon;
@property (weak, nonatomic) IBOutlet UILabel *locationSearchLabel;

@property (weak, nonatomic) IBOutlet UIImageView *nameSearchIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameSearchLabel;

@property (weak, nonatomic) IBOutlet UIView *leftBorder;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIView *rightBorder;

@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;

@end

@implementation GGPOnboardingChooseMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationItem.hidesBackButton = YES;
}

- (void)configureControls {
    self.backgroundImageView.image = [UIImage imageNamed:@"ggp_onboarding_background"];
    [self configureIntroLabels];
    [self configureSearchOptions];
    [self configureSeparator];
    [self configureDisclaimer];
}

- (void)configureIntroLabels {
    self.headingLabel.numberOfLines = 0;
    self.headingLabel.textAlignment = NSTextAlignmentCenter;
    self.headingLabel.font = [UIFont ggp_blackWithSize:18];
    self.headingLabel.textColor = [UIColor whiteColor];
    self.headingLabel.text = [@"ONBOARDING_HELLO_TITLE" ggp_toLocalized];
    
    self.secondaryLabel.numberOfLines = 0;
    self.secondaryLabel.textAlignment = NSTextAlignmentCenter;
    self.secondaryLabel.font = [UIFont ggp_regularWithSize:19];
    self.secondaryLabel.textColor = [UIColor ggp_timberWolfGray];
    self.secondaryLabel.text = [@"ONBOARDING_WELCOME_QUESTION" ggp_toLocalized];
}

- (void)configureSearchOptions {
    UITapGestureRecognizer *locationTap = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(searchLocationTapped)];
    
    self.locationSearchIcon.image = [UIImage imageNamed:@"ggp_icon_location_pin"];
    self.nameSearchIcon.image = [UIImage imageNamed:@"ggp_icon_nametag"];
    
    self.locationSearchLabel.userInteractionEnabled = YES;
    self.locationSearchLabel.font = [UIFont ggp_boldWithSize:18];
    self.locationSearchLabel.textColor = [UIColor whiteColor];
    self.locationSearchLabel.text = [@"ONBOARDING_SEARCH_LOCATION" ggp_toLocalized];
    [self.locationSearchLabel addGestureRecognizer:locationTap];
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(searchNameTapped)];
    
    self.nameSearchLabel.userInteractionEnabled = YES;
    self.nameSearchLabel.font = [UIFont ggp_boldWithSize:18];
    self.nameSearchLabel.textColor = [UIColor whiteColor];
    self.nameSearchLabel.text = [@"ONBOARDING_SEARCH_NAME" ggp_toLocalized];
    [self.nameSearchLabel addGestureRecognizer:nameTap];
}

- (void)configureSeparator {
    self.leftBorder.backgroundColor = [UIColor ggp_gray];
    self.rightBorder.backgroundColor = [UIColor ggp_gray];
    
    self.orLabel.font = [UIFont ggp_regularWithSize:19];
    self.orLabel.textColor = [UIColor whiteColor];
    self.orLabel.text = [@"ONBOARDING_OR_LABEL" ggp_toLocalized];
}

- (void)configureDisclaimer {
    self.disclaimerLabel.numberOfLines = 0;
    self.disclaimerLabel.textAlignment = NSTextAlignmentCenter;
    self.disclaimerLabel.font = [UIFont ggp_regularWithSize:16];
    self.disclaimerLabel.textColor = [UIColor ggp_gray];
    self.disclaimerLabel.text = [@"ONBOARDING_DISCLAIMER_LABEL" ggp_toLocalized];
}

#pragma mark - Tap Handlers 

- (void)searchLocationTapped {
    [self.navigationController pushViewController:[GGPOnboardingLocationSearchViewController new] animated:YES];
}

- (void)searchNameTapped {
    [self.navigationController pushViewController:[GGPOnboardingNameSearchViewController new] animated:YES];
}

@end
