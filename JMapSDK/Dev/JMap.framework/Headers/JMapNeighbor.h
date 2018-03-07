//
//  JMapNeighbor.h
//  JMap
//
//  Created by Bryan Hayes on 2015-08-31.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMapWaypoint;
@class JMapASEdge;

@interface JMapNeighbor : NSObject

@property NSNumber *neighborId;
@property NSNumber *cost; // float
@property NSNumber *acc;
@property NSNumber *edgeId;
@property NSNumber *edgeTypeId;
@property NSNumber *distance; // float
@property NSNumber *x; // float
@property NSNumber *y; // float
@property NSNumber *z; // float

-(id)initNeighbor:(JMapWaypoint *)currentWP currentEdge:(JMapASEdge *)currentEdge totalCost:(NSNumber *)totalCost distanceIn:(NSNumber *)distanceIn zIn:(NSNumber *)zIn;

@end
