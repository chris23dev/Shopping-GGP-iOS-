//
//  GGPJMapViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAmenityCollectionViewController.h"
#import "GGPFilterItem.h"
#import "GGPJMapUnitLabelViewController.h"
#import "GGPJMapViewController.h"
#import "GGPJMapViewController+Amenities.h"
#import "GGPJmapViewController+Highlighting.h"
#import "GGPJmapViewcontroller+Levels.h"
#import "GGPJMapViewController+Parking.h"
#import "GGPJMapViewController+Wayfinding.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPLevelCell.h"
#import "GGPLevelSelectorCollectionViewController.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPTenantDetailCardDelegate.h"
#import "GGPTenantDetailCardViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <JMap/JMap.h>

NSString *const kJMapAuthenticationTokenUserKey = @"x-jsapi_user";
NSString *const kJMapAuthenticationTokenUserValue = @"jsapiclient";
NSString *const kJMapAuthenticationTokenPasswordKey = @"x-jsapi_passcode";
NSString *const kJMapAuthenticationTokenPasswordValue = @"JSapi23";
NSString *const kJMapAuthenticationTokenAPIKey = @"x-jsapi_key";
NSString *const kJMapAPIVersionKey = @"x-jsapi_version";
NSString *const kJMapAPIVersionValue = @"3.3.0";
NSString *const kJMapAuthenticationTokenAPIValue = @"JMJ143880vl1045185ENRLW143880fz1";

NSTimeInterval const kScaleFactorChangeThreshold = 0.5;

NSString *const kJMapAPIRequestURL = @"https://ggp.js-network.co";

static const double kCardDetailAnimation = 0.25;

@interface GGPJMapViewController () <JMapDelegate, JMapDataSource, GGPTenantDetailCardDelegate>

//+Highlighting
@property (weak, nonatomic) IBOutlet UIView *detailCardContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailCardContainerBottomConstraint;
@property (strong, nonatomic) NSMutableArray *highlightedDestinations;
@property (strong, nonatomic) NSArray *allDestinations;
@property (strong, nonatomic) GGPTenant *tenantToDisplay;

//+Levels
@property (weak, nonatomic) IBOutlet UIView *levelSelectorContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelContainerWidthConstraint;
@property (strong, nonatomic) GGPLevelSelectorCollectionViewController *levelSelectorCollectionViewController;
@property (strong, nonatomic) NSMutableArray *reversedFloors;

//+Wayfinding
@property (strong, nonatomic) GGPTenant *wayfindingStartTenant;
@property (strong, nonatomic) GGPTenant *wayfindingEndTenant;
@property (strong, nonatomic) JMapFloor *wayfindingStartFloor;
@property (strong, nonatomic) JMapFloor *wayfindingEndFloor;
@property (strong, nonatomic) UIImageView *startPinImageView;
@property (strong, nonatomic) UIImageView *endPinImageView;
@property (strong, nonatomic) NSArray *wayfindingFloors;
@property (strong, nonatomic) GGPWayfindingFloor *currentWayfindingFloor;
@property (assign, nonatomic) BOOL isWayfindingRouteActive;

//+Zoom
@property (strong, nonatomic) NSMutableArray *allUnitLabelVCs;
@property (strong, nonatomic) NSArray *floors;
@property (assign, nonatomic) BOOL isZoomedToTenant;

//+Parking
@property (strong, nonatomic) NSArray *allParkingLots;
@property (strong, nonatomic) NSArray *parkingLotLevels;
@property (strong, nonatomic) NSArray *parkingLayerWaypoints;
@property (strong, nonatomic) GGPTenant *parkNearTenant;
@property (assign, nonatomic) BOOL isParkingAvailabilityActive;
@property (strong, nonatomic) UIView *tenantParkingPin;

//+Amenities
@property (weak, nonatomic) IBOutlet UIView *amenitiesContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amenitiesContainerWidthConstraint;
@property (strong, nonatomic) GGPAmenityCollectionViewController *amenityCollectionViewController;
@property (strong, nonatomic) NSArray *mallAmenityTypes;
@property (strong, nonatomic) NSArray *mallAmenities;
@property (strong, nonatomic) GGPAmenity *selectedAmenity;
@property (strong, nonatomic) NSArray *selectedAmenityWaypoints;
@property (assign, nonatomic) BOOL isAmenityFilterActive;

