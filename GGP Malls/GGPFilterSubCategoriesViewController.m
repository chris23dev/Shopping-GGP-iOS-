//
//  GGPFilterSubCategoriesViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFilterSubCategoriesViewController.h"
#import "GGPFilterTableViewController.h"
#import "UIViewController+GGPAdditions.h"

@implementation GGPFilterSubCategoriesViewController

- (instancetype)init {
    self = [super initWithNibName:@"GGPFilterSubCategoriesViewController" bundle:nil];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title andFilterItems:(NSArray *)filterItems hasDisclaimerSection:(BOOL)hasDisclaimerSection {
    self = [self init];
    if (self) {
        self.title = title;
        self.filterItems = filterItems;
        self.hasDisclaimerSection = hasDisclaimerSection;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)configureTableView {
    self.tableViewController = [GGPFilterTableViewController new];
    [self ggp_addChildViewController:self.tableViewController toPlaceholderView:self.tableViewContainer];
    [self.tableViewController configureWithFilterItems:self.filterItems hasDisclaimerSection:self.hasDisclaimerSection];
}

@end
