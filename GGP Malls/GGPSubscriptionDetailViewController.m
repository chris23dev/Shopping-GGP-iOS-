//
//  GGPSubscriptionDetailViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAccountPreferencesViewController.h"
#import "GGPMallRepository.h"
#import "GGPMallManager.h"
#import "GGPSubscriptionDetailTableViewController.h"
#import "GGPSubscriptionDetailTableViewDelegate.h"
#import "GGPSubscriptionDetailViewController.h"
#import "GGPUser.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPSubscriptionDetailViewController () <GGPSubscriptionDetailTableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedMallLabel;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewContainerHeightConstraint;

@property (strong, nonatomic) GGPSubscriptionDetailTableViewController *tableViewController;
@property (strong, nonatomic) NSArray *preferredMalls;

@end

@implementation GGPSubscriptionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchMinimalMalls];
    [self configureLabels];
}

- (void)fetchMinimalMalls {
    [GGPMallRepository fetchMinimalMallsWithCompletion:^(NSArray *malls) {
        if (malls.count > 0) {
            GGPUser *currentUser = [GGPAccount shared].currentUser;
            self.preferredMalls = [currentUser preferredMallsListFromAllMalls:malls];
            [self configureTableView];
            [self configureLabelsForMallsList];
        }
    }];
}

- (void)configureLabels {
    self.headingLabel.numberOfLines = 0;
    self.secondaryLabel.numberOfLines = 0;
    self.selectedMallLabel.numberOfLines = 0;
    self.headingLabel.font = [UIFont ggp_regularWithSize:14];
    self.secondaryLabel.font = [UIFont ggp_regularWithSize:14];
    self.selectedMallLabel.font = [UIFont ggp_regularWithSize:14];
}

- (BOOL)selectedMallIsInPreferredMallsList {
    return [self.preferredMalls containsObject:[GGPMallManager shared].selectedMall];
}

- (void)configureLabelsForMallsList {
    GGPMall *selectedMall = [GGPMallManager shared].selectedMall;
    
    if (self.preferredMalls.count <= 1) {
        [self.secondaryLabel ggp_collapseVertically];
        [self.tableViewContainer ggp_collapseVertically];
    } else {
        self.secondaryLabel.text = [@"SUBSCRIPTION_DETAIL_MOST_OFTEN" ggp_toLocalized];
    }
    
    if (self.preferredMalls.count == 1) {
        GGPMall *mallOne = self.preferredMalls.firstObject;
        self.headingLabel.text = [NSString stringWithFormat:[@"SUBSCRIPTION_DETAIL_SINGLE_MALL" ggp_toLocalized], mallOne.name];
    } else {
        self.headingLabel.text = [@"SUBSCRIPTION_DETAIL_MULTIPLE_MALLS" ggp_toLocalized];
    }
    
    if (self.selectedMallIsInPreferredMallsList) {
        [self.selectedMallLabel ggp_collapseVertically];
    } else {
        self.selectedMallLabel.text = [NSString stringWithFormat:[@"SUBSCRIPTION_DETAIL_NEW_MALL_UPDATE" ggp_toLocalized], selectedMall.name];
    }
}

- (void)configureTableView {
    self.tableViewController = [GGPSubscriptionDetailTableViewController new];
    self.tableViewController.tableViewDelegate = self;
    [self.tableViewController configureWithMalls:self.preferredMalls];
    [self ggp_addChildViewController:self.tableViewController toPlaceholderView:self.tableViewContainer];
    self.tableViewContainerHeightConstraint.constant = self.tableViewController.tableView.contentSize.height;
}

#pragma mark - Tableview delegate

- (void)cellTappedWithPreferredMall:(GGPMall *)preferredMall forUserMallId:(NSString *)userMallIdString {
    GGPMall *formerPreferredMall = [self.preferredMalls objectAtIndex:0];
    [self.subscriptionDetailDelegate didUpdatePreferredMall:preferredMall toReplaceMall:formerPreferredMall forUserMallIdString:userMallIdString];
}

@end
