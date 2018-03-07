//
//  JMapToolTips.h
//  JMapSDK
//
//  Created by Sean Batson on 2015-04-14.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JMAPFoundation.h"
extern int viewTag;

#define kDefaultTipWidth 26
#define kDefaultTipHeight 17
typedef void (^BezierPathBlock)(UIBezierPath *path);

/**
 * JMapToolTip / JMapLabel UIAppearance Usage
 *
 * The selectors marked above can be used to override the default appearance of all tool tips icons
 * 
 * __[[JMapLabel appearanceWhenContainedIn:[UIView class], nil] setBorderStrokeColor:[UIColor blackColor]];__
 *
 * __[[JMapLabel appearanceWhenContainedIn:[UIView class], nil] setBackgroundFillColor:[UIColor blackColor]];__
 *
 * __[[JMapLabel appearanceWhenContainedIn:[UIView class], nil] setLabelColor:[UIColor whiteColor]];__
 *
 * This Object is rendered in the map as a tool tip always in a heads up orientation
 *
 * This must be placed into the AppDelegate before any view controllers are loaded.
 */

@interface JMapToolTips : UIView <UIAppearance>
{
    NSStringDrawingContext *_drawingContext ;
    
}
/*! @name Methods */
/*!
 * \brief Perform CGRect scaling based on zoom scale and origin of shape
 * \param rect The CGRect to re-scale
 * \param zoomLevel The current zoom scale
 * \param center The origin of shape
 * \return CGRect - The newly size CGRect
 */
- (CGRect)scaleRect:(CGRect )rect withScale:(float)zoomLevel withCenter:(CGPoint)center;
/*! @name Properties */
/*!
 * Waypoint id
 */
@property (nonatomic, strong) NSNumber *wpid;
/*!
 * \brief The label display value - HTML snippets allowed
 */
@property (nonatomic, strong) NSString *localizedText;
/*!
 * \brief The label sub-text value
 */
@property (nonatomic, strong) NSString *descriptions;
/*!
 * \brief The labels text bounding box (readonly)
 */
@property (nonatomic, readonly) CGRect textFrame;
/*!
 * \brief The labels transformed matrix
 */
@property (nonatomic, readonly) CGAffineTransform boxTransform;
/*!
 * \brief The width used to constrain the maximum size of tool tip
 */
@property (nonatomic, assign) CGFloat maxWidth UI_APPEARANCE_SELECTOR;
/*!
 * \brief The padding to be applied to the area outside of text frame
 */
@property (nonatomic, assign) UIEdgeInsets padding UI_APPEARANCE_SELECTOR;
/*!
 * \brief The width of the label's outline stroke
 */
@property (nonatomic) CGFloat borderStrokeWidth UI_APPEARANCE_SELECTOR;
/*!
 * \brief The font size of label
 */
@property (nonatomic) CGFloat fontSize UI_APPEARANCE_SELECTOR;
/*!
 * \brief The font style of the label
 */
@property (nonatomic, strong) UIFont * font UI_APPEARANCE_SELECTOR;
/*!
 * \brief The stroke color of label outline
 */
@property (nonatomic, strong) UIColor* borderStrokeColor UI_APPEARANCE_SELECTOR;
/*!
 * \brief The background fill color of label
 */
@property (nonatomic, strong) UIColor* backgroundFillColor UI_APPEARANCE_SELECTOR;
/*!
 * \brief The text color label
 */
@property (nonatomic, strong) UIColor* labelColor UI_APPEARANCE_SELECTOR;
/*!
 * \brief The tooltip style
 */
@property (nonatomic) JMapToolTipStyle edgeStyle UI_APPEARANCE_SELECTOR;
/*!
 * \brief The text alignment
 */
@property (nonatomic, assign) NSTextAlignment textAlignment UI_APPEARANCE_SELECTOR;

/*!
 * \brief A custom attributes object to override the internal styling
 * NSForegroundColorAttributeName, NSFontAttributeName Supported
 * All other attributes ignored
 */
@property (nonatomic, strong) NSDictionary *labelAttributesDictionary UI_APPEARANCE_SELECTOR;
/*!
 * \brief Enable / Disable label upper or lower case
 */
@property (nonatomic) BOOL labelUpperCaseSet UI_APPEARANCE_SELECTOR;

/*!
 * \brief This determine the on / off state based on collisions. 
 * \warning Not to be used directly.
 */
@property (nonatomic) BOOL display;
/*!
 * \brief The object linked to during the collision detection process. 
 * \warning Not to be used directly.
 */
@property (nonatomic, strong) id pairedWithObject;
/*!
 * \brief The label line break mode or flag
 */
@property (nonatomic) NSLineBreakMode lineBreakMode;
/*!
 * \brief The label's current rotation matrix in radians
 */
@property (NS_NONATOMIC_IOSONLY, readonly) CGFloat rotationInRadians;
/*!
 * \brief The current zoom scale of map for rendering labels
 */
@property (nonatomic) CGFloat zoomScale;
/*!
 * \brief The x & y scale of label based on transform matrix
 */
@property (nonatomic, readonly) CGFloat xscale, yscale;
/*!
 * \brief The scaled results based on a zoom level change
 */
@property (nonatomic, strong) NSNumber *scaleFactorX, *scaleFactorY;

/*!
 * Tooltip path bounding box
 */
@property (nonatomic, assign, readonly) CGRect pathBounds;
@property (nonatomic, strong) UIBezierPath* bezierPath;
@property (nonatomic, copy) BezierPathBlock pathInfoCompletion;
@property (nonatomic) CGRect tooltipActualFrame;

- (void)prepareLayoutInfo;

@end

@protocol UIToolTipBehaviorDelegate <NSObject>
- (void)handleAnchor:(id)item;
@end

@interface UIToolTipBehavior : UIDynamicBehavior
@property (weak, nonatomic) id<UIToolTipBehaviorDelegate> delegate;
- (id)initWithItems:(NSMutableArray*)items withAnchorView:(UIView*)anchor;
@end


