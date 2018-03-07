//
//  GGPWayfindingFloor.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPWayfindingPathView.h"
#import <JMap/JMap.h>

@interface GGPWayfindingFloor : NSObject

@property (strong, nonatomic, readonly) NSArray *textDirections;
@property (strong, nonatomic, readonly) GGPWayfindingPathView *pathView;
@property (assign, nonatomic, readonly) NSInteger order;
@property (strong, nonatomic, readonly) JMapFloor *jmapFloor;
@property (strong, nonatomic) NSMutableArray *movers;

- (instancetype)initWithTextDirections:(NSArray *)textDirections pathView:(GGPWayfindingPathView *)pathView andOrder:(NSInteger)order;

@end
