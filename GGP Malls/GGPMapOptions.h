//
//  GGPMapOptions.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GGPMapOptions : NSObject

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)coordinates;

@property (assign, nonatomic) CLLocationCoordinate2D coordinates;
@property (assign, nonatomic) NSInteger initialZoomLevel;
@property (assign, nonatomic) NSInteger maxZoomLevel;
@property (assign, nonatomic) NSInteger placesZoomLevelThreshold;
@property (assign, nonatomic) BOOL currentLocationEnabled;
@property (assign, nonatomic) BOOL indoorsMapEnabled;
@property (assign, nonatomic) BOOL ghostPinEnabled;

@end
