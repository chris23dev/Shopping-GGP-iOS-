//
//  GGPDiningViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMallRepository.h"
#import "GGPCategory.h"
#import "GGPDiningViewController.h"
#import "GGPMallManager.h"
#import "GGPNavigationTitleView.h"
#import "GGPSpinner.h"
#import "GGPTenantDetailViewController.h"
#import "GGPTenantListDelegate.h"
#import "GGPTenantTableViewController.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSString *const kFoodCategoryCode = @"FOOD";

@interface GGPDiningViewController () <GGPTenantListDelegate>

@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;
@property (strong, nonatomic) GGPTenantTableViewController *tenantTableViewController;

@end

@implementation GGPDiningViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = [@"DINING_TITLE" ggp_toLocalized];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    [self retrieveTenantsForDining];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveTenantsForDining) name:GGPClientTenantsUpdatedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenDining];
}

- (void)configureControls {
    [GGPSpinner showForView:self.view];
    [self configureNavigationBar];
    
    self.tenantTableViewController = [GGPTenantTableViewController new];
    self.tenantTableViewController.delegate = self;
    
    [self ggp_addChildViewController:self.tenantTableViewController toPlaceholderView:self.tableViewContainer];
}

- (void)configureNavigationBar {
    self.navigationItem.titleView = [[GGPNavigationTitleView alloc] initWithImage:[UIImage imageNamed:@"ggp_white_dining"] andText:[@"DINING_TITLE" ggp_toLocalized]];
}

- (void)retrieveTenantsForDining {
    [GGPMallRepository fetchTenantsWithCompletion:^(NSArray *tenants) {
        [GGPSpinner hideForView:self.view];
        [self configureTableViewWithTenants:tenants];
    }];
}

- (void)configureTableViewWithTenants:(NSArray *)tenants {
    NSArray *diningTenants = [self filterTenantsForDining:tenants];
    [self.tenantTableViewController configureWithTenants:diningTenants];
}

- (NSArray *)filterTenantsForDining:(NSArray *)tenants {
    return [tenants ggp_arrayWithFilter:^BOOL(GGPTenant *tenant) {
        return [tenant.categories ggp_anyWithFilter:^BOOL(GGPCategory *category) {
            return [category.code isEqualToString:kFoodCategoryCode];
        }];
    }];
}

#pragma mark GGPTenantListDelegate

- (void)selectedTenant:(GGPTenant *)tenant {
    GGPTenantDetailViewController *tenantViewController = [[GGPTenantDetailViewController alloc] initWithTenantDetails:tenant];
    [self.navigationController pushViewController:tenantViewController animated:YES];
}

@end
