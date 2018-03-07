//
//  GGPDirectorytViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/16/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAuthenticationController.h"
#import "GGPAuthenticationDelegate.h"
#import "GGPCategory.h"
#import "GGPDirectoryFilterViewController.h"
#import "GGPDirectoryMapViewController.h"
#import "GGPDirectoryViewController.h"
#import "GGPFeedbackManager.h"
#import "GGPFilterItem.h"
#import "GGPFilterLandingViewController.h"
#import "GGPFilterShowcaseViewController.h"
#import "GGPJMapManager.h"
#import "GGPJmapViewController+Highlighting.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPMallManager.h"
#import "GGPMallRepository.h"
#import "GGPMessageViewController.h"
#import "GGPModalViewController.h"
#import "GGPNotificationConstants.h"
#import "GGPProduct.h"
#import "GGPSpinner.h"
#import "GGPTenantDetailViewController.h"
#import "GGPTenantListDelegate.h"
#import "GGPTenantTableViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIImage+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIStackView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSString *const kHasViewedFilterShowcaseKey = @"GGPHasViewedFilterShowcase";

@interface GGPDirectoryViewController () <GGPTenantListDelegate, GGPJMapViewControllerDelegate, GGPAuthenticationDelegate, GGPFilterSelectionDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *selectedFilterContainer;
@property (weak, nonatomic) IBOutlet UIView *filterMessageContainer;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) GGPDirectoryFilterViewController *directoryFilterViewController;
@property (strong, nonatomic) GGPTenantTableViewController *tableViewController;
@property (strong, nonatomic) GGPDirectoryMapViewController *mapViewController;
@property (strong, nonatomic) GGPFilterLandingViewController *filterLandingViewController;
@property (strong, nonatomic) GGPModalViewController *filterModalViewController;
@property (strong, nonatomic) GGPFilterShowcaseViewController *showcaseViewController;
@property (strong, nonatomic) UIBarButtonItem *filterButton;
@property (strong, nonatomic) NSArray *tenants;
@property (strong, nonatomic) NSArray *filteredTenants;
@property (strong, nonatomic) NSArray *searchResultTenants;
@property (strong, nonatomic) id<GGPFilterItem> selectedFilter;
@property (assign, nonatomic) BOOL shouldShowFilterDescriptionLabel;

@end

@implementation GGPDirectoryViewController

- (instancetype)initWithSelectedFilter:(id<GGPFilterItem>)selectedFilter {
    self = [super init];
    if (self) {
        self.selectedFilter = selectedFilter;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotifications];
    [self configureControls];
    [self retrieveTenants];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [GGPJMapManager shared].mapViewController.mapViewControllerDelegate = self;
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenDirectory];
    
    [self configureNavigationBar];
    
    // We need to refresh here to handle the case of favoriting/unfavoriting a tenant
    // then using the back button while filtered on My Favorites
    [self refreshForSelectedFilter];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[GGPJMapManager shared].mapViewController highlightTenants:self.filteredTenants];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[GGPJMapManager shared].mapViewController resetMapViewAndFilters:YES];
    [GGPJMapManager shared].mapViewController.showAmenityFilter = NO;
    [GGPJMapManager shared].mapViewController.mapViewControllerDelegate = nil;
    [self.searchBar endEditing:YES];
    [super viewWillDisappear:animated];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTappedFilter:) name:GGPDirectoryFilterSelectedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveTenants) name:GGPClientTenantsUpdatedNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GGPDirectoryFilterSelectedNotification object:nil];
}

- (void)configureControls {
    [GGPSpinner showForView:self.view];
    
    self.filterLandingViewController = [GGPFilterLandingViewController new];
    self.mapViewController = [GGPDirectoryMapViewController new];
    
    self.tableViewController = [GGPTenantTableViewController new];
    self.tableViewController.delegate = self;
    
    [self configureFilterButton];
    [self configureRibbon];
    [self configureFilterViewController];
    [self configureSearchBar];
    [self configureFilterShowcase];
}

- (void)configureFilterShowcase {
    BOOL hasViewed = [[NSUserDefaults standardUserDefaults] boolForKey:kHasViewedFilterShowcaseKey];
    if (!hasViewed && [GGPMallManager shared].selectedMall.config.productEnabled) {
        self.showcaseViewController = [GGPFilterShowcaseViewController new];
        
        __weak typeof(self) weakSelf = self;
        self.showcaseViewController.onViewTapped = ^() {
            [weakSelf dismissShowcase];
        };
        
        [self ggp_addChildViewController:self.showcaseViewController toPlaceholderView:self.view];
    }
}

