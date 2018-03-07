//
//  GGPAppContainerViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAlert.h"
#import "GGPAppContainerViewController.h"
#import "GGPBannerViewController.h"
#import "GGPChangeMallViewController.h"
#import "GGPClient.h"
#import "GGPMall.h"
#import "GGPMallLoadingViewController.h"
#import "GGPMallManager.h"
#import "GGPMallRepository.h"
#import "GGPModalViewController.h"
#import "GGPNotificationConstants.h"
#import "GGPOnboardingNavigationController.h"
#import "GGPOverlayImageController.h"
#import "GGPTabBarController.h"
#import "GGPURLCache.h"
#import "GGPVersionController.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static CGFloat const kLoadingDisplayDuration = 3.0;

@interface GGPAppContainerViewController ()

@property (weak, nonatomic) IBOutlet UIView *tabBarContainer;
@property (weak, nonatomic) IBOutlet UIImageView *overlayImageView;
@property (weak, nonatomic) IBOutlet UIView *bannerContainer;

@property (strong, nonatomic) GGPBannerViewController *networkBanner;
@property (strong, nonnull) GGPTabBarController *tabBarController;
@property (strong, nonatomic) GGPOverlayImageController *overlayImageController;

@end

@implementation GGPAppContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureOverlayImageController];
    [self configureNetworkBanner];
    [self configureTabBarController];
    [self registerNotifications];
}

- (void)configureOverlayImageController {
    self.overlayImageController = [[GGPOverlayImageController alloc] initWithOverlayImageView:self.overlayImageView];
    [self.overlayImageController displayLaunchOverlayImage];
}

- (void)configureNetworkBanner {
    self.networkBanner = [[GGPBannerViewController alloc] initWithMessage:[@"ALERT_WIFI_UNAVAILABLE" ggp_toLocalized]];
    [self ggp_addChildViewController:self.networkBanner toPlaceholderView:self.bannerContainer];
    [self updateNetworkBannerVisibility];
}

- (void)configureTabBarController {
    self.tabBarController = [GGPTabBarController new];
    [self ggp_addChildViewController:self.tabBarController toPlaceholderView:self.tabBarContainer];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMallChanged:) name:GGPMallManagerMallChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMallInactive) name:GGPMallManagerMallInactiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleReachabilityChanged) name:GGPClientReachabilityChanged object:nil];
}

- (void)handleMallChanged:(NSNotification *)notification {
    BOOL isInitialMallSelection = [[notification.userInfo objectForKey:GGPIsInitialMallSelectionUserInfoKey] boolValue];
    
    [[GGPURLCache shared] cacheAppData];
    
    if (isInitialMallSelection) {
        [self.tabBarController handleMallChanged];
    } else {
        [self handleChangeMallWithLoadingScreen];
    }
}

- (void)handleChangeMallWithLoadingScreen {
    [self.overlayImageController displayLoadingOverlayImage];
    
    [self dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:[GGPMallLoadingViewController new] animated:NO completion:nil];
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kLoadingDisplayDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabBarController handleMallChanged];
        [self.overlayImageController hideOverlayImage];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)handleMallInactive {
    [self presentChangeMallScreen];
}

- (void)handleReachabilityChanged {
    [self updateNetworkBannerVisibility];
}

- (BOOL)handleQuickActionType:(NSString *)type {
    return [self.tabBarController handleQuickActionType:type];
}

- (void)updateNetworkBannerVisibility {
    self.bannerContainer.hidden = ![GGPClient sharedInstance].isOffline;
}

- (void)appDidBecomeActive {
    [GGPVersionController checkAppVersionWithCompletion:^(BOOL requiresUpdate) {
        if (requiresUpdate) {
            [self displayUpdateRequiredAlert];
        } else if ([GGPMallManager shared].selectedMall) {
            [self.overlayImageController hideOverlayImage];
            [[GGPURLCache shared] cacheAppData];
        } else {
            [self presentOnboardingScreen];
        }
    }];
}

- (void)presentOnboardingScreen {
    [self presentViewController:[GGPOnboardingNavigationController new] animated:NO completion:^{
        [self.overlayImageController hideOverlayImage];
    }];
}

- (void)presentChangeMallScreen {
    GGPModalViewController *modalViewController = [[GGPModalViewController alloc] initWithRootViewController:[GGPChangeMallViewController new] includeCloseButton:NO andOnClose:nil];
    [self presentViewController:modalViewController animated:YES completion:^{
        [self.overlayImageController hideOverlayImage];
    }];
}

- (void)displayUpdateRequiredAlert {
    [self.overlayImageController displayLaunchOverlayImage];
    
    [self ggp_displayAlertWithTitle:[@"ALERT_FORCE_UPDATE_TITLE" ggp_toLocalized] message:[@"ALERT_FORCE_UPDATE" ggp_toLocalized] actionTitle:[@"ALERT_ACTION_UPDATE" ggp_toLocalized] andCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"APP_STORE_LINK" ggp_toLocalized]]];
        });
    }];
}

#pragma mark Deeplinking methods

- (void)handleDeeplinkedMallId:(NSInteger)mallId {
    [GGPMallRepository fetchMallById:mallId onComplete:^(GGPMall *mall) {
        [GGPMallManager shared].selectedMall = mall;
    }];
}

@end
