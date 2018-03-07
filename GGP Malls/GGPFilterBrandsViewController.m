//
//  GGPFilterBrandsViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPBrand.h"
#import "GGPBrandSearchTableViewController.h"
#import "GGPBrandsTableViewController.h"
#import "GGPFilterBrandsViewController.h"
#import "GGPFilterTableCellData.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPFilterBrandsViewController () <UISearchBarDelegate, UISearchControllerDelegate, GGPBrandSearchDelegate>

@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;

@property (strong, nonatomic) NSArray *tenants;
@property (strong, nonatomic) NSArray *tableItems;
@property (strong, nonatomic) GGPBrandSearchTableViewController *searchTableViewController;
@property (strong, nonatomic) GGPBrandsTableViewController *tableViewController;
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation GGPFilterBrandsViewController

- (instancetype)initWithTenants:(NSArray *)tenants {
    self = [super init];
    if (self) {
        self.tenants = tenants;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"FILTER_BRANDS" ggp_toLocalized];
    [self configureTableView];
    [self configureSearchBar];
    [self configureDisclaimerLabel];
    [self configureSearchController];
}

- (void)configureTableView {
    NSArray *brandFilterItems = [GGPBrand brandsListFromTenants:self.tenants];
    self.tableItems = [self configureTableItemsFromBrandItems:brandFilterItems];
    self.tableViewController = [GGPBrandsTableViewController new];
    [self ggp_addChildViewController:self.tableViewController toPlaceholderView:self.tableViewContainer];
    [self.tableViewController configureWithBrandItems:self.tableItems];
}

- (NSArray *)configureTableItemsFromBrandItems:(NSArray *)brandFilterItems {
    NSMutableArray *tableItems = [NSMutableArray new];
    
    for (GGPBrand *filterItem in brandFilterItems) {
        GGPFilterTableCellData *datum = [[GGPFilterTableCellData alloc]
                                         initWithTitle:filterItem.name
                                         hasChildItems:NO
                                         filterItem:filterItem
                                         andTapHandler:nil];
        [tableItems addObject:datum];
    }
    
    return tableItems;
}

- (void)configureSearchBar {
    self.searchBar.delegate = self;
    self.searchBar.placeholder = [@"FILTER_BRANDS_SEARCH_PLACEHOLDER" ggp_toLocalized];
}

- (void)configureDisclaimerLabel {
    self.disclaimerLabel.numberOfLines = 0;
    self.disclaimerLabel.textAlignment = NSTextAlignmentCenter;
    self.disclaimerLabel.font = [UIFont ggp_lightItalicWithSize:14];
    self.disclaimerLabel.textColor = [UIColor ggp_darkGray];
    self.disclaimerLabel.text = [@"FILTER_BRANDS_SEARCH_DISCLAIMER" ggp_toLocalized];
}

- (void)configureSearchController {
    self.searchTableViewController = [GGPBrandSearchTableViewController new];
    self.searchTableViewController.searchDelegate = self;
    [self.searchTableViewController configureWithBrandItems:self.tableItems];
    
    self.searchController = [[UISearchController alloc]
                             initWithSearchResultsController:self.searchTableViewController];
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self.searchTableViewController;
    self.searchController.searchBar.placeholder = [@"FILTER_BRANDS_SEARCH_PLACEHOLDER" ggp_toLocalized];
}

#pragma mark - BrandSearchDelegate

- (void)didSelectBrand {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.navigationController.navigationBar.translucent = YES;
    [self presentViewController:self.searchController animated:YES completion:nil];
    return YES;
}

#pragma mark - SearchControllerDelegate

- (void)willDismissSearchController:(UISearchController *)searchController {
    self.navigationController.navigationBar.translucent = NO;
}

@end
