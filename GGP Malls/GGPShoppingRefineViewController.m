//
//  GGPShoppingRefineViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/4/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCellData.h"
#import "GGPMallRepository.h"
#import "GGPRefineOptions.h"
#import "GGPSale.h"
#import "GGPShoppingRefineViewController.h"
#import "GGPShoppingRefineActionCell.h"
#import "GGPShoppingRefineHeaderCell.h"
#import "GGPShoppingRefineStoreFilterViewController.h"
#import "GGPShoppingRefineSortViewController.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

static NSString *const kSaleNameSortKey = @"saleSortName";
static NSString *const kSaleEndDateSortKey = @"endDateTime";

static NSInteger const kNumberOfRowsPerSection = 2;
static NSInteger const kNumberOfRowsPerSectionWithClearAll = 3;
static NSInteger const kStoreFilterSection = 0;
static NSInteger const kHeaderRow = 0;

@interface GGPShoppingRefineViewController () <GGPRefineOptionsDelegate>

@property (strong, nonatomic) GGPRefineOptions *refineOptions;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *sales;

@end

@implementation GGPShoppingRefineViewController

- (instancetype)initWithSales:(NSArray *)sales {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = [@"SHOPPING_REFINE_TITLE" ggp_toLocalized];
        self.sales = sales;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self filterSalesFromRefineOptions];
    [super viewWillDisappear:animated];
}

- (void)configureTableView {
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    
    // Remove default top inset inherited from "grouped" style
    self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self registerCells];
}

- (void)registerCells {
    UINib *headerNib = [UINib nibWithNibName:@"GGPShoppingRefineHeaderCell" bundle:nil];
    [self.tableView registerNib:headerNib forCellReuseIdentifier:GGPShoppingRefineHeaderReusueIdentifier];
    
    UINib *actionNib = [UINib nibWithNibName:@"GGPShoppingRefineActionCell" bundle:nil];
    [self.tableView registerNib:actionNib forCellReuseIdentifier:GGPShoppingRefineActionReusueIdentifier];
}

- (void)configureWithRefineOptions:(GGPRefineOptions *)refineOptions {
    self.refineOptions = refineOptions;
    [self configureSections];
    [self.tableView reloadData];
}

- (void)configureSections {
    NSMutableArray *sections = [NSMutableArray new];
    [sections addObject:[self storeFilterSection]];
    [sections addObject:[self sortBySection]];
    self.sections = sections;
}

#pragma mark - Store Filter Section

- (NSArray *)storeFilterSection {
    NSMutableArray *storeFilterSection = [NSMutableArray new];
    
    GGPCellData *storeFilterHeader = [[GGPCellData alloc] initWithTitle:[@"SHOPPING_REFINE_STORE_FILTER_HEADER" ggp_toLocalized] andTapHandler:nil];
    [storeFilterSection addObject:storeFilterHeader];
    
    NSString *cellTitle = self.refineOptions.tenants.count == 0 ?
        [@"SHOPPING_REFINE_STORE_FILTER_DEFAULT" ggp_toLocalized] :
        [@"SHOPPING_REFINE_STORE_FILTER_CHANGE_STORES" ggp_toLocalized];
    
    NSString *subTitle = [self filteredStoreCountString];
    GGPCellData *storeFilterAction = [[GGPCellData alloc] initWithTitle:cellTitle subTitle:subTitle andTapHandler:^{
        [self storeFilterTapped];
    }];
    [storeFilterSection addObject:storeFilterAction];
    
    NSMutableArray *filteredTenantRows = [NSMutableArray new];
    for (GGPTenant *tenant in self.refineOptions.tenants) {
        GGPCellData *tenantCellData = [[GGPCellData alloc] initWithTitle:tenant.name andTapHandler:nil];
        [filteredTenantRows addObject:tenantCellData];
    }
    [storeFilterSection addObjectsFromArray:filteredTenantRows];
    
    if (self.refineOptions.tenants.count > 0) {
        GGPCellData *clearAllAction = [[GGPCellData alloc] initWithTitle:[@"SHOPPING_REFINE_STORE_FILTER_CLEAR_ALL" ggp_toLocalized] andTapHandler:^{
            [self clearAllTapped];
        }];
        [storeFilterSection addObject:clearAllAction];
    }
    
    return storeFilterSection;
}

- (NSString *)filteredStoreCountString {
    NSInteger tenantCount = self.refineOptions.tenants.count == 0 ?
            [GGPSale tenantsFromSales:self.sales].count :
            self.refineOptions.tenants.count;
    return [NSString stringWithFormat:@"%ld", (long)tenantCount];
}

#pragma mark - Sory By Section

