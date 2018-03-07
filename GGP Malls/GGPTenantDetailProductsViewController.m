//
//  GGPTenantDetailProductsViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantDetailProductsTableViewController.h"
#import "GGPTenantDetailProductsViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UILabel+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPTenantDetailProductsViewController ()

@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UILabel *productsHeadingLabel;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownIcon;

@property (strong, nonatomic) GGPTenantDetailProductsTableViewController *tableViewController;
@property (strong, nonatomic) NSArray *products;

@end

@implementation GGPTenantDetailProductsViewController

- (instancetype)initWithProducts:(NSArray *)products {
    self = [super init];
    if (self) {
        self.products = products;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.borderView.backgroundColor = [UIColor ggp_separatorColor];
    [self configureHeadingLabel];
    [self configureTapGesture];
    [self configureTableView];
}

- (void)configureHeadingLabel {
    self.productsHeadingLabel.text = [@"DETAILS_PRODUCTS_HEADING" ggp_toLocalized];
    self.productsHeadingLabel.font = [UIFont ggp_boldWithSize:16];
}

- (void)configureTapGesture {
    self.productsHeadingLabel.userInteractionEnabled = YES;
    self.dropDownIcon.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *headingGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productsLabelTapped)];
    
    UITapGestureRecognizer *dropdownGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productsLabelTapped)];
    
    [self.productsHeadingLabel addGestureRecognizer:headingGesture];
    [self.dropDownIcon addGestureRecognizer:dropdownGesture];
}

- (void)configureTableView {
    self.tableViewContainer.hidden = YES;
    self.tableViewController = [GGPTenantDetailProductsTableViewController new];
    [self ggp_addChildViewController:self.tableViewController toPlaceholderView:self.tableViewContainer];
    [self.tableViewController configureWithSections:self.products];
}

#pragma mark - Tap handler

- (void)productsLabelTapped {
    CGFloat bottomPadding = 10;
    CGFloat height = self.tableViewController.tableView.contentSize.height + bottomPadding;
    self.tableViewContainer.hidden = NO;
    [self.productsDelegate didExpandProductsWithHeight:height];
}

@end
