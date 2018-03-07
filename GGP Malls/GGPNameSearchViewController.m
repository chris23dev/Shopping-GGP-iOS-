//
//  GGPNameSearchViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMallRepository.h"
#import "GGPMallSearchNoResultsDelegate.h"
#import "GGPMallSearchNoResultsView.h"
#import "GGPNameSearchViewController.h"
#import "GGPSearchTableViewCell.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSString *const kMallSortKey = @"name";

@interface GGPNameSearchViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *tableContainer;

@property (strong, nonatomic) NSArray *malls;
@property (strong, nonatomic) NSArray *searchResults;

@end

@implementation GGPNameSearchViewController

- (instancetype)init {
    self = [self initWithNibName:@"GGPNameSearchViewController" bundle:nil];
    if (self) {
        self.title = [@"SEARCH_NAME_TITLE" ggp_toLocalized];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    [self styleControls];
    [self fetchMalls];
}

- (void)fetchMalls {
    [GGPMallRepository fetchMinimalMallsWithCompletion:^(NSArray *malls) {
        self.malls = [malls ggp_sortListAscendingForKey:kMallSortKey];
        self.searchResults = self.malls;
        [self configureTableView];
    }];
}

- (void)configureControls {
    self.searchBar.delegate = self;
    self.searchBar.placeholder = [@"SEARCH_NAME_INPUT_PLACEHOLDER" ggp_toLocalized];
}

- (void)configureTableView {
    self.tableViewController = [GGPSearchTableViewController new];
    
    __weak typeof(self) weakSelf = self;
    self.tableViewController.onMallSelectionComplete = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self registerTableViewCell];
    [self ggp_addChildViewController:self.tableViewController toPlaceholderView:self.tableContainer];
    [self configureWithDefaultMallList];
}

- (void)configureWithDefaultMallList {
    [self.tableViewController configureWithSearchResultMalls:self.malls recentMalls:nil andHeaderText:[@"SEARCH_NAME_ALL_MALLS" ggp_toLocalized]];
}

- (void)styleControls {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.layoutMargins = UIEdgeInsetsZero;
    
    self.tableContainer.backgroundColor = [UIColor whiteColor];
}

- (void)registerTableViewCell {
    [self.tableViewController.tableView registerNib:[UINib nibWithNibName:@"GGPSearchTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:GGPSearchTableViewCellReuseIdentifier];
    
    GGPMallSearchNoResultsView *noResultsView = [GGPMallSearchNoResultsView new];
    [noResultsView configureWithLabelText:[@"SEARCH_NAME_NO_RESULTS" ggp_toLocalized] textColor:[UIColor ggp_mediumGray]
                            andButtonText:nil];
    
    self.tableViewController.tableView.backgroundView = noResultsView;
    self.tableViewController.tableView.backgroundView.hidden = YES;
}

#pragma mark - Search responder

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!searchText.length) {
        self.searchResults = self.malls;
        [self configureWithDefaultMallList];
    } else {
        [self searchByName:searchText];
    }
}

#pragma mark - Search by name

- (void)searchByName:(NSString *)searchString {
    NSMutableSet *filteredMalls = [NSMutableSet new];
    NSArray *searchParams = [searchString componentsSeparatedByString:@" "];
    
    for (NSString *searchParam in searchParams) {
        [filteredMalls addObjectsFromArray:[self.malls ggp_arrayWithFilter:^BOOL(GGPMall *mall) {
            return [mall.name localizedStandardContainsString:searchParam];
        }]];
    }
    
    NSSortDescriptor *alphabeticalSort = [NSSortDescriptor sortDescriptorWithKey:kMallSortKey ascending:YES];
    self.searchResults = [filteredMalls sortedArrayUsingDescriptors:@[ alphabeticalSort ]];
    
    [self.tableViewController configureWithSearchResultMalls:self.searchResults recentMalls:nil andHeaderText:[NSString stringWithFormat:[@"SELECT_MALL_HEADER_MATCHING_NAME" ggp_toLocalized], searchString]];
}

@end
