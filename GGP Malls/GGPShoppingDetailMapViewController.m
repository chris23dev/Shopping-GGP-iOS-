//
//  GGPShoppingDetailMapViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJmapViewController+Highlighting.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPShoppingDetailMapViewController.h"
#import "GGPTenant.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#include "UINavigationController+GGPAdditions.h"

@interface GGPShoppingDetailMapViewController ()

@property (strong, nonatomic) GGPTenant *tenant;

@end

@implementation GGPShoppingDetailMapViewController

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
    [[GGPJMapManager shared].mapViewController displayDetailCardForTenant:self.tenant];
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
