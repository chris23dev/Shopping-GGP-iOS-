//
//  GGPHomeFeedTableViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAlert.h"
#import "GGPAlertViewController.h"
#import "GGPCategory.h"
#import "GGPChooseFavoritesCell.h"
#import "GGPFavoriteTenantsViewController.h"
#import "GGPHero.h"
#import "GGPHeroViewController.h"
#import "GGPHomeFeedTableViewController.h"
#import "GGPHomePromotionTableViewCell.h"
#import "GGPJMapManager.h"
#import "GGPLoadingCell.h"
#import "GGPMallManager.h"
#import "GGPMall.h"
#import "GGPMallRepository.h"
#import "GGPModalViewController.h"
#import "GGPNowOpenViewController.h"
#import "GGPSale.h"
#import "GGPSpinner.h"
#import "GGPTenant.h"
#import "GGPTenantDetailViewController.h"
#import "GGPTodaysHoursViewController.h"
#import "GGPUpToDateCell.h"
#import "GGPViewCell.h"
#import "GGPWayfindingViewController.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIImage+GGPAdditions.h"


static NSInteger const kSalesPageSize = 10;
static NSString *const kTenantOpenDateSortKey = @"tenantOpenDate";

@interface GGPHomeFeedTableViewController () <GGPPromotionCellDelegate>

@property (assign, nonatomic) NSInteger currentSalesPage;
@property (assign, nonatomic) NSInteger numberOfSalesPages;
@property (assign, nonatomic) BOOL finishedInitialDataFetch;
@property (strong, nonatomic) NSMutableDictionary *saleImageLookup;
@property (strong, nonatomic) NSArray *sales;
@property (strong, nonatomic) NSArray *tenants;
@property (strong, nonatomic) UIImage *featuredSaleImage;
@property (strong, nonatomic) GGPSale *featuredSale;
@property (strong, nonatomic) GGPAlertViewController *alertViewController;
@property (strong, nonatomic) GGPTodaysHoursViewController *todaysHoursViewController;
@property (strong, nonatomic) GGPNowOpenViewController *nowOpenViewController;
@property (strong, nonatomic) GGPHeroViewController *heroViewController;

@end

@implementation GGPHomeFeedTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.saleImageLookup = [NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:GGPUserFavoritesUpdatedNotification object:nil];
    
    [GGPSpinner showForView:self.view];
    [self configureTableView];
    [self fetchData];
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor ggp_gainsboroGray];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPHomePromotionTableViewCell" bundle:nil] forCellReuseIdentifier:GGPHomePromotionTableViewCellReuseIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPChooseFavoritesCell" bundle:nil] forCellReuseIdentifier:GGChooseFavoritesCellReuseIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPUpToDateCell" bundle:nil] forCellReuseIdentifier:GGPUpToDateCellId];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPLoadingCell" bundle:nil] forCellReuseIdentifier:GGPLoadingCellId];
    
    [self.tableView registerClass:GGPViewCell.class forCellReuseIdentifier:GGPViewCellId];
}

- (void)fetchData {
    GGPMustOverride;
}

- (void)endRefreshing {
    [self.refreshControl endRefreshing];
}

#pragma mark - Alert

- (UITableViewCell *)alertCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    GGPViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPViewCellId forIndexPath:indexPath];
    [cell configureWithView:self.alertViewController.view];
    return cell;
}

- (void)fetchAlertsWithGroup:(dispatch_group_t)group {
    dispatch_group_enter(group);
    
    [GGPMallRepository fetchAlertsWithCompletion:^(NSArray *alerts) {
        GGPAlert *alert = alerts.firstObject;
        self.alertViewController = [alert isValidStartDate] ?
        [[GGPAlertViewController alloc] initWithAlert:alert] :
        nil;
        
        dispatch_group_leave(group);
    }];
}

#pragma mark - Hours

- (UITableViewCell *)hoursCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    GGPViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPViewCellId forIndexPath:indexPath];
    [cell configureWithView:self.todaysHoursViewController.view];
    return cell;
}

- (void)configureTodaysHours {
    self.todaysHoursViewController = [GGPTodaysHoursViewController new];
}

