//
//  JMapDataModel.h
//  JMap
//
//  Created by Bryan Hayes on 2015-10-11.
//  Copyright © 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMapSVGStyle;
@class JMapFloor;

@interface JMapDataModel : NSObject

@end

// ==========================
// JMap JMapEvents data model
// ==========================
@interface JMapEvents : NSObject
/*!
 * Identifier for the JMapEvents object
 */
@property (nonatomic, strong, readonly) NSNumber *componentId;
/*!
 * Location ID associated with the JMapEvents object
 */
@property (nonatomic, strong, readonly) NSNumber *locationId;
@property (nonatomic, strong, readonly) NSString *uri;
@property (nonatomic, strong, readonly) NSString *label;
/*!
 * Name field of the event set by user in content manager
 */
@property (nonatomic, strong, readonly) NSString *description;
/*!
 * Localized Text field set by user in content manager
 */
@property (nonatomic, strong, readonly) NSString *localizedText;
/*!
 * JMapFloor mapId associated with the event
 */
@property (nonatomic, strong, readonly) NSNumber *mapId;
@property (nonatomic, strong, readonly) NSNumber *typeId;
@property (nonatomic, strong, readonly) NSString *locationX;
@property (nonatomic, strong, readonly) NSString *locationY;
@property (nonatomic, strong, readonly) NSString *ck;
/*!
 * Project ID associated with the event
 */
@property (nonatomic, strong, readonly) NSNumber *projectId;
@property (nonatomic, strong, readonly) NSString *iconImagePath;
@property (nonatomic, strong, readonly) NSString *iconImage;
/*!
 * Path to the event image uploaded to the content manager
 */
@property (nonatomic, strong, readonly) NSString *filePath;
@property (nonatomic, strong, readonly) NSNumber *compgroup;
@property (nonatomic, strong, readonly) NSString *rotation;
@property (nonatomic, strong, readonly) NSNumber *zoomlevel;
@property (nonatomic, strong, readonly) NSString *metaData;
@property (nonatomic, strong, readonly) NSString *componentTypeName;
@property (nonatomic, strong, readonly) NSString *webPath;
@property (nonatomic, strong, readonly) NSNumber *sequenceNumber;
@property (nonatomic, strong, readonly) NSArray *waypoints;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ==================================
// JMap JMapOperatingHours data model
// ==================================
@interface JMapOperatingHours : NSObject
@property (nonatomic, strong, readonly) NSString *clientid;
@property (nonatomic, strong, readonly) NSDate *createTs;
@property (nonatomic, strong, readonly) NSDate *updateTs;
@property (nonatomic, strong, readonly) NSArray *details;
@property (nonatomic, strong, readonly) NSArray *entities;
@property (nonatomic, strong, readonly) NSNumber *statusCode;
@property (nonatomic, strong, readonly) NSNumber *opHoursId;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ================================
// JMap JMapPointOnFloor data model
// ================================
@interface JMapPointOnFloor : NSObject
/*!
 * X-coordinate for the point on floor
 */
@property (nonatomic, strong, readonly) NSNumber *x;
/*!
 * Y-coordinate for the point on floor
 */
@property (nonatomic, strong, readonly) NSNumber *y;
/*!
 * JMapFloor association to the point
 */
@property (nonatomic, strong, readonly) JMapFloor *floor;
/*!
 * Initializationg for JMapPointOnFloor
 * @param x coordinate, float value
 * @param y coordinate, float value
 * @param floor of point, JMapFloor object
 * @return JMapPointOnFloor object
 */
-(instancetype)initWithX:(float)x withY:(float)y withFloor:(JMapFloor *)floor;
@end

// ============
// JMapAMStyles
// ============
@interface JMapAMStyles : NSObject
/*!
 * Foreground styling for JMapAmenity objects
 */
@property (nonatomic, strong, readonly) JMapSVGStyle *foregroundStyle;
/*!
 * Background styling for JMapAmenity objects
 */
@property (nonatomic, strong, readonly) JMapSVGStyle *backgroundStyle;
/*!
 * Middleground styling for JMapAmenity objects
 */
@property (nonatomic, strong, readonly) JMapSVGStyle *middlegroundStyle;
/*!
 * Set width of the JMapAmenity object
 */
@property (nonatomic, strong) NSNumber *width;
/*!
 * Set height of the JMapAmenity object
 */
@property (nonatomic, strong) NSNumber *height;
/*!
 * Visibility of JMapAmenity object
 */
@property (nonatomic, strong) NSNumber *hidden;
/*!
 * Initialization method for JMapAmenity
 * @param f foreground styling, JMapSVGStyle object
 * @param m middleground styling, JMapSVGStyle object
 * @param b background styling, JMapSVGStyle object
 * @return JMapAMStyles object
 */
-(instancetype)initWithStyleF:(JMapSVGStyle *)f m:(JMapSVGStyle *)m b:(JMapSVGStyle *)b;
/*!
 * Setter method for styling JMapAmenity foreground
 */
