//
//  GGPJustForYouTableViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAlert.h"
#import "GGPAlertViewController.h"
#import "GGPCategory.h"
#import "GGPEvent.h"
#import "GGPEventDetailViewController.h"
#import "GGPFeaturedTableViewController.h"
#import "GGPHero.h"
#import "GGPHeroViewController.h"
#import "GGPHomePromotionTableViewCell.h"
#import "GGPJustForYouTableViewController.h"
#import "GGPMallRepository.h"
#import "GGPNowOpenViewController.h"
#import "GGPSale.h"
#import "GGPShoppingDetailViewController.h"
#import "GGPSpinner.h"
#import "GGPTenant.h"
#import "GGPTenantDetailViewController.h"
#import "GGPTodaysHoursViewController.h"
#import "GGPViewCell.h"
#import "NSArray+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIImage+GGPAdditions.h"
#import <AFNetworking/AFNetworking.h>

static NSInteger const kNumSections = 8;
static NSInteger const kAlertSection = 0;
static NSInteger const kHoursSection = 1;
static NSInteger const kFeaturedSaleSection = 2;
static NSInteger const kChooseFavoritesSection = 3;
static NSInteger const kNowOpenSection = 4;
static NSInteger const kHeroSection = 5;
static NSInteger const kEventsSection = 6;
static NSInteger const kSalesSection = 7;

static NSString *const kEndDateTimeSortKey = @"endDateTime";

@interface GGPHomeFeedTableViewController (JustForYou)

- (void)configureTodaysHours;
- (void)endRefreshing;
- (void)fetchHeroWithGroup:(dispatch_group_t)group;
- (void)fetchAlertsWithGroup:(dispatch_group_t)group;
- (void)fetchTenantsWithGroup:(dispatch_group_t)group;

- (UITableViewCell *)alertCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)heroCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)hoursCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)featuredSaleCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)chooseFavoritesCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)saleCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)nowOpenCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@property (assign, nonatomic) BOOL finishedInitialDataFetch;
@property (strong, nonatomic) NSMutableDictionary *saleImageLookup;
@property (strong, nonatomic) NSArray *sales;
@property (strong, nonatomic) GGPSale *featuredSale;
@property (strong, nonatomic) GGPAlertViewController *alertViewController;
@property (strong, nonatomic) GGPTodaysHoursViewController *todaysHoursViewController;
@property (strong, nonatomic) GGPNowOpenViewController *nowOpenViewController;
@property (strong, nonatomic) GGPHeroViewController *heroViewController;

@end

@interface GGPJustForYouTableViewController ()

@property (strong, nonatomic) NSMutableDictionary *eventImageLookup;
@property (strong, nonatomic) NSArray *events;

@end

@implementation GGPJustForYouTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = [@"JUST_FOR_YOU_TITLE" ggp_toLocalized];
        self.eventImageLookup = [NSMutableDictionary new];
    }
    return self;
}

- (void)fetchData {
    [self configureTodaysHours];
    
    dispatch_group_t group = dispatch_group_create();
    
    // subsequently fetches sales too to avoid stacking fetch tenant calls
    [self fetchTenantsWithGroup:group];
    
    [self fetchHeroWithGroup:group];
    [self fetchEventsWithGroup:group];
    [self fetchAlertsWithGroup:group];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [GGPSpinner hideForView:self.view];
        [self endRefreshing];
        self.finishedInitialDataFetch = YES;
        [self.tableView reloadData];
    });
}

#pragma mark - Sales

- (NSArray *)filteredSalesFromSales:(NSArray *)sales {
    NSArray *filteredSales = [sales ggp_arrayWithFilter:^BOOL(GGPSale *sale) {
        return sale.tenant.isFavorite;
    }];
    return [filteredSales ggp_sortListAscendingForKey:kEndDateTimeSortKey];
}

#pragma mark - Events

- (UITableViewCell *)eventCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    GGPHomePromotionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPHomePromotionTableViewCellReuseIdentifier forIndexPath:indexPath];
    GGPEvent *event = self.events[indexPath.row];
    UIImage *image = [self.eventImageLookup objectForKey:@(event.promotionId)];
    [cell configureWithPromotion:event andImage:image];
    return cell;
}

- (void)fetchEventsWithGroup:(dispatch_group_t)group {
    dispatch_group_enter(group);
    [GGPMallRepository fetchEventsWithCompletion:^(NSArray *events) {
        self.events = [self favoriteEventsFromEvents:events];
        [UIImage ggp_fetchImagesForPromotions:self.events intoLookup:self.eventImageLookup completion:^{
            dispatch_group_leave(group);
        }];
    }];
}

- (NSArray *)favoriteEventsFromEvents:(NSArray *)events {
    NSArray *eventsForFavoriteTenants = [events ggp_arrayWithFilter:^BOOL(GGPEvent *event) {
        return event.tenant.isFavorite;
    }];
    return [eventsForFavoriteTenants ggp_sortListAscendingForKey:kEndDateTimeSortKey];
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
        case kFeaturedSaleSection:
            return self.featuredSale == nil ? 0 : 1;
        case kChooseFavoritesSection:
            return !self.featuredSale ? 1 : 0;
        case kNowOpenSection:
            return self.nowOpenViewController == nil ? 0 : 1;
        case kHeroSection:
            return self.heroViewController == nil ? 0 : 1;
        case kEventsSection:
            return self.events.count;
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
        case kChooseFavoritesSection:
            return [self chooseFavoritesCellForTableView:tableView andIndexPath:indexPath];
        case kFeaturedSaleSection:
            return [self featuredSaleCellForTableView:tableView andIndexPath:indexPath];
        case kNowOpenSection:
            return [self nowOpenCellForTableView:tableView andIndexPath:indexPath];
        case kHeroSection:
            return [self heroCellForTableView:tableView andIndexPath:indexPath];
        case kEventsSection:
            return [self eventCellForTableView:tableView andIndexPath:indexPath];
        case kSalesSection:
            return [self saleCellForTableView:tableView andIndexPath:indexPath];
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    
    if (section == kFeaturedSaleSection) {
        [self.navigationController pushViewController:[[GGPShoppingDetailViewController alloc] initWithSale:self.featuredSale] animated:YES];
    } else if (section == kSalesSection && indexPath.row < self.saleImageLookup.count) {
        [self.navigationController pushViewController:[[GGPShoppingDetailViewController alloc] initWithSale:self.sales[indexPath.row]] animated:YES];
    } else if (section == kEventsSection) {
        [self.navigationController pushViewController:[[GGPEventDetailViewController alloc] initWithEvent:self.events[indexPath.row]] animated:YES];
    }
}

@end
