//
//  JMapHeaderLocation.h
//  JMapSDK
//
//  Created by sean batson on 2015-06-25.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <JMap/JMapBaseModelObject.h>

#ifndef __JMapSDK__Locations__
#define __JMapSDK__Locations__

@class JMapToolTips;
/*! @name Class */

/*!
 * JMap JMapLocations Model data model
 */
@interface JMapLocationsHierarchy : JMapBaseModelObject

@property (nonatomic, strong) NSNumber *locationId; //pkey
@property (nonatomic, strong) NSNumber *parentId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *typeId;
@property (nonatomic, strong) NSNumber *hasMap;
@property (nonatomic, strong) NSString *mapId;
@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, strong) NSNumber *locationX;
@property (nonatomic, strong) NSNumber *locationY;

@end


////@class JMapAnnotation;
///*! @name Class */
///*!
// * JMap JMapBean Model data model
// */
//@interface JMapBean : JMapBaseModelObject
//
//@property (nonatomic, strong) NSNumber *componentId;
//@property (nonatomic, strong) NSNumber *componentTypeId;
//@property (nonatomic, strong) NSString *componentTypeName;
//@property (nonatomic, strong) NSString *descriptions;
//@property (nonatomic, strong) NSNumber *startDate;
//@property (nonatomic, strong) NSNumber *endDate;
//@property (nonatomic, strong) NSString *position;
//@property (nonatomic, strong) NSString *filePath;
//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *iconImagePath;
//@property (nonatomic, strong) NSNumber *projectId;
//@property (nonatomic, strong) NSArray *destinations;
//
//@end
//
//@interface JMapAmenity : JMapBaseModelObject
//
//@property (nonatomic, strong) JMapBean *bean;
//@property (nonatomic, strong) NSArray *waypoints;
//
//@end
///*! @name Class */
///*!
// * JMap JMapPathDataTypesURI Model data model
// */
//@interface JMapPathDataTypesURI : JMapBaseModelObject
//
//@property (nonatomic, strong) NSNumber *uriId;
//@property (nonatomic, strong) NSNumber *uriTypeId;
//@property (nonatomic, strong) NSString *uri;
//@property (nonatomic, strong) NSString *filePath;
//
//@end
///*! @name Class */
///*!
// * JMap JMapPathDataTypes Model data model
// */
//@interface JMapPathDataTypes : JMapBaseModelObject
//
//@property (nonatomic, strong) NSNumber *pathTypeId;
//@property (nonatomic, strong) NSString *typeName;
//@property (nonatomic, strong) NSString *descriptions;
//@property (nonatomic, strong) NSNumber *accessibility;
//@property (nonatomic, strong) NSNumber *speed;
//@property (nonatomic, strong) NSNumber *maxfloors;
//@property (nonatomic, strong) NSString *weight;
//@property (nonatomic, strong) NSNumber *direction;
//@property (nonatomic, strong) NSString *metaData;
//@property (nonatomic, strong) NSNumber *projectId;
//@property (nonatomic, strong) NSNumber *typeidPK;
//@property (nonatomic, strong) NSArray *pathtypeUri;
//
//@end
///*! @name Class */
///*!
// * JMap JMapPathData Model data model
// */
//@interface JMapPathData : JMapBaseModelObject
//
//@property (nonatomic, strong) NSNumber *pathId;
//@property (nonatomic, strong) NSNumber *localId;
//@property (nonatomic, strong) NSNumber *type;
//@property (nonatomic, strong) NSNumber *weight;
//@property (nonatomic, strong) NSNumber *defaultWeight;
//@property (nonatomic, strong) NSNumber *direction;
//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSNumber *status;
//@property (nonatomic, strong) NSArray *waypoints;
//
//@end
///*! @name Class */
///*!
// * JMap JMapWaypoint Model data model
// */
//@interface JMapWaypoint : JMapBaseModelObject
//
//@property (nonatomic, strong) NSNumber *wpid;
//@property (nonatomic, strong) NSNumber *localId;
//@property (nonatomic, strong) NSNumber *mapId;
//@property (nonatomic, strong) NSNumber *xValue;
//@property (nonatomic, strong) NSNumber *yValue;
//@property (nonatomic, strong) NSNumber *status;
//@property (nonatomic, strong) NSArray *associations;
//@property (nonatomic, strong) NSNumber *decisionPoint;
//
//@end
/*! @name Class */
/*!
 * JMap JMapWaypointAssociation Model data model
 */
//@interface JMapWaypointAssociation : JMapBaseModelObject
//
//@property (nonatomic, strong) NSNumber *entityTypeId;
///**
// *[{id:1, type:"destination"}, {id:2, type:"device"}, {id:26, type:"amenity"}, {id:19, type:"event"}];
// */
//@property (nonatomic, strong) NSNumber *waypointId;
//@property (nonatomic, strong) NSNumber *entityId;
//@property (nonatomic, strong) NSNumber *landmarkRating;
//
//@end

/*! @name Class */
/*!
 * JMap JMapWaypoint Model data model (Ext)
 */
