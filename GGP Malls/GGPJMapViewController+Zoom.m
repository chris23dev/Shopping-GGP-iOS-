//
//  GGPJMapViewController+Zoom.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapUnitLabelViewController.h"
#import "GGPJmapViewcontroller+Levels.h"
#import "GGPJMapViewController+Wayfinding.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPLevelSelectorCollectionViewController.h"
#import "GGPTenant.h"
#import "UIColor+GGPAdditions.h"
#import <JMap/JMap.h>

@interface GGPJMapViewController ()

@property (strong, nonatomic) NSMutableArray *allUnitLabelVCs;
@property (strong, nonatomic) JMapContainerView *mapView;
@property (assign, nonatomic) BOOL isZoomedToTenant;

@end

@implementation GGPJMapViewController (Zoom)

- (void)configureTapToZoomRecognizer {
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(increaseZoomLevel)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.mapView addGestureRecognizer:doubleTapRecognizer];
}

- (void)increaseZoomLevel {
    CGFloat currentZoom = [self.mapView zoomScale];
    [self.mapView setZoomScale:currentZoom * 1.75 animated:YES];
}

- (void)zoomToMall {
    [self zoomToMallWithPadding:NO];
}

- (void)centerMapForParkingInfo {
    [self.mapView unhighlightAllUnits];
    [self zoomToMallWithPadding:YES];
}

- (void)zoomToMallWithPadding:(BOOL)withPadding {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isZoomedToTenant) {
            [self.mapView unhighlightAllUnits];
            self.isZoomedToTenant = NO;
        }
        
        JMapFloor *defaultFloor = [self.mapView getLevelById:[self.mapView getVenueDefaultFloorId].integerValue];
        CGRect unitsBoundingRect = [self.mapView rectForStyleString:@"Units" onFloor:defaultFloor];
        [self.mapView zoomToRect:unitsBoundingRect animated:NO];
        [self moveToFloor:defaultFloor];
        [self updateLevelWithSelectedFloor:defaultFloor];
        [self updateUnitLabelsWithScale:@([self.mapView zoomScale])];
        self.showIcons = YES;
        
        if (withPadding) {
            [self.mapView setZoomScale:[self.mapView zoomScale] * 0.75];
        }
    });
}

- (void)zoomToTenant:(GGPTenant *)tenant withIcons:(BOOL)shouldShowIcons {
    [self zoomToTenant:tenant
               onFloor:[self defaultFloorForTenant:tenant]
             withIcons:shouldShowIcons
          andHighlight:YES];
}

- (void)updateUnitLabelsWithScale:(NSNumber *)newScale {
    for (GGPJMapUnitLabelViewController *vc in self.allUnitLabelVCs) {
        [vc contentScaleFactorChanged:newScale];
    }
}

- (void)zoomToTenant:(GGPTenant *)tenant onFloor:(JMapFloor *)floor withIcons:(BOOL)shouldShowIcons andHighlight:(BOOL)shouldHighlight {
    JMapDestination *destination = [self retrieveDestinationFromLeaseId:tenant.leaseId];
    self.showIcons = shouldShowIcons;
    
    if (shouldHighlight) {
        [self.mapView unhighlightAllUnits];
        [self.mapView setDestinationHighlight:destination withColor:[UIColor ggp_blue]];
    }
    
    [self moveToFloor:floor];
    [self.mapView zoomUnit:destination onFloor:floor withPadding:CGSizeMake(100, 100) doAnimate:YES];
    [self updateLevelWithSelectedFloor:floor];
    self.isZoomedToTenant = YES;
    [self updateUnitLabelsWithScale:@([self.mapView zoomScale])];
}

@end
