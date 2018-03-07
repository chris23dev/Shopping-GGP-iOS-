//
//  GGPFilterCategoriesViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPCategory.h"
#import "GGPFilterCategoriesViewController.h"
#import "GGPFilterItem.h"
#import "GGPFilterSubCategoriesViewController.h"
#import "GGPFilterTableCellData.h"
#import "GGPFilterTableViewController.h"
#import "GGPMallRepository.h"
#import "GGPSpinner.h"
#import "GGPUser.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPFilterCategoriesViewController ()

@property (strong, nonatomic) NSArray *tenants;
@property (strong, nonatomic) NSArray *categories;

@end

@implementation GGPFilterCategoriesViewController

- (instancetype)initWithTenants:(NSArray<GGPTenant *> *)tenants {
    self = [super init];
    if (self) {
        self.tenants = tenants;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"FILTER_CATEGORIES" ggp_toLocalized];
    [self fetchCategories];
}

- (void)fetchCategories {
    [GGPSpinner showForView:self.view];
    [GGPMallRepository fetchTenantCategoriesWithCompletion:^(NSArray *categories) {
        [GGPSpinner hideForView:self.view];
        self.categories = categories;
        self.filterItems = [GGPCategory createFilterCategoriesFromCategories:self.categories withTenants:self.tenants];
        
        [self configureTableView];
    }];
}

- (void)configureTableView {
    self.tableViewController = [GGPFilterTableViewController new];
    [self ggp_addChildViewController:self.tableViewController toPlaceholderView:self.tableContainer];
    [self.tableViewController configureWithFilterItems:[self tableCellItemsForCategories:self.filterItems]];
}

- (NSArray *)tableCellItemsForCategories:(NSArray *)categories {
    NSMutableArray *tableItems = [NSMutableArray new];
    
    for (GGPCategory *category in categories) {
        BOOL hasChildItems = category.childFilters.count > 0;
        id tapHandler = hasChildItems ? ^(void) {
            [self categoryItemTappedWithTitle:category.name andSubCategories:category.childFilters];
        } : nil;
        
        GGPFilterTableCellData *datum = [[GGPFilterTableCellData alloc]
                                         initWithTitle:category.name
                                         hasChildItems:hasChildItems
                                         filterItem:category
                                         andTapHandler:tapHandler];
        [tableItems addObject:datum];
    }
    
    return tableItems;
}

#pragma mark - Tap handlers

- (void)categoryItemTappedWithTitle:(NSString *)title andSubCategories:(NSArray *)subCategories {
    self.subCategoryViewController = [[GGPFilterSubCategoriesViewController alloc] initWithTitle:title andFilterItems:[self tableCellItemsForCategories:subCategories] hasDisclaimerSection:NO];
    [self.navigationController pushViewController:self.subCategoryViewController animated:YES];
}

@end
