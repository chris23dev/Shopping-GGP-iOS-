//
//  JMapSVGStyle.h
//  JMap
//
//  Created by Bryan Hayes on 2015-09-20.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface JMapSVGStyle : NSObject

-(UIColor *)giveMeStrokeColor;
-(UIColor *)giveMeFillColor;

// Constructor also serves to copy
-(id)initWithStyle:(JMapSVGStyle *)style;

// Apply style
-(void)applyStyleToContext:(CGContextRef)context;
// Draw the path
-(void)drawYourPathInContext:(CGContextRef)context;

// setPath
-(void)setBezPath:(UIBezierPath *)bezierPath;
-(void)setPath:(CGPathRef)pathRefIn;
-(UIBezierPath *)getPath;

// Set path closed
-(void)closePath:(BOOL)closed;
// Get path closed
-(BOOL)getClosePath;

// CGContextSetLineWidth
-(void)setCGContextSetLineWidth:(float)thisFloat;
-(void)removeCGContextSetLineWidth;
-(BOOL)hasCGContextSetLineWidth;
-(float)valueCGContextSetLineWidth;

// CGContextSetRGBStrokeColor
-(void)setCGContextSetRGBStrokeColor:(float)r g:(float)g b:(float)b a:(float)a;
-(float)getCGContextSetRGBStrokeColor_r;
-(float)getCGContextSetRGBStrokeColor_g;
-(float)getCGContextSetRGBStrokeColor_b;
-(float)getCGContextSetRGBStrokeColor_a;
-(void)removeCGContextSetRGBStrokeColor;
-(BOOL)hasCGContextSetRGBStrokeColor;

// CGContextSetRGBFillColor
-(void)setCGContextSetRGBFillColor:(float)r g:(float)g b:(float)b a:(float)a;
-(float)getCGContextSetRGBFillColor_r;
-(float)getCGContextSetRGBFillColor_g;
-(float)getCGContextSetRGBFillColor_b;
-(float)getCGContextSetRGBFillColor_a;
-(void)removeCGContextSetRGBFillColor;
-(BOOL)hasCGContextSetRGBFillColor;

// CGContextSetLineJoin
-(void)setCGContextSetLineJoin:(int)joinType;
-(BOOL)hasCGContextSetLineJoin;
-(int)valueCGContextSetLineJoin;

// CGContextSetMiterLimit
-(void)setCGContextSetMiterLimit:(float)meterLimit;
-(BOOL)hasCGContextSetMiterLimit;
-(float)valueCGContextSetMiterLimit;

// CGContextSetStrokeDashArray
-(void)setCGContextSetStrokeDashArray:(NSArray *)strokeDashArray;
-(BOOL)hasCGContextSetStrokeDashArray;
-(NSArray *)valueCGContextSetStrokeDashArray;

// CGContextSetOpacity
-(void)setCGContextSetOpacity:(float)opacityFloat;
-(BOOL)hasCGContextSetOpacity;
-(float)valueCGContextOpacity;

@end
