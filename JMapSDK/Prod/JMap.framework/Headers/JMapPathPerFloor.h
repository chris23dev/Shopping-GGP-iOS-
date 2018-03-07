//
//  JMapPathPerFloor.h
//  JMap
//
//  Created by Bryan Hayes on 2015-08-31.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMapPathDataTypes;
@class JMapASEdge;

@interface JMapPathPerFloor : NSObject

@property NSNumber *seq; // int
@property NSNumber *mapId; // int
@property JMapPathDataTypes *mover; // JMapPathDataTypes
@property NSMutableArray *points; // ASNode[]
@property NSMutableArray *originalPoints; // ASNode[]
@property NSNumber *cost; // float

@end
