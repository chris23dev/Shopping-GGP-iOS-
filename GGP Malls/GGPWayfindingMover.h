//
//  GGPWayfindingMover.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPWayfindingMoverDirection.h"

@class GGPWayfindingFloor;
@class JMapTextDirectionInstruction;

@interface GGPWayfindingMover : NSObject

@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (assign, nonatomic, readonly) CGPoint mapPoint;
@property (strong, nonatomic, readonly) JMapTextDirectionInstruction *instruction;
@property (assign, nonatomic, readonly) GGPWayfindingMoverDirection direction;
@property (assign, nonatomic, readonly) NSInteger floorOrder;

@property (assign, nonatomic, readonly) CGRect mapRect;

- (instancetype)initWithImageView:(UIImageView *)imageView mapPoint:(CGPoint)point instruction:(JMapTextDirectionInstruction *)instruction direction:(GGPWayfindingMoverDirection)direction andFloorOrder:(NSInteger)floorOrder;
- (void)animatePulse;

@end
