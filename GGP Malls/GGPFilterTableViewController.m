//
//  GGPFilterTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAnalyticsConstants.h"
#import "GGPFilterDisclaimerCell.h"
#import "GGPFilterTableCell.h"
#import "GGPFilterTableCellData.h"
#import "GGPFilterTableViewController.h"
#import "GGPNotificationConstants.h"

@interface GGPFilterTableViewController ()

@property (assign, nonatomic) BOOL hasDisclaimerSection;

@end

@implementation GGPFilterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCells];
    [self configureTableView];
}

- (void)registerCells {
    UINib *disclaimerNib = [UINib nibWithNibName:@"GGPFilterDisclaimerCell" bundle:NSBundle.mainBundle];
    [self.tableView registerNib:disclaimerNib forCellReuseIdentifier:GGPFilterDisclaimerCellReuseIdentifier];
    [self.tableView registerClass:GGPFilterTableCell.class forCellReuseIdentifier:GGPFilterCellReuseIdentifier];
}

- (void)configureTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Configuration

- (void)configureWithFilterItems:(NSArray *)filterItems {
    [self configureWithFilterItems:filterItems hasDisclaimerSection:NO];
}

- (void)configureWithFilterItems:(NSArray *)filterItems hasDisclaimerSection:(BOOL)hasDisclaimerSection {
    self.hasDisclaimerSection = hasDisclaimerSection;
    self.filterItems = filterItems;
    [self.tableView reloadData];
}

- (BOOL)hasDisclaimerSectionAndIsDisclaimerSection:(NSInteger)section {
    return self.hasDisclaimerSection && section == 0;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.hasDisclaimerSection ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self hasDisclaimerSectionAndIsDisclaimerSection:section] ? 1 : self.filterItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self hasDisclaimerSectionAndIsDisclaimerSection:indexPath.section]) {
        return [self configureDisclaimerCellForTableView:tableView];
    } else {
        return [self configureCategoryCellForTableView:tableView atIndexPath:indexPath];
    }
}

- (GGPFilterDisclaimerCell *)configureDisclaimerCellForTableView:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:GGPFilterDisclaimerCellReuseIdentifier];
}

- (GGPFilterTableCell *)configureCategoryCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    GGPFilterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPFilterCellReuseIdentifier forIndexPath:indexPath];
    GGPFilterTableCellData *cellData = self.filterItems[indexPath.row];
    [cell configureWithCellData:cellData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPFilterTableCellData *cellData = self.filterItems[indexPath.row];
    if (cellData.tapHandler) {
        cellData.tapHandler();
    } else if (cellData.filterItem) {
        [self trackItem:cellData.filterItem];
        [self handleNotificationForCellData:cellData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)handleNotificationForCellData:(GGPFilterTableCellData *)cellData {
    [[NSNotificationCenter defaultCenter] postNotificationName:GGPDirectoryFilterSelectedNotification object:nil userInfo:@{ GGPFilterSelectedUserInfoKey: cellData.filterItem }];
}

#pragma mark - Analytics

- (void)trackItem:(id<GGPFilterItem>)filterItem {
    NSString *filterContextKey = filterItem.type == GGPFilterTypeCategory ? GGPAnalyticsContextDataDirectoryFilterCategory : GGPAnalyticsContextDataDirectoryFilterProduct;
    
    NSString *filterName = filterItem.name.length ? filterItem.name : @"";
    NSDictionary *data = @{ filterContextKey : filterName };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionDirectoryFilterItem withData:data];
}

@end