#pragma mark - Now Open

- (UITableViewCell *)nowOpenCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    GGPViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPViewCellId forIndexPath:indexPath];
    [cell configureWithView:self.nowOpenViewController.view];
    return cell;
}

- (void)fetchTenantsWithGroup:(dispatch_group_t)group {
    dispatch_group_enter(group);
    
    [GGPMallRepository fetchTenantsWithCompletion:^(NSArray *tenants) {
        NSArray *nowOpenTenants = [self allUniqueNowOpenTenantsFromTenants:tenants];
        self.nowOpenViewController = nowOpenTenants.count > 0 ?
        [[GGPNowOpenViewController alloc] initWithTenants:nowOpenTenants] :
        nil;
        self.tenants = tenants;
        self.nowOpenViewController.presenterDelegate = self;
        [self fetchSalesWithTenants:self.tenants andGroup:group];
        dispatch_group_leave(group);
    }];
}

- (NSArray *)allUniqueNowOpenTenantsFromTenants:(NSArray *)tenants {
    NSMutableArray *uniqueNowOpenTenants = [NSMutableArray new];
    [uniqueNowOpenTenants addObjectsFromArray:[self featuredOpeningTenantsFromTenants:tenants]];
    [uniqueNowOpenTenants addObjectsFromArray:[self allNowOpenTenantsFromTenants:tenants]];
    return [uniqueNowOpenTenants ggp_removeDuplicates];
}

- (NSArray *)featuredOpeningTenantsFromTenants:(NSArray *)tenants {
    NSArray *featuredOpeningTenants = [tenants ggp_arrayWithFilter:^BOOL(GGPTenant *tenant) {
        return tenant.isFeaturedOpening;
    }];
    return [featuredOpeningTenants ggp_sortListDescendingForKey:kTenantOpenDateSortKey];
}

- (NSArray *)allNowOpenTenantsFromTenants:(NSArray *)tenants {
    NSArray *featuredOpeningTenants = [tenants ggp_arrayWithFilter:^BOOL(GGPTenant *tenant) {
        return [tenant.categories ggp_anyWithFilter:^BOOL(GGPCategory *category) {
            return [category.code isEqualToString:GGPCategoryTenantOpeningsCode];
        }];
    }];
    return [featuredOpeningTenants ggp_sortListDescendingForKey:kTenantOpenDateSortKey];
}

#pragma mark - Featured Sale

- (UITableViewCell *)featuredSaleCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    GGPHomePromotionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPHomePromotionTableViewCellReuseIdentifier forIndexPath:indexPath];
    cell.cellDelegate = self;
    [cell configureWithPromotion:self.featuredSale andImage:self.featuredSaleImage];
    return cell;
}

#pragma mark - Choose Favorites Cell

- (UITableViewCell *)chooseFavoritesCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    GGPChooseFavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:GGChooseFavoritesCellReuseIdentifier forIndexPath:indexPath];
    
    [cell configureWithTenants:self.tenants];
    
    cell.onChooseFavoritesTapped = ^{
        GGPModalViewController *modalViewController = [[GGPModalViewController alloc] initWithRootViewController:[GGPFavoriteTenantsViewController new] andOnClose:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [weakSelf presentViewController:modalViewController animated:YES completion:nil];
    };
    
    return cell;
}

#pragma mark - Hero

- (UITableViewCell *)heroCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    GGPViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPViewCellId forIndexPath:indexPath];
    [cell configureWithView:self.heroViewController.view];
    return cell;
}

- (void)fetchHeroWithGroup:(dispatch_group_t)group {
    dispatch_group_enter(group);
    
    [GGPMallRepository fetchHeroesWithCompletion:^(NSArray *heroes) {
        GGPHero *hero = [self heroForDisplayFromHeroes:heroes];
        [UIImage ggp_fetchImageWithUrl:[NSURL URLWithString:hero.imageUrl] completion:^(UIImage *image) {
            self.heroViewController = hero ? [[GGPHeroViewController alloc] initWithHero:hero andImage:image] : nil;
            dispatch_group_leave(group);
        }];
    }];
}