- (void)configureFilterButton {
    NSDictionary *attrs = @{ NSForegroundColorAttributeName: [UIColor whiteColor],
                             NSFontAttributeName: [UIFont ggp_regularWithSize:14] };
    self.filterButton = [[UIBarButtonItem alloc] initWithTitle:[@"FILTER_BUTTON" ggp_toLocalized] style:UIBarButtonItemStylePlain target:self action:@selector(filterButtonTapped)];
    [self.filterButton setTitleTextAttributes:attrs forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = self.filterButton;
}

- (void)configureRibbon {
    self.tableViewController.title = [@"DIRECTORY_LIST_TITLE" ggp_toLocalized];

    __weak typeof(self)weakSelf = self;
    
    [self addRibbonController:self.tableViewController withTapHandler:^{
        [weakSelf trackViewType:GGPAnalyticsContextDataDirectoryViewTypeList];
        [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenDirectory];
        if (weakSelf.selectedFilter == nil) {
            [weakSelf.searchBar ggp_expandVertically];
        }
    }];
    
    [self addRibbonController:self.mapViewController withTapHandler:^{
        [GGPFeedbackManager trackAction];
        [weakSelf trackViewType:GGPAnalyticsContextDataDirectoryViewTypeMap];
        [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenDirectoryMap];
        [weakSelf.searchBar endEditing:YES];
        [weakSelf.searchBar ggp_collapseVertically];
    }];
}

- (void)configureFilterViewController {
    self.directoryFilterViewController = [[GGPDirectoryFilterViewController alloc] initWithFilterSelectionDelegate:self];
    
    [self.directoryFilterViewController configureWithFilter:self.selectedFilter];
    
    [self ggp_addChildViewController:self.directoryFilterViewController
                   toPlaceholderView:self.selectedFilterContainer];
}

- (void)configureSearchBar {
    self.searchBar.delegate = self;
    self.searchBar.placeholder = [@"DIRECTORY_SEARCH_PLACEHOLDER" ggp_toLocalized];
    self.searchBar.showsCancelButton = YES;
}

- (void)configureNavigationBar {
    [self.navigationController ggp_configureWithLightText];
    self.navigationController.navigationBar.barTintColor = [UIColor ggp_navigationBar];
    self.navigationItem.title = [@"DIRECTORY_TITLE" ggp_toLocalized];
}

- (void)retrieveTenants {
    [GGPMallRepository fetchTenantsWithCompletion:^(NSArray *tenants) {
        [GGPSpinner hideForView:self.view];
        
        self.tenants = tenants;
        [self.tableViewController configureWithTenants:tenants];
        [self refreshForSelectedFilter];
    }];
}

- (void)trackViewType:(NSString *)viewType {
    NSDictionary *data = @{ GGPAnalyticsContextDataDirectoryViewType: viewType };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionDirectoryChangeView withData:data];
}

- (void)handleNoFavorites {
    GGPMessageViewController *filterMessageViewController;
    if (![GGPAccount isLoggedIn]) {
        filterMessageViewController = [self createFilterMessageViewControllerForUnauthenticatedUser];
    } else {
        filterMessageViewController = [self createFilterMessageViewControllerForNoFavorites];
    }
    
    [self ggp_addChildViewController:filterMessageViewController toPlaceholderView:self.filterMessageContainer];
    self.filterMessageContainer.hidden = NO;
}

- (GGPMessageViewController *)createFilterMessageViewControllerForUnauthenticatedUser {
    __weak typeof(self) weakSelf = self;
    return [[GGPMessageViewController alloc] initWithImage:[UIImage imageNamed:@"ggp_tenant_heart_gray"]headline:[@"DIRECTORY_UNAUTHENTICATED_HEADLINE" ggp_toLocalized] body:[@"DIRECTORY_UNAUTHENTICATED_BODY" ggp_toLocalized] actionTitle:[@"REGISTER_BUTTON_TITLE" ggp_toLocalized] actionTapHandler:^{
        [[GGPAnalytics shared] trackAction:GGPAnalyticsActionDirectoryRegister withData:nil];
        [weakSelf presentAuthentication];
    }];
}