-(void)setStyleF:(JMapSVGStyle *)f;
/*!
 * Setter method for styling JMapAmenity middleground
 */
-(void)setStyleM:(JMapSVGStyle *)m;
/*!
 * Setter method for styling JMapAmenity background
 */
-(void)setStyleB:(JMapSVGStyle *)b;
@end

// ==============================
// JMap JMapAnnotation data model
// ==============================
@interface JMapAnnotation : NSObject
@property (nonatomic, strong) NSString *iconImagePath;
@property (nonatomic, strong) NSString *localizedText;
@end

// =============
// JMapAddresses
// =============
@interface JMapAddresses : NSObject
@property (strong, nonatomic, readonly) NSNumber *addressId;
@property (strong, nonatomic, readonly) NSString *street1;
@property (strong, nonatomic, readonly) NSString *street2;
@property (strong, nonatomic, readonly) NSString *city;
@property (strong, nonatomic, readonly) NSString *state;
@property (strong, nonatomic, readonly) NSString *zipcode;
@property (strong, nonatomic, readonly) NSString *country;
@property (strong, nonatomic, readonly) NSNumber *addressType;
@property (strong, nonatomic, readonly) NSNumber *isPrimary;
@property (strong, nonatomic, readonly) NSNumber *entityType;
@end

// =============================
// JMap JMapLocations data model
// =============================
@interface JMapLocations : NSObject
/*!
 * Unique ID for location in server URL endpoint
 */
@property (strong, nonatomic, readonly) NSNumber *projectId;
/*!
 * Name of location
 */
@property (strong, nonatomic, readonly) NSString *name;
/*!
 * Location ID associated with the location
 */
@property (strong, nonatomic, readonly) NSNumber *locationId;
/*!
 * Alternative name for the location (may be different than name property)
 */
@property (strong, nonatomic, readonly) NSString *locationName;
/*!
 * Status of the location, Active/Inactive
 */
@property (strong, nonatomic, readonly) NSString *status;
@property (strong, nonatomic, readonly) NSString *ck;
/*!
 * Name of the client project
 */
@property (strong, nonatomic, readonly) NSString *clientProjectId;
/*!
 * List of available languages associated with location
 */
@property (strong, nonatomic, readonly) NSArray *languages;
/*!
 * List of addresses associated with location
 */
@property (strong, nonatomic, readonly) NSArray *addresses;
@property (strong, nonatomic, readonly) NSString *street;
/*!
 * Hours of operation associated with location
 */
@property (strong, nonatomic, readonly) JMapOperatingHours *operatingHours;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ========================
// JMap Category data model
// ========================
@interface JMapCategoryModel : NSObject
/*!
 * Unique ID associated with the JMapCategoryModel
 */
@property (nonatomic, strong, readonly) NSNumber *id;
@property (nonatomic, strong, readonly) NSNumber *parent;
/*!
 * Name of the category
 */
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSNumber *sequence;
/*!
 * Keywords defined in the content manager for the category
 */
@property (nonatomic, strong, readonly) NSString *keywords;
/*!
 * Project ID associated with the category
 */
@property (nonatomic, strong, readonly) NSNumber *projectId;
/*!
 * Value defining the type the category belongs in
 */
@property (nonatomic, strong, readonly) NSNumber *categoryType;
/*!
 * Name of the type categorization of the category
 */
@property (nonatomic, strong, readonly) NSString *categoryTypeName;
/*!
 * Identifier of the client category defined in the content manager
 */
@property (nonatomic, strong, readonly) NSString *clientCategoryId;
/*!
 * Text description of the category object
 */
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *iconPath;
@property (nonatomic, strong, readonly) NSString *imagePath;
/*!
 * List of JMapExtensor objects for category
 */
@property (nonatomic, strong, readonly) NSArray *extensors;
// New
@property (nonatomic, strong, readonly) NSString *ck;
@property (nonatomic, strong, readonly) NSArray *children;
/*!
 * Initialization of the JMapCategoryModel object
 * @param dict of key value pairs for properties
 * @return JMapCategoryModel instance
 */
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ============================
// JMap JMapPathData data model
// ============================
@interface JMapPathData : NSObject
/*!
 * Unique identifier for the JMapPathData objects
 */
@property (nonatomic, strong, readonly) NSNumber *id;
@property (nonatomic, strong, readonly) NSNumber *localId;
/*!
 * Type value for JMapPathData objects
 * 1 - Normal Path
 * 2 - Elevator
 * 3 - Escalator
 * 4 - Stair Case
 * 5 - Moving Walkway
 */
@property (nonatomic, strong, readonly) NSNumber *type;
@property (nonatomic, strong, readonly) NSNumber *weight;
@property (nonatomic, strong, readonly) NSNumber *defaultWeight;
@property (nonatomic, strong, readonly) NSNumber *direction;
@property (nonatomic, strong, readonly) NSString *name;
/*!
 * Value of path availability
 * 0 - Not a valid path
 * 1 - Valid path
 */
