//
//  GGPShoppingRefineStoreFilterViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenant.h"
#import "GGPShoppingRefineStoreFilterTableViewController.h"
#import "GGPShoppingRefineStoreFilterViewController.h"
#import "NSString+GGPAdditions.h"
#import "NSArray+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSString *const kTenantSortKey = @"sortName";

@interface GGPShoppingRefineStoreFilterViewController () <UISearchBarDelegate, GGPRefineStoreFilterDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;

@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSArray *filteredTenants;
@property (assign, nonatomic) BOOL includeUserFavorites;
@property (strong, nonatomic) NSArray *tenants;
@property (strong, nonatomic) GGPShoppingRefineStoreFilterTableViewController *tableViewController;

@end

@implementation GGPShoppingRefineStoreFilterViewController

- (instancetype)initWithFilteredTenants:(NSArray *)filteredTenants includeUserFavorites:(BOOL)includeUserFavorites andTenants:(NSArray *)tenants {
    self = [super init];
    if (self) {
        self.title = [@"SHOPPING_REFINE_TITLE" ggp_toLocalized];
        self.filteredTenants = filteredTenants;
        self.includeUserFavorites = includeUserFavorites;
        self.tenants = tenants;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.refineDelegate didUpdateFilteredTenants:self.filteredTenants];
    [super viewWillDisappear:animated];
}

- (void)configureControls {
    [self configureSearchBar];
    [self configureTableView];
}

- (void)configureSearchBar {
    self.searchBar.delegate = self;
    self.searchBar.placeholder = [@"SHOPPING_REFINE_STORE_FILTER_SEARCH_BAR_PLACEHOLDER" ggp_toLocalized];
}

- (void)configureTableView {
    self.tableViewController = [[GGPShoppingRefineStoreFilterTableViewController alloc]
                                initWithFilteredTenants:self.filteredTenants
                                includeUserFavorites:self.includeUserFavorites
                                andTenants:self.tenants];
    self.tableViewController.storeFilterDelegate = self;
    [self ggp_addChildViewController:self.tableViewController toPlaceholderView:self.tableViewContainer];
}

#pragma mark - Searchbar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!searchText.length) {
        self.searchResults = self.tenants;
    } else {
        [self searchWithSearchText:searchText];
    }
    
    [self.tableViewController updateWithSearchResults:self.searchResults];
}

#pragma mark - Search by name

- (void)searchWithSearchText:(NSString *)searchText {
    self.searchResults = [GGPTenant filteredTenantsBySearchText:searchText fromTenants:self.tenants];
}

#pragma mark - StoreFilter Delegate

- (void)didUpdateFilteredTenants:(NSArray *)tenants {
    self.filteredTenants = [tenants ggp_sortListAscendingForKey:kTenantSortKey];
    [self.refineDelegate didUpdateFilteredTenants:self.filteredTenants];
}

- (void)didUpdateFavoriteTenants:(BOOL)includeUserFavorites {
    self.includeUserFavorites = includeUserFavorites;
    [self.refineDelegate didUpdateIncludeUserFavorites:self.includeUserFavorites];
}

@end
