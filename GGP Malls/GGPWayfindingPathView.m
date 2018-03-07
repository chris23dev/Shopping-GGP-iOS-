//
//  GGPWayfindingPathView.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPWayfindingPathView.h"
#import "UIColor+GGPAdditions.h"

static CGFloat const kAnimationTime = 8;
static NSString *const kAnimationStrokeKeyPath = @"strokeEnd";
static NSString *const kAnimationLineDashKeyPath = @"lineDashPhase";

@interface GGPWayfindingPathView ()

@property (strong, nonatomic, readonly) CAShapeLayer *pathLayer;

@end

@implementation GGPWayfindingPathView

@synthesize pathLayer = _pathLayer;

- (instancetype)initWithFloor:(JMapFloor *)floor {
    self = [super init];
    if (self) {
        self.floor = floor;
    }
    return self;
}

- (void)animatePath {
    self.backgroundColor = [UIColor clearColor];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:kAnimationStrokeKeyPath];
    pathAnimation.duration = self.pathPerFloor.points.count/kAnimationTime;
    pathAnimation.fromValue = @(0);
    pathAnimation.toValue = @(1);
    pathAnimation.delegate = self.animationDelegate;
    
    CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:kAnimationLineDashKeyPath];
    dashAnimation.fromValue = @(15);
    dashAnimation.toValue = @(0);
    dashAnimation.duration = 0.75;
    dashAnimation.repeatCount = FLT_MAX;

    [self.pathLayer addAnimation:pathAnimation forKey:kAnimationStrokeKeyPath];
    [self.pathLayer addAnimation:dashAnimation forKey:kAnimationLineDashKeyPath];

}

- (CAShapeLayer *)pathLayer {
    if (!_pathLayer) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [self wayfindingPath].CGPath;
        shapeLayer.strokeColor = [UIColor ggp_colorFromHexString:@"209e4d"].CGColor;
        shapeLayer.fillColor = nil;
        shapeLayer.lineWidth = 3;
        shapeLayer.lineJoin = kCALineJoinBevel;
        shapeLayer.lineDashPattern = @[@(10), @(5)];
        
        [self.layer addSublayer:shapeLayer];
        _pathLayer = shapeLayer;
    }
    
    return _pathLayer;
}

- (UIBezierPath *)wayfindingPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    JMapASNode *firstPoint = self.pathPerFloor.points.firstObject;
    
    [path moveToPoint:CGPointMake(firstPoint.x.floatValue, firstPoint.y.floatValue)];
    
    if(firstPoint) {
        for (JMapASNode *mapNode in self.pathPerFloor.points) {
            [path addLineToPoint:CGPointMake(mapNode.x.floatValue, mapNode.y.floatValue)];
        }
    }
    
    return path;
}

@end
