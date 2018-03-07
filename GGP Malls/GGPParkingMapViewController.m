//
//  GGPParkingMapViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPMallManager.h"
#import "GGPParkingAvailabilityViewController.h"
#import "GGPParkingMapViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPParkingMapViewController ()
@property (strong, nonatomic) UIViewController *displayedViewController;
@end

@implementation GGPParkingMapViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = [@"PARKING_AVAILABILITY_TITLE" ggp_toLocalized];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([GGPMallManager shared].selectedMall.config.isParkingAvailabilityEnabled) {
        self.displayedViewController = [GGPParkingAvailabilityViewController new];
    } else {
        self.displayedViewController = [GGPJMapManager shared].mapViewController;
        [[GGPJMapManager shared].mapViewController zoomToMall];
    }
    
    [self ggp_addChildViewController:self.displayedViewController toPlaceholderView:self.view];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.displayedViewController ggp_removeFromParentViewController];
    self.displayedViewController = nil;
}

@end
