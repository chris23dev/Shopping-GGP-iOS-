//
//  GGPChangeMallViewController.m
//  GGP Malls
//
//  Created by Janet Lin on 1/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPChangeMallViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import "GGPLocationSearchViewController.h"
#import "GGPNameSearchViewController.h"

@interface GGPChangeMallViewController ()

@property (strong, nonatomic) GGPLocationSearchViewController *locationSearchViewController;
@property (strong, nonatomic) GGPNameSearchViewController *nameSearchViewController;

@end

@implementation GGPChangeMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"SELECT_MALL_TITLE" ggp_toLocalized];
    [self configureControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenMallSelection];
}

- (void)configureControls {
    self.locationSearchViewController = [GGPLocationSearchViewController new];
    self.nameSearchViewController = [GGPNameSearchViewController new];
    
    self.ribbonControllers = @[self.locationSearchViewController, self.nameSearchViewController];
}

@end
