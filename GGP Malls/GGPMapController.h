//
//  GGPMapController.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGPMapOptions.h"
#import "GGPMapControllerDelegate.h"

@class GGPMapPolygonController;

@interface GGPMapController : NSObject

@property (strong, nonatomic, readonly) CLLocation *userLocation;
@property (strong, nonatomic, readonly) CLLocation *mapCenterLocation;

@property (weak, nonatomic) id<GGPMapControllerDelegate> mapDelegate;

- (instancetype)initWithMapOptions:(GGPMapOptions *)mapOptions andContainerView:(UIView *)containerView;

+ (void)initializeApiKey;

- (void)animateToLocation:(CLLocation *)location;

- (void)addPolygonWithPolyline:(NSString *)polyline andFillColor:(UIColor *)fillColor;

- (void)fitToPolygons;

- (void)fitToLocations:(NSArray *)locations;

- (void)displayAnchorTenantMarkers;

- (void)displayParkingPinAtLocation:(CLLocation *)location;

- (void)resetParkingPinLocation;

- (void)resetPolygons;

- (void)clearParkingPin;

@end
