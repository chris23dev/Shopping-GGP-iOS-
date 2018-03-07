//
//  GGPJMapViewController+Amenities.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapViewController+Amenities.h"
#import "GGPJmapViewcontroller+Levels.h"
#import "GGPAmenityCollectionViewController.h"
#import "GGPAmenity.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <JMap/JMap.h>

static NSString *const kJMapAmenityRestroom = @"Restroom";
static NSString *const kJMapAmenityKiosk = @"Kiosk";
static NSString *const kJMapAmenityMallManagement = @"Mall Management";
static NSString *const kJMapAmenityAtm = @"ATM";
static NSString *const kJMapAmenityParking = @"Parking";
static NSString *const kJMapMoverEscalator = @"Escalator";
static NSString *const kJMapMoverElevator = @"Elevator";
static NSString *const kJMapMoverStairCase = @"Stair Case";

static CGFloat const kAmenityCellWidth = 61;

@interface GGPJMapViewController ()

@property (weak, nonatomic) IBOutlet UIView *amenitiesContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amenitiesContainerWidthConstraint;
@property (strong, nonatomic) JMapContainerView *mapView;
@property (strong, nonatomic) GGPAmenityCollectionViewController *amenityCollectionViewController;
@property (strong, nonatomic) NSArray *mallAmenityTypes;
@property (strong, nonatomic) NSArray *mallAmenities;
@property (strong, nonatomic) GGPAmenity *selectedAmenity;
@property (strong, nonatomic) NSArray *selectedAmenityWaypoints;
@property (assign, nonatomic) BOOL isAmenityFilterActive;

@end

@implementation GGPJMapViewController (Amenities)

- (void)configureAmenities {
    [self view]; //Need to ensure outlets are loaded
    self.showAmenityFilter = NO;
    
    [self.amenitiesContainer ggp_addBorderWithWidth:1 andColor:[UIColor ggp_lightGray]];
    [self.amenitiesContainer ggp_addShadowWithRadius:4 andOpacity:0.30];
    [self.amenitiesContainer ggp_addBorderRadius:5];
    
    self.amenityCollectionViewController = [GGPAmenityCollectionViewController new];
    [self ggp_addChildViewController:self.amenityCollectionViewController toPlaceholderView:self.amenitiesContainer];
    
    self.mallAmenities = [self.mapView getAmenities];
    self.mallAmenityTypes = [self amenityTypesForMall];
    
    NSArray *filterableAmenities = [self filterableAmenities];
    self.amenitiesContainerWidthConstraint.constant = filterableAmenities.count * kAmenityCellWidth;
    [self.amenityCollectionViewController configureWithAmenities:filterableAmenities];
}

- (void)reloadAmenityFilters {
    if (self.showAmenityFilter) {
        [self highlightAmenity:self.selectedAmenity];
    }
}

- (NSArray *)filterableAmenities {
    NSMutableArray *amenities = [NSMutableArray new];
    
    if ([self mallHasAmenityType:kJMapAmenityRestroom]) {
        [amenities addObject:[[GGPAmenity alloc] initWithName:[@"MAP_AMENITY_RESTROOM" ggp_toLocalized] jmapType:kJMapAmenityRestroom defaultImage:[UIImage imageNamed:@"ggp_amenity_restroom_gray"] selectedImage:[UIImage imageNamed:@"ggp_amenity_restroom_white"] andMapImage:[UIImage imageNamed:@"ggp_amenity_restroom_blue"]]];
    }
    
    if ([self mallHasAmenityType:kJMapAmenityAtm]) {
        [amenities addObject:[[GGPAmenity alloc] initWithName:[@"MAP_AMENITY_ATM" ggp_toLocalized] jmapType:kJMapAmenityAtm defaultImage:[UIImage imageNamed:@"ggp_amenity_atm_gray"] selectedImage:[UIImage imageNamed:@"ggp_amenity_atm_white"] andMapImage:[UIImage imageNamed:@"ggp_amenity_atm_blue"]]];
    }
    
    if ([self mallHasAmenityType:kJMapAmenityMallManagement]) {
        [amenities addObject:[[GGPAmenity alloc] initWithName:[@"MAP_AMENITY_MANAGEMENT" ggp_toLocalized] jmapType:kJMapAmenityMallManagement defaultImage:[UIImage imageNamed:@"ggp_amenity_mgmt_gray"] selectedImage:[UIImage imageNamed:@"ggp_amenity_mgmt_white"] andMapImage:[UIImage imageNamed:@"ggp_amenity_mgmt_blue"]]];
    }
    
    if ([self mallHasAmenityType:kJMapAmenityKiosk]) {
        [amenities addObject:[[GGPAmenity alloc] initWithName:[@"MAP_AMENITY_KIOSK" ggp_toLocalized] jmapType:kJMapAmenityKiosk defaultImage:[UIImage imageNamed:@"ggp_amenity_kiosk_gray"] selectedImage:[UIImage imageNamed:@"ggp_amenity_kiosk_white"] andMapImage:[UIImage imageNamed:@"ggp_amenity_kiosk_blue"]]];
    }
    
    return amenities;
}

