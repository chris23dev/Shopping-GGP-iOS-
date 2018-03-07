//
//  GGPChildTenantsTableViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPChildTenantsTableViewController.h"
#import "GGPTenantDetailListHeaderView.h"
#import "GGPTenantDetailViewController.h"
#import "GGPTenantTableCell.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

static NSString *const kNameKey = @"name";

@interface GGPChildTenantsTableViewController ()

@property (strong, nonatomic) NSArray *childTenants;
@property (strong, nonatomic) GGPTenant *parentTenant;

@end

@implementation GGPChildTenantsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)configureTableView {
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.estimatedRowHeight = GGPTenantTableCellHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPTenantTableCell" bundle:nil] forCellReuseIdentifier:GGPTenantTableCellReuseIdentifier];
   
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPTenantDetailListHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:GGPTenantDetailListHeaderViewId];
}

- (void)configureWithParentTenant:(GGPTenant *)parentTenant {
    self.parentTenant = parentTenant;
    self.childTenants = [parentTenant.childTenants ggp_sortListAscendingForKey:kNameKey];
    [self.tableView reloadData];
}

#pragma mark Table View methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.childTenants.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.childTenants.count ? GGPTenantDetailListHeaderViewHeight : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GGPTenantDetailListHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:GGPTenantDetailListHeaderViewId];
    [header configureWithTitle:[NSString stringWithFormat:@"%@ %@", [@"DETAILS_STORES_INSIDE" ggp_toLocalized], self.parentTenant.name]];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPTenantTableCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPTenantTableCellReuseIdentifier forIndexPath:indexPath];
    [cell configureCellWithTenant:self.childTenants[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[GGPTenantDetailViewController alloc] initWithTenantDetails:self.childTenants[indexPath.row]] animated:YES];
}

@end

