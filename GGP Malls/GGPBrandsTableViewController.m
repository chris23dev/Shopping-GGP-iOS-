//
//  GGPBrandsTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPBrand.h"
#import "GGPBrandFooterView.h"
#import "GGPBrandsTableViewController.h"
#import "GGPFilterTableCell.h"
#import "GGPFilterTableCellData.h"
#import "GGPNotificationConstants.h"

@interface GGPBrandsTableViewController ()

@property (strong, nonatomic) GGPBrandFooterView *footerView;
@property (strong, nonatomic) NSArray *brands;
@property (strong, nonatomic) NSMutableArray *sections;

@end

@implementation GGPBrandsTableViewController

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
    self.tableView.tableFooterView = self.footerView;
    self.footerView.borderViewHeightConstraint.constant = 0;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)configureWithBrandItems:(NSArray *)brandItems {
    SEL selector = @selector(title);
    
    NSInteger sectionTitlesCount = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
    NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    for (NSInteger i = 0; i < sectionTitlesCount; i++) {
        [mutableSections addObject:[NSMutableArray array]];
    }
    
    for (GGPFilterTableCellData *data in brandItems) {
        NSInteger sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:data collationStringSelector:selector];
        [[mutableSections objectAtIndex:sectionNumber] addObject:data];
    }
    
    for (NSInteger i = 0; i < sectionTitlesCount; i++) {
        NSArray *objectsForSection = [mutableSections objectAtIndex:i];
        [mutableSections replaceObjectAtIndex:i withObject:[[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:objectsForSection collationStringSelector:selector]];
    }
    
    self.sections = mutableSections;
    [self.tableView reloadData];
}

- (NSArray *)sectionArrayForIndex:(NSInteger)index {
    return self.sections[index];
}

- (GGPFilterTableCellData *)cellDataForIndexPath:(NSIndexPath *)indexPath {
    return [self sectionArrayForIndex:indexPath.section][indexPath.row];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionTitles].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self sectionArrayForIndex:section].count ? UITableViewAutomaticDimension : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self sectionArrayForIndex:section].count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GGPFilterTableCellData *data = [self cellDataForIndexPath:indexPath];
    [self trackBrand:data.filterItem];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GGPDirectoryFilterSelectedNotification object:nil userInfo:@{ GGPFilterSelectedUserInfoKey: data.filterItem }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPFilterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPFilterCellReuseIdentifier forIndexPath:indexPath];
    GGPFilterTableCellData *cellData = [self cellDataForIndexPath:indexPath];
    [cell configureWithCellData:cellData];
    return cell;
}

#pragma mark - Analytics

- (void)trackBrand:(id<GGPFilterItem>)brand {
    NSString *brandName = brand.name.length ? brand.name : @"";
    NSDictionary *data = @{ GGPAnalyticsContextDataDirectoryFilterBrand : brandName };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionDirectoryFilterItem withData:data];
}

@end