- (BOOL)mallHasAmenityType:(NSString *)type {
    for (NSString *amenityType in self.mallAmenityTypes) {
        if ([amenityType containsString:type]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *)amenityTypesForMall {
    NSMutableArray *amenityTypes = [NSMutableArray new];
    
    for (JMapAmenity *mapAmenity in self.mallAmenities) {
        [amenityTypes addObject:mapAmenity.description];
    }
    
    return amenityTypes;
}

- (void)highlightAmenity:(GGPAmenity *)amenity {
    self.selectedAmenity = amenity;
    if (!self.selectedAmenity) {
        return;
    }
    
    self.isAmenityFilterActive = YES;
    [self.mapView showOnlyIconsTypeArray:@[kJMapAmenityParking, kJMapMoverElevator, kJMapMoverEscalator, kJMapMoverStairCase]];
    
    NSArray<JMapAmenity *> *selectedAmenities = [self.mallAmenities ggp_arrayWithFilter:^BOOL(JMapAmenity *jmapAmenity) {
        return [jmapAmenity.description containsString:amenity.jmapType];
    }];
    
    NSMutableArray *waypoints = [NSMutableArray array];
    
    // Workaround for resolving different images for restrooms.
    // It should be fixed by using SVG images for JMap
    BOOL isRestroom = [amenity.jmapType isEqualToString:kJMapAmenityRestroom];
    
    for (JMapAmenity *selectedAmenity in selectedAmenities) {
        [waypoints addObjectsFromArray:selectedAmenity.waypoints];
    
        UIImage *mapImage = nil;
        if (isRestroom) {
            mapImage = [self imageForRestroomWithAmenity:selectedAmenity];
        } else {
            mapImage = amenity.mapImage;
        }
        
        for (JMapWaypoint *waypoint in selectedAmenity.waypoints) {
            [self addImage:mapImage atWaypoint:waypoint];
        }
    }
    
    self.selectedAmenityWaypoints = waypoints;

    [self reloadLevelSelectorData];
}

- (UIImage *)imageForRestroomWithAmenity:(JMapAmenity *)amenity {
    NSString *imageName = nil;
    
    if ([amenity.description containsString:@"Men"]) {
        imageName = @"ggp_amenity_men_restroom_blue";
    } else if ([amenity.description containsString:@"Women"]) {
        imageName = @"ggp_amenity_woman_restroom_blue";
    } else {
        imageName = @"ggp_amenity_restroom_blue";
    }
    
    return [UIImage imageNamed:imageName];
}

- (BOOL)amenityExistsOnFloor:(JMapFloor *)floor {
    for (JMapWaypoint *waypoint in self.selectedAmenityWaypoints) {
        if (waypoint.mapId == floor.mapId) {
            return YES;
        }
    }
    
    return NO;
}

- (void)resetAmenityFilters {
    self.isAmenityFilterActive = NO;
    [self.mapView showAllIcons];
    [self.mapView removeAllWayFindViews];
    [self reloadLevelSelectorData];
}

@end
