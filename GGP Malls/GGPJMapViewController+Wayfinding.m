//
//  GGPJMapViewController+Wayfinding.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJmapViewcontroller+Levels.h"
#import "GGPJMapViewController+Wayfinding.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPLevelSelectorCollectionViewController.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPTenant.h"
#import "GGPWayfindingFloor.h"
#import "GGPWayfindingMover.h"
#import "GGPWayfindingMoverDirection.h"
#import "GGPWayfindingPathView.h"
#import "NSArray+GGPAdditions.h"
#import "UIImage+GGPAdditions.h"
#import <JMap/JMap.h>

static const NSInteger kMapUnitPadding = 100;
static const NSInteger kJMapAccessibilityIncludingStairsAndEscalator = 100;
static const NSInteger kJMapUturnThreshold = 30.0;
static NSString *const kMoverType = @"mover";
static const CGFloat kPinWidth = 40;
static const CGFloat kPinHeight = 60;

@interface GGPJMapViewController () <JMapDelegate>

@property (strong, nonatomic) JMapContainerView *mapView;

@property (strong, nonatomic) GGPTenant *wayfindingStartTenant;
@property (strong, nonatomic) GGPTenant *wayfindingEndTenant;
@property (strong, nonatomic) JMapFloor *wayfindingStartFloor;
@property (strong, nonatomic) JMapFloor *wayfindingEndFloor;
@property (strong, nonatomic) UIImageView *startPinImageView;
@property (strong, nonatomic) UIImageView *endPinImageView;
@property (assign, nonatomic) BOOL isWayfindingRouteActive;
@property (strong, nonatomic) NSArray *wayfindingFloors;
@property (strong, nonatomic) GGPWayfindingFloor *currentWayfindingFloor;

- (void)zoomToTenant:(GGPTenant *)tenant onFloor:(JMapFloor *)floor withIcons:(BOOL)shouldShowIcons andHighlight:(BOOL)shouldHighlight;
- (void)updateUnitLabelsWithScale:(NSNumber *)newScale;
- (void)moveToFloor:(JMapFloor *)tenantFloor;
- (JMapDestination *)retrieveDestinationFromLeaseId:(NSInteger)leaseId;

@end

@implementation GGPJMapViewController (Wayfinding)

- (void)resetWayfindingData {
    self.wayfindingStartTenant = nil;
    self.wayfindingStartFloor = nil;
    self.wayfindingEndTenant = nil;
    self.wayfindingEndFloor = nil;
    self.isWayfindingRouteActive = NO;
    [self.mapView removeAllWayFindViews];
}

- (void)configureWayfindingPins {
    CGSize pinSize = CGSizeMake(kPinWidth, kPinHeight);
    UIImage *startPinImage = [UIImage ggp_imageWithImage:[UIImage imageNamed:@"ggp_wayfinding_map_start_pin"] scaledToSize:pinSize];
    UIImage *endPinImage = [UIImage ggp_imageWithImage:[UIImage imageNamed:@"ggp_wayfinding_map_end_pin"] scaledToSize:pinSize];
    self.startPinImageView = [[UIImageView alloc] initWithImage:startPinImage];
    self.endPinImageView = [[UIImageView alloc] initWithImage:endPinImage];
    self.startPinImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.endPinImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)configureWayfindingStartTenant:(GGPTenant *)tenant onFloor:(JMapFloor *)floor {
    if (tenant != self.wayfindingStartTenant || floor != self.wayfindingStartFloor) {
        [self.mapView removeWayFindView:self.startPinImageView forFloorId:[self.mapView floorViewFromSequence:self.wayfindingStartFloor.floorSequence]];
        
        self.wayfindingStartTenant = tenant;
        self.wayfindingStartFloor = floor;
        [self updateEndPinLocation];
        [self placeStartPin];
        
        [self configureWayfindingView];
    }
}

- (void)configureWayfindingEndTenant:(GGPTenant *)tenant {
    self.wayfindingEndTenant = tenant;
    [self updateEndPinLocation];
    
    [self configureWayfindingView];
}

- (void)updateEndPinLocation {
    [self.mapView removeWayFindView:self.endPinImageView forFloorId:[self.mapView floorViewFromSequence:self.wayfindingEndFloor.floorSequence]];
    self.wayfindingEndFloor = [self floorForTenant:self.wayfindingEndTenant closestToFloor:self.wayfindingStartFloor];
    [self placeEndPin];
}

