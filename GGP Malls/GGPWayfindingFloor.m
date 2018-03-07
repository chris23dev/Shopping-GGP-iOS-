//
//  GGPWayfindingFloor.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPWayfindingFloor.h"

@implementation GGPWayfindingFloor

- (instancetype)initWithTextDirections:(NSArray *)textDirections pathView:(GGPWayfindingPathView *)pathView andOrder:(NSInteger)order {
    self = [super init];
    if (self) {
        _textDirections = textDirections;
        _pathView = pathView;
        _order = order;
        _movers = [NSMutableArray new];
    }
    return self;
}

- (JMapFloor *)jmapFloor {
    return self.pathView.floor;
}

@end