@property (nonatomic, strong, readonly) NSNumber *status;
/*!
 * List of waypoints linked to the JMapPathData object (2 waypoints, beginning and end)
 */
@property (nonatomic, strong, readonly) NSArray *waypoints;
@property (nonatomic, strong) JMapAnnotation *annotation;
/*!
 * Initialization method for JMapPathData
 * @param dict of key value pairs for properties
 * @return JMapPathData object
 */
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ====================================
// JMap JMapPathDataTypesURI data model
// ====================================
@interface JMapPathDataTypesURI : NSObject
@property (nonatomic, strong, readonly) NSNumber *uriId;
@property (nonatomic, strong, readonly) NSNumber *uriTypeId;
@property (nonatomic, strong, readonly) NSString *uri;
@property (nonatomic, strong, readonly) NSString *filePath;
@property (nonatomic, strong, readonly) NSString *metaData;
@property (nonatomic, strong, readonly) NSString *data;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// =================================
// JMap JMapPathDataTypes data model
// =================================
@interface JMapPathDataTypes : NSObject
/*!
 * Unique ID for each type of possible path (see JMapPathData type)
 */
@property (nonatomic, strong, readonly) NSNumber *pathTypeId;
/*!
 * Name of the path type, set in content manager
 */
@property (nonatomic, strong, readonly) NSString *typeName;
/*!
 * Text description of the path type
 */
@property (nonatomic, strong, readonly) NSString *description;
/*!
 * Value of the path type used in wayfinding algorithm
 */
@property (nonatomic, strong, readonly) NSNumber *accessibility;
/*!
 * Speed factor for the path type used in wayfinding algorithm
 */
@property (nonatomic, strong, readonly) NSNumber *speed;
/*!
 * Max floor set for the path type used in wayfinding algorithm
 */
@property (nonatomic, strong, readonly) NSNumber *maxfloors;
/*!
 * Weight of the path type used in wayfinding algorithm
 */
@property (nonatomic, strong, readonly) NSNumber *weight;
/*!
 * Direction of the path type used in wayfinding algorithm
 */
@property (nonatomic, strong, readonly) NSNumber *direction;
/*!
 * Additional metadata of the path type
 */
@property (nonatomic, strong, readonly) NSString *metaData;
/*!
 * Project ID associated with the path type
 */
@property (nonatomic, strong, readonly) NSNumber *projectId;
@property (nonatomic, strong, readonly) NSNumber *typeidPK;
/*!
 * List of additional data associated with the path type
 * Contains filePath to link to SVG/PNG icon of the path type
 */
@property (nonatomic, strong, readonly) NSArray *pathtypeUri;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ===============
// JMapProximities
// ===============
@interface JMapProximities : NSObject
@property (nonatomic, strong, readonly) NSNumber *onSameFloor;
/*!
 * Proximity destination's type (i.e. Anchor Store)
 */
@property (nonatomic, strong, readonly) NSString *proximityType;
/*!
 * JMapDestination id of the proximity destination
 */
@property (nonatomic, strong, readonly) NSNumber *destinationId;
/*!
 * JMapDestination clientId of the proximity destination
 */
@property (nonatomic, strong, readonly) NSString *clientDestinationId;
/*!
 * JMapDestination name of the proximity destination
 */
@property (nonatomic, strong, readonly) NSString *destinationName;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ============================
// JMap JMapExtensor data model
// ============================
@interface JMapExtensor : NSObject
/*!
 * Name of the extensor defined in content manager
 */
@property (nonatomic, strong, readonly) NSString *name;
/*!
 * Extensor's value type defined in content manager
 */
@property (nonatomic, strong, readonly) NSString *valueType;
@property (nonatomic, strong, readonly) NSNumber *entityTypeId;
@property (nonatomic, strong, readonly) NSString *editor;
/*!
 * Unique identifier assigned to the extensor
 */
@property (nonatomic, strong, readonly) NSNumber *extensorId;
@property (nonatomic, strong, readonly) NSNumber *entityId;
/*!
 * Value of the extensor defined in content manager
 */
@property (nonatomic, strong, readonly) NSString *value;
@property (nonatomic, strong, readonly) NSString *group;
/*!
 * Project ID associated with the extensor
 */
@property (nonatomic, strong, readonly) NSNumber *projectId;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// =========================================
// JMap JMapOperatingHoursDetails data model
// =========================================
@interface JMapOperatingHoursDetails : NSObject
@property (nonatomic, strong, readonly) NSNumber *opHoursId;
@property (nonatomic, strong, readonly) NSNumber *opHoursDetailsId;
@property (nonatomic, strong, readonly) NSNumber *type;
@property (nonatomic, strong, readonly) NSString *closingHours;
@property (nonatomic, strong, readonly) NSString *date;
@property (nonatomic, strong, readonly) NSString *eventName;
@property (nonatomic, strong, readonly) NSString *openingHours;
@property (nonatomic, strong, readonly) NSString *dayOfWeek;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ==========================================
// JMap JMapOperatingHoursEntities data model
// ==========================================
@interface JMapOperatingHoursEntities : NSObject
@property (nonatomic, strong, readonly) NSNumber *entityTypeId;
@property (nonatomic, strong, readonly) NSNumber *opHoursId;
@property (nonatomic, strong, readonly) NSNumber *entityId;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ==============
// JMap Schedules
// ==============
@interface JMapSchedules : NSObject
/*!
 * Unique identifier for the schedule
 */