- (void)placeStartPin {
    if (self.wayfindingStartTenant) {
        UIView *floorView = [self.mapView floorViewFromSequence:self.wayfindingStartFloor.floorSequence];
        CGPoint mapPoint = [self mapPointForTenant:self.wayfindingStartTenant onFloor:self.wayfindingStartFloor];
        
        [self.mapView addWayFindView:self.startPinImageView atXY:mapPoint forFloorId:floorView];
    }
}

- (void)placeEndPin {
    if (self.wayfindingEndTenant) {
        UIView *floorView = [self.mapView floorViewFromSequence:self.wayfindingEndFloor.floorSequence];
        CGPoint mapPoint = [self mapPointForTenant:self.wayfindingEndTenant onFloor:self.wayfindingEndFloor];
        
        [self.mapView addWayFindView:self.endPinImageView atXY:mapPoint forFloorId:floorView];
    }
}

- (void)configureWayfindingView {
    if (self.wayfindingStartTenant || self.wayfindingEndTenant) {
        [self.mapView hideAllIcons];
    }
    
    if (self.wayfindingStartTenant && self.wayfindingEndTenant) {
        [self startWayfindingRoute];
    } else if (self.wayfindingStartTenant) {
        [self zoomToTenant:self.wayfindingStartTenant onFloor:self.wayfindingStartFloor withIcons:NO andHighlight:NO];
    } else if (self.wayfindingEndTenant) {
        [self zoomToTenant:self.wayfindingEndTenant onFloor:self.wayfindingEndFloor withIcons:NO andHighlight:NO];
    }
}

- (void)zoomToFloorPath:(JMapPathPerFloor *)floorPath onFloor:(JMapFloor *)floor {
    JMapASNode *firstNode = floorPath.points.firstObject;
    JMapASNode *lastNode = floorPath.points.lastObject;
    
    CGRect startRect = [self rectForPoint:CGPointMake(firstNode.x.floatValue, firstNode.y.floatValue)];
    CGRect endRect = [self rectForPoint:CGPointMake(lastNode.x.floatValue, lastNode.y.floatValue)];
    CGRect zoomRect = CGRectUnion(startRect, endRect);
    
    [self.mapView zoomToRect:zoomRect animated:NO];
    [self updateUnitLabelsWithScale:@(self.mapView.zoomScale)];
    [self updateLevelWithSelectedFloor:floor];
}

- (CGPoint)mapPointForTenant:(GGPTenant *)tenant onFloor:(JMapFloor *)floor {
    JMapWaypoint *waypoint = [self waypointForTenant:tenant onFloor:floor];
    return CGPointMake(waypoint.x.floatValue, waypoint.y.floatValue - self.startPinImageView.frame.size.height/2);
}

- (JMapWaypoint *)waypointForTenant:(GGPTenant *)tenant onFloor:(JMapFloor *)floor {
    NSNumber *destinationId = [self retrieveDestinationFromLeaseId:tenant.leaseId].id;
    
    // Note: we must use predicateWithFormat here since Jibestream does not expose the JMapWaypointAssociation object
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY associations.entityId = %@", destinationId];
    NSArray *waypointsAvailable = [self.mapView.venueObject.waypoints filteredArrayUsingPredicate:predicate];
    
    return [waypointsAvailable ggp_firstWithFilter:^BOOL(JMapWaypoint *waypoint) {
        return waypoint.mapId.integerValue == floor.mapId.integerValue;
    }];
}

- (JMapFloor *)floorForTenant:(GGPTenant *)tenant closestToFloor:(JMapFloor *)targetFloor {
    NSArray *tenantFloors = [self floorsForTenant:tenant];
    
    if (targetFloor && tenantFloors.count > 1) {
        JMapFloor *closestFloor = nil;
        NSInteger min = NSIntegerMax;
        
        for (JMapFloor *tenantFloor in tenantFloors) {
            NSInteger diff = labs(targetFloor.floorSequence.integerValue - tenantFloor.floorSequence.integerValue);
            if (diff == 0) {
                return tenantFloor;
            } else if (diff < min) {
                min = diff;
                closestFloor = tenantFloor;
            }
        }
        return closestFloor;
    } else {
        return tenantFloors.firstObject;
    }
    return nil;
}

- (CGRect)rectForPoint:(CGPoint)point {
    return CGRectMake(point.x - kMapUnitPadding, point.y - kMapUnitPadding/2, kMapUnitPadding*2, kMapUnitPadding*2);
}

