//
//  GGPCarLocationsTableViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/12/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCarLocationsTableViewController.h"
#import "GGPCarLocationCell.h"
#import "GGPCarLocationHeaderCell.h"
#import "GGPCarMapViewController.h"
#import "GGPParkingSite.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"

@interface GGPCarLocationsTableViewController ()

@property (strong, nonatomic) GGPParkingSite *site;
@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSArray *carLocations;

@end

@implementation GGPCarLocationsTableViewController

- (instancetype)initWithSite:(GGPParkingSite *)site searchText:(NSString *)searchText andCarLocations:(NSArray *)carLocations {
    self = [super init];
    if (self) {
        self.site = site;
        self.searchText = searchText;
        self.carLocations = carLocations;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"FIND_MY_CAR_SEARCH_RESULTS_TITLE" ggp_toLocalized];
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController ggp_configureWithDarkText];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)configureTableView {
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPCarLocationCell" bundle:nil] forCellReuseIdentifier:GGPCarLocationCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPCarLocationHeaderCell" bundle:nil] forCellReuseIdentifier:GGPCarLocationHeaderCellId];
}

#pragma mark UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.carLocations.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? [self dequeueHeaderCellForIndexPath:indexPath] : [self dequeueLocationCellForIndexPath:indexPath];
}

- (GGPCarLocationHeaderCell *)dequeueHeaderCellForIndexPath:(NSIndexPath *)indexPath {
    GGPCarLocationHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GGPCarLocationHeaderCellId];
    [cell configureWithSearchText:self.searchText andResultCount:self.carLocations.count];
    return cell;
}

- (GGPCarLocationCell *)dequeueLocationCellForIndexPath:(NSIndexPath *)indexPath {
    GGPCarLocationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GGPCarLocationCellId forIndexPath:indexPath];
    [cell configureWithCarLocation:self.carLocations[indexPath.row - 1] andSite:self.site];
    
    __weak typeof(self) weakSelf = self;
    cell.onMapTapped = ^(GGPParkingCarLocation *carLocation) {
        GGPCarMapViewController *mapController = [[GGPCarMapViewController alloc] initWithCarLocation:carLocation andSite:self.site];
        [weakSelf.navigationController pushViewController:mapController animated:YES];
    };
    return cell;
}

@end
