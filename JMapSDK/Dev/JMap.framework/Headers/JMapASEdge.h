//
//  JMapASEdge.h
//  JMap
//
//  Created by Bryan Hayes on 2015-08-31.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMapASEdge : NSObject

@property NSNumber *edgeId;
@property NSMutableArray *nodes; // ints
@property NSNumber *type;
@property NSNumber *cost; // float
@property NSNumber *acc;
@property NSNumber *speed; // float
@property NSNumber *direction;

-(id)initASEdge:(NSNumber *)edgeIdIn nodesIn:(NSMutableArray *)nodesIn typeIn:(NSNumber *)typeIn costIn:(NSNumber *)costIn accIn:(NSNumber *)accIn speedIn:(NSNumber *)speedIn directionIn:(NSNumber *)directionIn;

@end