//@interface JMapWaypoint (Distance)
//@property (nonatomic) CGFloat distance;
//@end
/*! @name Class */
/*!
// * JMap JMapDevices Model data model
// */
//@interface JMapDevices : JMapBaseModelObject
//
//@property (nonatomic, strong) NSNumber *componentId;
//@property (nonatomic, strong) NSString *deviceTypeDescription;
//@property (nonatomic, strong) NSNumber *deviceTypeId;
//@property (nonatomic, strong) NSString *descriptions;
//@property (nonatomic, strong) NSString *status;
//@property (nonatomic, strong) NSNumber *heading;
//@property (nonatomic, strong) NSNumber *locationId;
//@property (nonatomic, strong) NSNumber *mapId;
//@property (nonatomic, strong) NSNumber *templateId;
//@property (nonatomic, strong) NSString *templateName;
//@property (nonatomic, strong) NSNumber *projectId;
//
//
//@end
/*! @name Class */
/*!
 * JMap JMapEvents Model data model
 */
//@interface JMapEvents : JMapBaseModelObject
//
//@property (nonatomic, strong) NSNumber *componentId;
//@property (nonatomic, strong) id mimeType;
//@property (nonatomic, strong) NSNumber *componentTypeId;
//@property (nonatomic, strong) NSString *componentTypeName;
//@property (nonatomic, strong) NSString *descriptions;
//@property (nonatomic, strong) NSNumber *startDate;
//@property (nonatomic, strong) NSNumber *endDate;
//@property (nonatomic, strong) id status;
//@property (nonatomic, strong) NSString *position;
//@property (nonatomic, strong) NSNumber *sequence;
//@property (nonatomic, strong) NSNumber *isOdaComponent;
//@property (nonatomic, strong) NSString *filePath;
//@property (nonatomic, strong) NSString *webPath;
//@property (nonatomic, strong) NSString *localizedText;
//@property (nonatomic, strong) NSString *metaData;
//@property (nonatomic, strong) NSString *iconImagePath;
//@property (nonatomic, strong) id  ck;
//@property (nonatomic, strong) NSNumber *projectId;
//@property (nonatomic, strong) NSArray *destinations;
//@property (nonatomic, strong) id compgroup;
//
//@end
///*! @name Class */
///*!
// * JMap JMapVenue Model data model
// */
//@interface JMapVenue : JMapBaseModelObject
//
//@property (nonatomic, strong) NSArray *amenities;
//@property (nonatomic, strong) NSArray *destinations;
//@property (nonatomic, strong) NSArray *devices;
//@property (nonatomic, strong) NSArray *maps;
//@property (nonatomic, strong) NSArray *paths;
//@property (nonatomic, strong) NSArray *pathTypes;
//@property (nonatomic, strong) NSArray *wayPointsAll;
//@property (nonatomic, strong) NSArray *events;
//@property (nonatomic, strong) NSArray *waypoints;
//@property (nonatomic, strong) NSArray *categories;
//@property (nonatomic, strong) NSArray *extractedMovers;
//@property (nonatomic, strong) NSArray *maptext;
//@property (nonatomic, strong) NSArray *locationsHierarchy;
//
//-(NSArray *)reverseObjectByKey:(NSString *)key;
//
//-(NSString *)deserializeObject;
//@end
/*! @name Class */
/*!
 * JMap LocationImageView for Annotations
 */
@interface LocationImageView : UIImageView
/*!
 * View's current X scale factor
 */
- (CGFloat)xscale;

/*!
 * View's current Y scale factor
 */
- (CGFloat)yscale;

/*!
 * Current orientation of view
 */
- (CGFloat)rotationInRadians;

/*!
 * Scale rect based on touch point
 */
- (CGRect)scaleRect:(CGRect )rect withScale:(float)zoomLevel withCenter:(CGPoint)center;
/*!
 * \brief The x & y scale of label based on transform matrix
 */
@property (nonatomic, readonly) CGFloat xscale, yscale;
/*!
 * \brief The scaled results based on a zoom level change
 */
@property (nonatomic, strong) NSNumber *scaleFactorX, *scaleFactorY;

@end

//@interface JMapAnnotation : UIControl
///*!
// * \brief The location tool tip control
// */
//@property (nonatomic, strong, readonly)  JMapToolTips *callout;
///*!
// * \brief The location icon image path
// */
//@property (nonatomic, copy) NSString *iconImagePath;
///*!
// * \brief The location text title
// */
//@property (nonatomic, copy) NSString *localizedText;
///*!
// * \brief The location icon image representation of icon image path
// */
//@property (nonatomic, strong, readonly) UIImage *iconImage;
///*!
// * \brief The location image view placeholder
// */
//@property (nonatomic, strong, readonly) LocationImageView *imageView;
///*!
// * \brief The location was touched flag
// */
//@property (nonatomic) BOOL touched;
///*!
// * \brief The location color value in RGB
// */
//@property (nonatomic, strong) NSString *rgb;
///*!
// * \brief The location was there a collision as result of overlapping icons
// */
//@property (nonatomic, getter=isColliding) BOOL colliding;
//
//@end


#endif