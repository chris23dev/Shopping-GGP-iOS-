//
//  GGPTenantDetailProductsTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPProduct.h"
#import "GGPTenantDetailProductsTableViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

static NSInteger const kCellHeight = 20;
static NSString *const kCellIdentifier = @"reuseIdentifier";

@interface GGPTenantDetailProductsTableViewController ()

@property (strong, nonatomic) NSArray *sections;

@end

@implementation GGPTenantDetailProductsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)configureTableView {
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:kCellIdentifier];
}

- (void)configureWithSections:(NSArray *)sections {
    self.sections = sections;
    [self.tableView reloadData];
}

#pragma mark - FilterItem convenience methods

- (NSArray *)childItemsForSection:(NSInteger)section {
    return [GGPProduct nonParentItemChildItemsFromProducts:[self parentItemForSection:section].childFilters];
}

- (GGPProduct *)parentItemForSection:(NSInteger)section {
    return self.sections[section];
}

- (GGPProduct *)childItemForIndex:(NSIndexPath *)indexPath {
    return [self childItemsForSection:indexPath.section][indexPath.row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self childItemsForSection:section].count;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.backgroundView.backgroundColor = [UIColor clearColor];
    header.textLabel.textColor = [UIColor blackColor];
    header.textLabel.font = [UIFont ggp_boldWithSize:16];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    GGPProduct *parentItem = self.sections[section];
    return parentItem.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    GGPProduct *childItem = [self childItemForIndex:indexPath];
    
    cell.textLabel.font = [UIFont ggp_regularWithSize:14];
    cell.indentationLevel = 1;
    cell.indentationWidth = 25;
    cell.textLabel.text = childItem.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.backgroundView.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kCellHeight;
}

@end