- (GGPMessageViewController *)createFilterMessageViewControllerForNoFavorites {
    return [[GGPMessageViewController alloc] initWithImage:[UIImage imageNamed:@"ggp_tenant_heart_gray"] headline:[@"DIRECTORY_NO_FAVORITES_HEADLINE" ggp_toLocalized] andBody:[@"DIRECTORY_NO_FAVORITES_BODY" ggp_toLocalized]];
}

- (void)presentAuthentication {
    GGPAuthenticationController *authController = [GGPAuthenticationController authenticationControllerForRegistration];
    authController.authenticationDelegate = self;
    [self presentViewController:authController animated:YES completion:nil];
}

#pragma mark - FilterSelectedNotification

- (void)handleTappedFilter:(NSNotification *)notification {
    id<GGPFilterItem> filter = notification.userInfo[GGPFilterSelectedUserInfoKey];
    [self filterSelected:filter];
}

#pragma mark - Filter interactions

- (void)filterSelected:(id<GGPFilterItem>)selectedFilter {
    self.filterMessageContainer.hidden = YES;
    self.selectedFilter = selectedFilter;
    self.searchBar.text = nil;
    
    [self filterListForSelectedFilter];
}

- (void)filterListForSelectedFilter {
    self.filteredTenants = self.selectedFilter.filteredItems;
    
    [self.searchBar ggp_collapseVertically];
    [self.tableViewController configureWithTenants:self.filteredTenants hideAlpha:YES];
    [self.directoryFilterViewController configureWithFilter:self.selectedFilter];
    
    [[GGPJMapManager shared].mapViewController highlightTenants:self.filteredTenants];
    
    if (self.isUserFavoritesCodeNoFavorites) {
        [self handleNoFavorites];
    }
}

- (BOOL)isUserFavoritesCodeNoFavorites {
    return [self.selectedFilter.code isEqualToString:GGPCategoryUserFavoritesCode] &&
            self.filteredTenants.count == 0;
}

- (void)filterButtonTapped {
    if (self.showcaseViewController) {
        [self dismissShowcase];
    }
    
    self.filterModalViewController = [[GGPModalViewController alloc] initWithRootViewController:self.filterLandingViewController andOnClose:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:self.filterModalViewController animated:YES completion:nil];
}

- (void)dismissShowcase {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHasViewedFilterShowcaseKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.showcaseViewController ggp_removeFromParentViewController];
    self.showcaseViewController = nil;
}

- (void)refreshForSelectedFilter {
    if (self.selectedFilter) {
        [self filterSelected:self.selectedFilter];
    }
    
    [GGPJMapManager shared].mapViewController.showAmenityFilter = !self.selectedFilter;
}

#pragma mark - GGPFilterSelectionDelegate

- (void)selectedFilterCleared {
    self.selectedFilter = nil;
    [self.searchBar ggp_expandVertically];
    [self.directoryFilterViewController clearStackView];
    [self.tableViewController configureWithTenants:self.tenants];
    [[GGPJMapManager shared].mapViewController resetMapViewAndFilters:YES];
    [GGPJMapManager shared].mapViewController.showAmenityFilter = YES;
}

#pragma mark - GGPDirectoryListDelegate

- (void)selectedTenant:(GGPTenant *)tenant {
    GGPTenantDetailViewController *tenantViewController = [[GGPTenantDetailViewController alloc] initWithTenantDetails:tenant];
    [self.navigationController pushViewController:tenantViewController animated:YES];
}

#pragma mark - GGPJMapDelegate

- (GGPTenant *)tenantFromLeaseId:(NSString *)leaseId {
    for (GGPTenant *tenant in self.tenants) {
        if ([leaseId isEqual:[NSString stringWithFormat:@"%ld", (long)tenant.leaseId]]) {
            return tenant;
        }
    }
    return nil;
}

#pragma mark - GGPAuthenticationDelegate

- (void)authenticationCompleted {
    [self refreshForSelectedFilter];
}

#pragma mark - Searchbar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    [self.tableViewController configureWithTenants:self.tenants];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchResultTenants = [self tenantsForSearchText:searchText];
    BOOL hideAlpha = searchBar.text.length > 0;
    [self.tableViewController configureWithTenants:self.searchResultTenants hideAlpha:hideAlpha];
}

- (NSArray *)tenantsForSearchText:(NSString *)searchText {
    return searchText.length == 0 ?
        self.tenants :
        [GGPTenant filteredTenantsBySearchText:searchText fromTenants:self.tenants];
}

@end
