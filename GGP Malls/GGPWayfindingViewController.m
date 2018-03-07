//
//  GGPWayfindingViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController+Wayfinding.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPWayfindingDelegate.h"
#import "GGPWayfindingDetailCardViewController.h"
#import "GGPWayfindingDisclaimerCardViewController.h"
#import "GGPWayfindingFloor.h"
#import "GGPWayfindingPickerDelegate.h"
#import "GGPWayfindingPickerViewController.h"
#import "GGPWayfindingToast.h"
#import "GGPWayfindingViewController.h"
#import "UIColor+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPWayfindingViewController () <GGPWayfindingPickerDelegate, GGPWayfindingDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchContainer;
@property (weak, nonatomic) IBOutlet UIView *mapContainer;
@property (weak, nonatomic) IBOutlet UIView *detailCardContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailCardContainerBottomConstraint;

@property (strong, nonatomic) GGPTenant *toTenant;
@property (strong, nonatomic) GGPTenant *fromTenant;
@property (strong, nonatomic) UINavigationController *localNavigationController;
@property (strong, nonatomic) GGPWayfindingDetailCardViewController *detailCardViewController;
@property (strong, nonatomic) GGPWayfindingDisclaimerCardViewController *disclaimerCardViewController;
@property (strong, nonatomic) GGPWayfindingToast *wayfindingToast;

@end

@implementation GGPWayfindingViewController

- (instancetype)initWithTenant:(GGPTenant *)tenant {
    self = [super init];
    if (self) {
        self.toTenant = tenant;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
    [self ggp_addChildViewController:[GGPJMapManager shared].mapViewController toPlaceholderView:self.mapContainer];
    [self configureToast];
    self.tabBarController.tabBar.hidden = YES;
    
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenWayfinding];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.localNavigationController.navigationBarHidden = NO;
    self.localNavigationController = nil;
    self.tabBarController.tabBar.hidden = NO;
    
    [[GGPJMapManager shared].mapViewController ggp_removeFromParentViewController];
    
    [super viewWillDisappear:animated];
}

- (void)configureControls {
    [self configurePicker];
    [self configureDetailCardContainer];
    [self configureMap];
    [self configureDisclaimerCard];
    [GGPJMapManager shared].mapViewController.wayfindingDelegate = self;
}

- (void)configureNavigationBar {
    self.localNavigationController = self.navigationController;
    self.navigationController.navigationBarHidden = YES;
}

- (void)configureDetailCardContainer {
    self.detailCardContainer.backgroundColor = [UIColor clearColor];
    self.detailCardContainerBottomConstraint.constant = -self.detailCardContainer.frame.size.height;
}

- (void)configurePicker {
    GGPWayfindingPickerViewController *wayfindingPickerViewController = [[GGPWayfindingPickerViewController alloc] initWithTenant:self.toTenant];
    wayfindingPickerViewController.wayfindingPickerDelegate = self;
    [self ggp_addChildViewController:wayfindingPickerViewController toPlaceholderView:self.searchContainer];
}

- (void)configureMap {
    [[GGPJMapManager shared].mapViewController resetMapView];
    [GGPJMapManager shared].mapViewController.showIcons = NO;
    [[GGPJMapManager shared].mapViewController zoomToMall];
}

- (void)configureDisclaimerCard {
    if (!self.fromTenant || !self.toTenant) {
        self.disclaimerCardViewController = [GGPWayfindingDisclaimerCardViewController new];
        [self populateCardContainerWithViewController:self.disclaimerCardViewController];
        [self showDetailCard];
    }
}

- (void)configureToast {
    self.wayfindingToast = [GGPWayfindingToast new];
    [self.mapContainer addSubview:self.wayfindingToast];
    [self.wayfindingToast ggp_addConstraintsToFillSuperview];
}

- (void)removeDisclaimerCardFromContainer {
    [self.disclaimerCardViewController ggp_removeFromParentViewController];
    [self hideDetailCard];
}

#pragma mark - Detailcard interactions

- (void)configureDirectionCard {
    NSArray *wayfindingFloors = [GGPJMapManager shared].mapViewController.wayfindingFloors;
    if ([self isMultiLevelRoute:wayfindingFloors]) {
        [self displayDetailCardForWayfindingFloor:wayfindingFloors.firstObject];
    } else {
        [self hideDetailCard];
    }
}

- (void)displayDetailCardForWayfindingFloor:(GGPWayfindingFloor *)wayfindingFloor {
    if (!self.detailCardViewController) {
        self.detailCardViewController = [GGPWayfindingDetailCardViewController new];
        [self populateCardContainerWithViewController:self.detailCardViewController];
    }
    
    [self.detailCardViewController configureWithWayfindingFloor:wayfindingFloor];
    [self showDetailCard];
}

- (void)populateCardContainerWithViewController:(UIViewController *)viewController {
    [self ggp_addChildViewController:viewController toPlaceholderView:self.detailCardContainer];
}

- (void)showDetailCard {
    self.detailCardContainerBottomConstraint.constant = 0;
}

- (void)hideDetailCard {
    self.detailCardContainerBottomConstraint.constant = -self.detailCardContainer.frame.size.height;
}

- (BOOL)isMultiLevelRoute:(NSArray *)wayfindingFloors {
    return wayfindingFloors.count > 1;
}

#pragma mark - WayfindingPicker delegate

- (void)didSelectFromTenant:(GGPTenant *)fromTenant andToTenant:(GGPTenant *)toTenant {
    if (fromTenant && toTenant) {
        [[GGPAnalytics shared] trackAction:GGPAnalyticsActionWayfindingNavigate withData:[[GGPJMapManager shared].mapViewController dataForWayfindingAnalytics]];
        
        [self removeDisclaimerCardFromContainer];
        [self configureDirectionCard];
    }
}

- (void)didUpdateLevelSelection {
    [self configureDirectionCard];
}

#pragma mark GGPWayfindingDelegate

- (void)didUpdateFloor:(JMapFloor *)floor {
    GGPWayfindingFloor *wayfindingFloor = [[GGPJMapManager shared].mapViewController wayfindingFloorForJmapFloor:floor];
    
    if (wayfindingFloor) {
        [self displayDetailCardForWayfindingFloor:wayfindingFloor];
    } else {
        [self hideDetailCard];
    }
    
    [self.wayfindingToast showWithText:floor.description];
}

@end
