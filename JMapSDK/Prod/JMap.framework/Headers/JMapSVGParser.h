//
//  JMapSVGParser.h
//  JMapiOSDemo
//
//  Created by Bryan Hayes on 2015-08-11.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JMapAMStyles;
@class JMapSVGIconView;
@class JMapAmenity;

@interface JMapSVGParser : NSXMLParser <NSXMLParserDelegate>
{
    BOOL isCustomHighlight;
}

@property (nonatomic, strong, readonly) NSDictionary *allStyles;
@property (nonatomic, retain) NSMutableString *currentElementValue;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic) float width;
@property (nonatomic) float height;
@property (nonatomic, strong) NSString *typeDescription;
@property (nonatomic, readonly) float customWidth;
@property (nonatomic, readonly) float customHeight;
@property BOOL isAmenityIcon;
@property BOOL isStockSVGIcon;
@property BOOL isReadyForMap;
@property (nonatomic, strong) JMapAmenity *amenity;
@property (nonatomic, retain) NSString *typeName;
@property (nonatomic, retain) NSMutableArray *arrayOfShapes;
// Styles
@property (nonatomic, retain) NSMutableDictionary *styles;
// The icon image on map
// Bryan: come back and set to readonly
@property (nonatomic, strong) JMapSVGIconView *theView;
// Symbols
@property (nonatomic, retain) NSMutableDictionary *symbols;
// Elements
@property (nonatomic, retain) NSMutableArray *elements;
// SVGs
@property (nonatomic, retain) NSMutableDictionary *svgs;
// Use
@property (nonatomic, retain) NSMutableDictionary *uses;
// Transformation matrix array
@property (nonatomic, retain) NSMutableArray *transformationArray;
@property CGAffineTransform transformationMatrix;
@property (readonly) BOOL isHighlighted;
// gs
@property (nonatomic, retain) NSMutableDictionary *gs;
// centerXY
@property (nonatomic) CGPoint centerXY;
// Parent
@property (nonatomic, retain) id theParent;
// waypoint id
@property (nonatomic, strong) NSNumber *waypointId;
@property (nonatomic, strong, readonly)JMapAMStyles *loadedStyles;
@property (nonatomic, strong, readonly)JMapAMStyles *defaultStyles;
@property (nonatomic, strong, readonly)JMapAMStyles *highlightedStyles;

-(void)setCustomHeight:(float)customHeight;
-(void)setCustomWidth:(float)customWidth;

// B: Obsolete this in favour of new styling class JMapAMStyles
//@property (nonatomic, retain) NSMutableDictionary *highlightedStyles;
//@property (nonatomic, retain) NSMutableDictionary *customHighlightStyling;
//@property (nonatomic, retain) NSDictionary *customColours;

-(void)addAllStyles:(NSDictionary *)thisAllStyle;
-(void)setTheView:(JMapSVGIconView *)theView;
-(void)removeTheView;
-(BOOL)isHidden;
-(void)setHidden:(BOOL)hidden;
-(void)setHighlightedStyles:(JMapAMStyles *)withStyles;
-(void)setDefaultStyles:(JMapAMStyles *)withStyles;
-(JMapSVGParser *)initWithURL:(NSString *)urlString withPoint:(CGPoint)thisPoint withParent:(id)thisParent withTypeName:(NSString *)thisTypeName isStock:(BOOL)isStock isAmenity:(BOOL)isAmenity withAuthentication:(NSDictionary *)withAuthentication withStyles:(JMapAMStyles *)withStyles loadFromServer:(BOOL)loadFromServer projectId:(NSNumber *)projectId;
-(BOOL)hasTransformationMatrix;
// Highlighted
-(BOOL)getHighlighted;
-(void)setHighlighted:(BOOL)willHighlight;
// Animated?
-(BOOL)getAnimated;
-(void)setAnimated:(BOOL)willAnimate scale:(float)scale;

// B: obsoleted, use setHighlightedStyles
//-(BOOL)getCustomHighlight;
//-(NSDictionary*)getCustomColour;
//-(void)setCustomColour:(NSDictionary *)selectedColours;
//-(void)setCustomHighlightStyles:(BOOL)willApplyCustomHighlight;
-(BOOL)pointIsInsideIcon:(CGPoint)thisPoint;
-(CGAffineTransform) transformArryToMatric;
-(void)cleanUp;

@end