@property (nonatomic, strong, readonly) NSNumber *scheduleId;
/*!
 * Name of the schedule defined in content manager
 */
@property (nonatomic, strong, readonly) NSString *name;
/*!
 * Start date of the schedule set by the user in content manager
 */
@property (nonatomic, strong, readonly) NSNumber *startDate;
/*!
 * End date of the schedule set by the user in content manager
 */
@property (nonatomic, strong, readonly) NSNumber *endDate;
/*!
 * Name of the extensor defined in content manager
 */
@property (nonatomic, strong, readonly) NSNumber *status;
/*!
 * Project ID associated with the schedule
 */
@property (nonatomic, strong, readonly) NSNumber *projectId;
@end

// ===============================
// JMap JMapDestination data model
// ===============================
@interface JMapDestination : NSObject
/*!
 * Unique identifier assigned to the destination
 */
@property (nonatomic, strong, readonly) NSNumber *id;
/*!
 * Name of the destination defined by user in content manager
 */
@property (nonatomic, strong, readonly) NSString *name;
/*!
 * Text description of the destination
 */
@property (nonatomic, strong, readonly) NSString *description;
/*!
 * Additional information associated with the destination
 */
@property (nonatomic, strong, readonly) NSString *descriptionMore;
/*!
 * Client ID assigned by the content manager for the destination
 */
@property (nonatomic, strong, readonly) NSString *clientId;
/*!
 * URL containing the destination's Logo image (in PNG/SVG format)
 */
@property (nonatomic, strong, readonly) NSString *helperImage;
/*!
 * URL containing the destination's QR code (PNG format)
 */
@property (nonatomic, strong, readonly) NSString *qrCodeImage;
/*!
 * Keywords associated with the destination, defined by user in content manager
 */
@property (nonatomic, strong, readonly) NSString *keywords;
/*!
 * Project ID associated with the destination
 */
@property (nonatomic, strong, readonly) NSNumber *projectId;
/*!
 * Sponsorship rating of the destination (used to determine visiblity priority)
 */
@property (nonatomic, strong, readonly) NSNumber *sponsoredRating;
/*!
 * Opening date of the destination
 */
@property (nonatomic, strong, readonly) NSNumber *openingDate;
/*!
 * Status of the destination, 0 - Not in operation, 1 - In operation
 */
@property (nonatomic, strong, readonly) NSNumber *operatingStatus;
/*!
 * Closing date of the destination
 */
@property (nonatomic, strong, readonly) NSNumber *closingDate;
/*!
 * List of categories the destination falls under
 */
@property (nonatomic, strong, readonly) NSArray *category;
/*!
 * List of category ID's associated with the category
 */
@property (nonatomic, strong, readonly) NSArray *categoryId;
/*!
 * List of categories the destination falls under, in ID: Name format
 */
@property (nonatomic, strong, readonly) NSArray *primaryCategories;
/*!
 * List of secondary categories the destination falls under
 */
@property (nonatomic, strong, readonly) NSArray *secondaryCategories;
/*!
 * Name of the JMapFloor associated with destination
 */
@property (nonatomic, strong, readonly) NSString *level;
/*!
 * List of anchor stores associated with this destination
 */
@property (nonatomic, strong, readonly) NSArray *destinationProximities;
/*!
 * Unit Number field in map builder/content manager
 */
@property (nonatomic, strong, readonly) NSString *unitNumber;
@property (nonatomic, strong, readonly) NSNumber *destinationTypeId;
@property (nonatomic, strong, readonly) NSNumber *destinationType;
/*!
 * List of categories set by user in content manager
 */
@property (nonatomic, strong, readonly) NSArray *displayCategories;
/*!
 * List of JMapExtensor objects associated with the destination
 */
@property (nonatomic, strong, readonly) NSArray *extensors;
@property (nonatomic, strong, readonly) NSArray *unitType;
/*!
 * JMapOperatingHours object associated with the destination
 */
@property (nonatomic, strong, readonly) JMapOperatingHours *operatingHours;
@property (nonatomic, strong, readonly) NSArray *schedules;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ===========================
// JMap JMapDevices data model
// ===========================
@interface JMapDevices : NSObject
/*!
 * Unique identifier for the device
 */
@property (nonatomic, strong, readonly) NSNumber *id;
/*!
 * Text description of the device set by user in content manager
 * Device type field
 */
@property (nonatomic, strong, readonly) NSString *deviceTypeDescription;
/*!
 * Type ID of the device
 * 1 - Kiosk Default - Landscape
 * 2 - Kiosk Default - Portrait
 * 3 - Windows Desktop
 * 4 - Generic Mobile
 */
