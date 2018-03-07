//
//  GGPTenantPromotionsTableViewControllerId.m
//  GGP Malls
//
//  Created by Janet Lin on 1/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantPromotionsTableViewController.h"
#import "GGPTenantPromotionCell.h"
#import "GGPTenantDetailListHeaderView.h"
#import "GGPSale.h"
#import "NSString+GGPAdditions.h"

@interface GGPTenantPromotionsTableViewController ()

@property (strong, nonatomic) NSArray *promotions;

@end

@implementation GGPTenantPromotionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.rowHeight = GGPTenantPromotionCellRowHeight;
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPTenantPromotionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:GGPTenantPromotionCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPTenantDetailListHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:GGPTenantDetailListHeaderViewId];
}

- (void)configureWithSales:(NSArray *)sales andEvents:(NSArray *)events {
    NSSortDescriptor *sortByNearestExpiration = [[NSSortDescriptor alloc] initWithKey:@"endDateTime" ascending:YES];
    NSArray *sortDescriptors = @[sortByNearestExpiration];
    NSArray *sortedSales = [sales sortedArrayUsingDescriptors:sortDescriptors];
    self.promotions = events ? [events arrayByAddingObjectsFromArray:sortedSales] : sortedSales;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.promotions.count ? GGPTenantDetailListHeaderViewHeight : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.promotions.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GGPTenantDetailListHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:GGPTenantDetailListHeaderViewId];
    [header configureWithTitle:[@"DETAILS_PROMOTIONS_HEADER" ggp_toLocalized]];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPTenantPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPTenantPromotionCellReuseIdentifier forIndexPath:indexPath];
    [cell configureCellWithPromotion:self.promotions[indexPath.row] isFirstCell:indexPath.row == 0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self.tenantPromotionsDelegate selectedPromotion:self.promotions[indexPath.row]];
}

@end
