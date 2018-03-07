//
//  GGPFeaturedTableViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/24/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAlertViewController.h"
#import "GGPCallToRegisterViewController.h"
#import "GGPFeaturedTableViewController.h"
#import "GGPHeroViewController.h"
#import "GGPNowOpenViewController.h"
#import "GGPSale.h"
#import "GGPShoppingDetailViewController.h"
#import "GGPSpinner.h"
#import "GGPTodaysHoursViewController.h"
#import "GGPViewCell.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

static NSInteger const kNumSections = 7;
static NSInteger const kAlertSection = 0;
static NSInteger const kHoursSection = 1;
static NSInteger const kNowOpenSection = 2;
static NSInteger const kRegisterSection = 3;
static NSInteger const kFeaturedSaleSection = 4;
static NSInteger const kHeroSection = 5;
static NSInteger const kSalesSection = 6;

static NSString *const kEndDateTimeSortKey = @"endDateTime";

@interface GGPHomeFeedTableViewController (Featured)

- (void)configureTodaysHours;
- (void)endRefreshing;
- (void)fetchHeroWithGroup:(dispatch_group_t)group;
- (void)fetchAlertsWithGroup:(dispatch_group_t)group;
- (void)fetchTenantsWithGroup:(dispatch_group_t)group;

- (UITableViewCell *)alertCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)heroCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)hoursCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)featuredSaleCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)saleCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)nowOpenCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@property (assign, nonatomic) BOOL finishedInitialDataFetch;
@property (assign, nonatomic) NSInteger currentSalesPage;
@property (assign, nonatomic) NSInteger numberOfSalesPages;
@property (strong, nonatomic) NSMutableDictionary *saleImageLookup;
@property (strong, nonatomic) NSArray *sales;
@property (strong, nonatomic) GGPSale *featuredSale;
@property (strong, nonatomic) GGPAlertViewController *alertViewController;
@property (strong, nonatomic) GGPTodaysHoursViewController *todaysHoursViewController;
@property (strong, nonatomic) GGPNowOpenViewController *nowOpenViewController;
@property (strong, nonatomic) GGPHeroViewController *heroViewController;

@end

@interface GGPFeaturedTableViewController ()

@property (strong, nonatomic) GGPCallToRegisterViewController *registerViewController;

@end

@implementation GGPFeaturedTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = [@"FEATURED_TITLE" ggp_toLocalized];
    }
    return self;
}

- (void)fetchData {
    [self configureTodaysHours];
    [self configureCallToRegister];
    
    dispatch_group_t group = dispatch_group_create();
    
    // subsequently fetches sales too to avoid stacking fetch tenant calls
    [self fetchTenantsWithGroup:group];
    
    [self fetchHeroWithGroup:group];
    [self fetchAlertsWithGroup:group];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [GGPSpinner hideForView:self.view];
        [self endRefreshing];
        self.finishedInitialDataFetch = YES;
        [self.tableView reloadData];
    });
}

#pragma mark - Register

- (UITableViewCell *)registerCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    GGPViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPViewCellId forIndexPath:indexPath];
    [cell configureWithView:self.registerViewController.view];
    return cell;
}

- (void)configureCallToRegister {
    self.registerViewController = [GGPCallToRegisterViewController new];
    self.registerViewController.presenterDelegate = self;
}

#pragma mark - Sales

- (NSArray *)filteredSalesFromSales:(NSArray *)sales {
    NSArray *filteredSales = [sales ggp_arrayWithFilter:^BOOL(GGPSale *sale) {
        return sale.isTopRetailer;
    }];
    
    return [filteredSales ggp_sortListAscendingForKey:kEndDateTimeSortKey];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.finishedInitialDataFetch) {
        return 0;
    }
    
    switch (section) {
        case kAlertSection:
            return self.alertViewController == nil ? 0 : 1;
        case kHoursSection:
            return 1;
        case kNowOpenSection:
            return self.nowOpenViewController == nil ? 0 : 1;
        case kRegisterSection:
            return 1;
        case kFeaturedSaleSection:
            return self.featuredSale == nil ? 0 : 1;
        case kHeroSection:
            return self.heroViewController == nil ? 0 : 1;
        case kSalesSection:
            return self.saleImageLookup.count + 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case kAlertSection:
            return [self alertCellForTableView:tableView andIndexPath:indexPath];
        case kHoursSection:
            return [self hoursCellForTableView:tableView andIndexPath:indexPath];
        case kNowOpenSection:
            return [self nowOpenCellForTableView:tableView andIndexPath:indexPath];
        case kRegisterSection:
            return [self registerCellForTableView:tableView andIndexPath:indexPath];
        case kFeaturedSaleSection:
            return [self featuredSaleCellForTableView:tableView andIndexPath:indexPath];
        case kHeroSection:
            return [self heroCellForTableView:tableView andIndexPath:indexPath];
        case kSalesSection:
            return [self saleCellForTableView:tableView andIndexPath:indexPath];
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kFeaturedSaleSection) {
        [self.navigationController pushViewController:[[GGPShoppingDetailViewController alloc] initWithSale:self.featuredSale] animated:YES];
    } else if (indexPath.section == kSalesSection && indexPath.row < self.saleImageLookup.count) {
        [self.navigationController pushViewController:[[GGPShoppingDetailViewController alloc] initWithSale:self.sales[indexPath.row]] animated:YES];
    }
}

@end
