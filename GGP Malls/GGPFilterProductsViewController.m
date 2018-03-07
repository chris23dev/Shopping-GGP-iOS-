//
//  GGPFilterProductsViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFilterTableViewController.h"
#import "GGPFilterSubCategoriesViewController.h"
#import "GGPFilterProductsViewController.h"
#import "GGPFilterTableCellData.h"
#import "GGPProduct.h"
#import "GGPTenant.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPFilterProductsViewController ()

@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;

@property (strong, nonatomic) GGPFilterTableViewController *tableViewController;
@property (strong, nonatomic) GGPFilterSubCategoriesViewController *subCategoryViewController;
@property (strong, nonatomic) NSArray *tenants;
@property (strong, nonatomic) NSArray *productCategories;

@end

@implementation GGPFilterProductsViewController

- (instancetype)initWithTenants:(NSArray *)tenants {
    self = [super init];
    if (self) {
        self.tenants = tenants;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"FILTER_PRODUCTS" ggp_toLocalized];
    [self configureTableView];
}

- (void)configureTableView {
    NSArray *productFilters = [GGPProduct productsListFromTenants:self.tenants];
    self.productCategories = [self configureTableItemsFromProducts:productFilters];
    self.tableViewController = [GGPFilterTableViewController new];
    [self ggp_addChildViewController:self.tableViewController toPlaceholderView:self.tableViewContainer];
    [self.tableViewController configureWithFilterItems:self.productCategories hasDisclaimerSection:YES];
}

- (NSArray *)configureTableItemsFromProducts:(NSArray *)productFilters {
    NSMutableArray *tableItems = [NSMutableArray new];
    
    for (GGPProduct *filterItem in productFilters) {
        BOOL hasChildItems = filterItem.childFilters.count > 0;
        id tapHandler = hasChildItems ? ^(void) {
            [self productItemTappedWithTitle:filterItem.name andSubProducts:filterItem.childFilters];
        } : nil;
        
        GGPFilterTableCellData *datum = [[GGPFilterTableCellData alloc]
                                         initWithTitle:filterItem.name
                                         hasChildItems:hasChildItems
                                         filterItem:filterItem
                                         andTapHandler:tapHandler];
        [tableItems addObject:datum];
    }
    
    return tableItems;
}

#pragma mark - Taphandler

- (void)productItemTappedWithTitle:(NSString *)title andSubProducts:(NSArray *)subProducts {
    self.subCategoryViewController = [[GGPFilterSubCategoriesViewController alloc] initWithTitle:title andFilterItems:[self configureTableItemsFromProducts:subProducts] hasDisclaimerSection:YES];
    [self.navigationController pushViewController:self.subCategoryViewController animated:YES];
}

@end
