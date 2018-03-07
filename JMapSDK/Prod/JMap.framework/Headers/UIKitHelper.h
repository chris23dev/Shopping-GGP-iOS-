//
//  UIKitHelper.h
//
//  Created by Bryan Hayes on 2015-08-12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Position a rect with a center point
#define CGRectCenterAt(rect, point) ({ CGRect __rect = (rect); CGPoint __point = (point); (CGRect){.size=__rect.size, .origin=CGPointMake(__point.x - (__rect.size.width/2.0f), __point.y - (__rect.size.height/2.0f))}; })


#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

// UIKitHelperCustomThresholds
// NOTE: 0 degree is on top
//        0
//        |
//        |
// -90 ---+--- 90
//        |
//        |
//    -180/180
// Defaults: Direction threshholds
// forwardFrom = -25;
// forwardTo = 25;
// Right
// rightSlightFrom = 25;
// rightSlightTo = 45;
// rightFrom = 45;
// rightTo = 135;
// rightBackFrom = 135;
// rightBackTo = 180;
// Left
// leftSlightFrom = -45;
// leftSlightTo = -25;
// leftFrom = -135;
// leftTo = -45;
// leftBackFrom = -180;
// leftBackTo = -135;
@interface UIKitHelperCustomThresholds : NSObject
// Forward
@property NSNumber *forwardFrom;
@property NSNumber *forwardTo;
// Right
@property NSNumber *rightSlightFrom;
@property NSNumber *rightSlightTo;
@property NSNumber *rightFrom;
@property NSNumber *rightTo;
@property NSNumber *rightBackFrom;
@property NSNumber *rightBackTo;
// Left
@property NSNumber *leftSlightFrom;
@property NSNumber *leftSlightTo;
@property NSNumber *leftFrom;
@property NSNumber *leftTo;
@property NSNumber *leftBackFrom;
@property NSNumber *leftBackTo;
@end;

@interface UIKitHelper : NSObject

+(void)printCallingFunction;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (NSString *) UIColorToHexString:(UIColor *)uiColor;
+ (CGAffineTransform)applyAngleTransFromUIView:(UIView *)thisView withCenter:(CGPoint)pt targetView:(UIView *)targetView;
+ (void)frameAroundView:(UIView *)thisView;
+ (CGAffineTransform) CGAffineTransformMakeRotationAt:(CGFloat) angle withCenter:(CGPoint)pt;
+ (UIViewController *)topViewController:(UIViewController *)rootViewController;
+ (UIViewController *)topViewController;
+(CGPoint)centerOfCGRect:(CGRect)thisRect;
+(UIColor *)randomColor;
+(CGSize)getSizeForText:(NSString *)text maxWidth:(CGFloat)width font:(NSString *)fontName fontSize:(float)fontSize;
+(CGFloat)degreeAngleFromTransform:(CGAffineTransform)transform;
+(CGFloat)viewAngleofRotation:(CGAffineTransform)transform;
+(CGFloat)pointPairToBearingDegrees:(CGPoint)startingPoint endingPoint:(CGPoint)endingPoint;

// Text Directions related Helpers
+(float)distanceBetween:(CGPoint)fromXY and:(CGPoint)andXY;
// pointOnLineUsingDistanceFromStart
+(CGPoint)pointOnLineUsingDistanceFromStart:(CGPoint)lp1 lp2:(CGPoint)lp2 distanceFromP1:(float)distanceFromP1;
+(BOOL)isPointInsideBlockers:(CGPoint)point blockers:(NSArray *)blockers;
+(BOOL)isPointInsideRotatedRect:(CGPoint)p a:(CGPoint)a b:(CGPoint)b c:(CGPoint)c d:(CGPoint)d;
+(float)triangleArea:(CGPoint)a b:(CGPoint)b c:(CGPoint)c;
+(CGPoint)rotatePoint:(CGPoint)point center:(CGPoint)center angle:(float)angle;
+(NSArray *)arrayOfPointsForRotatedRectangleUsingAngle:(CGRect)rect withCenter:(CGPoint)withCenter angleInDegrees:(float)angleInDegrees;
+(NSArray *)arrayOfRotatedPoints:(CGRect)rect transformString:(NSString *)transformString;
+(CGPoint)returnCenterOfRect:(CGRect)thisRect;
// Line of sight
+(float)sqr:(float)x;
+(float)dist2:(CGPoint)first second:(CGPoint)second;
+(float)distToSegmentSquared:(CGPoint)point lineP1:(CGPoint)lineP1 lineP2:(CGPoint)lineP2 intersectPoint:(CGPoint *)interSectPoint;
+(BOOL)doLineSegmentsIntersect:(CGPoint)l11 l12:(CGPoint)l12 l21:(CGPoint)l21 l22:(CGPoint)l22;
+(float)distanceToLine:(CGPoint)point lineP1:(CGPoint)lineP1 lineP2:(CGPoint)lineP2 intersectPoint:(CGPoint *)interSectPoint;
+(NSString *)returnDirectionToPoint:(CGPoint)currentPoint toPoint:(CGPoint)toPoint previousAngle:(float)previousAngle customThreshHolds:(UIKitHelperCustomThresholds *)customThreshHolds;

+(NSString *)directionFromAngle:(float)angle customThresholds:(UIKitHelperCustomThresholds *)customThresholds;

// xyScale
+(float)convertMetersToPixels:(float)meters usingXYScale:(float)xyScale;
+(float)convertPixelsToMeters:(float)pixels usingXYScale:(float)xyScale;

@end
