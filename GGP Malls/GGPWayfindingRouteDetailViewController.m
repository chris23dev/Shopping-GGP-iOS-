//
//  GGPWayfindingRouteDetailViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenant.h"
#import "GGPWayfindingRouteDetailTableViewController.h"
#import "GGPWayfindingRouteDetailViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPWayfindingRouteDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *tableContainer;

@property (strong, nonatomic) GGPWayfindingRouteDetailTableViewController *tableViewController;
@property (strong, nonatomic) NSArray *directions;
@property (strong, nonatomic) GGPTenant *fromTenant;
@property (strong, nonatomic) GGPTenant *toTenant;

@end

@implementation GGPWayfindingRouteDetailViewController

- (instancetype)initWithDirectionsList:(NSArray *)directions fromTenant:(GGPTenant *)fromTenant toTenant:(GGPTenant *)toTenant {
    self = [super init];
    if (self) {
        self.directions = directions;
        self.fromTenant = fromTenant;
        self.toTenant = toTenant;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    [self configureTableView];
}

- (void)configureControls {
    [self configureNavigationBar];
}

- (void)configureNavigationBar {
    self.title = [@"WAYFINDING_DIRECTION_LIST_TITLE" ggp_toLocalized];
}

- (void)configureTableView {
    self.tableViewController = [GGPWayfindingRouteDetailTableViewController new];
    [self ggp_addChildViewController:self.tableViewController toPlaceholderView:self.tableContainer];
    [self.tableViewController configureWithDirections:self.directions fromTenant:self.fromTenant toTenant:self.toTenant];
}

@end
