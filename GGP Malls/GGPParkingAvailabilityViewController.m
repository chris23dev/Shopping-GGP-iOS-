//
//  GGPParkingAvailabilityViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingAvailabilityClient.h"
#import "GGPJMapManager.h"
#import "GGPJmapViewcontroller+Levels.h"
#import "GGPJMapViewController+Parking.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMallRepository.h"
#import "GGPMapController.h"
#import "GGPParkingAvailabilityPopoverViewController.h"
#import "GGPParkingAvailabilityViewController.h"
#import "GGPParkingAvailibilityPopoverDelegate.h"
#import "GGPParkingLot.h"
#import "GGPParkingLotOccupancy.h"
#import "GGPParkingLotThreshold.h"
#import "GGPTenant.h"
#import "GGPTenantSearchTableViewController.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <JMap/JMap.h>

static NSInteger const kArrivalTimeNow = 0;

@interface GGPParkingAvailabilityViewController () <GGPParkingAvailibilityPopoverDelegate, GGPTenantSearchDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (weak, nonatomic) IBOutlet UIView *topCardContainerView;
@property (weak, nonatomic) IBOutlet UIView *arrivalContainerView;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *parkingForContainerView;
@property (weak, nonatomic) IBOutlet UILabel *parkingForHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingForLabel;
@property (weak, nonatomic) IBOutlet UIView *popoverViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (strong, nonatomic) GGPMall *mall;
@property (strong, nonatomic) GGPParkingAvailabilityPopoverViewController *popoverViewController;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) GGPTenantSearchTableViewController *searchTableController;
@property (strong, nonatomic) NSDate *arrivalDate;
@property (strong, nonatomic) NSString *arrivalTimeString;
@property (assign, nonatomic) NSInteger arrivalTimeHour;
@property (strong, nonatomic) NSArray *parkingLots;

@end

@implementation GGPParkingAvailabilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"PARKING_AVAILABILITY_TITLE" ggp_toLocalized];
    [self configureControls];
    [self fetchTenants];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMallUpdate) name:GGPMallManagerMallUpdatedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GGPJMapManager shared].mapViewController resetParkNearSelection];
    [self fetchParkingLotOccupanciesWithDate:self.arrivalDate];
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenParkingAvailability];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureMap];
}

- (GGPMall *)mall {
    return [GGPMallManager shared].selectedMall;
}

- (void)handleMallUpdate {
    [[GGPJMapManager shared].mapViewController showAvailabilityForParkingLots:self.parkingLots];
}

- (void)fetchTenants {
    [GGPMallRepository fetchTenantsWithCompletion:^(NSArray *tenants) {
        [self.searchTableController formatTenantNamesForDisplay:tenants];
        [self.searchTableController configureWithTenants:tenants];
    }];
}

- (void)configureControls {
    [self configureTopCard];
    [self configureArrivalTimeView];
    [self configureParkingForView];
    [self configureClearButton];
    [self configureGestures];
    [self configurePopOverView];
    [self configureSearch];
}

- (void)configureTopCard {
    self.topCardContainerView.backgroundColor = [UIColor whiteColor];
    [self.topCardContainerView ggp_addBorderWithWidth:1 andColor:[UIColor ggp_lightGray]];
    [self.topCardContainerView ggp_addShadowWithRadius:4 andOpacity:0.30];
    [self.topCardContainerView ggp_addBorderRadius:5];
}

- (void)configureArrivalTimeView {
    self.arrivalTimeString = [@"PARKING_AVAILABILITY_NOW" ggp_toLocalized];
    self.arrivalDate = [NSDate new];
    
    self.arrivalTimeHeadingLabel.font = [UIFont ggp_mediumWithSize:11];
    self.arrivalTimeHeadingLabel.text = [@"PARKING_AVAILABILITY_ARRIVAL_TIME" ggp_toLocalized];
    self.arrivalTimeHeadingLabel.textColor = [UIColor ggp_darkGray];
    
    self.arrivalTimeLabel.font = [UIFont ggp_regularWithSize:13];
    self.arrivalTimeLabel.textColor = [UIColor ggp_darkGray];
    self.arrivalTimeLabel.text = self.arrivalTimeString;
}

- (void)configureParkingForView {
    self.parkingForHeadingLabel.font = [UIFont ggp_mediumWithSize:11];
    self.parkingForHeadingLabel.textColor = [UIColor ggp_darkGray];
    self.parkingForHeadingLabel.text = [@"PARKING_AVAILABILITY_PARKING_FOR" ggp_toLocalized];
    
    self.parkingForLabel.font = [UIFont ggp_regularWithSize:13];
    self.parkingForLabel.textColor = [UIColor ggp_gray];
    self.parkingForLabel.text = [@"PARKING_AVAILABILITY_ENTER_STORE" ggp_toLocalized];
}

- (void)configureClearButton {
    self.clearButton.backgroundColor = [UIColor ggp_pastelGray];
    self.clearButton.titleLabel.font = [UIFont ggp_boldWithSize:9];
    [self.clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.clearButton.layer.cornerRadius = 8;
    self.clearButton.hidden = YES;
}

- (void)configureGestures {
    UITapGestureRecognizer *arrivalTimeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrivalTimeViewTapped)];
    [self.arrivalContainerView addGestureRecognizer:arrivalTimeTapGesture];
    
    UITapGestureRecognizer *parkingForTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(parkingForTapped)];
    [self.parkingForContainerView addGestureRecognizer:parkingForTapGesture];
}

