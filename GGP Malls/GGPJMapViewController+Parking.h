//
//  GGPJMapViewController+Parking.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapViewController.h"

@interface GGPJMapViewController (Parking)

- (void)showAvailabilityForParkingLots:(NSArray *)parkingLots;
- (void)hideParkingLayer;
- (void)highlightClosestParkingLotsToTenant:(GGPTenant *)tenant;
- (void)resetParkNearSelection;
- (BOOL)parkingAvailabileForFloor:(JMapFloor *)floor;

@end
