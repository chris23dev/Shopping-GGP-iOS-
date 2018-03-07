//
//  GGPParkingReminderViewController.m
//  GGP Malls
//
//  Created by Janet Lin on 1/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMapController.h"
#import "GGPMapControllerDelegate.h"
#import "GGPParkingReminder.h"
#import "GGPParkingReminderCardDelegate.h"
#import "GGPParkingReminderCardViewController.h"
#import "GGPParkingReminderViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSInteger const kParkingLinesZoomLevel = 17;
static CGFloat const kCardViewShadowOpacity = 0.2;
static CGFloat const kCardViewShadowRadius = 5;
static CGFloat const kGhostPinAlpha = 0.5;

@interface GGPParkingReminderViewController () <GGPMapControllerDelegate, GGPParkingReminderCardDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (weak, nonatomic) IBOutlet UIView *cardContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardContainerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *ghostPinMarker;

@property (strong, nonatomic) GGPMapController *mapController;
@property (strong, nonatomic) GGPParkingReminderCardViewController *cardViewController;
@property (strong, nonatomic) GGPMall *mall;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) CLAuthorizationStatus authorizationStatus;
@property (assign, nonatomic) BOOL locationServicesEnabled;

@end

@implementation GGPParkingReminderViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = [@"PARKING_REMINDER_TITLE" ggp_toLocalized];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mall = [GGPMallManager shared].selectedMall;
    [self configureControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenParkingReminder];
}

- (BOOL)locationServicesEnabled {
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse;
}

- (void)configureControls {
    [self configureCard];
    [self configureLocationManager];
}

- (void)configureLocationManager {
    self.authorizationStatus = [CLLocationManager authorizationStatus];
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    
    if (self.authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        [self configureMap];
    }
}

- (void)configureMap {
    GGPMapOptions *options = [[GGPMapOptions alloc] initWithCoordinates:self.mall.coordinates];
    options.initialZoomLevel = kParkingLinesZoomLevel;
    options.currentLocationEnabled = self.locationServicesEnabled;
    
    self.mapController = [[GGPMapController alloc] initWithMapOptions:options
                                                     andContainerView:self.mapContainerView];
    self.mapController.mapDelegate = self;
    [self.mapController displayAnchorTenantMarkers];
    
    [self configureGhostPinMarker];
    [self configureMapView];
}

- (void)configureGhostPinMarker {
    self.ghostPinMarker.alpha = kGhostPinAlpha;
    self.ghostPinMarker.image = [UIImage imageNamed:@"ggp_parking_pin"];
    [self.mapContainerView bringSubviewToFront:self.ghostPinMarker];
}

- (void)configureCard {
    self.cardContainerView.layer.shadowOpacity = kCardViewShadowOpacity;
    self.cardContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardContainerView.layer.shadowRadius = kCardViewShadowRadius;
    
    self.cardViewController = [GGPParkingReminderCardViewController new];
    self.cardViewController.cardDelegate = self;
    [self ggp_addChildViewController:self.cardViewController toPlaceholderView:self.cardContainerView];
}

- (void)configureMapView {
    if (!self.locationServicesEnabled) {
        [self displayLocationNotEnabledAlert];
    }
    
    GGPParkingReminder *parkingReminder = [GGPParkingReminder retrieveSavedReminder];
    if (parkingReminder && parkingReminder.isValid) {
        [self configureViewForExistingReminder:parkingReminder];
    } else {
        [self.cardViewController configureForDefaultState];
    }
}

- (void)configureNewParkingLocation:(CLLocation *)location {
    [self.mapController animateToLocation:location];
}

- (void)configureViewForExistingReminder:(GGPParkingReminder *)reminder {
    [self.cardViewController configureForExistingLocationWithNote:reminder.note];
    self.ghostPinMarker.alpha = 0;
    
    NSMutableArray *locations = [[NSMutableArray alloc] initWithArray:@[reminder.location]];
    if (self.mapController.userLocation) {
        [locations addObject:self.mapController.userLocation];
    }
    
    [self.mapController fitToLocations:locations];
    [self.mapController displayParkingPinAtLocation:reminder.location];
}

- (void)saveParkingReminderAtLocation:(CLLocation *)location {
    if (location) {
        GGPParkingReminder *reminder = [[GGPParkingReminder alloc] initWithLocation:location andNote:self.cardViewController.noteText];
        [reminder saveToUserDefaults];
        
        [[GGPAnalytics shared] trackAction:GGPAnalyticsActionParkingReminderSave withData:nil];
    }
}

- (void)displayLocationNotEnabledAlert {
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:[@"PARKING_REMINDER_ALERT_LOCATION_DISABLED_SETTINGS" ggp_toLocalized] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[@"PARKING_REMINDER_ALERT_LOCATION_DISABLED_CANCEL" ggp_toLocalized] style:UIAlertActionStyleCancel handler:nil];
    
    [self ggp_displayAlertWithTitle:[@"PARKING_REMINDER_ALERT_LOCATION_DISABLED_TITLE" ggp_toLocalized] message:[@"PARKING_REMINDER_ALERT_LOCATION_DISABLED_MESSAGE" ggp_toLocalized] actions:@[cancelAction, settingsAction] andPreferredAction:settingsAction];
}

- (void)resetMapView {
    [self.mapController clearParkingPin];
    [self.cardViewController configureForDefaultState];
}

#pragma mark - ScrollViewDelegate

- (void)keyboardWillShow:(NSNotification *)notification {
    [super keyboardWillShow:notification];
    [self.scrollView scrollRectToVisible:self.cardContainerView.frame animated:YES];
}

#pragma mark - GGPMapControllerDelegate

- (void)didDetermineLocation:(CLLocation *)location {
    GGPParkingReminder *parkingReminder = [GGPParkingReminder retrieveSavedReminder];
    
    if (parkingReminder && parkingReminder.isValid) {
        [self configureViewForExistingReminder:parkingReminder];
    } else {
        [self configureNewParkingLocation:location];
    }
}

- (void)didUpdateParkingMarkerPosition:(CLLocationCoordinate2D)position {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:position.latitude longitude:position.longitude];
    [self saveParkingReminderAtLocation:location];
}

#pragma mark - GGPParkingReminderCardDelegate

- (void)clearReminderTapped {
    [GGPParkingReminder clearSavedReminder];
    [self resetMapView];
    self.ghostPinMarker.alpha = kGhostPinAlpha;
}

- (void)placePinTapped {
    CLLocation *mapCenter = self.mapController.mapCenterLocation;
    [self.mapController displayParkingPinAtLocation:mapCenter];
    [self saveParkingReminderAtLocation:mapCenter];
    [self.cardViewController configureForLocationSaved];
    self.ghostPinMarker.alpha = 0;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (self.authorizationStatus != status) {
        self.authorizationStatus = status;
        [self configureMap];
    }
}

#pragma mark - IBActions

- (IBAction)tapOutsideTextView:(id)sender {
    [self.view endEditing:YES];
}

@end
