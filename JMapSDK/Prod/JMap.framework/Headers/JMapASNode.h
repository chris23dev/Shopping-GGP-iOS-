//
//  JMapASNode.h
//  JMap
//
//  Created by Bryan Hayes on 2015-08-31.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMapASNode;

@interface JMapASNode : NSObject

@property NSNumber *nodeId;
@property NSNumber *x; // float
@property NSNumber *y; // float
@property NSNumber *z; // float
@property NSNumber *decisionPoint;
@property NSNumber *mapId;
@property NSMutableArray *edges; // ASNode(s)
@property NSMutableArray *neighbors;
@property NSNumber *visited; // BOOL
@property NSNumber *closed; // BOOL
@property NSNumber *f;
@property NSNumber *g;
@property NSNumber *h;
@property JMapASNode *parent; // ASNode
@property NSNumber *usedEdgeTypeId;

-(id)initASNode:(NSNumber *)edgeIdIn xIn:(NSNumber *)xIn yIn:(NSNumber *)yIn zIn:(NSNumber *)zIn decisionPointIn:(NSNumber *)decisionPointIn mapIdIn:(NSNumber *)mapIdIn edgesIn:(NSMutableArray *)edgesIn neighborsIn:(NSMutableArray *)neighborsIn;

-(void)reset;

@end
