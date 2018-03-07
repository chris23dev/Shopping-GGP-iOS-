//
//  JMAPFoundation.h
//  JMapSDK
//
//  Created by sean batson on 2015-06-15.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMapRequestMethod;

/**
 * To build for the following end points #define one of the following keys
 * AMGEN_DEV or WESTFIELD_UAT or WESTFIELD_PROD for REQUESTURL
 * You should implement "JMapDataSource" method JMapAPIRequestURL: if your server environement has changed
 */
#define WESTFIELD_PROD
FOUNDATION_EXTERN NSString *const REQUESTURL;

/*! @name The HTTP call methods */
/*! 
 \typedef JMapRequestMethod
 \brief The supported HTTP request methods */
/*
typedef NS_ENUM(NSUInteger, JMapRequestMethod) {
    ///HTTP GET
    JMapRequestMethodGet = 0,
    ///HTTP POST content type = @"application/x-www-form-urlencoded"
    JMapRequestMethodPost = 1,
    /// HTTP POST content type = @"multipart/form-data"
    JMapRequestMethodMultipartPost = 2
} ;
*/

/*! @name The Device Refresh HTTP send types */
/*! \brief The supported Device Refresh HTTP send types */
/*
typedef NS_ENUM(NSUInteger, JMapSendHttpResponseType)
{
    /// Do not cache object
    kJMapSendHttpResponseTypeNotCached,
    /// Cached object
    kJMapSendHttpResponseTypeCached,
    /// Caching failed
    kJMapSendHttpResponseTypeFailed
    
};
*/

/*
/// WSFSponsorShipRatings
typedef NS_ENUM(NSInteger, WSFSponsorShipRatings)
{
    /// WSFSponsorShipRatingsNormal
    WSFSponsorShipRatingsNormal = 0,
    /// WSFSponsorShipRatingsSpecialty
    WSFSponsorShipRatingsSpecialty = 25,
    /// WSFSponsorShipRatingsAnchor
    WSFSponsorShipRatingsAnchor = 50,
    /// WSFSponsorShipRatingsHighTraffic
    WSFSponsorShipRatingsHighTraffic = 75,
    /// WSFSponsorShipRatingsVIP
    WSFSponsorShipRatingsVIP = 100
};
*/

typedef NSString* ((^JMapLocationSelectionBlock)(NSArray *locationObjects));

/**
 * Zoom levels upper & lower boundaries
 */
FOUNDATION_EXTERN CGFloat const kMaximumZoomInLevel;
FOUNDATION_EXTERN CGFloat const kMinimumZoomOutLevel;

/*!
 * JMapAuthenticationTokens
 * Provide an Authentication Dictionary with the follow keys and credentials
 */
/*
FOUNDATION_EXTERN NSString *const kJMapAuthenticationTokensUser;
FOUNDATION_EXTERN NSString *const kJMapAuthenticationTokensPassword;
FOUNDATION_EXTERN NSString *const kJMapAuthenticationTokensAPIKey;
FOUNDATION_EXTERN NSString *const kJMapLanguageCode;
*/
/*!
 * NSNotification center
 * Keys for events fired as various map data becomes available
 */
FOUNDATION_EXTERN NSString *const kJMAPCanvasAllVenuDataAvailable;
FOUNDATION_EXTERN NSString *const kJMAPCanvasAllMapsAvailable;
FOUNDATION_EXTERN NSString *const kJMAPCanvasAllDestinationsAvailable;
FOUNDATION_EXTERN NSString *const kJMAPCanvasAllMapBuilderDataAvailable;
FOUNDATION_EXTERN NSString *const kJMAPCanvasAllLegendsAvailable;
FOUNDATION_EXTERN NSString *const kJMAPCanvasAllCategoriesAvailable;
FOUNDATION_EXTERN NSString *const kJMAPCanvasAllPeopleMoverDataAvailable;
FOUNDATION_EXTERN NSString *const kJMAPCanvasallDeviceRefreshStatusDataAvailable ;
FOUNDATION_EXTERN NSString *const kJMAPCanvasLocationsForSelectionAvailable ;
/*!
 * Map Interaction
 * NSDictionary keys for map touch events
 */
FOUNDATION_EXTERN NSString *const kJMAPDataUnits ;
FOUNDATION_EXTERN NSString *const kJMAPDataLboxes ;
FOUNDATION_EXTERN NSString *const kJMAPWayPointUnits ;
FOUNDATION_EXTERN NSString *const kJMAPWayPointLboxes ;
FOUNDATION_EXTERN NSString *const kJMAPMapLegends ;
FOUNDATION_EXTERN NSString *const kJMAPMapTouchPoint;
FOUNDATION_EXTERN NSString *const kJMAPMapDestination ;
FOUNDATION_EXTERN NSString *const kJMAPMoverWayPoint ;
FOUNDATION_EXTERN NSString *const kJMAPMoverData ;
FOUNDATION_EXTERN NSString *const kJMAPMoverName ;


/*!
 * People Mover Types
 * These are basic set of available types passing a custom string 
 * into highlightMoverIcons: once matched will highlight icon
 */
