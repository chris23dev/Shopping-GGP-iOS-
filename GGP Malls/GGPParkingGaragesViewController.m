//
//  GGPParkingGaragesViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingGaragesViewController.h"
#import "GGPMallRepository.h"
#import "GGPParkAssistClient.h"
#import "GGPParkingSite.h"
#import "GGPParkingZone.h"
#import "GGPParkingGarageViewController.h"
#import "GGPSpinner.h"
#import "NSString+GGPAdditions.h"
#import "UIStackView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPParkingGaragesViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *garagesStackView;
@property (assign, nonatomic) BOOL shouldUpdateOnResume;

@end

@implementation GGPParkingGaragesViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = [@"PARKING_GARAGE_TITLE" ggp_toLocalized];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchGarages) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    self.shouldUpdateOnResume = YES;
    [self fetchGarages];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.shouldUpdateOnResume = NO;
}

- (void)fetchGarages {
    if (!self.shouldUpdateOnResume) {
        return;
    }
    
    [GGPSpinner showForView:self.view];
    [GGPMallRepository fetchParkingSiteWithCompletion:^(GGPParkingSite *site) {
        if (site) {
            [self fetchZonesWithSite:site];
        } else {
            [GGPSpinner hideForView:self.view];
            [self ggp_displayAlertWithTitle:nil message:[@"ALERT_GENERIC_ERROR_MESSAGE" ggp_toLocalized] actionTitle:[@"ALERT_OK" ggp_toLocalized] andCompletion:nil];
        }
    }];
}

- (void)fetchZonesWithSite:(GGPParkingSite *)site {
    [[GGPParkAssistClient shared] retrieveZonesForSite:site andCompletion:^(NSArray *zones) {
        [GGPSpinner hideForView:self.view];
        [self configureSite:site withZones:zones];
    }];
}

- (void)configureSite:(GGPParkingSite *)site withZones:(NSArray *)zones {
    [self.garagesStackView ggp_clearArrangedSubviews];
    
    for (GGPParkingGarage *garage in site.garages) {
        NSArray *garageLevels = [GGPParkingSite levelsForGarageId:garage.garageId fromLevels:site.levels];
        GGPParkingGarageViewController *garageViewController = [[GGPParkingGarageViewController alloc] initWithGarage:garage levels:garageLevels andZones:zones];
        [self ggp_addChildViewController:garageViewController toStackView:self.garagesStackView];
    }
}

@end
