//
//  GGPJMapViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapViewControllerDelegate.h"
#import "GGPWayfindingDelegate.h"
#import "GGPTenant.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JMapDestination;
@class JMapWaypoint;

@interface GGPJMapViewController : UIViewController

@property (weak, nonatomic) id<GGPJMapViewControllerDelegate> mapViewControllerDelegate;
@property (weak, nonatomic) id<GGPWayfindingDelegate> wayfindingDelegate;
@property (assign, nonatomic) BOOL showIcons;
@property (assign, nonatomic) BOOL showAmenityFilter;

- (void)loadMapData;
- (void)resetMapView;
- (void)resetMapViewAndFilters:(BOOL)resetFilters;

- (NSString *)locationDescriptionForTenant:(GGPTenant *)tenant;
- (NSString *)formattedLocationDescriptionForTenant:(GGPTenant *)tenant;
- (NSString *)parkingLocationDescriptionForTenant:(GGPTenant *)tenant;
- (NSString *)nearbyLocationDescriptionForTenant:(GGPTenant *)tenant;

- (JMapDestination *)retrieveDestinationFromLeaseId:(NSInteger)leaseId;
- (NSString *)leaseIdFromDestinationClientId:(NSString *)destinationClientId;

- (void)displayDetailCardForTenant:(GGPTenant *)tenant;
- (void)removeDetailCard;

- (void)addImage:(UIImage *)image atWaypoint:(JMapWaypoint *)waypoint;

@end
