//
//  GGPShoppingRefineSortViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCellData.h"
#import "GGPRefineOptions.h"
#import "GGPShoppingRefineCell.h"
#import "GGPShoppingRefineHeaderCell.h"
#import "GGPShoppingRefineSortViewController.h"
#import "UIView+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

static NSInteger const kHeaderSection = 0;
static NSInteger const kSortSection = 1;
static NSInteger const kNumberOfSortRows = 3;

static NSInteger const kEndDateRow = 0;
static NSInteger const kAlphaRow = 1;
static NSInteger const kReverseAlphaRow = 2;

@interface GGPShoppingRefineSortViewController ()

@property (assign, nonatomic) GGPRefineSortType sortType;

@end

@implementation GGPShoppingRefineSortViewController

- (instancetype)initWithRefineSortType:(GGPRefineSortType)sortType {
    self = [super init];
    if (self) {
        self.title = [@"SHOPPING_REFINE_TITLE" ggp_toLocalized];
        self.sortType = sortType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)configureTableView {
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self registerCells];
}

- (void)registerCells {
    UINib *headerNib = [UINib nibWithNibName:@"GGPShoppingRefineHeaderCell" bundle:nil];
    [self.tableView registerNib:headerNib forCellReuseIdentifier:GGPShoppingRefineHeaderReusueIdentifier];
    
    UINib *sortCellNib = [UINib nibWithNibName:@"GGPShoppingRefineCell" bundle:nil];
    [self.tableView registerNib:sortCellNib forCellReuseIdentifier:GGPShoppingRefineCellReuseIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == kHeaderSection ? 1 : kNumberOfSortRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == kHeaderSection ?
        [self headerCellForTableView:(UITableView *)tableView atIndexPath:indexPath] :
        [self refineCellForTableView:(UITableView *)tableView atIndexPath:indexPath];
}

- (GGPShoppingRefineHeaderCell *)headerCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    GGPShoppingRefineHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPShoppingRefineHeaderReusueIdentifier forIndexPath:indexPath];
    
    [cell configureWithTitle:[@"SHOPPING_REFINE_SORT_BY_HEADER" ggp_toLocalized]];
    
    return cell;
}

- (GGPShoppingRefineCell *)refineCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    GGPShoppingRefineCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPShoppingRefineCellReuseIdentifier forIndexPath:indexPath];
    GGPRefineSortType sortType = [self sortTypeForRow:indexPath.row];
    NSString *title = [GGPRefineOptions sortStringFromSortType:sortType];
    
    [cell configureWithTitle:title andSubtitle:nil];
    
    if (sortType == self.sortType) {
        cell.selected = YES;
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kSortSection) {
        [self trackSortType:[self sortTypeForRow:indexPath.row]];
        
        [self.refineDelegate didUpdateSortType:[self sortTypeForRow:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (GGPRefineSortType)sortTypeForRow:(NSInteger)row {
    switch (row) {
        case kEndDateRow:
            return GGPRefineSortByEndDate;
        case kAlphaRow:
            return GGPRefineSortByAlpha;
        case kReverseAlphaRow:
            return GGPRefineSortByReverseAlpha;
        default:
            return GGPRefineSortByEndDate;
    }
}

#pragma mark Analytics

- (void)trackSortType:(GGPRefineSortType)sortType {
    NSString *title = [GGPRefineOptions sortStringFromSortType:sortType];
    NSDictionary *data = @{ GGPAnalyticsContextDataShoppingFilterSort: title };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionShoppingFilterSort withData:data];
}

@end