@property (strong, nonatomic) NSDate *lastScaleFactorChange;
@property (strong, nonatomic) GGPTenantDetailCardViewController *tenantDetailCardViewController;
@property (strong, nonatomic) JMapContainerView *mapView;

@end

@implementation GGPJMapViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.allUnitLabelVCs = [NSMutableArray new];
        self.lastScaleFactorChange = [NSDate date];
        self.mapView = [[JMapContainerView alloc] initDataWithLanguage:[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] andDelegate:self andDataSource:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMapView];
    [self configureTapToZoomRecognizer];
    [self configureWayfindingPins];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureWayfindingView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resetMapView];
}

- (void)configureMapView {
    self.showIcons = YES;
    [JMapContainerView deleteCacheFolder];
    [self.view insertSubview:self.mapView belowSubview:self.detailCardContainer];
    self.mapView.minimumZoomScale = 0.1;
}

- (void)loadMapData {
    if ([GGPMallManager shared].selectedMall) {
        JMapSelectedLocation *selectedLocation = [JMapSelectedLocation new];
        selectedLocation.projectId = @([GGPMallManager shared].selectedMall.mallId);
        [self.mapView reloadMapDataForSelectedLocation:selectedLocation];
    }
}

- (void)setShowIcons:(BOOL)showIcons {
    if (showIcons) {
        [self.mapView showAllIcons];
    } else {
        [self.mapView hideAllIcons];
    }
}

- (void)setShowAmenityFilter:(BOOL)showAmenityFilter {
    _showAmenityFilter = showAmenityFilter;
    self.amenitiesContainer.hidden = !showAmenityFilter;
    
    if (!showAmenityFilter) {
        self.isAmenityFilterActive = NO;
    }
}

#pragma mark - Helpers

- (NSString *)locationDescriptionForTenant:(GGPTenant *)tenant {
    if (tenant.isAnchor) {
        return [@"DETAILS_ANCHOR_STORE" ggp_toLocalized];
    }
    
    JMapDestination *destination = [self retrieveDestinationFromLeaseId:tenant.leaseId];
    NSString *locationLevel = destination.level;
    
    if (self.floors.count == 1 || !locationLevel) {
        locationLevel = @"";
    }
    
    return [NSString stringWithFormat:@"%@%@", locationLevel, [self retrieveFormattedStringForProximity:[self proximityNameForTenant:tenant]]];
}

- (NSString *)formattedLocationDescriptionForTenant:(GGPTenant *)tenant {
    NSString *locationDescription = [self locationDescriptionForTenant:tenant];
    return locationDescription.length ? [NSString stringWithFormat:@" (%@)", locationDescription] : @"";
}

- (NSString *)parkingLocationDescriptionForTenant:(GGPTenant *)tenant {
    NSString *proximityName = [self proximityNameForTenant:tenant];
    return proximityName ? [NSString stringWithFormat:@"%@ %@", [@"PARKING_PARK_NEAR" ggp_toLocalized], proximityName] : @"";
}

- (NSString *)nearbyLocationDescriptionForTenant:(GGPTenant *)tenant {
    return [NSString stringWithFormat:@"near %@", [self proximityNameForTenant:tenant]];
}

- (NSString *)proximityNameForTenant:(GGPTenant *)tenant {
    JMapDestination *destination = [self retrieveDestinationFromLeaseId:tenant.leaseId];
    return [destination.destinationProximities.firstObject destinationName];
}

- (NSString *)retrieveFormattedStringForProximity:(NSString *)proximityName {
    if (!proximityName) {
        return @"";
    }
    
    return self.floors.count == 1 ? [NSString stringWithFormat:@"Near %@", proximityName] : [NSString stringWithFormat:@", near %@", proximityName];
}

/**
 *  A Tenant's "leaseId" is the first component of a destination's clientId
 *
 *  @param destinationClientId
 *
 *  @return First component of the destination's client id which corresponds to a tenant's leaseId
 */
- (NSString *)leaseIdFromDestinationClientId:(NSString *)destinationClientId {
    return [destinationClientId componentsSeparatedByString:@"-"][0];
}

- (JMapDestination *)retrieveDestinationFromLeaseId:(NSInteger)leaseId {
    for (JMapDestination *destination in self.allDestinations) {
        NSString *clientId = [self leaseIdFromDestinationClientId:destination.clientId];
        if ([clientId isEqual:[NSString stringWithFormat:@"%ld", (long)leaseId]]) {
            return destination;
        }
    }
    return nil;
}

