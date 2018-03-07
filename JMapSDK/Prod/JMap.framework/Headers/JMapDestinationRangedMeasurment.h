//
//  JMapDestinationRangedMeasurment.h
//  JMap
//
//  Created by Bryan Hayes on 2015-10-16.
//  Copyright © 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMapWaypoint;
@class JMapDestination;

@interface JMapDestinationRangedMeasurment : NSObject

@property long distance;
@property JMapWaypoint *point;
@property JMapDestination *destination;
@property double theta;
@property double calculatedTheta;

@end