- (void)configureSearch {
    self.searchTableController = [GGPTenantSearchTableViewController new];
    self.searchTableController.searchDelegate = self;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchTableController];
    self.searchController.searchResultsUpdater = self.searchTableController;
    self.searchController.searchBar.placeholder = [@"PARKING_AVAILABILITY_ENTER_STORE" ggp_toLocalized];
}

- (void)configurePopOverView {
    self.popoverViewContainer.hidden = YES;
    self.popoverViewContainer.backgroundColor = [UIColor clearColor];
    self.popoverViewController = [GGPParkingAvailabilityPopoverViewController new];
    self.popoverViewController.popoverDelegate = self;
    self.popoverViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
}

- (void)configureMap {
    [self ggp_addChildViewController:[GGPJMapManager shared].mapViewController toPlaceholderView:self.mapContainerView];
}

- (void)fetchParkingLotOccupanciesWithDate:(NSDate *)arrivalDate {
    [[GGPParkingAvailabilityClient shared] retrieveParkingLotsForCoordinate:self.mall.coordinates time:self.timeStringForArrivalDate andCompletion:^(NSArray *parkingLots) {
        self.parkingLots = parkingLots;
        [[GGPJMapManager shared].mapViewController showAvailabilityForParkingLots:parkingLots];
    }];
}

- (NSString *)timeStringForArrivalDate {
    NSString *timeZone = self.isArrivalTimeNow ? self.mall.timeZone : nil;
    return [[self constructedArrivalDate] ggp_isoTimeStringForTimeZone:timeZone];
}

- (NSDate *)constructedArrivalDate {
    return self.isArrivalTimeNow ? [NSDate ggp_dateBySettingTimeZone:self.mall.timeZone forDate:self.arrivalDate] : [NSDate ggp_dateBySettingHour:self.arrivalTimeHour forDate:self.arrivalDate];
}

- (BOOL)isArrivalTimeNow {
    return self.arrivalTimeHour == kArrivalTimeNow;
}

#pragma mark - Tap Gestures

- (void)arrivalTimeViewTapped {
    self.popoverViewContainer.hidden = NO;
    [self.topCardContainerView ggp_collapseVertically];
    [self presentViewController:self.popoverViewController animated:YES completion:nil];
}

- (void)parkingForTapped {
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    [self presentViewController:self.searchController animated:YES completion:nil];
}

- (IBAction)clearButtonTapped:(id)sender {
    [[GGPJMapManager shared].mapViewController resetParkNearSelection];
    self.parkingForLabel.text = [@"PARKING_AVAILABILITY_ENTER_STORE" ggp_toLocalized];
    self.parkingForLabel.textColor = [UIColor ggp_gray];
    self.clearButton.hidden = YES;
}

#pragma mark - Popover Delegate

- (void)didTapDoneButtonWithArrivalString:(NSString *)arrivalString {
    self.popoverViewContainer.hidden = YES;
    [self.topCardContainerView ggp_expandVertically];
    self.arrivalTimeLabel.text = arrivalString;
    [self trackParkingAvailability];
}

- (void)didUpdateDate:(NSDate *)date withTime:(NSString *)timeString andArrivalTimeHour:(NSInteger)arrivalTime {
    self.arrivalDate = date;
    self.arrivalTimeString = timeString;
    self.arrivalTimeHour = arrivalTime;
    [self fetchParkingLotOccupanciesWithDate:self.arrivalDate];
}

#pragma mark GGPTenantSearchDelegate

- (void)didSelectTenant:(GGPTenant *)tenant {
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
    self.clearButton.hidden = NO;
    
    GGPTenant *tenantForMap = tenant.parentTenant ? tenant.parentTenant : tenant;
    JMapFloor *floor = [[GGPJMapManager shared].mapViewController defaultFloorForTenant:tenantForMap];
    
    [[GGPJMapManager shared].mapViewController highlightClosestParkingLotsToTenant:tenantForMap];
    [self updateParkingForLabelWithTenant:tenant andFloor:floor];
    
    [self trackParkingForTenant:tenant];
}

- (void)updateParkingForLabelWithTenant:(GGPTenant *)tenant andFloor:(JMapFloor *)floor {
    if (tenant.parentTenant) {
        self.parkingForLabel.text = tenant.nameIncludingParent;
    } else if (tenant.isAnchor || !floor.description) {
        self.parkingForLabel.text = tenant.name;
    } else {
        self.parkingForLabel.text = [NSString stringWithFormat:@"%@ %@ %@", tenant.name, [@"PARKING_AVAILABILITY_ON" ggp_toLocalized], floor.description];
    }
    
    self.parkingForLabel.textColor = [UIColor ggp_darkGray];
}

#pragma mark Analytics

- (void)trackParkingAvailability {
    NSInteger daysInAdvance = [NSDate ggp_daysFromDate:[NSDate date] toDate:self.arrivalDate];
    NSDictionary *data = @{
                           GGPAnalyticsContextDataParkingDaysInAdvance : [NSString stringWithFormat:@"%ld", (long)daysInAdvance],
                           GGPAnalyticsContextDataParkingTimeOfDay : self.arrivalTimeString
                           };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionParkingAvailabilityMenu withData:data];
}

- (void)trackParkingForTenant:(GGPTenant *)tenant {
    NSDictionary *data = @{ GGPAnalyticsContextDataParkingTenant : tenant.name };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionParkingForTenant withData:data andTenant:tenant.name];
}

@end