- (void)displayDetailCardForTenant:(GGPTenant *)tenant {
    self.tenantDetailCardViewController = [[GGPTenantDetailCardViewController alloc] initWithTenant:tenant];
    self.tenantDetailCardViewController.tenantDetailCardDelegate = self;
    [self ggp_addChildViewController:self.tenantDetailCardViewController toPlaceholderView:self.detailCardContainer];

    [self.tenantDetailCardViewController updateLayout];
    
    [UIView animateWithDuration:kCardDetailAnimation animations:^{
        self.detailCardContainerBottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
    
    self.detailCardContainer.hidden = NO;
    [self setShowLevelButtons:NO];
}

- (void)removeDetailCard {
    [self.tenantDetailCardViewController ggp_removeFromParentViewController];
    self.detailCardContainer.hidden = YES;
    self.tenantDetailCardViewController = nil;
}

- (void)addImage:(UIImage *)image atWaypoint:(JMapWaypoint *)waypoint {
    JMapFloor *floor = [self.mapView getLevelById:waypoint.mapId.integerValue];
    UIView *floorView = [self.mapView floorViewFromSequence:floor.floorSequence];
    [self.mapView addWayFindView:[[UIImageView alloc] initWithImage:image] atXY:CGPointMake(waypoint.x.floatValue, waypoint.y.floatValue) forFloorId:floorView];
}

#pragma mark - Reset map view

- (void)resetMapViewAndFilters:(BOOL)resetFilters {
    [self hideParkingLayer];
    
    if (resetFilters) {
        [self clearHighlightedDestinations];
        [self.amenityCollectionViewController resetAmenitySelection];
    } else {
        [self reloadAmenityFilters];
    }
    
    if (self.highlightedDestinations.count == 0) {
        [self.mapView unhighlightAllUnits];
    } else {
        [self unhighlightUnitsBasedOnFilters];
    }
    
    [self.levelSelectorCollectionViewController.collectionView reloadData];
    [self.amenityCollectionViewController.collectionView reloadData];
    
    [UIView animateWithDuration:kCardDetailAnimation animations:^{
        self.detailCardContainerBottomConstraint.constant = -self.detailCardContainer.frame.size.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeDetailCard];
        [self setShowLevelButtons:YES];
    }];
}

- (void)resetMapView {
    [self resetMapViewAndFilters:NO];
}

#pragma mark - TenantDetailCard delegate

- (void)tenantCardWasDismissed {
    [self resetMapView];
}

#pragma mark - LevelSelectorController delegate

- (void)levelCellWasTapped:(JMapFloor *)selectedFloor {
    [self moveToFloor:selectedFloor];
}

#pragma mark - JMapDelegate methods

- (void)jMapViewDataReady:(JMapContainerView *)sender withVenuData:(JMapVenue *)data didFailLoadWithError:(NSError *)error {
    self.allDestinations = [self.mapView getDestinations];
    self.floors = [self.mapView getLevels];
    [self configureLevels];
    [self configureAmenities];
    [self zoomToMall];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GGPJMapDataReadyNotification object:nil];
}

- (void)jMapViewContentScaleFactor:(NSNumber *)newScale onFloor:(JMapFloor *)onFloor {
    [self updateUnitLabelsWithScale:newScale];
}

- (void)jMapViewContentScaleFactorChange:(NSNumber *)nextScale onFloor:(JMapFloor *)onFloor {
    NSTimeInterval timeSinceLastChange = [[NSDate date] timeIntervalSinceDate:self.lastScaleFactorChange];
    if (timeSinceLastChange > kScaleFactorChangeThreshold) {
        [self jMapViewContentScaleFactor:nextScale onFloor:onFloor];
        self.lastScaleFactorChange = [NSDate date];
    }
}

- (UIView *)jMapViewShouldDisplayAsTooltipDestinations:(NSArray *)destinations onFloor:(JMapFloor *)onFloor insideUnit:(BOOL *)insideUnit {
    JMapDestination *destination = destinations.firstObject;
    if (!destination) {
        return nil;
    }
    *insideUnit = YES;
    GGPJMapUnitLabelViewController *unitLabelVC = [[GGPJMapUnitLabelViewController alloc] initWithUnitName:destination.name];
    [self.allUnitLabelVCs addObject:unitLabelVC];
    
    return unitLabelVC.view;
}

- (BOOL)jMapViewShouldRotateUnitLabels {
    return YES;
}

