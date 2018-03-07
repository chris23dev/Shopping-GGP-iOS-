//
//  GGPTenantTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/17/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPTenantTableCell.h"
#import "GGPTenantTableViewController.h"
#import "GGPWayfindingViewController.h"
#import "UIColor+GGPAdditions.h"
#import <MGSwipeTableCell/MGSwipeTableCell.h>

static NSString *const kSwipeHintKey = @"GGPTenantTableViewControllerSwipeHintKey";

@interface GGPTenantTableViewController () <MGSwipeTableCellDelegate>

@property (strong, nonatomic) NSMutableArray *sections;
@property (assign, nonatomic) BOOL hideAlpha;
@property (assign, nonatomic) BOOL isCellExpanded;
@property (assign, nonatomic) BOOL displayedSwipeHint;

@end

@implementation GGPTenantTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.displayedSwipeHint = [[NSUserDefaults standardUserDefaults] boolForKey:kSwipeHintKey];
    [self registerCell];
    [self configureTableView];
}

- (void)registerCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPTenantTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:GGPTenantTableCellReuseIdentifier];
}

- (void)setIsCellExpanded:(BOOL)isCellExpanded {
    _isCellExpanded = isCellExpanded;
    [self.tableView reloadSectionIndexTitles];
}

- (void)configureTableView {
    self.tableView.estimatedRowHeight = GGPTenantTableCellHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)configureWithTenants:(NSArray *)tenants {
    [self configureWithTenants:tenants hideAlpha:NO];
}

- (void)configureWithTenants:(NSArray *)tenants hideAlpha:(BOOL)hideAlpha {
    self.hideAlpha = hideAlpha;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    SEL selector = @selector(listOrderName);
    
    NSInteger sectionTitlesCount = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
    NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    for (NSInteger i = 0; i < sectionTitlesCount; i++) {
        [mutableSections addObject:[NSMutableArray array]];
    }
    
    for (GGPTenant *tenant in tenants) {
        NSInteger sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:tenant collationStringSelector:selector];
        [[mutableSections objectAtIndex:sectionNumber] addObject:tenant];
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

- (GGPTenant *)tenantForIndexPath:(NSIndexPath *)indexPath {
    return [self sectionArrayForIndex:indexPath.section][indexPath.row];
}

- (BOOL)shouldDisplaySwipeHintForRow:(NSInteger)row andCell:(GGPTenantTableCell *)cell {
    // only display the swipe hint for the first cell that has swipe buttons in positions 2-4
    return row > 0 && row < 4 && cell.rightButtons.count > 0 && !self.displayedSwipeHint;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.hideAlpha || self.isCellExpanded ? nil : [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionTitles].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    BOOL showHeader = !self.hideAlpha && [self sectionArrayForIndex:section].count > 0;
    return showHeader ? UITableViewAutomaticDimension : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self sectionArrayForIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPTenantTableCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPTenantTableCellReuseIdentifier forIndexPath:indexPath];
    
    GGPTenant *tenant = [self tenantForIndexPath:indexPath];
    [cell configureCellWithTenant:tenant];
    
    cell.delegate = self;
    
    cell.onGuideMeTapped = ^(GGPTenant *tenant) {
        [self.navigationController pushViewController:[[GGPWayfindingViewController alloc] initWithTenant:tenant] animated:YES];
    };
    
    if ([self shouldDisplaySwipeHintForRow:indexPath.row andCell:cell]) {
        [cell showSwipe:MGSwipeDirectionRightToLeft animated:YES];
        self.displayedSwipeHint = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSwipeHintKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GGPTenant *tenant = [self tenantForIndexPath:indexPath];
    [self.delegate selectedTenant:tenant];
}

#pragma mark MGSwipeTableCellDelegate methods

- (void)swipeTableCellWillBeginSwiping:(MGSwipeTableCell *)cell {
    self.isCellExpanded = YES;
}

- (void)swipeTableCellWillEndSwiping:(MGSwipeTableCell *)cell {
    self.isCellExpanded = NO;
}

@end