- (NSArray *)wayfindPathsForSelectedTenants {
    JMapWaypoint *fromWaypoint = [self waypointForTenant:self.wayfindingStartTenant onFloor:self.wayfindingStartFloor];
    JMapWaypoint *toWaypoint = [self waypointForTenant:self.wayfindingEndTenant onFloor:self.wayfindingEndFloor];
    
    return [self.mapView findPathForWaypoint:fromWaypoint toWaypoint:toWaypoint accessibility:@(kJMapAccessibilityIncludingStairsAndEscalator)];
}

- (NSArray *)textDirectionsForSelectedWayfindingTenants {
    GGPMall *selectedMall = [GGPMallManager shared].selectedMall;
    NSArray *wayfindPaths = [self wayfindPathsForSelectedTenants];
    
    return [self.mapView makeTextDirections:wayfindPaths filterOn:YES addTDifEmptyMeters:selectedMall.config.wayfindingMinDistance UTurnInMeters:kJMapUturnThreshold customThreshHolds:nil];
}

- (void)startWayfindingRoute {
    self.isWayfindingRouteActive = YES;
    [self resetWayfindingViews];
    
    self.wayfindingFloors = [self createWayfindingFloors];
    self.currentWayfindingFloor = self.wayfindingFloors.firstObject;
    for (GGPWayfindingFloor *floor in self.wayfindingFloors) {
        [self addMoversForFloor:floor];
    }
    
    if (self.wayfindingFloors.count > 0) {
        [self moveToFloor:self.currentWayfindingFloor.jmapFloor];
    }
}

- (NSArray *)createWayfindingFloors {
    NSArray *wayfindPaths = [self wayfindPathsForSelectedTenants];
    NSMutableArray *wayfindingFloors = [NSMutableArray new];
    
    if (wayfindPaths.count > 0) {
        NSArray *textDirections = [self textDirectionsForSelectedWayfindingTenants];
        NSArray *wayfindPathViews = [self createPathViewsForPaths:wayfindPaths];
        
        for (int i = 0; i < textDirections.count; i++) {
            GGPWayfindingFloor *wayfindingFloor = [[GGPWayfindingFloor alloc] initWithTextDirections:textDirections[i] pathView:wayfindPathViews[i] andOrder:i];
            [wayfindingFloors addObject:wayfindingFloor];
        }
    }
    return wayfindingFloors;
}

- (NSMutableArray *)createPathViewsForPaths:(NSArray *)wayfindPaths {
    NSMutableArray *pathViews = [NSMutableArray new];
    CGSize worldSize = self.mapView.worldSize;
    CGPoint centerXY = CGPointMake(worldSize.width/2, worldSize.height/2);
    
    for (JMapPathPerFloor *nextPathPerFloor in wayfindPaths) {
        UIView *floorView = [self.mapView floorViewFromSequence:nextPathPerFloor.seq];
        JMapFloor *floor = [self.mapView getLevelBySequence:nextPathPerFloor.seq.integerValue];
        GGPWayfindingPathView *pathView = [[GGPWayfindingPathView alloc] initWithFloor:floor];
        
        pathView.frame = CGRectMake(0, 0, worldSize.width, worldSize.height);
        pathView.pathPerFloor = nextPathPerFloor.copy;
        pathView.animationDelegate = self;
        [self.mapView addWayFindView:pathView atXY:centerXY forFloorId:floorView];
        
        [pathViews addObject:pathView];
    }
    
    return pathViews;
}

- (void)updateWayfindingFloorForJmapFloor:(JMapFloor *)jmapFloor {
    GGPWayfindingFloor *wayfindingFloor = [self wayfindingFloorForJmapFloor:jmapFloor];
    
    if (wayfindingFloor) {
        self.currentWayfindingFloor = wayfindingFloor;
        [self zoomToFloorPath:self.currentWayfindingFloor.pathView.pathPerFloor onFloor:self.currentWayfindingFloor.pathView.floor];
        [self animatePathViewForWayfindingFloor:wayfindingFloor];
    }
    
    [self.wayfindingDelegate didUpdateFloor:jmapFloor];
}

- (void)animatePathViewForWayfindingFloor:(GGPWayfindingFloor *)wayfindingFloor {
    GGPWayfindingPathView *pathView = wayfindingFloor.pathView;
    
    if (pathView) {
        pathView.animationDelegate = self;
        [pathView animatePath];
    }
}

- (GGPWayfindingFloor *)wayfindingFloorForJmapFloor:(JMapFloor *)jmapFloor {
    return [self.wayfindingFloors ggp_firstWithFilter:^BOOL(GGPWayfindingFloor *wayfindingFloor) {
        return wayfindingFloor.jmapFloor.mapId == jmapFloor.mapId;
    }];
}

