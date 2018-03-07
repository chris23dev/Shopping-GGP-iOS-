//
//  ShoppingViewController.m
//  GGP Malls
//
//  Created by Janet Lin on 1/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCategory.h"
#import "GGPMallRepository.h"
#import "GGPShoppingViewController.h"
#import "GGPShoppingCategoryViewController.h"
#import "GGPSpinner.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIStackView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPShoppingViewController () <GGPShoppingCategoryDelegate>

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) GGPShoppingCategoryViewController *expandedViewController;

@end

@implementation GGPShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotifications];
    [self fetchCategories];
    
    self.stackView.spacing = 10;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)configureNavigationBar {
    [self.navigationController ggp_configureWithLightText];
    self.navigationController.navigationBar.barTintColor = [UIColor ggp_navigationBar];
    self.navigationItem.title = [@"SHOPPING_TITLE" ggp_toLocalized];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchCategories) name:GGPClientSalesUpdatedNotification object:nil];
}

- (void)fetchCategories {
    [GGPSpinner showForView:self.view];
    [GGPMallRepository fetchSaleCategoriesWithCompletion:^(NSArray *categories) {
        [GGPSpinner hideForView:self.view];
        self.categories = categories;
        [self configureCategories];
    }];
}

- (void)configureCategories {
    [self.stackView ggp_clearArrangedSubviews];
    
    for (GGPCategory *category in self.categories) {
        GGPShoppingCategoryViewController *categoryViewController = [[GGPShoppingCategoryViewController alloc] initWithCategory:category];
        categoryViewController.categoryDelegate = self;
        [self ggp_addChildViewController:categoryViewController toStackView:self.stackView];
    }
    
    [self addSeeAllSection];
}

- (void)addSeeAllSection {
    GGPCategory *allCategory = [GGPCategory new];
    allCategory.label = [@"SHOPPING_SEE_ALL" ggp_toLocalized];
    allCategory.code = GGPCategoryAllSalesCode;
    
    GGPShoppingCategoryViewController *categoryViewController = [[GGPShoppingCategoryViewController alloc] initWithCategory:allCategory];
    [self ggp_addChildViewController:categoryViewController toStackView:self.stackView];
}

#pragma mark GGPShoppingCategoryDelegate

- (void)didExpandCategoryViewController:(GGPShoppingCategoryViewController *)expandedViewController {
    if (self.expandedViewController != expandedViewController) {
        [self.expandedViewController collapseCategory];
        self.expandedViewController = expandedViewController;
    }
}

@end
