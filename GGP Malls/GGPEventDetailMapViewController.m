//
//  GGPEventDetailMapViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPEventDetailMapViewController.h"
#import "GGPJMapManager.h"
#import "GGPJmapViewController+Highlighting.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPTenant.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"


@interface GGPEventDetailMapViewController ()

@property (strong, nonatomic) GGPTenant *tenant;

@end

@implementation GGPEventDetailMapViewController

- (instancetype)initWithTenant:(GGPTenant *)tenant {
    self = [super init];
    if (self) {
        self.tenant = tenant;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"EVENT_DETAIL_MAP_TITLE" ggp_toLocalized];
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self ggp_addChildViewController:[GGPJMapManager shared].mapViewController toPlaceholderView:self.view];
    [[GGPJMapManager shared].mapViewController zoomToTenant:self.tenant withIcons:YES];
    [[GGPJMapManager shared].mapViewController displayDetailCardForTenant:self.tenant];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GGPJMapManager shared].mapViewController ggp_removeFromParentViewController];
    
    self.tabBarController.tabBar.hidden = NO;
}

@end
