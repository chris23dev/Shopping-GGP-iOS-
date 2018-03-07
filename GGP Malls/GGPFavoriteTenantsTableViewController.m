//
//  GGPFavoriteTenantsTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/7/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPFavoriteTenantsCell.h"
#import "GGPFavoriteTenantsTableViewController.h"
#import "GGPTenant.h"
#import "GGPTenantSearchNoResultsView.h"
#import "GGPUser.h"
#import "NSArray+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

static NSString *const kSortKey = @"sortName";

@interface GGPFavoriteTenantsTableViewController ()

@property (strong, nonatomic) NSArray *tenants;
@property (strong, nonatomic) NSArray *filteredTenants;

@end

@implementation GGPFavoriteTenantsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[GGPAccount shared].currentUser sendUpdatedFavorites];
    [super viewWillDisappear:animated];
}

- (void)configureWithTenants:(NSArray *)tenants {
    self.tenants = [[GGPTenant openTenantsFromAllTenants:tenants] ggp_sortListAscendingForKey:kSortKey];
    self.filteredTenants = [GGPTenant uniqueTenantsByBrandFromAllTenants:self.tenants];
    [self.tableView reloadData];
}

- (void)configureTableView {
    UINib *cellNib = [UINib nibWithNibName:@"GGPFavoriteTenantsCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:GGPFavoriteTenantsCellReuseIdentifier];
    
    self.tableView.backgroundView = [GGPTenantSearchNoResultsView new];
    self.tableView.backgroundView.hidden = YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredTenants.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor ggp_pastelGray];
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPFavoriteTenantsCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPFavoriteTenantsCellReuseIdentifier forIndexPath:indexPath];
    
    GGPTenant *tenant = self.filteredTenants[indexPath.row];
    [cell configureWithTenant:tenant];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPTenant *tenant = self.filteredTenants[indexPath.row];
    [[GGPAccount shared].currentUser toggleLocalFavorite:tenant];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self trackFavoriteTapForTenant:tenant];
}

#pragma mark Analytics

- (void)trackFavoriteTapForTenant:(GGPTenant *)tenant {
    NSString *favoriteStatus = tenant.isFavorite ? GGPAnalyticsContextDataTenantFavoriteStatusFavorite : GGPAnalyticsContextDataTenantFavoriteStatusUnFavorite;
    NSDictionary *data = @{ GGPAnalyticsContextDataTenantFavoriteStatus : favoriteStatus };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTenantFavoriteTap withData:data andTenant:tenant.name];
}

@end
