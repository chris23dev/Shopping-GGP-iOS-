//
//  GGPTenantDetailCardViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 2/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCategory.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPLogoImageView.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPTenant.h"
#import "GGPTenantDetailCardViewController.h"
#import "GGPTenantDetailViewController.h"
#import "GGPWayfindingViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface GGPTenantDetailCardViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundContainer;
@property (weak, nonatomic) IBOutlet UILabel *tenantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenantDescriptionLabel;
@property (weak, nonatomic) IBOutlet GGPLogoImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *guideMeContainer;
@property (weak, nonatomic) IBOutlet UIImageView *guideMeImageView;
@property (strong, nonatomic) GGPTenant *tenant;

@end

@implementation GGPTenantDetailCardViewController

static const double kShadowRadius = 4.0;
static const double kShadowOpacity = 0.75;
static const double kAnimationDuration = 0.4;

- (instancetype)initWithTenant:(GGPTenant *)tenant {
    self = [super init];
    if (self) {
        self.tenant = tenant;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)updateLayout {
    [self.view layoutSubviews];
    [self.guideMeContainer layoutSubviews];
    [self.backgroundContainer layoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.guideMeContainer.layer.cornerRadius = self.guideMeContainer.frame.size.width/2;
}

- (void)configureControls {
    [self configureShadow];
    [self configureImage];
    [self configureGuideMe];
    [self configureTextStyling];
    [self configureLabels];
    [self configureGestures];
}

- (void)configureShadow {
    [self.backgroundContainer ggp_addShadowWithRadius:kShadowRadius andOpacity:kShadowOpacity];
}

- (void)configureGuideMe {
    if ([GGPMallManager shared].selectedMall.config.wayfindingEnabled && !self.tenant.temporarilyClosed) {
        self.guideMeContainer.backgroundColor = [UIColor ggp_blue];
        self.guideMeImageView.image = [UIImage imageNamed:@"ggp_icon_guide_me"];
        self.guideMeImageView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayWayfinding)];
        [self.guideMeContainer addGestureRecognizer:tapRecognizer];
        self.guideMeContainer.hidden = NO;
    } else {
        self.guideMeContainer.hidden = YES;
    }
}

- (void)configureGestures {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayTenantDetail)];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(displayTenantDetail)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(resetMapView)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:singleTap];
    [self.view addGestureRecognizer:swipeUp];
    [self.view addGestureRecognizer:swipeDown];
}

- (void)displayTenantDetail {
    GGPTenantDetailViewController *tenantDetailViewController = [[GGPTenantDetailViewController alloc] initWithTenantDetails:self.tenant];
    [self pushViewControllerFromBottom:tenantDetailViewController];
}

- (void)displayWayfinding {
    GGPWayfindingViewController *wayfindingController = [[GGPWayfindingViewController alloc] initWithTenant:self.tenant];
    [self pushViewControllerFromBottom:wayfindingController];
}

- (void)pushViewControllerFromBottom:(UIViewController *)controller {
    [self resetMapView];
    [self configureSlideUpAnimation];
    [self.navigationController pushViewController:controller animated:NO];
}

- (void)configureImage {
    [self.logoImageView setImageWithURL:self.tenant.tenantLogoUrl defaultName:self.tenant.name];
}

- (void)configureTextStyling {
    self.tenantNameLabel.font = [UIFont ggp_boldWithSize:15.0];
    self.tenantNameLabel.textColor = [UIColor ggp_colorFromHexString:@"#1D1D1D"];
    self.tenantDescriptionLabel.font = [UIFont ggp_mediumWithSize:13.0];
    self.tenantDescriptionLabel.textColor = [UIColor ggp_colorFromHexString:@"#BEBEBE"];
}

- (void)configureLabels {
    self.tenantNameLabel.text = [self.tenant.displayName capitalizedString];
    self.tenantDescriptionLabel.text = [self.tenant prettyPrintCategories];
}

- (void)configureSlideUpAnimation {
    CATransition* transition = [CATransition animation];
    transition.duration = kAnimationDuration;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
}

- (void)resetMapView {
    [self.tenantDetailCardDelegate tenantCardWasDismissed];
}

- (void)updateWithTenant:(GGPTenant *)tenant {
    self.tenant = tenant;
    [self configureImage];
    [self configureLabels];
    [self configureGuideMe];
}

@end
