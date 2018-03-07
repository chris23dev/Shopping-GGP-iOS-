//
//  GGPHomeViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/16/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAuthenticationController.h"
#import "GGPDiningViewController.h"
#import "GGPEventsTableViewController.h"
#import "GGPFeaturedTableViewController.h"
#import "GGPHomeViewController.h"
#import "GGPJustForYouTableViewController.h"
#import "GGPMallManager.h"
#import "GGPChangeMallViewController.h"
#import "GGPModalViewController.h"
#import "GGPMovieTheaterTableViewController.h"
//#import "GGPMovieContainerViewController.h"
#import "UIColor+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

static NSInteger const kRibbonMovieItemIndex = 2;

@interface GGPHomeViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerContainer;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (assign, nonatomic) BOOL hasTheater;

@end

@implementation GGPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasTheater = [GGPMallManager shared].selectedMall.hasTheater;
    
    [self configureControls];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureRibbon) name:GGPAuthenticationCompletedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMallUpdate) name:GGPMallManagerMallUpdatedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenHome];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)handleMallUpdate {
    [self updateMallLogo];
    
    if (self.hasTheater != [GGPMallManager shared].selectedMall.hasTheater) {
        self.hasTheater = [GGPMallManager shared].selectedMall.hasTheater;
        [self configureRibbon];
    }
}

- (void)configureNavigationBar {
    [self.navigationController ggp_configureWithLightText];
    self.navigationController.navigationBarHidden = YES;
}

- (void)configureControls {
    self.headerContainer.backgroundColor = [UIColor ggp_navigationBar];
    
    [self updateMallLogo];
    [self configureRibbon];
    [self configureTapGesture];
}

- (void)configureRibbon {
    NSMutableArray *ribbonControllers = [NSMutableArray new];
    
    if ([GGPAccount isLoggedIn]) {
        [ribbonControllers addObject:[GGPJustForYouTableViewController new]];
    } else {
        [ribbonControllers addObject:[GGPFeaturedTableViewController new]];
    }
    
    [ribbonControllers addObjectsFromArray:@[[GGPEventsTableViewController new], [GGPDiningViewController new]]];
    
    if (self.hasTheater) {
        [ribbonControllers insertObject:[GGPMovieTheaterTableViewController new] atIndex:kRibbonMovieItemIndex];
    }
    
    self.ribbonControllers = ribbonControllers;
}

- (void)configureTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLogoTap)];
    self.headerImageView.userInteractionEnabled = YES;
    [self.headerImageView addGestureRecognizer:tapGesture];
}

- (void)updateMallLogo {
    [self.headerImageView setImageWithURL:[NSURL URLWithString:[GGPMallManager shared].selectedMall.inverseNonSvgLogoUrl]];
}

#pragma mark - Tap Handler

- (void)handleLogoTap {
    GGPModalViewController *modal = [[GGPModalViewController alloc] initWithRootViewController:[GGPChangeMallViewController new] andOnClose:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.navigationController presentViewController:modal animated:YES completion:nil];
}

@end
