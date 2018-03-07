//
//  GGPJMapViewController+Parking.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPClient.h"
#import "GGPJmapViewController+Highlighting.h"
#import "GGPJmapViewcontroller+Levels.h"
#import "GGPJMapViewController+Parking.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPParkingLot.h"
#import "GGPParkingLotOccupancy.h"
#import "GGPParkingLotThreshold.h"
#import "GGPTenant.h"
#import "NSArray+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import <JMap/JMap.h>

static NSString *const kParkingZonesLayer = @"Parking-Zones";
static NSString *const kWaypointUnitKey = @"waypoint-unit";
static NSString *const kJMapMoverEscalator = @"Escalator";
static NSString *const kJMapMoverElevator = @"Elevator";
static NSString *const kJMapMoverStairCase = @"Stair Case";
static NSInteger const kNumberOfClosestLotsToDisplay = 3;
static CGFloat const kMapTopOffset = 150;

@interface GGPJMapViewController ()

@property (strong, nonatomic) JMapContainerView *mapView;
@property (strong, nonatomic) NSArray *allParkingLots;
@property (strong, nonatomic) NSArray *parkingLotLevels;
@property (strong, nonatomic) NSArray *parkingLayerWaypoints;
@property (strong, nonatomic) GGPTenant *parkNearTenant;
@property (assign, nonatomic) BOOL isParkingAvailabilityActive;
@property (strong, nonatomic) UIView *tenantParkingPin;

- (JMapWaypoint *)waypointForTenant:(GGPTenant *)tenant onFloor:(JMapFloor *)floor;

@end

@implementation GGPJMapViewController (Parking)

- (void)showAvailabilityForParkingLots:(NSArray *)parkingLots {
    self.isParkingAvailabilityActive = YES;
    
    [self zoomToParkingLayer];
    [self clearParkingLotColors];
    [self.mapView showOnlyIconsTypeArray:@[kJMapMoverElevator, kJMapMoverEscalator, kJMapMoverStairCase]];

    self.allParkingLots = parkingLots;
    self.parkingLayerWaypoints = [self waypointsForParkingLayer];
    
    if (self.parkNearTenant) {
        [self highlightParkingLots:[self closestParkingLotsToTenant:self.parkNearTenant]];
    } else {
        [self highlightParkingLots:self.allParkingLots];
    }
    
    self.parkingLotLevels = [self levelsForParkingLots:self.allParkingLots];
    [self updateLevelSelectorForParking];
    [self displayCustomParkingIcons];
    [self.mapView showMapLayer:kParkingZonesLayer];
}

- (void)hideParkingLayer {
    self.isParkingAvailabilityActive = NO;
    self.parkNearTenant = nil;
    
    [self.mapView hideMapLayer:kParkingZonesLayer];
    [self clearParkingLotColors];
    [self.mapView showAllIcons];
    [self.mapView removeAllWayFindViews];
    [self removeAllParkingFloor];
}

- (void)resetParkNearSelection {
    [self removeParkingPin];
    [self clearHighlightedDestinations];
    [self clearParkingLotColors];
    [self highlightParkingLots:self.allParkingLots];
    self.parkNearTenant = nil;
}

- (void)highlightClosestParkingLotsToTenant:(GGPTenant *)tenant {
    self.parkNearTenant = tenant;
    NSArray *closestParkingLots = [self closestParkingLotsToTenant:tenant];
    
    [self moveToLowestLevelForParkingLots:closestParkingLots];
    
    [self clearParkingLotColors];
    [self clearHighlightedDestinations];
    
    [self placePinAtTenant:tenant];
    [self highlightParkingLots:closestParkingLots];
    
}

- (void)moveToLowestLevelForParkingLots:(NSArray *)parkingLots {
    NSMutableArray *parkingLotLevels = [self levelsForParkingLots:parkingLots].mutableCopy;
    
    [parkingLotLevels sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"floorSequence" ascending:YES]]];
    
    [self moveToFloor:parkingLotLevels.firstObject];
    [self updateLevelWithSelectedFloor:parkingLotLevels.firstObject];
}

- (void)clearParkingLotColors {
    for (JMapWaypoint *waypoint in self.parkingLayerWaypoints) {
        [self highLightParkingLotForWaypointId:waypoint.id withColor:[UIColor clearColor]];
    }
}

