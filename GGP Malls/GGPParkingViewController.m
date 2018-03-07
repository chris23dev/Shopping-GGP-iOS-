//
//  GGPParkingViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingViewController.h"
#import "GGPJMapViewController+Parking.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPParkingGaragesViewController.h"
#import "GGPParkingInfoViewController.h"
#import "GGPParkingMapViewController.h"
#import "GGPParkingReminderViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "GGPFindYourCarViewController.h"

@interface GGPParkingViewController ()

@property (assign, nonatomic) BOOL parkingAvailabilityEnabled;
@property (assign, nonatomic) BOOL parkAssistEnabled;

@end

@implementation GGPParkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [@"PARKING_TITLE" ggp_toLocalized];
    self.parkingAvailabilityEnabled = [GGPMallManager shared].selectedMall.config.isParkingAvailabilityEnabled;
    self.parkAssistEnabled = [GGPMallManager shared].selectedMall.config.parkAssistEnabled;
    [self configureRibbonItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMallUpdate) name:GGPMallManagerMallUpdatedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)configureNavigationBar {
    [self.navigationController ggp_configureWithLightText];
    self.navigationController.navigationBar.barTintColor = [UIColor ggp_navigationBar];
}

- (void)handleMallUpdate {
    BOOL mallParkingAvailabilityEnabled = [GGPMallManager shared].selectedMall.config.isParkingAvailabilityEnabled;
    
    if (self.parkingAvailabilityEnabled != mallParkingAvailabilityEnabled) {
        self.parkingAvailabilityEnabled = mallParkingAvailabilityEnabled;
        [self configureRibbonItems];
    }
}

- (void)configureRibbonItems {
    if (self.parkAssistEnabled) {
        self.ribbonControllers = [self ribbonItemsForParkAssist];
    } else if (self.parkingAvailabilityEnabled) {
        self.ribbonControllers = [self ribbonItemsForParkingAvailability];
    } else {
        self.ribbonControllers = [self ribbonItemsForParkingDisabled];
    }
}

- (NSArray *)ribbonItemsForParkAssist {
    return @[  [GGPParkingGaragesViewController new],
               [GGPFindYourCarViewController new],
               [GGPParkingInfoViewController new] ];
}

- (NSArray *)ribbonItemsForParkingAvailability {
    return @[  [GGPParkingMapViewController new],
               [GGPParkingReminderViewController new],
               [GGPParkingInfoViewController new]];
}

- (NSArray *)ribbonItemsForParkingDisabled {
    return @[  [GGPParkingReminderViewController new],
               [GGPParkingInfoViewController new] ];
}

@end
