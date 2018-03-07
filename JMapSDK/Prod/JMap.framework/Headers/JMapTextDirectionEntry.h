//
//  JMapTextDirectionEntry.h
//  JMap
//
//  Created by Bryan Hayes on 2015-10-16.
//  Copyright © 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMapASNode;
@class JMapPathDataTypes;
@class JMapDestinationRangedMeasurment;

@interface JMapTextDirectionEntry : NSObject

@property NSString *intensity;
@property NSString *direction;
@property double distance;
@property JMapASNode *point;
@property JMapASNode *previousPoint;
@property BOOL decisionPoint;
@property BOOL uTurn;
@property JMapDestinationRangedMeasurment *nearPoint;
@property NSMutableArray *proxDestinations;
@property JMapDestination *startingStore;
@property double startingStoreDirection;
@property JMapWaypoint *startingStoreWP;
@property JMapPathDataTypes *mover;
@property int moverId;
@property int mapId;

@end
