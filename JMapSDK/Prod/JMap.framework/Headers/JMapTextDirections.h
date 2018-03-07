//
//  JMapTextDirections.h
//  JMapSDK
//
//  Created by developer on 2015-05-19.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * JMap Text Direction Item
 * Describes the model of text directions available to path routing
 */
@class JMapWaypoint, JMapToolTips;
@interface JMapTextDirectionItem : NSObject <NSCopying>
{
    NSDictionary *_itemInfo;
}

- (instancetype)initItemWithDictionary:(NSDictionary *)itemInfo NS_DESIGNATED_INITIALIZER;
/*! @name Properties */

///returns NSString of the direction of this step
@property (nonatomic, strong, readonly) NSString* getDirection;

///returns NSObject with the waypoint data of this step.
@property (nonatomic, strong, readonly) id getWayPoint;

///retruns name (NSString) of the landmark associated with this wp
@property (nonatomic, strong, readonly) NSString* getLandmark;

///returns id (NSString) of the landmark object associated with this wp
@property (nonatomic, strong, readonly) NSString* getLandmarkID;

///returns position data of the landmark object
@property (nonatomic, strong, readonly) JMapWaypoint* getLandmarkWP;

///returns the instruction of this specific step
@property (nonatomic, strong, readonly) NSString* getOutput;

///returns the index of the step in it's sequence (Starts at 0)
@property (nonatomic, strong, readonly) NSNumber* getStep;

/*!
 * \brief Tooltip Object
 */
@property (nonatomic, strong, readonly) JMapToolTips *currentToolTip;
/*!
 * \brief Priority level
 */
@property (nonatomic) NSInteger priority;
/*!
 * \brief Should display flag
 */
@property (nonatomic) BOOL display;
/*!
 * \brief Object collision
 */
@property (nonatomic, getter=isColliding) BOOL colliding;
/*!
 * \brief Bounding box of label
 */
@property (nonatomic, unsafe_unretained) CGRect labelBoundingBox;
/*!
 * \brief fontsize
 */
@property (nonatomic, unsafe_unretained) CGFloat fontsize;

@end

/**
 * JMapTextDirection
 * A container of JMapTextDirectionItem objects
 */
@interface JMapTextDirections : NSObject
{
    NSArray *_directions;
}

/*!
 * \brief The collection of direction items
 */
@property (nonatomic, strong, readonly) NSArray *directions;

- (instancetype)initWithDirectionsArray:(NSArray*)textDirections NS_DESIGNATED_INITIALIZER;

@end