- (void)zoomToParkingLayer {
    JMapFloor *defaultFloor = [self.mapView getLevelById:self.mapView.defaultFloorId.integerValue];
    [self moveToFloor:defaultFloor];
    [self updateLevelWithSelectedFloor:defaultFloor];
    
    CGRect zoomRect = [self.mapView rectForStyleString:kParkingZonesLayer onFloor:defaultFloor];
    zoomRect.origin.y = zoomRect.origin.y - kMapTopOffset;
    
    [self.mapView zoomToRect:zoomRect animated:NO];
    [self.mapView setZoomScale:[self.mapView zoomScale] * 0.7];
}

- (void)placePinAtTenant:(GGPTenant *)tenant {
    if (!self.tenantParkingPin) {
        self.tenantParkingPin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ggp_red_pin"]];
    }
    
    JMapFloor *tenantFloor = [self defaultFloorForTenant:tenant];
    JMapWaypoint *waypoint = [self waypointForTenant:tenant onFloor:tenantFloor];
    CGPoint mapPoint = CGPointMake(waypoint.x.floatValue, waypoint.y.floatValue - self.tenantParkingPin.frame.size.height/2);
    UIView *floorView = [self.mapView floorViewFromSequence:tenantFloor.floorSequence];
    
    [self.mapView addWayFindView:self.tenantParkingPin atXY:mapPoint forFloorId:floorView];
}

- (void)removeParkingPin {
    JMapFloor *tenantFloor = [self defaultFloorForTenant:self.parkNearTenant];
    UIView *floorView = [self.mapView floorViewFromSequence:tenantFloor.floorSequence];
    [self.mapView removeWayFindView:self.tenantParkingPin forFloorId:floorView];
}

#pragma mark Helpers

- (NSArray *)closestParkingLotsToTenant:(GGPTenant *)tenant {
    NSArray *closestUnitNumbers = [self closestUnitNumbersToTenant:tenant];
    
    NSMutableArray *parkingLots = [NSMutableArray new];
    for (NSString *unitNumber in closestUnitNumbers) {
        GGPParkingLot *lot = [self parkingLotForWaypointUnitNumber:unitNumber];
        if (lot && lot.isValid) {
            [parkingLots addObject:lot];
            if (parkingLots.count == kNumberOfClosestLotsToDisplay) {
                return parkingLots;
            }
        }
    }
    
    return parkingLots;
}