- (GGPHero *)heroForDisplayFromHeroes:(NSArray *)heroes {
    NSDate *today = [NSDate date];
    for (GGPHero *hero in heroes) {
        if ([today ggp_isBetweenStartDate:hero.startDate andEndDate:hero.endDate withGranularity:NSCalendarUnitDay]) {
            return hero;
        }
    }
    return nil;
}

#pragma mark - Sales

- (UITableViewCell *)saleCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    if ([self shouldShowPromotionCellForRow:indexPath.row]) {
        return [self promotionCellForTableView:tableView andIndexPath:indexPath];
    } else if ([self shouldShowLoadingCell]) {
        return [self loadingCellForTableView:tableView andIndexPath:indexPath];
    }
    return [self upToDateCellForTableView:tableView andIndexPath:indexPath];
}

- (UITableViewCell *)promotionCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    GGPHomePromotionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPHomePromotionTableViewCellReuseIdentifier forIndexPath:indexPath];
    cell.cellDelegate = self;
    GGPSale *sale = self.sales[indexPath.row];
    UIImage *image = [self.saleImageLookup objectForKey:@(sale.promotionId)];
    [cell configureWithPromotion:sale andImage:image];
    
    return cell;
}

- (UITableViewCell *)loadingCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    [self fetchPagedSalesImageForSales:self.sales completion:^{
        [self.tableView reloadData];
    }];
    
    GGPLoadingCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPLoadingCellId forIndexPath:indexPath];
    [cell startLoading];
    
    return cell;
}

- (UITableViewCell *)upToDateCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    GGPUpToDateCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPUpToDateCellId forIndexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    cell.onChooseFavoritesTapped = ^{
        GGPModalViewController *modalViewController = [[GGPModalViewController alloc] initWithRootViewController:[GGPFavoriteTenantsViewController new] andOnClose:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [weakSelf presentViewController:modalViewController animated:YES completion:nil];
    };
    
    if ([self shouldShowUpToDateChooseFavorites]) {
        [cell showChooseFavorites];
    } else {
        [cell hideChooseFavorites];
    }
    
    return cell;
}

- (BOOL)shouldShowPromotionCellForRow:(NSInteger)row {
    return self.saleImageLookup.count > 0 && row <= self.saleImageLookup.count - 1;
}

- (BOOL)shouldShowLoadingCell {
    return self.sales.count > self.saleImageLookup.count;
}

- (BOOL)shouldShowUpToDateChooseFavorites {
    return [GGPAccount isLoggedIn] && self.featuredSale;
}

- (void)fetchSalesWithTenants:(NSArray *)tenants andGroup:(dispatch_group_t)group {
    dispatch_group_enter(group);
    
    [GGPMallRepository fetchSalesWithTenants:tenants andCompletion:^(NSArray *sales) {
        NSMutableArray *filteredSales = [self filteredSalesFromSales:sales].mutableCopy;
        
        self.featuredSale = nil;
        self.featuredSaleImage = nil;
        
        if (filteredSales.count > 0) {
            NSInteger randomIndex = arc4random_uniform((uint32_t)filteredSales.count);
            self.featuredSale = filteredSales[randomIndex];
            
            dispatch_group_enter(group);
            [UIImage ggp_fetchImageWithUrl:self.featuredSale.imageUrl completion:^(UIImage *image) {
                self.featuredSaleImage = image;
                dispatch_group_leave(group);
            }];
        }
        
        [filteredSales removeObject:self.featuredSale];
        self.sales = filteredSales;
        
        [self fetchPagedSalesImageForSales:self.sales completion:^{
            dispatch_group_leave(group);
        }];
    }];
}

- (void)setSales:(NSArray *)sales {
    _sales = sales;
    self.saleImageLookup = [NSMutableDictionary new];
    self.currentSalesPage = 0;
    self.numberOfSalesPages = [self numberOfPagesForItemCount:sales.count andPageSize:kSalesPageSize];
}

