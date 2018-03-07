//
//  GGPShoppingRefineStoreFilterTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCellData.h"
#import "GGPTenant.h"
#import "GGPUser.h"
#import "GGPAccount.h"
#import "GGPRefineOptions.h"
#import "GGPShoppingRefineCell.h"
#import "GGPShoppingRefineTenantSortHeaderCell.h"
#import "GGPShoppingRefineTenantSortFavoriteCell.h"
#import "GGPShoppingRefineStoreFilterTableViewController.h"
#import "NSString+GGPAdditions.h"
#import "NSArray+GGPAdditions.h"

static NSInteger const kHeaderSection = 0;
static NSInteger const kFavoritesSection = 1;
static NSInteger const kTenantsSection = 2;
static NSInteger const kNumberOfSections = 3;

static NSString *const kTenantSortKey = @"sortName";

@interface GGPShoppingRefineStoreFilterTableViewController ()

@property (strong, nonatomic) NSMutableArray *filteredTenants;
@property (strong, nonatomic) NSArray *tenants;
@property (assign, nonatomic) BOOL includeUserFavorites;

@end

@implementation GGPShoppingRefineStoreFilterTableViewController

- (instancetype)initWithFilteredTenants:(NSArray *)filteredTenants includeUserFavorites:(BOOL)includeUserFavorites andTenants:(NSArray *)tenants {
    self = [super init];
    if (self) {
        self.title = [@"SHOPPING_REFINE_TITLE" ggp_toLocalized];
        self.filteredTenants = filteredTenants.mutableCopy;
        self.includeUserFavorites = includeUserFavorites;
        self.tenants = tenants;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)configureTableView {
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self registerCells];
}

- (void)registerCells {
    UINib *headerNib = [UINib nibWithNibName:@"GGPShoppingRefineTenantSortHeaderCell" bundle:nil];
    [self.tableView registerNib:headerNib
         forCellReuseIdentifier:GGPShoppingRefineTenantSortHeaderCellReuseIdentifier];
    
    UINib *favoriteCellNib = [UINib nibWithNibName:@"GGPShoppingRefineTenantSortFavoriteCell" bundle:nil];
    [self.tableView registerNib:favoriteCellNib forCellReuseIdentifier:GGPShoppingRefineTenantSortFavoriteCellReuseIdentifier];
    
    UINib *sortCellNib = [UINib nibWithNibName:@"GGPShoppingRefineCell" bundle:nil];
    [self.tableView registerNib:sortCellNib forCellReuseIdentifier:GGPShoppingRefineCellReuseIdentifier];
}

- (void)updateWithSearchResults:(NSArray *)searchResults {
    self.tenants = searchResults;
    [self.tableView reloadData];
}

- (void)setTenants:(NSArray *)tenants {
    _tenants = [tenants ggp_sortListAscendingForKey:kTenantSortKey];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kHeaderSection:
            return 1;
            break;
        case kFavoritesSection:
            return [self userHasFavoritesInTenants] ? 1 : 0;
            break;
        default:
            return self.tenants.count;
            break;
    }
}

- (BOOL)userHasFavoritesInTenants {
    if ([GGPAccount shared].currentUser.favorites.count == 0) {
        return NO;
    }
    
    for (GGPTenant *tenant in self.tenants) {
        if (tenant.isFavorite) {
            return YES;
        }
    }
    
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case kHeaderSection:
            return [self headerCellForTableView:tableView atIndexPath:indexPath];
            break;
        case kFavoritesSection:
            return [self userFavoriteCellForTableView:tableView atIndexPath:indexPath];
        default:
            return [self refineCellForTableView:tableView atIndexPath:indexPath];
            break;
    }
}

#pragma mark - Header Cell

