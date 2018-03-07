//
//  GGPBrandSearchTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPBrandFooterView.h"
#import "GGPBrandSearchNoResultsView.h"
#import "GGPBrandSearchTableViewController.h"
#import "GGPFilterTableCell.h"
#import "GGPFilterTableCellData.h"
#import "GGPNotificationConstants.h"
#import "NSArray+GGPAdditions.h"

static NSString *const kSortkey = @"title";

@interface GGPBrandSearchTableViewController ()

@property (strong, nonatomic) GGPBrandFooterView *footerView;
@property (strong, nonatomic) NSArray *brandItems;
@property (strong, nonatomic) NSArray *filteredBrandItems;

@end

@implementation GGPBrandSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
    [self registerFooterView];
    [self configureTableView];
}

- (void)registerCell {
    [self.tableView registerClass:GGPFilterTableCell.class forCellReuseIdentifier:GGPFilterCellReuseIdentifier];
}

- (void)registerFooterView {
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPBrandFooterView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:GGPBrandFooterViewReuseIdentifier];
    self.footerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:GGPBrandFooterViewReuseIdentifier];
}

- (void)configureTableView {
    self.tableView.backgroundView = [GGPBrandSearchNoResultsView new];
    self.tableView.backgroundView.hidden = YES;
    self.tableView.tableFooterView = self.footerView;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)configureWithBrandItems:(NSArray *)brands {
    self.brandItems = brands;
    self.filteredBrandItems = brands;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredBrandItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPFilterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPFilterCellReuseIdentifier forIndexPath:indexPath];
    GGPFilterTableCellData *data = self.filteredBrandItems[indexPath.row];
    [cell configureWithCellData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPFilterTableCellData *data = self.filteredBrandItems[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:GGPDirectoryFilterSelectedNotification object:nil userInfo:@{ GGPFilterSelectedUserInfoKey: data.filterItem }];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.searchDelegate didSelectBrand];
}

#pragma mark UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.tableView.hidden = NO;
    
    if (searchController.searchBar.text.length) {
        [self performSearchWithParams:[searchController.searchBar.text componentsSeparatedByString:@" "]];
    } else {
        self.filteredBrandItems = self.brandItems;
    }
    
    [self.tableView reloadData];
}

- (void)performSearchWithParams:(NSArray *)searchParams {
    NSMutableSet *filteredSet = [NSMutableSet new];
    
    for (NSString *query in searchParams) {
        [filteredSet addObjectsFromArray:[self.brandItems ggp_arrayWithFilter:^BOOL(GGPFilterTableCellData *filterItem) {
            return [filterItem.title localizedStandardContainsString:query];
        }]];
    }
    
    self.filteredBrandItems = [filteredSet.allObjects ggp_sortListAscendingForKey:kSortkey];
    self.tableView.tableFooterView.hidden = self.filteredBrandItems.count == 0;
    self.tableView.backgroundView.hidden = self.filteredBrandItems.count > 0;
}

@end