- (NSArray *)closestUnitNumbersToTenant:(GGPTenant *)tenant {
    NSDictionary *distanceToUnitNumberLookup = [self parkingDistanceLookupForTenant:tenant];
    
    NSArray *sortedUnitNumbers = [distanceToUnitNumberLookup keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    return sortedUnitNumbers;
}

- (NSDictionary *)parkingDistanceLookupForTenant:(GGPTenant *)tenant {
    JMapDestination *destination = [self retrieveDestinationFromLeaseId:tenant.leaseId];
    JMapWaypoint *destinationWaypoint = [self.mapView getWayPointByDestinationId:destination.id];
    
    NSMutableDictionary *distanceDictionary = [NSMutableDictionary new];
    
    for (JMapWaypoint *lotWaypoint in self.parkingLayerWaypoints) {
        if (lotWaypoint.unitNumber) {
            CGFloat distance = [self distanceFromWaypoint:destinationWaypoint toWaypoint:lotWaypoint];
            [distanceDictionary setValue:@(distance) forKey:lotWaypoint.unitNumber];
        }
    }
    
    return distanceDictionary;
}

- (CGFloat)distanceFromWaypoint:(JMapWaypoint *)fromWaypoint toWaypoint:(JMapWaypoint *)toWaypoint {
    return hypotf(fromWaypoint.x.floatValue - toWaypoint.x.floatValue, fromWaypoint.y.floatValue - toWaypoint.y.floatValue);
}

- (NSArray *)waypointsForParkingLayer {
    NSArray *shapes = [self.mapView getAllShapesDataFromLayerName:kParkingZonesLayer];
    NSMutableArray *waypoints = [NSMutableArray new];
    
    for (NSDictionary *shape in shapes) {
        [waypoints addObjectsFromArray:[self waypointsInShape:shape]];
    }
    
    return waypoints;
}

- (NSArray *)waypointsInShape:(NSDictionary *)shape {
    NSMutableArray *waypoints = [NSMutableArray new];
    NSArray *waypointIds = shape[kWaypointUnitKey];
    
    for (NSNumber *waypointId in waypointIds) {
        JMapWaypoint *waypoint = [self.mapView getWayPointById:waypointId];
        if (waypoint && [self parkingLotForWaypointUnitNumber:waypoint.unitNumber]) {
            [waypoints addObject:waypoint];
        }
    }
    
    return waypoints;
}

- (NSArray *)waypointsForParkingLot:(GGPParkingLot *)parkingLot {
    return [self.parkingLayerWaypoints ggp_arrayWithFilter:^BOOL(JMapWaypoint *waypoint) {
        return [waypoint.unitNumber isEqualToString:@(parkingLot.facilityId).stringValue];
    }];
}

- (GGPParkingLot *)parkingLotForWaypointUnitNumber:(NSString *)unitNumber {
    return [self.allParkingLots ggp_firstWithFilter:^BOOL(GGPParkingLot *parkingLot) {
        return parkingLot.facilityId == unitNumber.integerValue;
    }];
}

- (NSArray *)levelsForParkingLots:(NSArray *)parkingLots {
    NSMutableArray *parkingLotLevels = [NSMutableArray new];
    
    for (GGPParkingLot *parkingLot in parkingLots) {
        for (JMapWaypoint *waypoint in parkingLot.waypoints) {
            JMapFloor *floor = [self.mapView getLevelById:waypoint.mapId.integerValue];
            if (floor) {
                [parkingLotLevels addObject:floor];
            }
        }
        
    }
    
    return parkingLotLevels;
}

- (BOOL)parkingAvailabileForFloor:(JMapFloor *)floor {
    if (self.parkNearTenant) {
        NSArray *parkingLevels = [self levelsForParkingLots:[self closestParkingLotsToTenant:self.parkNearTenant]];
        return [parkingLevels containsObject:floor];
    } else {
        return [self.parkingLotLevels containsObject:floor];
    }
}

- (UIColor *)colorForOccupancyPercentage:(NSInteger)occupancyPercentage fromThresholds:(NSArray *)thresholds {
    for (GGPParkingLotThreshold *threshold in thresholds) {
        if ([self isOccupancyPercentage:occupancyPercentage withinThreshold:threshold]) {
            return [UIColor ggp_colorFromHexString:threshold.colorHex andAlpha:threshold.alphaPercentage/100.0f];
        }
    }
    return nil;
}

- (BOOL)isOccupancyPercentage:(NSInteger)occupancyPercentage withinThreshold:(GGPParkingLotThreshold *)threshold {
    return occupancyPercentage >= threshold.minPercentage && occupancyPercentage <= threshold.maxPercentage;
}

#pragma mark Styling

- (void)highlightParkingLots:(NSArray *)parkingLots {
    for (GGPParkingLot *parkingLot in parkingLots) {
        if (parkingLot.isValid) {
            GGPParkingLotOccupancy *occupancy = parkingLot.occupancies.firstObject;
            UIColor *fillColor = [self colorForOccupancyPercentage:occupancy.occupancyPercentage fromThresholds:[GGPMallManager shared].selectedMall.config.parkingLotThresholds];
            
            parkingLot.waypoints = [self waypointsForParkingLot:parkingLot];
            for (JMapWaypoint *waypoint in parkingLot.waypoints) {
                [self highLightParkingLotForWaypointId:waypoint.id withColor:fillColor];
            }
        }
    }
}

- (void)highLightParkingLotForWaypointId:(NSNumber *)waypointId withColor:(UIColor *)fillColor {
    if (waypointId) {
        JMapSVGStyle *style = [[JMapSVGStyle alloc] init];
        
        CGFloat red, green, blue, alpha;
        [fillColor getRed:&red green:&green blue:&blue alpha:&alpha];
        
        [style closePath:YES];
        [style setCGContextSetLineWidth:10.0];
        [style setCGContextSetRGBStrokeColor:red*255 g:green*255 b:blue*255 a:alpha];
        [style setCGContextSetRGBFillColor:red*255 g:green*255 b:blue*255 a:alpha];
        
        NSDictionary *idDictionary = @{ kWaypointUnitKey : waypointId };
        [self.mapView highlightLayerWithName:kParkingZonesLayer byIdPair:idDictionary withSVGStyle:style];
    }
}

- (void)displayCustomParkingIcons {
    for (JMapWaypoint *waypoint in self.parkingLayerWaypoints) {
        [self addImage:[UIImage imageNamed:@"ggp_map_parking"] atWaypoint:waypoint];
    }
}

@end
