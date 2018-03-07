//
//  GGPBenefitsViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPBenefitsItemViewController.h"
#import "GGPBenefitsPageViewController.h"
#import "GGPBenefitsViewController.h"
#import "GGPMallManager.h"
#import "GGPOnboardingLoginViewController.h"
#import "GGPOnboardingRegisterViewController.h"
#import "GGPSweepstakes.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface GGPBenefitsViewController ()

@property (weak, nonatomic) IBOutlet UIView *pageControllerContainer;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UILabel *alreadyMemberLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

@property (strong, nonatomic) GGPBenefitsPageViewController *pageController;
@property (strong, nonatomic) GGPSweepstakes *sweepstakes;

@end

@implementation GGPBenefitsViewController

- (instancetype)initWithSweepstakes:(GGPSweepstakes *)sweepstakes {
    self = [super init];
    if (self) {
        self.sweepstakes = sweepstakes;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)configureControls {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.logoImageView setImageWithURL:[NSURL URLWithString:[GGPMallManager shared].selectedMall.inverseNonSvgLogoUrl]];
    
    [self.skipButton setTitle:[@"BENEFITS_SKIP" ggp_toLocalized] forState:UIControlStateNormal];
    self.skipButton.titleLabel.font = [UIFont ggp_boldWithSize:16];
    [self.skipButton setTitleColor:[UIColor ggp_manateeGray] forState:UIControlStateNormal];
    
    [self.createAccountButton ggp_styleAsDarkActionButton];
    [self.createAccountButton setTitle:[@"BENEFITS_CREATE_ACCOUNT" ggp_toLocalized]
                              forState:UIControlStateNormal];
    self.createAccountButton.titleLabel.font = [UIFont ggp_boldWithSize:16];
    
    self.alreadyMemberLabel.text = [@"ACCOUNT_ALREADY_MEMBER" ggp_toLocalized];
    self.alreadyMemberLabel.textColor = [UIColor ggp_pastelGray];
    self.alreadyMemberLabel.font = [UIFont ggp_regularWithSize:16];
    
    UITapGestureRecognizer *loginTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLoginTapped)];
    self.loginLabel.userInteractionEnabled = YES;
    self.loginLabel.text = [@"ACCOUNT_LOGIN" ggp_toLocalized];
    self.loginLabel.textColor = [UIColor ggp_blue];
    self.loginLabel.font = [UIFont ggp_boldWithSize:16];
    [self.loginLabel addGestureRecognizer:loginTap];
    
    [self configurePageController];
}

- (void)configurePageController {
    self.pageController = [GGPBenefitsPageViewController new];
    [self.pageController configureWithViewControllers:[self createBenefitItemControllers]
                                       andPageControl:self.pageControl];
    [self ggp_addChildViewController:self.pageController
                   toPlaceholderView:self.pageControllerContainer];
}

- (NSArray *)createBenefitItemControllers {
    NSMutableArray *controllers = [NSMutableArray new];
    
    if (self.sweepstakes) {
        GGPBenefitsItemViewController *sweepstakesItem = [[GGPBenefitsItemViewController alloc] initWithTitle:self.sweepstakes.title description:self.sweepstakes.sweepstakesDescription background:self.sweepstakes.image icon:[UIImage imageNamed:@"ggp_benefits_sweeps_icon"] andPosition:controllers.count];
        [controllers addObject:sweepstakesItem];
    }
    
    GGPBenefitsItemViewController *shoppingItem = [[GGPBenefitsItemViewController alloc] initWithTitle:[@"BENEFITS_SHOPPING_TITLE" ggp_toLocalized] description:[@"BENEFITS_SHOPPING_DESCRIPTION" ggp_toLocalized] background:[UIImage imageNamed:@"ggp_benefits_shopping_background"] icon:[UIImage imageNamed:@"ggp_benefits_shopping_icon"] andPosition:controllers.count];
    [controllers addObject:shoppingItem];
    
    GGPBenefitsItemViewController *parkingItem = [[GGPBenefitsItemViewController alloc] initWithTitle:[@"BENEFITS_PARKING_TITLE" ggp_toLocalized] description:[@"BENEFITS_PARKING_DESCRIPTION" ggp_toLocalized] background:[UIImage imageNamed:@"ggp_benefits_parking_background"] icon:[UIImage imageNamed:@"ggp_benefits_parking_icon"] andPosition:controllers.count];
    [controllers addObject:parkingItem];
    
    if ([GGPMallManager shared].selectedMall.config.wayfindingEnabled) {
        GGPBenefitsItemViewController *wayfindingItem = [[GGPBenefitsItemViewController alloc] initWithTitle:[@"BENEFITS_WAYFINDING_TITLE" ggp_toLocalized] description:[@"BENEFITS_WAYFINDING_DESCRIPTION" ggp_toLocalized] background:[UIImage imageNamed:@"ggp_benefits_wayfinding_background"] icon:[UIImage imageNamed:@"ggp_benefits_wayfinding_icon"] andPosition:controllers.count];
        [controllers addObject:wayfindingItem];
    }
    
    GGPBenefitsItemViewController *justForYouItem = [[GGPBenefitsItemViewController alloc] initWithTitle:[@"BENEFITS_JFY_TITLE" ggp_toLocalized] description:[@"BENEFITS_JFY_DESCRIPTION" ggp_toLocalized] background:[UIImage imageNamed:@"ggp_benefits_jfy_background"] icon:[UIImage imageNamed:@"ggp_benefits_jfy_icon"] andPosition:controllers.count];
    [controllers addObject:justForYouItem];
    
    return controllers;
}

#pragma mark - Tap Handlers

- (IBAction)skipButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createAccountButtonTapped:(id)sender {
    [self.navigationController pushViewController:[GGPOnboardingRegisterViewController new] animated:YES];
}

- (void)handleLoginTapped {
    [self.navigationController pushViewController:[GGPOnboardingLoginViewController new] animated:YES];
}

@end