@property (nonatomic, strong, readonly) NSNumber *deviceTypeId;
/*!
 * Device Name field in content manager
 */
@property (nonatomic, strong, readonly) NSString *description;
/*!
 * Status of the device, Active/Inactive
 */
@property (nonatomic, strong, readonly) NSString *status;
/*!
 * Used by kiosks for orientating the map displayed
 */
@property (nonatomic, strong, readonly) NSNumber *heading;
/*!
 * Location ID associated with the device
 */
@property (nonatomic, strong, readonly) NSNumber *locationId;
/*!
 * JMapFloor mapId the device is on
 */
@property (nonatomic, strong, readonly) NSNumber *mapId;
/*!
 * Template ID field in content manager
 */
@property (nonatomic, strong, readonly) NSNumber *templateId;
/*!
 * Template Name field in content manager
 */
@property (nonatomic, strong, readonly) NSString *templateName;
/*!
 * Project ID associated with the device
 */
@property (nonatomic, strong, readonly) NSNumber *projectId;
// New
@property (nonatomic, strong, readonly) NSString *deviceGroup;
@property (nonatomic, strong, readonly) NSString *lastPublished;
@property (nonatomic, strong, readonly) NSString *lastPolled;
@property (nonatomic, strong, readonly) NSString *locationX;
@property (nonatomic, strong, readonly) NSString *locationY;
@property (nonatomic, strong, readonly) NSString *icon;
@property (nonatomic, strong, readonly) NSString *health;
@property (nonatomic, strong, readonly) NSNumber *wpid;
@property (nonatomic, strong, readonly) NSNumber *kiosk;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *latitude;
@property (nonatomic, strong, readonly) NSString *logitude;
@property (nonatomic, strong, readonly) NSString *latTerminal;
@property (nonatomic, strong, readonly) NSString *lngTerminal;
@property (nonatomic, strong, readonly) NSString *zoom;
@property (nonatomic, strong, readonly) NSString *clientDeviceId;
@property (nonatomic, strong, readonly) NSString *metaData;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// =============================
// JMap JMapMapLabels data model
// =============================
@interface JMapMapLabels : NSObject
@property (nonatomic, strong, readonly) NSString *uri;
@property (nonatomic, strong, readonly) NSString *webPath;
@property (nonatomic, strong, readonly) NSNumber *sequenceNumber;
@property (nonatomic, strong, readonly) NSString *filePath;
@property (nonatomic, strong, readonly) NSString *description;
/*!
 * String name of the street label
 */
@property (nonatomic, strong, readonly) NSString *label;
/*!
 * JMapwaypoint ID
 */
@property (nonatomic, strong, readonly) NSString *rotation;
@property (nonatomic, strong, readonly) NSNumber *typeId;
/*!
 * Y-coordinate on the map the label is on
 */
@property (nonatomic, strong, readonly) NSString *locationY;
@property (nonatomic, strong, readonly) NSString *ck;
/*!
 * Location ID associated with the map label
 */
@property (nonatomic, strong, readonly) NSNumber *locationId;
/*!
 * Text string of the map label
 */
@property (nonatomic, strong, readonly) NSString *localizedText;
@property (nonatomic, strong, readonly) NSNumber *componentId;
@property (nonatomic, strong, readonly) NSNumber *mapId;
/*!
 * Project ID associated with the map label
 */
@property (nonatomic, strong, readonly) NSNumber *projectId;
/*!
 * Type name of the component (i.e. "Map Labels")
 */
@property (nonatomic, strong, readonly) NSString *componentTypeName;
@property (nonatomic, strong, readonly) NSNumber *zoomlevel;
/*!
 * X-coordinate of the map label
 */
@property (nonatomic, strong, readonly) NSString *locationX;
// New
@property (nonatomic, strong, readonly) NSString *iconImagePath;
@property (nonatomic, strong, readonly) NSString *iconImage;
@property (nonatomic, strong, readonly) NSNumber *compgroup;
@property (nonatomic, strong, readonly) NSString *metaData;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ====================================
// JMap JMapDestinationLabel data model
// ====================================
@interface JMapDestinationLabel : NSObject
@property (nonatomic, strong, readonly) NSString *description;
@property (nonatomic, strong, readonly) NSString *label;
@property (nonatomic, strong, readonly) NSString *rotation;
@property (nonatomic, strong, readonly) NSString *uri;
@property (nonatomic, strong, readonly) NSNumber *typeId;
@property (nonatomic, strong, readonly) NSString *locationY;
@property (nonatomic, strong, readonly) NSString *ck;
@property (nonatomic, strong, readonly) NSString *webPath;
@property (nonatomic, strong, readonly) NSNumber *locationId;
@property (nonatomic, strong, readonly) NSString *localizedText;
@property (nonatomic, strong, readonly) NSNumber *componentId;
@property (nonatomic, strong, readonly) NSNumber *mapId;
@property (nonatomic, strong, readonly) NSNumber *projectId;
@property (nonatomic, strong, readonly) NSString *componentTypeName;
@property (nonatomic, strong, readonly) NSString *filePath;
@property (nonatomic, strong, readonly) NSNumber *zoomlevel;
@property (nonatomic, strong, readonly) NSString *iconImagePath;
@property (nonatomic, strong, readonly) NSString *locationX;
// NEW
@property (nonatomic, strong, readonly) NSString *iconImage;
@property (nonatomic, strong, readonly) NSNumber *compgroup;
@property (nonatomic, strong, readonly) NSString *metaData;
@property (nonatomic, strong, readonly) NSNumber *sequenceNumber;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// =======================================
// JMap JMapWaypointAssociation data model
// =======================================
@interface JMapWaypointAssociation : NSObject
/*!
 * Entity type ID associated with the waypoint
 * 1 - Destination
 * 2 - Device
 * 13 - Scheduled Ad
 * 19 - Event
 * 25 - Path
 * 26 - Amenity
 * 41 - Location
 */
