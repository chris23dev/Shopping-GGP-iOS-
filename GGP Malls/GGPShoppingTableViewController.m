//
//  ShoppingTableViewController.m
//  GGP Malls
//
//  Created by Janet Lin on 1/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCategory.h"
#import "GGPMallRepository.h"
#import "GGPModalViewController.h"
#import "GGPShoppingRefineViewController.h"
#import "GGPSale.h"
#import "GGPShoppingDetailViewController.h"
#import "GGPShoppingTableViewCell.h"
#import "GGPShoppingTableViewController.h"
#import "GGPShoppingTableHeaderCell.h"
#import "GGPSpinner.h"
#import "GGPRefineOptions.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"

static NSString *const kEndDateTimeSortKey = @"endDateTime";
static NSInteger const kHeaderSection = 0;

@interface GGPShoppingTableViewController () <GGPRefineFilterDelegate>

@property (strong, nonatomic) NSArray *allSales;
@property (strong, nonatomic) NSArray *filteredSales;
@property (strong, nonatomic) NSArray *filteredTenants;
@property (strong, nonatomic) GGPCategory *category;
@property (strong, nonatomic) GGPRefineOptions *refineOptions;
@property (strong, nonatomic) UIBarButtonItem *refineButton;

@end

@implementation GGPShoppingTableViewController

- (instancetype)initWithCategory:(GGPCategory *)category {
    self = [super init];
    if (self) {
        self.category = category;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    
    if (self.category.code == GGPCategoryAllSalesCode) {
        [self fetchAllSales];
    } else {
        self.allSales = self.category.filteredItems;
        [self configureWithSales:self.allSales];
        [self configureRefineButton];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSalesUpdated) name:GGPClientSalesUpdatedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)fetchAllSales {
    [GGPSpinner showForView:self.view];
    [GGPMallRepository fetchSalesWithCompletion:^(NSArray *sales) {
        [GGPSpinner hideForView:self.view];
        self.allSales = sales;
        [self configureWithSales:sales];
        [self configureRefineButton];
    }];
}

- (void)setAllSales:(NSArray *)allSales {
    _allSales = [allSales ggp_sortListAscendingForKey:kEndDateTimeSortKey];
}

- (void)configureWithSales:(NSArray *)sales {
    self.filteredSales = sales;
    [self.tableView reloadData];
}

- (void)configureTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPShoppingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:GGPShoppingTableViewCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPShoppingTableHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:GGPShoppingTableHeaderCellReuseIdentifier];
    
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)configureNavigationBar {
    self.navigationItem.title = self.category.code == GGPCategoryAllSalesCode ? [@"SHOPPING_SEE_ALL_HEADER_TEXT" ggp_toLocalized] : self.category.name.uppercaseString;
    [self.navigationController ggp_configureWithLightText];
    self.navigationController.navigationBar.barTintColor = [UIColor ggp_navigationBar];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)configureRefineButton {
    self.refineOptions = [GGPRefineOptions new];
    self.refineButton = [[UIBarButtonItem alloc] initWithTitle:[@"SHOPPING_REFINE_BUTTON" ggp_toLocalized]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(refineButtonTapped)];
    
    NSDictionary *attributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSFontAttributeName: [UIFont ggp_regularWithSize:14] };
    
    [self.refineButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = self.refineButton;
}

- (void)refineButtonTapped {
    GGPShoppingRefineViewController *refineController = [[GGPShoppingRefineViewController alloc]
                                                         initWithSales:self.allSales];
    refineController.refineFilterDelegate = self;
    
    GGPModalViewController *modalController = [[GGPModalViewController alloc] initWithRootViewController:refineController andOnClose:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:modalController animated:YES completion:nil];
    [refineController configureWithRefineOptions:self.refineOptions];
}

- (void)handleSalesUpdated {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == kHeaderSection ? 1 : self.filteredSales.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor ggp_lightGray];
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kHeaderSection) {
        GGPShoppingTableHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPShoppingTableHeaderCellReuseIdentifier forIndexPath:indexPath];
        
        NSString *name = self.category.code == GGPCategoryAllSalesCode ? [@"SHOPPING_SEE_ALL_HEADER_TEXT" ggp_toLocalized] : self.category.name;
        
        NSInteger tenantCount = self.filteredTenants.count;
        
        [cell configureWithCategoryName:name tenantCount:tenantCount andCount:self.filteredSales.count];
        
        return cell;
    } else {
        GGPShoppingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPShoppingTableViewCellReuseIdentifier forIndexPath:indexPath];
        [cell configureCellWithSale:self.filteredSales[indexPath.row]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section != kHeaderSection) {
        GGPSale *sale = self.filteredSales[indexPath.row];
        [self.navigationController pushViewController:[[GGPShoppingDetailViewController alloc] initWithSale:sale] animated:YES];
    }
}

#pragma mark - Refine Filter Delegate

- (void)didUpdateFilteredSales:(NSArray *)filteredSales withTenants:(NSArray *)tenants {
    self.filteredTenants = tenants;
    [self configureWithSales:filteredSales];
}

@end
