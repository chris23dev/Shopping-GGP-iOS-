//
//  GGPShoppingCategoryViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCategory.h"
#import "GGPShoppingCategoryViewController.h"
#import "GGPShoppingSubCategoryViewController.h"
#import "GGPShoppingTableViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

CGFloat const kDefaultViewAlpha = 0.5;
CGFloat const kExpandedViewAlpha = 0.8;

@interface GGPShoppingCategoryViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIStackView *subCategoryStackView;

@property (strong, nonatomic) GGPCategory *category;
@property (strong, nonatomic) NSMutableArray *subCategoryViewControllers;
@property (strong, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) BOOL isExpanded;

@end

@implementation GGPShoppingCategoryViewController

- (instancetype)initWithCategory:(GGPCategory *)category {
    self = [super init];
    if (self) {
        self.category = category;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)configureControls {
    [self configureTitleLabel];
    [self configureStackView];

    [self collapseCategory];
    
    self.overlayView.backgroundColor = [UIColor blackColor];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryTapped)]];
}

- (void)configureTitleLabel {
    self.titleLabel = [UILabel new];
    self.titleLabel.text = self.category.name.uppercaseString;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont ggp_boldWithSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)configureStackView {
    self.subCategoryStackView.spacing = 15;
    self.subCategoryViewControllers = [NSMutableArray new];
    
    if (self.category.childFilters.count > 0) {
        [self.category addAllFilterToSubCategoryList];
    }
}

- (void)expandCategory {
    [self.subCategoryStackView removeArrangedSubview:self.titleLabel];
    
    for (GGPCategory *childCategory in self.category.childFilters) {
        GGPShoppingSubCategoryViewController *childController = [[GGPShoppingSubCategoryViewController alloc] initWithCategory:childCategory];
        [self.subCategoryViewControllers addObject:childController];
        [self ggp_addChildViewController:childController toStackView:self.subCategoryStackView];
    }
    
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ggp_category_%@_expanded", self.category.code.lowercaseString]];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.overlayView.alpha = kExpandedViewAlpha;
    }];
}

- (void)collapseCategory {
    for (UIViewController *viewController in self.subCategoryViewControllers) {
        [viewController ggp_removeFromParentViewController];
    }
    self.subCategoryViewControllers = [NSMutableArray new];
    [self.subCategoryStackView addArrangedSubview:self.titleLabel];
    
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ggp_category_%@_default", self.category.code.lowercaseString]];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.overlayView.alpha = kDefaultViewAlpha;
    }];
}

- (void)categoryTapped {
    NSString *categoryName = self.category.name ? self.category.name : @"";
    NSDictionary *data = @{ GGPAnalyticsContextDataShoppingCategoryName: categoryName };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionShoppingCategory withData:data];
    
    if (self.category.childFilters.count > 0) {
        [self toggleCategory];
    } else {
        GGPShoppingTableViewController *tableViewController = [[GGPShoppingTableViewController alloc] initWithCategory:self.category];
        [self.navigationController pushViewController:tableViewController animated:YES];
    }
}

- (void)toggleCategory {
    if (self.isExpanded) {
        [self collapseCategory];
    } else {
        [self expandCategory];
        [self.categoryDelegate didExpandCategoryViewController:self];
    }
}

- (BOOL)isExpanded {
    return self.subCategoryViewControllers.count > 0;
}

@end
