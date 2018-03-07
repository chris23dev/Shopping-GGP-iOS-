//
//  GGPFilterViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/22/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPFilterCategoriesViewController.h"
#import "GGPFilterTableViewController.h"
#import "GGPFilterBrandsViewController.h"
#import "GGPFilterLandingViewController.h"
#import "GGPFilterProductsViewController.h"
#import "GGPFilterTableCellData.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMallRepository.h"
#import "GGPSpinner.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPFilterLandingViewController ()

@property (weak, nonatomic) IBOutlet UIView *tableContainer;

@property (strong, nonatomic) GGPFilterCategoriesViewController *filterCategoriesViewController;
@property (strong, nonatomic) GGPFilterProductsViewController *productsViewController;
@property (strong, nonatomic) GGPFilterBrandsViewController *brandsViewController;
@property (strong, nonatomic) GGPFilterTableViewController *tableViewController;
@property (strong, nonatomic) NSArray *tenants;

@end

@implementation GGPFilterLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [self fetchTenants];
    [self registerNotifications];
    self.title = [@"FILTER_TITLE" ggp_toLocalized];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchTenants) name:GGPClientTenantsUpdatedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchTenants) name:GGPMallManagerMallUpdatedNotification object:nil];
}

- (void)fetchTenants {
    [GGPSpinner showForView:self.view];
    [GGPMallRepository fetchTenantsWithCompletion:^(NSArray *tenants) {
        [GGPSpinner hideForView:self.view];
        self.tenants = tenants;
        [self.tableViewController configureWithFilterItems:[self configureParentFilterCategories]];
    }];
}

- (void)configureTableView {
    self.tableViewController = [GGPFilterTableViewController new];
    [self ggp_addChildViewController:self.tableViewController toPlaceholderView:self.tableContainer];
}

- (NSArray *)configureParentFilterCategories {
    NSMutableArray *filterItems = [NSMutableArray new];
    GGPMall *selectedMall = [GGPMallManager shared].selectedMall;
    
    GGPFilterTableCellData *categoriesItem = [[GGPFilterTableCellData alloc] initWithTitle:[@"FILTER_CATEGORIES_HEADING" ggp_toLocalized] hasChildItems:YES filterItem:nil andTapHandler:^{
        [self categoryItemTapped];
    }];
    [filterItems addObject:categoriesItem];
    
    if (selectedMall.config.productEnabled) {
        GGPFilterTableCellData *productsItem = [[GGPFilterTableCellData alloc] initWithTitle:[@"FILTER_PRODUCTS_HEADING" ggp_toLocalized] hasChildItems:YES filterItem:nil  andTapHandler:^{
            [self productsItemTapped];
        }];
        [filterItems addObject:productsItem];
        
        GGPFilterTableCellData *brandsItem = [[GGPFilterTableCellData alloc] initWithTitle:[@"FILTER_BRANDS_HEADING" ggp_toLocalized] hasChildItems:YES filterItem:nil  andTapHandler:^{
            [self brandsItemTapped];
        }];
        [filterItems addObject:brandsItem];
    }
    
    return filterItems;
}

#pragma mark - Tap handlers

- (void)categoryItemTapped {
    self.filterCategoriesViewController = [[GGPFilterCategoriesViewController alloc] initWithTenants:self.tenants];
    [self.navigationController pushViewController:self.filterCategoriesViewController animated:YES];
}

- (void)productsItemTapped {
    self.productsViewController = [[GGPFilterProductsViewController alloc] initWithTenants:self.tenants];
    [self.navigationController pushViewController:self.productsViewController animated:YES];
}

- (void)brandsItemTapped {
    self.brandsViewController = [[GGPFilterBrandsViewController alloc] initWithTenants:self.tenants];
    [self.navigationController pushViewController:self.brandsViewController animated:YES];
};

@end