- (BOOL)jMapViewShouldProcessUnitLabels:(JMapFloor *)onFloor {
    return YES;
}

- (BOOL)jMapViewShouldDisplayUnitLabelForDestinations:(NSArray *)destinations onFloor:(JMapFloor *)onFloor {
    return YES;
}

- (BOOL)jMapViewShouldProcessAMIcons {
    return YES;
}

- (JMapAMStyles *)jMapViewThisAMIconStyle:(JMapAmenity *)thisIcon {
    JMapSVGStyle *svgWhiteStyle = [JMapSVGStyle new];
    [svgWhiteStyle setCGContextSetRGBFillColor:255 g:255 b:255 a:1];
    JMapSVGStyle *svgBlackStyle = [JMapSVGStyle new];
    [svgBlackStyle setCGContextSetRGBFillColor:64 g:64 b:64 a:1];
    
    JMapAMStyles *amStyle = [[JMapAMStyles alloc] initWithStyleF:svgWhiteStyle
                                                               m:svgBlackStyle
                                                               b:svgBlackStyle];
    amStyle.width = @(26);
    amStyle.height = @(26);
    
    if ([thisIcon.description.lowercaseString containsString:@"parking".lowercaseString]) {
        amStyle.width = @(40);
        amStyle.height = @(40);
    }
    
    return amStyle;
}

- (NSDictionary *)JMapAuthenticationTokens {
    return @{
             kJMapAuthenticationTokenUserKey: kJMapAuthenticationTokenUserValue,
             kJMapAuthenticationTokenPasswordKey: kJMapAuthenticationTokenPasswordValue,
             kJMapAuthenticationTokenAPIKey: kJMapAuthenticationTokenAPIValue,
             kJMapAPIVersionKey : kJMapAPIVersionValue
             };
}

- (NSString *)JMapAPIRequestURL:(JMapContainerView *)sender {
    return kJMapAPIRequestURL;
}

- (BOOL)jMapViewShouldLoadCustomCSSDictionaryHandler {
    return YES;
}

- (void)jMapViewWillLoadCustomCSSDictionaryHandler:(JMapContainerView *)sender withCompletion:(void (^)(JMapCustomStyleSheet *))completion {
    NSString *jsonConfig = [[NSBundle mainBundle] pathForResource:@"jmapConfig" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:jsonConfig encoding:NSUTF8StringEncoding error:nil];
    
    if (jsonString) {
        JMapCustomStyleSheet *sheet = [JMapCustomStyleSheet new];
        sheet.jSONSourceConfig = jsonString;
        if (completion) {
            completion(sheet);
        }
    }
}

- (BOOL)jMapViewShouldProcessStreetNames:(JMapFloor *)thisFloor {
    return YES;
}

- (UIView *)jMapViewShouldDisplayStreetName:(JMapMapLabels *)thisLabel onfloor:(JMapFloor *)thisFloor {
    UILabel *streetNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    streetNameLabel.text = thisLabel.localizedText;
    streetNameLabel.font = [UIFont ggp_mediumWithSize:30];
    streetNameLabel.textColor = [UIColor ggp_darkGray];
    [streetNameLabel sizeToFit];
    
    return streetNameLabel;
}

#pragma mark - Required Delegate Methods

- (void)jMapView:(JMapContainerView *)sender didSendTouchInfo:(NSDictionary *)touchInfo {}

- (void)jMapViewDidTapOnDestination:(NSArray *)thisDestinationArray destinationCenterPoint:(JMapPointOnFloor *)destinationCenterPoint {
    if (self.mapViewControllerDelegate) {
        [self handleTappedDestination:thisDestinationArray.firstObject];
    }
}

- (void)jMapView:(JMapContainerView *)sender didSendAllLocationsAvailable:(NSArray *)data didFailLoadWithError:(NSError *)error {}

- (void)jMapViewProcessStreetNamesStart:(JMapFloor *)thisFloor {}

- (void)jMapViewProcessStreetNamesFinish:(JMapFloor *)thisFloor {}

- (void)reloadStreetNames {}

- (void)removeStreetNames {}

- (void)jMapViewProcessUnitLabelsStart:(id)floorViewId {}

- (void)jMapViewProcessUnitLabelsFinish:(id)floorViewId {}

- (void)jMapViewProcessAMIconsStart {}

- (void)jMapViewProcessAMIconsFinish {}

- (void)AMIconTapped:(JMapAmenity *)thisAMIcon atXY:(NSValue *)atXY {}

@end