- (GGPShoppingRefineTenantSortHeaderCell *)headerCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    GGPShoppingRefineTenantSortHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPShoppingRefineTenantSortHeaderCellReuseIdentifier forIndexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    GGPCellData *headerdata = [[GGPCellData alloc] initWithTitle:[@"SHOPPING_REFINE_STORE_FILTER_HEADER" ggp_toLocalized] andTapHandler:^{
        [weakSelf clearAllTapped];
    }];
    
    [cell configureWithCellData:headerdata];
    
    return cell;
}

#pragma mark - Favorite Cell

- (GGPShoppingRefineTenantSortFavoriteCell *)userFavoriteCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    GGPShoppingRefineTenantSortFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPShoppingRefineTenantSortFavoriteCellReuseIdentifier forIndexPath:indexPath];
    
    if (self.includeUserFavorites) {
        cell.selected = YES;
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

#pragma mark - Tenant Cell

- (GGPShoppingRefineCell *)refineCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    GGPShoppingRefineCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPShoppingRefineCellReuseIdentifier forIndexPath:indexPath];
    
    GGPTenant *tenant = self.tenants[indexPath.row];

    [cell configureWithTitle:tenant.displayName andSubtitle:nil];
    
    if ([self.filteredTenants containsObject:tenant]) {
        cell.selected = YES;
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kFavoritesSection) {
        [self handleFavoritesRowSelected];
    } else if (indexPath.section == kTenantsSection) {
        GGPTenant *tenant = self.tenants[indexPath.row];
        [self handleSelectedTenant:tenant];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kFavoritesSection) {
        [self handleFavoritesRowDeselected];
    } else if (indexPath.section == kTenantsSection) {
        GGPTenant *tenant = self.tenants[indexPath.row];
        [self handleDeselectedTenant:tenant];
    }
}

#pragma mark - Tenant Cell Selection / Deselection

- (void)handleSelectedTenant:(GGPTenant *)tenant {
    [self trackFilter:tenant.name];
    
    if (![self.filteredTenants containsObject:tenant]) {
        [self.filteredTenants addObject:tenant];
    }
    
    [self updateFilteredTenants];
}

- (void)handleDeselectedTenant:(GGPTenant *)tenant {
    if ([self.filteredTenants containsObject:tenant]) {
        [self.filteredTenants removeObject:tenant];
    }
    
    if (self.filteredTenants.count == 0) {
        [self resetFilters];
    }
    
    if (tenant.isFavorite) {
        self.includeUserFavorites = NO;
    }
    
    [self updateFilteredTenants];
}

#pragma mark - Favorite Cell Selection / Deselection

- (void)handleFavoritesRowSelected {
    [self trackFilter:[@"SHOPPING_REFINE_STORE_FILTER_MY_FAVORITES" ggp_toLocalized]];
    self.includeUserFavorites = YES;
    
    for (GGPTenant *tenant in self.tenants) {
        if (tenant.isFavorite && ![self.filteredTenants containsObject:tenant]) {
            [self.filteredTenants addObject:tenant];
        }
    }
    
    [self updateFilteredTenants];
}

- (void)handleFavoritesRowDeselected {
    self.includeUserFavorites = NO;
    
    self.filteredTenants = [self.filteredTenants ggp_arrayWithFilter:^BOOL(GGPTenant *tenant) {
        return !tenant.isFavorite;
    }].mutableCopy;
    
    [self updateFilteredTenants];
}

#pragma mark - Clear All

- (void)clearAllTapped {
    [self resetFilters];
    [self updateFilteredTenants];
}

- (void)resetFilters {
    self.filteredTenants = [NSMutableArray new];
    self.includeUserFavorites = NO;
}

- (void)updateFilteredTenants {
    [self.tableView reloadData];
    [self.storeFilterDelegate didUpdateFilteredTenants:self.filteredTenants];
    [self.storeFilterDelegate didUpdateFavoriteTenants:self.includeUserFavorites];
}

#pragma mark Analytics

- (void)trackFilter:(NSString *)filterName {
    NSString *name = filterName ? filterName : @"";
    NSDictionary *data = @{ GGPAnalyticsContextDataShoppingFilterStore: name };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionShoppingFilterStore withData:data];
}

@end
