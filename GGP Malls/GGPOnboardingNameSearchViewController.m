//
//  GGPOnboardingNameSearchViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMallSearchNoResultsView.h"
#import "GGPOnboardingLocationSearchViewController.h"
#import "GGPOnboardingMallLoadingViewController.h"
#import "GGPOnboardingNameSearchViewController.h"
#import "GGPOnboardingSearchTableViewCell.h"
#import "GGPSearchTableViewCell.h"
#import "GGPOnboardingSearchTableViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSString *const kSearchBarSearchFieldKey = @"searchField";

@interface GGPNameSearchViewController (Onboarding) <GGPMallSearchNoResultsDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *tableContainer;

- (void)configureWithDefaultMallList;

@end

@implementation GGPOnboardingNameSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController ggp_configureAsTransparent:NO];
}

- (void)configureTableView {
    self.tableViewController = [GGPOnboardingSearchTableViewController new];
    
    __weak typeof(self) weakSelf = self;
    self.tableViewController.onMallSelectionComplete = ^{
        [weakSelf.navigationController pushViewController:[GGPOnboardingMallLoadingViewController new]
                                                 animated:YES];
    };
    
    [self registerTableViewCell];
    [self ggp_addChildViewController:self.tableViewController toPlaceholderView:self.tableContainer];
    [self configureWithDefaultMallList];
}

- (void)styleControls {
    self.view.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.image = [UIImage imageNamed:@"ggp_onboarding_background"];
    
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.layoutMargins = UIEdgeInsetsZero;
    
    UITextField *searchField = [self.searchBar valueForKey:kSearchBarSearchFieldKey];
    searchField.backgroundColor = [UIColor clearColor];
    searchField.textColor = [UIColor whiteColor];
    [searchField ggp_addBorderRadius:4];
    [searchField ggp_addBorderWithWidth:1 andColor:[UIColor grayColor]];

    self.tableContainer.backgroundColor = [UIColor clearColor];
}

- (void)registerTableViewCell {
    [self.tableViewController.tableView registerNib:[UINib nibWithNibName:@"GGPOnboardingSearchTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:GGPSearchTableViewCellReuseIdentifier];
    
    
    GGPMallSearchNoResultsView *noResultsView = [GGPMallSearchNoResultsView new];
    [noResultsView configureWithLabelText:[@"SEARCH_NAME_NO_RESULTS" ggp_toLocalized] textColor:[UIColor ggp_pastelGray]
                            andButtonText:[@"SEARCH_NAME_NO_RESULTS_BUTTON" ggp_toLocalized]];
    noResultsView.noResultsDelegate = self;
    
    self.tableViewController.tableView.backgroundView = noResultsView;
    self.tableViewController.tableView.backgroundView.hidden = YES;
}

#pragma mark - No Results Delegate

- (void)didTapNoResultsButton {
    [self.navigationController pushViewController:[GGPOnboardingLocationSearchViewController new] animated:YES];
}

@end