- (void)fetchPagedSalesImageForSales:(NSArray *)sales completion:(void(^)())completion {
    if (self.currentSalesPage == self.numberOfSalesPages) {
        if (completion) {
            completion();
        }
        return;
    }
    
    self.currentSalesPage++;
    NSInteger startIndex = [self startIndexForPage:self.currentSalesPage withPageSize:kSalesPageSize];
    NSInteger length = [self pageFetchLengthForCurrentPage:self.currentSalesPage totalPages:self.numberOfSalesPages pageSize:kSalesPageSize andItemCount:sales.count];
    
    NSArray *pagedSales = [sales subarrayWithRange:NSMakeRange(startIndex, length)];
    
    [UIImage ggp_fetchImagesForPromotions:pagedSales intoLookup:self.saleImageLookup completion:^{
        if (completion) {
            completion();
        }
    }];
}

- (NSInteger)numberOfPagesForItemCount:(NSInteger)itemCount andPageSize:(NSInteger)pageSize {
    if (pageSize == 0) {
        return 0;
    }
    
    NSInteger pages = itemCount / pageSize;
    if (itemCount % pageSize > 0) {
        pages++;
    }
    return pages;
}

- (NSInteger)startIndexForPage:(NSInteger)page withPageSize:(NSInteger)pageSize {
    return (page - 1) * kSalesPageSize;
}

- (NSInteger)pageFetchLengthForCurrentPage:(NSInteger)currentPage totalPages:(NSInteger)totalPages pageSize:(NSInteger)pageSize andItemCount:(NSInteger)itemCount {
    if (currentPage < totalPages) {
        return pageSize;
    }
    
    NSInteger mod = itemCount % pageSize;
    return mod == 0 ? pageSize : mod;
}

- (NSArray *)filteredSalesFromSales:(NSArray *)sales {
   GGPMustOverride;
}

#pragma mark - GGPPresenterDelegate methods

- (void)presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)pushViewController:(UIViewController *)viewController {
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - GGPPromotionCellDelegate

- (void)didTapPostOptionsWithPromotion:(GGPPromotion *)promotion {
    UIAlertController *shareOptions = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (UIAlertAction *action in [self alertActionsForPromotion:promotion]) {
        [shareOptions addAction:action];
    }
    
    [self.navigationController presentViewController:shareOptions animated:YES completion:nil];
}

- (NSArray *)alertActionsForPromotion:(GGPPromotion *)promotion {
    NSMutableArray *shareActions = [NSMutableArray new];
    
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:[@"POST_OPTIONS_SHARE" ggp_toLocalized] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareActionTappedWithPromotion:promotion];
    }];
    [shareActions addObject:shareAction];
    
    if ([[GGPJMapManager shared] wayfindingAvailableForTenant:promotion.tenant]) {
        UIAlertAction *guideMeAction = [UIAlertAction actionWithTitle:[@"POST_OPTIONS_GUIDE_ME" ggp_toLocalized] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self guideMeActionTappedWithPromotion:promotion];
        }];
        [shareActions addObject:guideMeAction];
    }
    
    UIAlertAction *detailsAction = [UIAlertAction actionWithTitle:[@"POST_OPTIONS_STORE_DETAILS" ggp_toLocalized] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self detailsActionTappedWithPromotion:promotion];
    }];
    [shareActions addObject:detailsAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[@"POST_OPTIONS_CANCEL" ggp_toLocalized] style:UIAlertActionStyleCancel handler:nil];
    [shareActions addObject:cancelAction];
    
    return shareActions;
}

#pragma mark - Post options tap handlers

- (void)shareActionTappedWithPromotion:(GGPPromotion *)promotion {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[promotion] applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
}

- (void)guideMeActionTappedWithPromotion:(GGPPromotion *)promotion {
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTenantGuideMe withData:nil andTenant:promotion.tenant.name];
    
    GGPWayfindingViewController *viewController = [[GGPWayfindingViewController alloc] initWithTenant:promotion.tenant];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)detailsActionTappedWithPromotion:(GGPPromotion *)promotion {
    GGPTenantDetailViewController *viewController = [[GGPTenantDetailViewController alloc] initWithTenantDetails:promotion.tenant];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