@property (nonatomic, strong, readonly) NSNumber *entityTypeId;
/*!
 * JMapwaypoint ID
 */
@property (nonatomic, strong, readonly) NSNumber *waypointId;
/*!
 * ID associated with the entity type
 * Matches JMapDestination id if entity type id is 1
 * Matches JMapAmenity id if entity type id is 26
 */
@property (nonatomic, strong, readonly) NSNumber *entityId;
/*!
 * Rating value of the landmark associated with waypoint destination
 */
@property (nonatomic, strong, readonly) NSNumber *landmarkRating;
/*!
 * Initialization method for JMapWaypointAssociation
 * @param dict of key value pairs for the properties
 * @return JMapWaypointAssociation object linked to JMapwaypoint object
 */
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ============================
// JMap JMapWaypoint data model
// ============================
@interface JMapWaypoint : NSObject
/*!
 * Unique idenitifer of the waypoint
 */
@property (nonatomic, strong, readonly) NSNumber *id;
@property (nonatomic, strong, readonly) NSNumber *localId;
/*!
 * The map id associated with the waypoint (matches JMapFloor mapId)
 */
@property (nonatomic, strong, readonly) NSNumber *mapId;
/*!
 * X-coordinate of the waypoint
 */
@property (nonatomic, strong, readonly) NSNumber *x;
/*!
 * Y-coordinate of the waypoint
 */
@property (nonatomic, strong, readonly) NSNumber *y;
/*!
 * Status of the waypoint, Open/Closed
 */
@property (nonatomic, strong, readonly) NSNumber *status;
/*!
 * List of JMapWaypointAssociation objects for the waypoint
 * Associations.entityId contains JMapDestination Id value for destination waypoints
 */
@property (nonatomic, strong, readonly) NSArray *associations;
/*!
 * Decision point of the waypoint set by user in map builder tool
 */
@property (nonatomic, strong, readonly) NSNumber *decisionPoint;
/*!
 * Unit number field set by user in map builder tool
 */
@property (nonatomic, strong, readonly) NSString *unitNumber;
/*!
 * Zone id associated with the waypoint (matches JMapZone id)
 */
@property (nonatomic, strong, readonly) NSNumber *zoneId;
/*!
 * Client Id field set by user in map builder tool
 */
@property (nonatomic, strong, readonly) NSString *clientId;
-(id)initWithCGPoint:(NSValue *)thisPoint;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ===============================
// JMap JMapZoneDetails data model
// ===============================
@interface JMapZoneDetails : NSObject
@property (nonatomic, strong, readonly) NSNumber *languageId;
/*!
 * Project ID associated with the JMapZone object
 */
@property (nonatomic, strong, readonly) NSNumber *projectId;
/*!
 * Text description of the zone
 */
@property (nonatomic, strong, readonly) NSString *zoneDescription;
/*!
 * Unique identifier for the zone
 */
@property (nonatomic, strong, readonly) NSNumber *zoneId;
/*!
 * Zone Type Id
 */
@property (nonatomic, strong, readonly) NSNumber *zoneTypeId;
/*!
 * Name associated with the zone defined in content manager
 */
@property (nonatomic, strong, readonly) NSString *zoneName;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ========================
// JMap JMapZone data model
// ========================
@interface JMapZone : NSObject
@property (nonatomic, strong, readonly) NSString *clientId;
/*!
 * Project ID associated with the zone
 */
@property (nonatomic, strong, readonly) NSNumber *projectId;
/*!
 * Status of the zone, Active/Inactive
 */
@property (nonatomic, strong, readonly) NSNumber *statusCode;
/*!
 * Unique identifier for the zone
 */
@property (nonatomic, strong, readonly) NSNumber *zoneId;
/*!
 * Zone Type Id
 */
@property (nonatomic, strong, readonly) NSNumber *typeId;
/*!
 * List of JMapZoneDetails objects
 */
@property (nonatomic, strong, readonly) NSArray *zoneDetails;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// =========================
// JMap JMapFloor data model
// =========================
@interface JMapFloor : NSObject
/*!
 * List of JMapAmenity objects on the floor
 */
