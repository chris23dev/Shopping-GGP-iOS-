//
//  JMapTextDirectionProcessor.h
//  JMap
//
//  Created by Bryan Hayes on 2015-10-18.
//  Copyright © 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMapASGrid;

@interface JMapTextDirectionProcessor : NSObject

@property NSArray *waypoints; // Waypoint[]
@property NSArray *paths; // Path[]
@property NSArray *mapFulls; // MapFull[]
@property NSArray *destinations; // Destination[]
@property JMapASGrid *grid; // ASGrid
@property NSMutableArray *decisionPoints; // ArrayList<Waypoint>
@property NSMutableArray *deadEndPoints; // ArrayList<Waypoint>
@property NSMutableArray *destinationWaypoints; // ArrayList<DestinationRangedMeasurment>

@property double straightDegrees;
@property double slightDegrees;
@property double hardDegrees;
@property double pathStraightAngle;
@property double closestDistanceCutoff;
@property double closestAngleCutoff;

@property double uTurnAngle;
@property double uTurnGeneralDirection;
@property double maxUTurnDistance;

@property double tolerance;

-(id)initWithData:(NSArray *)waypointsA pathsA:(NSArray *)pathsA mapFullsA:(NSArray *)mapFullsA destinationsA:(NSArray *)destinationsA gridI:(JMapASGrid *)gridI;

-(NSArray *)processDirections:(NSArray *)pointArray fromLocation:(JMapDestination *) fromLocation;

@end
