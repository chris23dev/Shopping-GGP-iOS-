//
//  JMapTextDirectionInstruction.h
//  JMap
//
//  Created by Bryan Hayes on 2015-10-16.
//  Copyright © 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMapWaypoint;
@class JMapDestination;
@class JMapTextDirectionEntry;

@interface JMapTextDirectionInstruction : NSObject

// Text direction floor information
@property NSNumber *mapId;
@property NSString *floorName;

// Current Waypoint, Destination and Direction
@property JMapWaypoint *wp;
@property JMapDestination *destination;
@property NSString *direction;

// Next step
@property JMapWaypoint *nextWp;
@property NSNumber *angleToNext;
@property NSNumber *angleToNextOfPreviousDirection;

// Landmark
// Used to describe point of reference eg.: "With *Landmark* on your Left, proceed Forward"
@property JMapWaypoint *landmarkWP;
@property JMapDestination *landmarkDestination;
@property NSNumber *angleToLandmark;
@property NSString *directionToLandmark;

// Final instruction
// eg.: "With Landmark on your Left, proceed Forward"
// eg.: "Arrive at Final Destination"
@property NSString *output;

// Combo Direction
@property NSMutableArray *secondaryDirections;

// Distance
@property NSNumber *distanceFromStartMeters;
@property NSNumber *distanceToNextMeters;
@property NSNumber *distanceFromStartPixels; // Pixels
@property NSNumber *distanceToNextPixels; // Pixels

// foldedPoints
// We will use this array to fold points that will be filtered out
// We could need them for posterity. If implementation chooses to use them, they are here
@property NSMutableArray *foldedPointsFront;
@property NSMutableArray *foldedPointsBack;

// We may not need this
@property JMapWaypoint *initialWp;
// We may not need this
@property JMapTextDirectionEntry *data;
@property NSString *type;
@property NSString *moverType;
@property NSString *pointType;
@property NSString *intensity;
@property NSString *nextType;
@property int step;
@property int steps;

// Methods
-(void)foldInFront:(JMapTextDirectionInstruction *)thisInstruction;
-(void)foldToBack:(JMapTextDirectionInstruction *)thisInstruction;

@end