@property (nonatomic, strong, readonly) NSArray *amenities;
/*!
 * List of JMapAmenity objects that are people movers on the floor
 */
@property (nonatomic, strong, readonly) NSArray *movers;
/*!
 * List of JMapWaypoint objects on the floor
 */
@property (nonatomic, strong, readonly) NSArray *waypoints;
@property (nonatomic, strong, readonly) NSArray *destinationLabels;
/*!
 * XML string containing the SVG data
 */
@property (nonatomic, strong, readonly) NSString *svg;
/*!
 * List of map labels (street names) on the map
 */
@property (nonatomic, strong, readonly) NSArray *mapLabels;
/*!
 * Unique identifier for the floor in the venue
 */
@property (nonatomic, strong, readonly) NSNumber *mapId;
/*!
 * Location ID associated with the floor
 */
@property (nonatomic, strong, readonly) NSNumber *locationId;
@property (nonatomic, strong, readonly) NSNumber *parentLocationId;
/*!
 * Location name associated with the floor
 */
@property (nonatomic, strong, readonly) NSString *locationName;
/*!
 * Description field in content manager for Location Maps
 */
@property (nonatomic, strong, readonly) NSString *description;
@property (nonatomic, strong, readonly) NSString *themedMap;
/*!
 * Name of the floor defined by user in content manager
 */
@property (nonatomic, strong, readonly) NSString *name;
/*!
 * String containing the PNG URL the map
 */
@property (nonatomic, strong, readonly) NSString *uri;
/*!
 * Image source of the PNG link to the map
 */
@property (nonatomic, strong, readonly) NSString *thumbnailHTML;
/*!
 * Floor sequence value defined by the user in content manager
 */
@property (nonatomic, strong, readonly) NSNumber *floorSequence;
/*!
 * Default floor sequence value when JMapDevices object not found in building
 */
@property (nonatomic, strong, readonly) NSNumber *defaultMapForDevice;
/*!
 * String containing the SVG URL to the map
 */
@property (nonatomic, strong, readonly) NSString *svgMap;
@property (nonatomic, strong, readonly) NSNumber *preference;
/*!
 * Advanced setting of X offset coordinates of the map used for location service
 */
@property (nonatomic, strong, readonly) NSNumber *xOffset;
/*!
 * Advanced setting of Y offset coordinates of the map used for location service
 */
@property (nonatomic, strong, readonly) NSNumber *yOffset;
/*!
 * Advanced setting of the X scale factor of the map used for location service
 */
@property (nonatomic, strong, readonly) NSNumber *xScale;
/*!
 * Advanced setting of the Y scale factor of the map used for location service
 */
@property (nonatomic, strong, readonly) NSNumber *yScale;
/*!
 * Status of the map, 1/0
 */
@property (nonatomic, strong, readonly) NSNumber *status;
/*!
 * Status of the map, Active/Inactive
 */
@property (nonatomic, strong, readonly) NSString *statusDesc;
@property (nonatomic, strong, readonly) NSString *highContrastMap;
@property (nonatomic, strong, readonly) NSString *customFile1;
@property (nonatomic, strong, readonly) NSString *customFile2;
@property (nonatomic, strong, readonly) NSString *customFile3;
// New properties as of 12th January 2016
/*!
 * Advanced setting of the latitude value of the top left most point on the map
 */
@property (nonatomic, strong, readonly) NSNumber *lat1;
/*!
 * Advanced setting of the longitude value of the top left most point on the map
 */
@property (nonatomic, strong, readonly) NSNumber *lng1;
/*!
 * Advanced setting of the latitude value of the bottom right most point on the map
 */
@property (nonatomic, strong, readonly) NSNumber *lat2;
/*!
 * Advanced setting of the longitude value of the bottom right most point on the map
 */
@property (nonatomic, strong, readonly) NSNumber *lng2;
// Init
-(instancetype)initWithDictionary:(NSDictionary *)dict withPaths:(NSArray *)withPaths withPathTypes:(NSArray *)withPathTypes withURL:(NSString *)withURL;
@end

// ===========================
// JMap JMapAmenity data model
// ===========================
@interface JMapAmenity : NSObject
/*!
 * Identifier for the JMapAmenity object
 */
@property (nonatomic, strong, readonly) NSNumber *componentId;
/*!
 * Type identifier for the JMapAmenity object
 */
@property (nonatomic, strong, readonly) NSNumber *componentTypeId;
/*!
 * Text defined in the Localized Text field in content manager
 */
@property (nonatomic, strong, readonly) NSString *localizedText;
/*!
 * Name of the component type (i.e. Legend Item)
 */
@property (nonatomic, strong, readonly) NSString *componentTypeName;
/*!
 * Description defined in content manager
 */
@property (nonatomic, strong, readonly) NSString *description;
/*!
 * Start date of the amenity set by user in content manager
 */
@property (nonatomic, strong, readonly) NSNumber *startDate;
/*!
 * End date of the amenity set by user in content manager
 */
