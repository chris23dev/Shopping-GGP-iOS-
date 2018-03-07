//
//  GGPJmapViewcontroller+Levels.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapViewController+Amenities.h"
#import "GGPJmapViewcontroller+Levels.h"
#import "GGPJMapViewController+Parking.h"
#import "GGPJMapViewController+Wayfinding.h"
#import "GGPLevelCell.h"
#import "GGPLevelSelectorCollectionViewController.h"
#import "GGPLevelSelectorDelegate.h"
#import "GGPTenant.h"
#import "NSArray+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSInteger const kJMapAllParkingFloorSequence = 99;
static NSString *const kLevelSelectorParkingLabel = @"P";

@interface GGPJMapViewController () <GGPLevelSelectorDelegate>

@property (weak, nonatomic) IBOutlet UIView *levelSelectorContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelContainerWidthConstraint;

@property (strong, nonatomic) GGPLevelSelectorCollectionViewController *levelSelectorCollectionViewController;
@property (strong, nonatomic) JMapContainerView *mapView;
@property (strong, nonatomic) NSMutableArray *reversedFloors;
@property (assign, nonatomic) BOOL showLevelButtons;
@property (assign, nonatomic) BOOL isWayfindingRouteActive;
@property (assign, nonatomic) BOOL isParkingAvailabilityActive;
@property (assign, nonatomic) BOOL isAmenityFilterActive;
@property (strong, nonatomic) NSArray *floors;
@property (strong, nonatomic) NSMutableArray *highlightedDestinations;

@end

@implementation GGPJMapViewController (Levels)

- (void)updateLevelContainerWidthAndHeightForFloors:(NSArray *)floors {
    self.levelContainerWidthConstraint.constant = self.levelSelectorCollectionViewController.cellWidth;
    self.levelContainerHeightConstraint.constant = (floors.count * GGPLevelCellHeight);
}

- (void)configureLevels {
    [self view]; //Need to ensure outlets are loaded
    self.reversedFloors = [[[self.mapView getLevels] reverseObjectEnumerator] allObjects].mutableCopy;
    
    [self removeAllParkingFloor];
    
    JMapFloor *currentFloor = [self.mapView getCurrentFloor];
    NSInteger selectedIndex = [self.reversedFloors indexOfObject:currentFloor];
    
    if (!self.levelSelectorCollectionViewController) {
        self.levelSelectorCollectionViewController = [[GGPLevelSelectorCollectionViewController alloc] initWithFloors:self.reversedFloors selectedIndex:selectedIndex];
        self.levelSelectorCollectionViewController.levelSelectorDelegate = self;
        [self ggp_addChildViewController:self.levelSelectorCollectionViewController toPlaceholderView:self.levelSelectorContainer];
    } else {
        [self.levelSelectorCollectionViewController updateWithFloors:self.reversedFloors selectedIndex:selectedIndex];
    }
    
    [self updateLevelContainerWidthAndHeightForFloors:self.reversedFloors];
}

- (void)reloadLevelSelectorData {
    [self.levelSelectorCollectionViewController.collectionView reloadData];
}

- (void)setShowLevelButtons:(BOOL)showLevelButtons {
    self.levelSelectorContainer.hidden = !showLevelButtons;
}

- (void)moveToFloor:(JMapFloor *)tenantFloor {
    if (self.mapView.currentFloor.floorSequence != tenantFloor.floorSequence) {
        [self.mapView setLevelById:tenantFloor.mapId];
    }
    
    if (self.isWayfindingRouteActive) {
        [self updateWayfindingFloorForJmapFloor:tenantFloor];
    }
}

- (void)updateLevelWithSelectedFloor:(JMapFloor *)floor {
    [self.levelSelectorCollectionViewController updateWithSelectedFloor:floor];
}

- (void)updateLevelSelectorForParking {
    JMapFloor *allParkingFloor = [self allParkingFloor];
    if (!allParkingFloor) {
        return;
    }
    
    if (![self.reversedFloors containsObject:allParkingFloor]) {
        [self.reversedFloors addObject:allParkingFloor];
    }
    
    NSInteger selectedIndex = [self.reversedFloors indexOfObject:allParkingFloor];
    [self moveToFloor:allParkingFloor];
    [self.levelSelectorCollectionViewController updateWithFloors:self.reversedFloors selectedIndex:selectedIndex];
    [self updateLevelContainerWidthAndHeightForFloors:self.reversedFloors];
}

- (void)removeAllParkingFloor {
    JMapFloor *allParkingFloor = [self allParkingFloor];
    if (allParkingFloor) {
        [self.reversedFloors removeObject:allParkingFloor];
    }
}

- (JMapFloor *)allParkingFloor {
    return [self.floors ggp_firstWithFilter:^BOOL(JMapFloor *level) {
        return level.floorSequence.integerValue == kJMapAllParkingFloorSequence;
    }];
}

- (JMapFloor *)defaultFloorForTenant:(GGPTenant *)tenant {
    JMapFloor *defaultFloor = [self.mapView getLevelById:self.mapView.defaultFloorId.integerValue];
    return [self floorForTenant:tenant closestToFloor:defaultFloor];
}

- (NSArray *)floorsForTenant:(GGPTenant *)tenant {
    JMapDestination *destination = [self retrieveDestinationFromLeaseId:tenant.leaseId];
    
    return [self.floors ggp_arrayWithFilter:^BOOL(JMapFloor *floor) {
        NSArray *floorDestinations = [self.mapView getDestinationsByFloorSequence:floor.floorSequence];
        return [floorDestinations ggp_anyWithFilter:^BOOL(JMapDestination *floorDestination) {
            return floorDestination.id.intValue == destination.id.intValue;
        }];
    }];
}

- (NSString *)filterTextForFloor:(JMapFloor *)floor {
    if (self.isParkingAvailabilityActive) {
        return [self parkingAvailabileForFloor:floor] && floor.floorSequence.integerValue != kJMapAllParkingFloorSequence ? kLevelSelectorParkingLabel : nil;
    } else if (self.isAmenityFilterActive) {
        return [self amenityExistsOnFloor:floor] ? @" " : nil;
    } else {
        NSInteger count = [self activeFilterCountForFloor:floor];
        return count > 0 ? [NSString stringWithFormat:@"%ld", (long)[self activeFilterCountForFloor:floor]] : nil;
    }
}

- (NSInteger)activeFilterCountForFloor:(JMapFloor *)floor {
    NSMutableSet *floorDestinationsSet = [NSMutableSet setWithArray:[self.mapView getDestinationsByFloorSequence:floor.floorSequence]];
    NSMutableSet *filteredDestinationsSet = [NSMutableSet setWithArray:self.highlightedDestinations];
    [floorDestinationsSet intersectSet:filteredDestinationsSet];
    return floorDestinationsSet.allObjects.count;
}

@end
