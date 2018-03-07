//
//  GGPFilterShowcaseViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFilterShowcaseViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPFilterShowcaseViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *subHeaderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation GGPFilterShowcaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)configureControls {
    self.view.backgroundColor = [UIColor ggp_colorFromHexString:@"000000" andAlpha:0.8];
    self.containerView.backgroundColor = [UIColor ggp_blue];
    
    self.headerLabel.font = [UIFont ggp_lightWithSize:26];
    self.headerLabel.textColor = [UIColor whiteColor];
    self.headerLabel.text = [@"FILTER_SHOWCASE_HEADER" ggp_toLocalized];
    
    self.subHeaderLabel.font = [UIFont ggp_regularWithSize:14];
    self.subHeaderLabel.textColor = [UIColor whiteColor];
    self.subHeaderLabel.text = [@"FILTER_SHOWCASE_SUB_HEADER" ggp_toLocalized];
    
    self.arrowImageView.image = [UIImage imageNamed:@"ggp_filter_showcase_arrow"];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)]];
}

- (void)viewTapped {
    if (self.onViewTapped) {
        self.onViewTapped();
    }
}

@end
