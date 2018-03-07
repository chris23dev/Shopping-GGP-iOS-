//
//  JMapSDK.h
//  JMapSDK
//
//  Created by jibestream on 2015-03-23.
//  Copyright (c) 2015 jibestream. All rights reserved.

#import <MapKit/MapKit.h>
#import "JMAPFoundation.h"

@class JMapsYouAreHere;

/*!
 * The user location annotation
 */
@interface JMapsUserLocationAnnotation : MKAnnotationView
/// default is same as MKUserLocationView
@property (nonatomic, strong) UIColor *annotationColor;
/// default is same as annotationColor
@property (nonatomic, strong) UIColor *innerPulseColor;
@property (nonatomic, strong) UIColor *outerPulseColor;
/// default is nil
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, readwrite) CGAffineTransform userLocationTransform;
@property (nonatomic, readwrite) float startAlpha;
@property (nonatomic, readwrite) float endAlpha;
@property (nonatomic, readwrite) float confidenceAlpha;
@property (nonatomic) JMAPPoint userCenter;
/// default is 5.3
@property (nonatomic, readwrite) float pulseScaleFactor;
/// default is 1s
@property (nonatomic, readwrite) NSTimeInterval pulseAnimationDuration;
/// default is 3s
@property (nonatomic, readwrite) NSTimeInterval outerPulseAnimationDuration;
/// default is 1s
@property (nonatomic, readwrite) NSTimeInterval delayBetweenPulseCycles;
@property (nonatomic, copy) JMapsYouAreHere *yahInfo;
@property (nonatomic, copy) void (^willMoveToSuperviewAnimationBlock)(JMapsUserLocationAnnotation *view, UIView *superview); // default is pop animation

@property (nonatomic) NSInteger orientation;

@end
