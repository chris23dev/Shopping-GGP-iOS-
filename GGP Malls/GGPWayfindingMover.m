//
//  GGPWayfindingMover.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPWayfindingMover.h"
#import "UIColor+GGPAdditions.h"

static NSInteger const kMoverIconSize = 30;
static NSString *const kScaleAnimationKeyPath = @"transform.scale";
static CGFloat const kPulseAnimationDuration = 0.4;
static CGFloat const kPulseAnimationRepeatCount = 2;
static CGFloat const kPulseAnimationToValue = 1.3;
static CGFloat const kPulseAnimationFromValue = 1;

@interface GGPWayfindingMover ()

@property (strong, nonatomic) CAShapeLayer *circleLayer;

@end

@implementation GGPWayfindingMover

- (instancetype)initWithImageView:(UIImageView *)imageView mapPoint:(CGPoint)point instruction:(JMapTextDirectionInstruction *)instruction direction:(GGPWayfindingMoverDirection)direction andFloorOrder:(NSInteger)floorOrder {
    self = [super init];
    if (self) {
        _imageView = imageView;
        _imageView.frame = CGRectMake(0, 0, kMoverIconSize, kMoverIconSize);
        _mapPoint = point;
        _instruction = instruction;
        _direction = direction;
        _floorOrder = floorOrder;
        [self configureCircleLayer];
    }
    return self;
}

- (CGRect)mapRect {
    return CGRectMake(self.mapPoint.x - (kMoverIconSize/2), self.mapPoint.y - (kMoverIconSize/2), kMoverIconSize, kMoverIconSize);
}

- (void)animatePulse {
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:kScaleAnimationKeyPath];
    pulseAnimation.duration = kPulseAnimationDuration;
    pulseAnimation.toValue = @(kPulseAnimationToValue);
    pulseAnimation.fromValue = @(kPulseAnimationFromValue);
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = kPulseAnimationRepeatCount;
    
    self.circleLayer.hidden = NO;
    [self.circleLayer addAnimation:pulseAnimation forKey:kScaleAnimationKeyPath];
}

- (void)configureCircleLayer {
    self.circleLayer = [CAShapeLayer layer];
    [self.circleLayer setPath:[UIBezierPath bezierPathWithOvalInRect:self.imageView.frame].CGPath];
    [self.circleLayer setStrokeColor:[UIColor ggp_colorFromHexString:@"209e4d"].CGColor];
    [self.circleLayer setFillColor:[UIColor clearColor].CGColor];
    [self.circleLayer setLineWidth:2];
    self.circleLayer.frame = self.imageView.frame;
    [self.imageView.layer addSublayer:self.circleLayer];
    self.circleLayer.hidden = YES;
}

@end