- (NSArray *)sortBySection {
    GGPCellData *sortByHeader = [[GGPCellData alloc] initWithTitle:[@"SHOPPING_REFINE_SORT_BY_HEADER" ggp_toLocalized] andTapHandler:nil];
    
    NSString *cellTitle = [GGPRefineOptions sortStringFromSortType:self.refineOptions.sortType];
    GGPCellData *sortByAction = [[GGPCellData alloc] initWithTitle:cellTitle andTapHandler:^{
        [self sortByTapped];
    }];
    
    return @[sortByHeader, sortByAction];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == kStoreFilterSection && self.refineOptions.tenants.count > 0 ?
        (self.refineOptions.tenants.count + kNumberOfRowsPerSectionWithClearAll) :
        kNumberOfRowsPerSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == kHeaderRow ?
        [self headerCellForTableView:tableView atIndexPath:indexPath] :
        [self actionCellForTableView:tableView atIndexPath:indexPath];
}

- (UITableViewCell *)headerCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    GGPShoppingRefineHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPShoppingRefineHeaderReusueIdentifier forIndexPath:indexPath];
    GGPCellData *data = self.sections[indexPath.section][indexPath.row];
    [cell configureWithTitle:data.title];
    return cell;
}

- (UITableViewCell *)actionCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    GGPShoppingRefineActionCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPShoppingRefineActionReusueIdentifier forIndexPath:indexPath];
    GGPCellData *data = self.sections[indexPath.section][indexPath.row];
    [cell configureWithCellData:data isClearAllCell:[self isClearAllRowForIndexPath:indexPath]];
    return cell;
}

- (BOOL)isClearAllRowForIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == kStoreFilterSection &&
        self.refineOptions.tenants.count > 0 &&
        indexPath.row == self.refineOptions.tenants.count + kNumberOfRowsPerSection;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPCellData *data = self.sections[indexPath.section][indexPath.row];
    if (data.tapHandler) {
        data.tapHandler();
    }
}

#pragma mark - Section Tap Handlers

- (void)storeFilterTapped {
    GGPShoppingRefineStoreFilterViewController *storeFilterViewController = [[GGPShoppingRefineStoreFilterViewController alloc] initWithFilteredTenants:self.refineOptions.tenants includeUserFavorites:self.refineOptions.includeFavorites andTenants:[GGPSale tenantsFromSales:self.sales]];
    
    storeFilterViewController.refineDelegate = self;
    [self.navigationController pushViewController:storeFilterViewController animated:YES];
}

- (void)sortByTapped {
    GGPShoppingRefineSortViewController *sortViewController = [[GGPShoppingRefineSortViewController alloc] initWithRefineSortType:self.refineOptions.sortType];
    
    sortViewController.refineDelegate = self;
    [self.navigationController pushViewController:sortViewController animated:YES];
}

- (void)clearAllTapped {
    self.refineOptions.tenants = @[];
    self.refineOptions.includeFavorites = NO;
    [self configureWithRefineOptions:self.refineOptions];
}

#pragma mark - Filter results

- (void)filterSalesFromRefineOptions {
    NSArray *filteredSales = self.refineOptions.tenants.count > 0 ?
        [self filterSales:self.sales forFilteredTenants:self.refineOptions.tenants] :
        self.sales ;
    
    NSArray *sortedSales = [self sortSales:filteredSales forSortType:self.refineOptions.sortType];
    
    [self.refineFilterDelegate didUpdateFilteredSales:sortedSales withTenants:self.refineOptions.tenants];
}

- (NSArray *)filterSales:(NSArray *)sales forFilteredTenants:(NSArray *)filteredTenants {
    return [sales ggp_arrayWithFilter:^BOOL(GGPSale *sale) {
        return [filteredTenants ggp_anyWithFilter:^BOOL(GGPTenant *tenant) {
            return tenant.tenantId == sale.tenant.tenantId;
        }];
    }];
}

- (NSArray *)sortSales:(NSArray *)sales forSortType:(GGPRefineSortType)sortType {
    switch (sortType) {
        case GGPRefineSortByAlpha:
            return [sales ggp_sortListForPrimarySortKey:kSaleNameSortKey primaryAscending:YES
                                       secondarySortkey:kSaleEndDateSortKey secondaryAscending:YES];
            break;
        case GGPRefineSortByEndDate:
            return [sales ggp_sortListAscendingForKey:kSaleEndDateSortKey];
            break;
        case GGPRefineSortByReverseAlpha:
            return [sales ggp_sortListForPrimarySortKey:kSaleNameSortKey primaryAscending:NO
                                       secondarySortkey:kSaleEndDateSortKey secondaryAscending:YES];
            break;
    }
}

#pragma mark - GGPRefineOptions Delegate

- (void)didUpdateFilteredTenants:(NSArray *)tenants {
    self.refineOptions.tenants = tenants;
    [self configureWithRefineOptions:self.refineOptions];
}

- (void)didUpdateSortType:(GGPRefineSortType)sortType {
    self.refineOptions.sortType = sortType;
    [self configureWithRefineOptions:self.refineOptions];
}

- (void)didUpdateIncludeUserFavorites:(BOOL)includeUserFavorites {
    self.refineOptions.includeFavorites = includeUserFavorites;
    [self configureWithRefineOptions:self.refineOptions];
}

@end
