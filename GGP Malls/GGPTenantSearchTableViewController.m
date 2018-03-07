//
//  GGPTenantSearchTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenant.h"
#import "GGPTenantSearchNoResultsView.h"
#import "GGPTenantSearchTableViewCell.h"
#import "GGPTenantSearchTableViewController.h"
#import "GGPJMapManager.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "GGPSpinner.h"

static NSString *const kSortKey = @"sortName";

@interface GGPTenantSearchTableViewController ()

@property (strong, nonatomic) NSArray *tenants;
@property (strong, nonatomic) NSArray *filteredTenants;

@end

@implementation GGPTenantSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GGPSpinner showForView:self.view];
    [self configureTableView];
}

- (void)formatTenantNamesForDisplay:(NSArray *)tenants {
    NSMutableDictionary *tenantDictionary = [NSMutableDictionary new];
    
    for (GGPTenant *tenant in tenants) {
        NSString *nameKey = tenant.name;
        
        if (tenant.parentTenant) {
            tenant.displayName = tenant.nameIncludingParent;
            nameKey = tenant.displayName;
        }
        
        NSArray *existingTenants = [tenantDictionary objectForKey:nameKey];
        NSArray *tenantList = existingTenants.count ? [existingTenants arrayByAddingObject:tenant] : @[tenant];
        [tenantDictionary setObject:tenantList forKey:nameKey];
    }
    
    for (NSString *key in tenantDictionary.allKeys) {
        NSArray *tenants = [tenantDictionary objectForKey:key];
        if (tenants.count > 1) {
            [self configureTenantsWithDuplicateNames:tenants];
        }
    }
}

- (void)configureTenantsWithDuplicateNames:(NSArray *)tenants {
    for (GGPTenant *tenant in tenants) {
        tenant.displayName = [NSString stringWithFormat:@"%@ - %@", tenant.name, [[GGPJMapManager shared].mapViewController nearbyLocationDescriptionForTenant:tenant]];
    }
    
    for (GGPTenant *tenant in tenants) {
        NSArray *nearbyDuplicates = [tenants ggp_arrayWithFilter:^BOOL(GGPTenant *evaluatedTenant) {
            return [evaluatedTenant.displayName isEqualToString:tenant.displayName];
        }];
        
        if (nearbyDuplicates.count > 1) {
            [self configureTenantsWithDuplicateNamesAndNearby:nearbyDuplicates];
        }
    }
}

- (void)configureTenantsWithDuplicateNamesAndNearby:(NSArray *)tenants {
    for (GGPTenant *tenant in tenants) {
        tenant.displayName = [NSString stringWithFormat:@"%@ - %@", tenant.name, [[GGPJMapManager shared].mapViewController locationDescriptionForTenant:tenant]];
    }
}

- (void)configureWithTenants:(NSArray *)tenants {
    [self configureWithTenants:tenants excludeUnMappedTenants:NO];
}

- (void)configureWithTenants:(NSArray *)tenants excludeUnMappedTenants:(BOOL)excludeUnMappedTenants {
    [GGPSpinner hideForView:self.view];
    
    self.tenants = [GGPTenant openTenantsFromAllTenants:tenants];
    
    if (excludeUnMappedTenants) {
        self.tenants = [GGPTenant wayFindingEnabledTenantsFromAllTenants:self.tenants];
    }
    
    self.filteredTenants = [self.tenants ggp_sortListAscendingForKey:kSortKey];
    [self.tableView reloadData];
}

- (void)configureTableView {
    UINib *cellNib = [UINib nibWithNibName:@"GGPTenantSearchTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:GGPTenantSearchTableViewCellReuseIdentifier];
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
    footer.backgroundColor = [UIColor ggp_colorFromHexString:@"c9c9ce"];
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPTenantSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPTenantSearchTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    GGPTenant *tenant = self.filteredTenants[indexPath.row];
    [cell configureWithTenantName:tenant.displayName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPTenant *tenant = self.filteredTenants[indexPath.row];
    [self.searchDelegate didSelectTenant:tenant];
}

#pragma mark UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.tableView.hidden = NO;
    
    if (searchController.searchBar.text.length) {
        self.filteredTenants = [GGPTenant filteredTenantsBySearchText:searchController.searchBar.text fromTenants:self.tenants];
    } else {
        self.filteredTenants = self.tenants;
    }
    
    self.tableView.backgroundView.hidden = !self.tenants || self.filteredTenants.count > 0;
    
    [self.tableView reloadData];
}

@end