- (void)addMoversForFloor:(GGPWayfindingFloor *)floor {
    JMapTextDirectionInstruction *currentFloorMoverInstruction = floor.textDirections.lastObject;
    
    if ([currentFloorMoverInstruction.type isEqualToString:kMoverType]) {
        GGPWayfindingFloor *nextFloor = [self wayfindingFloorWithOrder:floor.order + 1];
        JMapTextDirectionInstruction *nextFloorMoverInstruction = nextFloor.textDirections.firstObject;
        
        UIImageView *currentFloorMover = [[UIImageView alloc] initWithImage:[UIImage ggp_imageForJmapMoverType:currentFloorMoverInstruction.moverType]];
        UIImageView *nextFloorMover = [[UIImageView alloc] initWithImage:[UIImage ggp_imageForJmapMoverType:currentFloorMoverInstruction.moverType]];
        
        [self addMoverIcon:currentFloorMover ForInstruction:currentFloorMoverInstruction withDirection:GGPWayfindingMoverDirectionForward];
        [self addMoverIcon:nextFloorMover ForInstruction:nextFloorMoverInstruction withDirection:GGPWayfindingMoverDirectionBackward];
    }
}

- (void)addMoverIcon:(UIImageView *)moverImageView ForInstruction:(JMapTextDirectionInstruction *)instruction withDirection:(GGPWayfindingMoverDirection)direction {
    JMapWaypoint *waypoint = instruction.wp;
    
    CGPoint mapPoint = CGPointMake(waypoint.x.floatValue, waypoint.y.floatValue);
    JMapFloor *floor = [self.mapView getLevelById:waypoint.mapId.integerValue];
    UIView *floorView = [self.mapView floorViewFromSequence:floor.floorSequence];
    GGPWayfindingFloor *wayfindingFloor = [self wayfindingFloorForJmapFloor:floor];
    
    GGPWayfindingMover *mover = [[GGPWayfindingMover alloc] initWithImageView:moverImageView mapPoint:mapPoint instruction:instruction direction:direction andFloorOrder:wayfindingFloor.order];
    [wayfindingFloor.movers addObject:mover];
    
    [self.mapView addWayFindView:moverImageView atXY:mapPoint forFloorId:floorView];
}

- (GGPWayfindingFloor *)wayfindingFloorWithOrder:(NSInteger)order {
    return [self.wayfindingFloors ggp_firstWithFilter:^BOOL(GGPWayfindingFloor *wayfindingFloor) {
        return wayfindingFloor.order == order;
    }];
}

- (void)resetWayfindingViews {
    for (GGPWayfindingFloor *floor in self.wayfindingFloors) {
        [floor.pathView removeFromSuperview];
        [self removeMoversForFloor:floor];
    }
}

- (void)removeMoversForFloor:(GGPWayfindingFloor *)floor {
    for (GGPWayfindingMover *mover in floor.movers) {
        [mover.imageView removeFromSuperview];
    }
}

- (NSDictionary *)dataForWayfindingAnalytics {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:@{GGPAnalyticsContextDataWayfindingStartTenant: self.wayfindingStartTenant.name,
                                                                                  GGPAnalyticsContextDataWayfindingEndTenant: self.wayfindingEndTenant.name}];
    
    if ([self floorsForTenant:self.wayfindingStartTenant].count > 1) {
        [data setObject:self.wayfindingStartFloor.name forKey:GGPAnalyticsContextDataWayfindingStartLevel];
    }
    
    if ([self floorsForTenant:self.wayfindingEndTenant].count > 1) {
        [data setObject:self.wayfindingEndFloor.name forKey:GGPAnalyticsContextDataWayfindingEndLevel];
    }
    
    return data;
}

#pragma mark CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)didFinish {
    if ([self hasNextFloor] && didFinish) {
        GGPWayfindingMover *mover = self.currentWayfindingFloor.movers.lastObject;
        [mover animatePulse];
    }
}

- (BOOL)hasNextFloor {
    return self.currentWayfindingFloor.order < self.wayfindingFloors.count - 1;
}

#pragma mark JMapDelegate

- (void)jMapTapAtXY:(NSValue *)atXY {
    for (GGPWayfindingMover *mover in self.currentWayfindingFloor.movers) {
        
        if (CGRectContainsPoint(mover.mapRect, atXY.CGPointValue)) {
            NSInteger order = mover.floorOrder;
            if (mover.direction == GGPWayfindingMoverDirectionForward) {
                order++;
            } else {
                order--;
            }

            GGPWayfindingFloor *destinationFloor = [self wayfindingFloorWithOrder:order];
            [self moveToFloor:destinationFloor.jmapFloor];
        }
    }
}

@end
