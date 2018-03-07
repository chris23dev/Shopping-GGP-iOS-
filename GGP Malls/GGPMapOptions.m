//
//  GGPMapOptions.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMapOptions.h"

static NSInteger const kDefaultInitialZoom = 16;
static NSInteger const kDefaultMaxZoom = 20;
static NSInteger const kDefaultPlacesZoomLevelThreshold = 15;
static BOOL const kDefaultCurrentLocationEnabled = NO;
static BOOL const kDefaultIndoorMapEnabled = NO;
static BOOL const kDefaultGhostPinVisibility = NO;

@implementation GGPMapOptions

- (instancetype)init {
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(0, 0);
    return [self initWithCoordinates:coordinates];
}

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)coordinates {
    self = [super init];
    if (self) {
        self.coordinates = coordinates;
        self.maxZoomLevel = kDefaultMaxZoom;
        self.initialZoomLevel = kDefaultInitialZoom;
        self.placesZoomLevelThreshold = kDefaultPlacesZoomLevelThreshold;
        self.currentLocationEnabled = kDefaultCurrentLocationEnabled;
        self.indoorsMapEnabled = kDefaultIndoorMapEnabled;
        self.ghostPinEnabled = kDefaultGhostPinVisibility;
    }
    return self;
}

@end
