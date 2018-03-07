//
//  GGPMallLoadingViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMallLoadingViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPMallLoadingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GGPMallLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationItem.hidesBackButton = YES;
}

- (void)configureControls {
    GGPMall *selectedMall = [GGPMallManager shared].selectedMall;
    self.backgroundImageView.image = selectedMall.loadingImage;
    
    self.locationImageView.image = [UIImage imageNamed:@"ggp_icon_location_pin_white"];
    
    self.loadingLabel.numberOfLines = 0;
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.font = [UIFont ggp_regularWithSize:19];
    self.loadingLabel.textColor = [UIColor ggp_timberWolfGray];
    self.loadingLabel.text = [NSString stringWithFormat:[@"MALL_LOADING_LABEL" ggp_toLocalized], selectedMall.name];
    
    self.activityIndicator.color = [UIColor whiteColor];
    [self.activityIndicator startAnimating];
}

@end