@property (nonatomic, strong, readonly) NSNumber *endDate;
@property (nonatomic, strong, readonly) NSString *position;
/*!
 * URL of the JMapAmenity icon
 */
@property (nonatomic, strong, readonly) NSString *filePath;
/*!
 * Name defined in the Name field in content manager
 */
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *iconImagePath;
/*!
 * Project ID associated with the amenity
 */
@property (nonatomic, strong, readonly) NSNumber *projectId;
/*!
 * List of JMapDestination objects associated with the amenity
 */
@property (nonatomic, strong, readonly) NSArray *destinations;
/*!
 * List of JMapWaypoint objects associated with the amenity
 */
@property (nonatomic, strong, readonly) NSArray *waypoints;
@property (nonatomic) BOOL isAmenity;
@property (nonatomic, strong) JMapAnnotation *annotation;
/*!
 * Location ID associated with the amenity
 */
@property (nonatomic, strong, readonly) NSNumber *locationId;
@property (nonatomic, strong, readonly) NSString *uri;
@property (nonatomic, strong, readonly) NSString *label;
/*!
 * JMapFloor mapId associated with the amenity
 */
@property (nonatomic, strong, readonly) NSNumber *mapId;
@property (nonatomic, strong, readonly) NSNumber *typeId;
@property (nonatomic, strong, readonly) NSString *locationX;
@property (nonatomic, strong, readonly) NSString *locationY;
@property (nonatomic, strong, readonly) NSString *ck;
/*!
 * URL of the JMapAmenity icon in PNG format
 */
@property (nonatomic, strong, readonly) NSString *iconImage;
@property (nonatomic, strong, readonly) NSNumber *compgroup;
@property (nonatomic, strong, readonly) NSString *rotation;
@property (nonatomic, strong, readonly) NSNumber *zoomlevel;
@property (nonatomic, strong, readonly) NSString *metaData;
/*!
 * URL of the JMapAmenity icon in SVG format for Web
 */
@property (nonatomic, strong, readonly) NSString *webPath;
@property (nonatomic, strong, readonly) NSString *svg;
@property (nonatomic, strong, readonly) NSNumber *sequenceNumber;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

// ================================
// JMap JMapFloorSVGData data model
// ================================
@interface JMapFloorSVGData : NSObject
/*!
 * View box received from the SVG file for floor
 */
@property (nonatomic, strong, readonly) NSValue *viewBox;
/*!
 * List of styles received from the SVG file for floor
 */
@property (nonatomic, strong, readonly) NSDictionary *styles;
/*!
 * List of all shape elements in the SVG file for floor
 */
@property (nonatomic, strong, readonly) NSArray *shapeArray;
-(instancetype)initWithData:(NSValue *)viewBoxIn stylesIn:(NSDictionary *)stylesIn shapeArrayIn:(NSArray *)shapeArrayIn;
@end

// =========================
// JMap JMapVenue data model
// =========================
@interface JMapVenue : NSObject
/*!
 * List of locations at server URL endpoint
 */
@property (nonatomic, strong, readonly) JMapLocations *location;
/*!
 * List of all amenities in the venue, JMapAmenity objects,
 */
@property (nonatomic, strong, readonly) NSArray *amenities;
/*!
 * List of all people movers in the venue, JMapAmenity objects
 */
@property (nonatomic, strong, readonly) NSArray *movers;
/*!
 * List of all destinations in the venue, JMapDestination objects
 */
@property (nonatomic, strong, readonly) NSArray *destinations;
/*!
 * List of all devices in the venue, JMapDevices objects
 */
@property (nonatomic, strong, readonly) NSArray *devices;
/*!
 * List of all maps/floors in the venue, JMapFloor objects
 */
@property (nonatomic, strong, readonly) NSArray *maps;
/*!
 * List of all paths in the venue, JMapPathData objects
 */
@property (nonatomic, strong, readonly) NSArray *paths;
/*!
 * List of all path types in the venue, JMapPathDataTypes objects
 */
@property (nonatomic, strong, readonly) NSArray *pathTypes;
/*!
 * List of all events for venue, JMapEvents objects
 */
@property (nonatomic, strong, readonly) NSArray *events;
/*!
 * List of all waypoints in the venue, JMapWayPoint objects
 */
@property (nonatomic, strong, readonly) NSArray *waypoints;
/*!
 * List of all categories in the venue, JMapCategoryModel objects
 */
@property (nonatomic, strong, readonly) NSArray *categories;
@property (nonatomic, strong, readonly) NSArray *extractedMovers;
/*!
 * List of all street labels in the map, JMapMapLabels ojbects
 */
@property (nonatomic, strong, readonly) NSArray *maptext;
@property (nonatomic, strong, readonly) NSArray *locationsHierarchy;
/*!
 * List of all zones in the venue, JMapZone objects
 */
@property (nonatomic, strong, readonly) NSArray *zones;
/*!
 * Initialization method for JMapVenue
 * @param dict containing key value pairs of properties
 * @return JMapVenue object data instance
 */
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end