FOUNDATION_EXTERN NSString *const kMoverTypeStairCase;
FOUNDATION_EXTERN NSString *const kMoverTypeEscalator;
FOUNDATION_EXTERN NSString *const kMoverTypeMovingWalkway;
FOUNDATION_EXTERN NSString *const kMoverTypeElevator;

FOUNDATION_EXTERN NSString const *kJMapMoverItem;
FOUNDATION_EXTERN NSString const *kJMapMoverWaypointItem;
FOUNDATION_EXTERN NSString const *kJMapMoverAssociationItem;


#define JMAPS_DEPRECATED($message) __attribute__((deprecated($message)))
/*!
 * Various map Render states
 */
typedef NS_ENUM(NSInteger, JMapStates)
{
    /// Done
    JMapStatesBaseMapDone           = 1UL,
    /// New
    JMapStatesBaseMapShapesNew      = (1UL << 2),
    /// Inserted
    JMapStatesBaseMapStylesInserted = (1UL << 3),
    /// Busy
    JMapStatesBaseMapBusy           = (1UL << 4),
    /// Ready
    JMapStatesBaseMapReady          = (1UL << 5),
    /// Boundary Set
    JMapStatesBaseMapBoundarySet    = (1UL << 6),
    /// Legends Drawn
    JMapStateBaseMapLegendsDrawn   = (1UL << 7),
    /// Cluster Labels Drawn
    JMapStateBaseMapClusterLabelsDrawn    = (1UL << 8),
    /// Non Cluster Labels Drawn
    JMapStateBaseMapNonClusterLabelsDrawn = (1UL << 9),
    /// Zoom Level Changed
    JMapStateBaseMapZoomLevelChanged = (1UL << 10),
    /// Map was Rotated
    JMapStateBaseMapWasRotated = (1UL << 11),
    /// Map data element touched
    JMapStateBaseMapUnitWasTouched = (1UL << 12),
    /// Building quad tree
    JMapStateBaseMapBuildingQuadTree = (1UL << 13),
    /// Waypoints visible
    JMapStateBaseMapWayPointsVisible = (1UL << 14),
    /// Movers Drawn
    JMapStateBaseMapMoversDrawn   = (1UL << 15),
    
};
/*!
 * Various tool tip icons
 */
typedef NS_ENUM(NSInteger, JMapToggleLabelType)
{
    /// Label Box
    JMapToggleLabelTypeLbox = (1UL << 0),
    /// Tooltip
    JMapToggleLabelTypeToolTipToggle = (1UL << 1),
    /// Tooltip Toggle
    JMapToggleLabelTypeToolTipTouch = (1UL << 2),
    /// Store Card (Available in a future release)
    JMapToggleLabelTypeCard = (1UL << 3),
    /// Draw both Label box & Tool tip
    JMapToggleLabelTypeBoth = (JMapToggleLabelTypeLbox | JMapToggleLabelTypeToolTipToggle)
};

/*!
 * @enum JMapToolTipStyle
 * \brief Edges rendered by tool tip.
 */
typedef NS_ENUM(NSInteger, JMapToolTipStyle) {
    /// Rounded edges
    JMapToolTipStyleRoundedEdges = (1 << 1),
    /// Squared edges - Available in version 1.1
    JMapToolTipStyleSquaredEdges = (1 << 2)
    
};

#ifndef __JMapSDK__JMAPFoundation__
#define __JMapSDK__JMAPFoundation__

#include <stdio.h>
#include <stdlib.h>

/**
 * \struct JMAPPoint
 * \brief A JMAPPoint specified by x,y,z.
 */
typedef struct {
    
    double x;
    double y;
    double z; // z is used for elevation of floor
    
} JMAPPoint;

/// Make a new JMAPPoint type consisting of x,y,z
JMAPPoint JMAPPointMake (double x, double y, double z);
/// Convert JMAPPoint too CGPoint
CGPoint CGPointMakeFromJMapPoint (JMAPPoint point);
/// Evaluate JMAPPoint
bool JMAPPointEqualToPoint (JMAPPoint src, JMAPPoint dest);

/// Transform the x,y points of a JMAPPoint in a 2D space. 'z' is ignored
CG_INLINE JMAPPoint
__JMAPPointApplyAffineTransform(JMAPPoint point, CGAffineTransform t)
{
    JMAPPoint p;
    p.x = (CGFloat)((double)t.a * point.x + (double)t.c * point.y + t.tx);
    p.y = (CGFloat)((double)t.b * point.x + (double)t.d * point.y + t.ty);
    return p;
}
#define JMAPPointApplyAffineTransform __JMAPPointApplyAffineTransform

FOUNDATION_EXTERN const JMAPPoint JMAPPointZero;

#endif /* defined(__JMapSDK__JMAPFoundation__) */

/// JMAPPoint NSValue Category
@interface NSValue (JMAPPoints)

- (JMAPPoint)JMMapPointValue;

+ (NSValue*)valueWithJMapPoint:(JMAPPoint)point;

@end

typedef void (^JavascriptsWaypointCompletion)(NSArray *waypoints);

/*!
 * Measure App CPU usage
 */
float cpu_usage();


