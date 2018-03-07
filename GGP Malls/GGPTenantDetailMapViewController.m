//
//  GGPTenantDetailMapViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAnalytics.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPTenant.h"
#import "GGPTenantDetailMapViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPTenantDetailMapViewController ()

@property (strong, nonatomic) GGPTenant *tenant;

@end

@implementation GGPTenantDetailMapViewController

- (instancetype)initWithTenant:(GGPTenant *)tenant {
    self = [super init];
    if (self) {
        self.tenant = tenant;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [@"DETAILS_MAP_TITLE" ggp_toLocalized];
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configureNavigationBar];
    [self ggp_addChildViewController:[GGPJMapManager shared].mapViewController toPlaceholderView:self.view];
    [[GGPJMapManager shared].mapViewController zoomToTenant:self.tenant withIcons:YES];
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenTenantDetailMap withTenant:self.tenant.name];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[GGPJMapManager shared].mapViewController ggp_removeFromParentViewController];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)configureNavigationBar {
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController ggp_configureWithDarkText];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

@end
