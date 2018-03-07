//
//  GGPJMapViewController+Wayfinding.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapViewController.h"

@class GGPTenant;
@class GGPWayfindingFloor;
@class JMapFloor;

@interface GGPJMapViewController (Wayfinding)

@property (strong, nonatomic) JMapFloor *wayfindingStartFloor;
@property (strong, nonatomic) JMapFloor *wayfindingEndFloor;
@property (strong, nonatomic, readonly) NSArray *wayfindingFloors;

- (void)resetWayfindingData;
- (void)configureWayfindingPins;
- (void)configureWayfindingView;
- (void)configureWayfindingStartTenant:(GGPTenant *)tenant onFloor:(JMapFloor *)floor;
- (void)configureWayfindingEndTenant:(GGPTenant *)tenant;
- (NSArray *)textDirectionsForSelectedWayfindingTenants;
- (NSDictionary *)dataForWayfindingAnalytics;
- (JMapFloor *)floorForTenant:(GGPTenant *)tenant closestToFloor:(JMapFloor *)targetFloor;
- (void)updateWayfindingFloorForJmapFloor:(JMapFloor *)jmapFloor;
- (GGPWayfindingFloor *)wayfindingFloorWithOrder:(NSInteger)order;
- (GGPWayfindingFloor *)wayfindingFloorForJmapFloor:(JMapFloor *)jmapFloor;

@end
