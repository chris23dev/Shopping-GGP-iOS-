//
//  GGPFavoriteTenantsViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/7/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFavoriteTenantsTableViewController.h"
#import "GGPFavoriteTenantsViewController.h"
#import "GGPMallRepository.h"
#import "GGPSpinner.h"
#import "GGPTenant.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPFavoriteTenantsViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;

@property (strong, nonatomic) NSArray *tenants;
@property (strong, nonatomic) GGPFavoriteTenantsTableViewController *tableViewController;

@end

@implementation GGPFavoriteTenantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"CHOOSE_FAVORITES_TITLE" ggp_toLocalized];
    
    [self fetchTenants];
    [self configureControls];
}

- (void)fetchTenants {
    [GGPSpinner showForView:self.view];
    
    [GGPMallRepository fetchTenantsWithCompletion:^(NSArray *tenants) {
        [GGPSpinner hideForView:self.view];
        self.tenants = tenants;
        [self configureTableView];
    }];
}

- (void)configureControls {
    self.searchBar.delegate = self;
    self.searchBar.placeholder = [@"CHOOSE_FAVORITES_SEARCHBAR_PLACEHOLDER" ggp_toLocalized];
}

- (void)configureTableView {
    self.tableViewController = [GGPFavoriteTenantsTableViewController new];
    [self.tableViewController configureWithTenants:self.tenants];
    [self ggp_addChildViewController:self.tableViewController toPlaceholderView:self.tableViewContainer];
}

#pragma mark - Search responder

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!searchText.length) {
        [self.tableViewController configureWithTenants:self.tenants];
    } else {
        [self.tableViewController configureWithTenants:[GGPTenant filteredTenantsBySearchText:searchText fromTenants:self.tenants]];
    }
}

@end
