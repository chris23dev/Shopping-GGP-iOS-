//
//  jMapContainerView.h
//  JMapSDK
//
//  Created by Sean Batson on 2015-03-27.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMap/JMapFoundation.h>

@class JMapVenue;
@class JMapSVGParser;
@class JMapMapLabels;
@class JMapProximities;
@class JMapSVGStyle;
@class JMapCanvas;
@class JMapDevices;
@class JMapTextDirection;
@class JMapDestination;
@class JMapFloor;
@class JMapWaypoint;
@class JMapAmenity;
@class JMapDestination;
@class JMapBuilder;
@class JMapTextDirections;
@class JMapsUserLocationAnnotation;
@class JMapsYouAreHere;
@class JMapScriptsWebProcessor;
@class JMapCustomStyleSheet;
@class JMapSelectedLocation;
@class JMapBaseModelObject;
@class JMapAMStyles;
@class JMapZone;
@class JMapPathPerFloor;
@class JMapPointOnFloor;
@class UIKitHelperCustomThresholds;

@protocol JMapDelegate;
@protocol JMapDataSource;

/*!
 * @interface JMapContainerView
 *  This is the map container view of the SDK. This view is subviewed into a view controller for  rendering of user supplied map documents.
 */
@interface JMapContainerView : UIScrollView
//

/*!
 * Deletes Local Cache
 */
+(void)deleteCacheFolder;

/*!
 * Prints current SDK Version
 */
+(NSString *)JMapSDKVersion;

/*!
 * Prints SDK version notes
 */
+(NSString *)JMapSDKVersionNotes;

/*!
 * Get All Map Layers
 */
-(NSArray *)getMapLayers;

/*!
 * Hide selected map layer
 * @param mapLayer a string of a layer name to be hidden
 */
-(void)hideMapLayer:(NSString *)mapLayer;

/*!
 * Show selected map layer
 * @param mapLayer a string of a layer name to be shown
 */
-(void)showMapLayer:(NSString *)mapLayer;

/*!
 * Show only selected map layers
 * @param mapLayer a list of layer names to be shown
 */
-(void)showOnlyMapLayers:(NSArray *)mapLayers;

/*!
 * Reset and make map layers visible
 */
-(void)resetMapLayers;

/*!
 * Enable map layer to be interactive
 * @param layerName a string of a layer name to enable interactivity
 */
-(void)enableLayerInteractivity:(NSString *)layerName;

/*!
 * Disable map layer interactive
 * @param layerName a string of a layer name to disable interactivity
 */
-(void)disableLayerInteractivity:(NSString *)layerName;

/*!
 * Reset map layer interactivity
 */
-(void)resetLayersInteractivity;

/*!
 * Highlight shape in specified layer
 * @param layerName a string of the layer name to highlight
 * @param idDic a NSDictionary of the data-* key-value pairing of the specified shape
 * @param style a custom JMapSVGStyle object for highlighting the unit
 */
-(void)highlightLayerWithName:(NSString *)layerName byIdPair:(NSDictionary *)idDic withSVGStyle:(JMapSVGStyle *)style;

/*!
 * Unhighlight shape in specified layer
 * @param layerName a string of the layer name to highlight
 * @param idDic a NSDictionary of the data-* key-value pairing of the specified shape
 */
-(void)unhighlightLayerWithName:(NSString *)layerName withIdPair:(NSDictionary *)idDic;

// This command is used by UIViews to tell main to tell vCommander to check if UIView's new positon causes collision with others
-(void)tellMainToTellViewCommanderIGotUpdated:(UIView *)thisView;
// Image of floor
// Obsoleted
//-(UIImage *)twoUnitsWithPaddingToImage:(int)firstUnit secondUnit:(int)secondUnit minSize:(float)minSize padding:(float)padding firstXY:(CGPoint *)firstXY secondXY:(CGPoint *)secondXY scale:(float)scale;

-(UIView *)getBlueDotView;

/*!
 * Helper method which returns UIImage for two destinations.
 * @param firstDestination JMapDestination* of first destination.
 * @param secondDestination JMapDestination* of second destination.
 * @param onFloor JMapFloor* floor containing two destinations.
 * @param minSize float minimum size of image. The retunred image will always be square.
 * @param padding float padding to be added to returned image.
 * @param scale float 2.0 for 2x Retina, 3.0 for 3x Retina...
 * @return UIImage* image for two destinations.
 */
-(UIImage *)twoDestinationsOnFloorToImage:(JMapDestination *)firstDestination secondDestination:(JMapDestination *)secondDestination onFloor:(JMapFloor *)onFloor minSize:(float)minSize padding:(float)padding scale:(float)scale;

/*!
 * Get image of Floor/Map with Rectangle parameters
 * @param mapId NSNumber* obtained from JMapFloor mapId
 * @param cropRect CGRect, the rectangle to be cropped on the map
 * @param toRect CGRect, the rectangle that contains the cropped rectangle (size adjustable)
 * @return UIImage* of cropped image
 */
-(UIImage *)cropImageOfFloor:(NSNumber *)mapId cropRect:(CGRect)cropRect toRect:(CGRect)toRect;

/*!
 * Get image of Floor/Map with Rectangle
 * @param floorIndex NSInteger, equivalent to floor sequence
 * @param withRect CGRect, the rectangle to be cropped
 * @return UIImage* of cropped rect on floor
 */
-(UIImage *)imageOfFloor:(NSInteger)floorIndex withRect:(CGRect)withRect;

/*!
 * Get view of Floor/Map by Floor Index
 * @param floorIndex NSInteger, equivalent to floor sequence
 * @return UIView* of entire floor
 */
-(UIView *)viewOfFloor:(NSInteger)floorIndex;

/*!
 * Get number of floors in floor stack/building
 * @return NSInteger value
 */
-(NSInteger)howManyFloorsInStack;

/*!
 * Get view of current Floor/Map
 * @return UIView* object
 */
-(UIView *)getCurrentFloorView;

/*!
 * Set SVG Icon highlight
 * @param thisIcon JMapSVGParser*
 */
-(void)highlightIcon:(JMapSVGParser *)thisIcon;
-(void)hilightIcon:(JMapSVGParser *)thisIcon __attribute__((deprecated("Use highlightIcon: instead")));

/*!
 * Set SVG Icon unhighlight
 * @param thisIcon JMapSVGParser*
 */
-(void)unhighlightIcon:(JMapSVGParser *)thisIcon;
-(void)unhilightIcon:(JMapSVGParser *)thisIcon __attribute__((deprecated("Use unhighlightIcon: instead")));

// What is the default floor
/*!
 * Get initial Floor/Map Id
 * @return NSNumber* mapId
 */
-(NSNumber *)defaultFloorId;

// Get current floor
/*!
 * Get the current viewing Floor/Map
 * @return JMapFloor* object
 */
-(JMapFloor *)getCurrentFloor;

// Get floor from view
/*!
 * Get Floor/Map by View
 * @param thisView UIView*
 * @return JMapFloor* object
 */
-(JMapFloor *)getFloorForView:(UIView *)thisView;

// Categories helpers
/*!
 * Get a list of all Categories in this building
 * @return An NSArray of JMapCategoryModel* object(s)
 */
-(NSArray*)getCategories;
// Get all Destinations
/*!
 * Get a list of all Destination in this building
 * @return An NSArray of JMapDestination* object(s)
 */
-(NSArray*)getDestinations;
// Bryan: Jan 24th 2016 Obsoleting all JMapBaseElement helpers
// SDK will no longer serve Bezier Shapes to clients
// Get destination from destination ID int
//-(id)getDestinationById:(int)thisDestinationId;
// Get Destination from Unit returned by jMapViewDidTapOnUnit
//-(id)getDestinationFromUnit:(id)thisUnit;

/*!
 * Get Destination by ClientId
 * @param clientId NSString*, can be found in content manager
 * @return JMapDestination* object
 */
-(JMapDestination*)getDestinationByClientId:(NSString *)clientId;

/*!
 * Get Destination by DestinationId
 * @param destinationId NSNumber*, unique identifier of the destination
 * @return JMapDestination* object
 */
-(JMapDestination *)getDestinationByDestinationId:(NSNumber *)destinationId;

/*!
 * Get Destination(s) by Waypoint
 * @param waypoint JMapwaypoint* associated with the destination
 * @return An NSArray* of JMapDestination* object(s)
 */
-(NSArray*)getDestinationsByWp:(JMapWaypoint*)waypoint;

/*!
 * Get Destination(s) by Floor Sequence Number
 * @param floorSequence NSNumber*
 * @return An NSArray* of JMapDestination* object(s)
 */
-(NSArray*)getDestinationsByFloorSequence:(NSNumber *)floorSequence;

/*!
 * Get Destination(s) by Map/Floor Id
 * @param mapId NSNumber*
 * @return An NSArray* of JMapDestination* object(s)
 */
-(NSArray*)getDestinationsByMapId:(NSNumber *)mapId;

/*!
 * Get Destination(s) by CategoryId
 * @param categoryId NSNumber* of the unique category identifier
 * @return An NSArray* of JMapDestination* object(s)
 */
-(NSArray*)getDestinationsByCategoryId:(NSNumber *)categoryId;

/*!
 * Get a list of all Waypoints
 * @return An NSArray* of JMapWaypoint* object(s)
 */
-(NSArray*)getWayspoints;

/*!
 * Get a Waypoint by WaypointId
 * @param waypointId NSNumber*, can be found in map builder
 * @return JMapWaypoint* object
 */
-(JMapWaypoint *)getWayPointById:(NSNumber *)waypointId;

/*!
 * Get an array of all the Amenities
 * @return An NSArray of JMapAmenity* object(s)
 */
-(NSArray*)getAmenities;

/*!
 * Get a list of all Waypoints that have an Amenity association
 * @return An NSArray* of JMapWaypoint* object(s)
 */
-(NSArray*)getAmenityWaypoints;

/*!
 * Get Amenity with AmenityId
 * @param amenityId NSNumber* found in content manager
 * @return JMapAmenity* object
 */
-(JMapAmenity*)getAmenityById:(NSNumber *)amenityId;

/*!
 * Get a list of all the maps with their metadata of this location
 * @return An NSArray* of JMapFloor* object(s)
 */
-(NSArray*)getMaps;

/*!
 * Get all shapes of this unit with DestinationId
 * @param destinationId NSNumber*
 * @return An NSArray* of JMapBaseElement* object(s)
 */
-(NSArray *)getAllShapesFromDestinationId:(NSNumber *)destinationId;

/*!
 * Get all data from shapes of given layer name
 * @param layerName NSString*
 * @return An NSArray* of NSDictionary object(s)
 */
-(NSArray *)getAllShapesDataFromLayerName:(NSString *)layerName;

/*!
 * Get a list of all Waypoints on this Map/Floor Id
 * @param mapId NSNumber* obtained from JMapFloor mapId
 * @return An NSArray* of JMapWaypoint* object(s)
 */
-(NSArray*)getWaypointsFromMapId:(NSNumber *)mapId;

// WayFind
/*!
 * Get Path for by from and to Waypoints
 * @param fromWaypoint JMapWaypoint*, starting waypoint object
 * @param toWaypoint JMapWaypoint*, ending waypoint object
 * @param accessibility NSNumber*, 50/100 (50 - use most accessible path, 100 - use fastest path)
 * @return An NSArray* of JMapPathPerFloor object
 */
-(NSArray *)findPathForWaypoint:(JMapWaypoint *)fromWaypoint toWaypoint:(JMapWaypoint *)toWaypoint accessibility:(NSNumber *)accessibility;
// Obsolete as of 1.0.11
// Use findPathForWaypoint:toWaypoint:accessibility:
//-(NSArray *)findWaypointsForUnit:(int)fromUnitId toUnit:(int)toUnit accessibility:(int)accessibility;

// Text Directions v2.0 Line Of Sight
// Input wayfindArray is result of findPathForWaypoint:toWaypoint:accessibility:
// Input:
// filterOn Jibestream solution or raw Text Direction for every waypoint
// addTDifEmptyMeters must be over 0 or filter disabled
// UTurnInMeters must be over 0 or filter disabled
/*!
 * Generate list of text directions
 * @param wayfindArray NSArray*, list of array of wayfind floors (returned from findPathForWaypoint method)
 * @param filterOn BOOL to toggle using filters or not for generating text directions
 * @param addTDifEmptyMeters float threshold used for combining text directions (continue past)
 * @param UTurnInMeters float threshold for initiating a u-turn
 * @param customThreshHolds UIKitHelperCustomThresholds*
 * @return An NSArray* of NSString* object(s)
 */
-(NSArray *)makeTextDirections:(NSArray *)wayfindArray filterOn:(BOOL)filterOn addTDifEmptyMeters:(float)addTDifEmptyMeters UTurnInMeters:(float)UTurnInMeters customThreshHolds:(UIKitHelperCustomThresholds *)customThreshHolds;
// Obsolete as of 1.0.11
// Use makeTextDirections:filterOn:addTDifEmptyMeters:UTurnInMeters:
//-(NSArray *)findTextDirectionsFromUnit:(int)fromUnitId toUnit:(int)toUnit accessibility:(int)accessibility;

// Soften path
// Prototype. Do not use until further notice
-(NSArray *)softenPath:(NSArray *)wayfindArray;

// getIconByWaypoint
/*!
 * Get Icon by Waypoint
 * @param waypoint JMapWaypoint*
 * @return JMapSVGParser* object
 */
-(JMapSVGParser *)getIconByWaypoint:(JMapWaypoint *)waypoint;

/*!
 * Correct blue dota XY and place it on WayFind Path
 * @param setOfPoints JMapPathPerFloor* from wayfind method call
 * @param point CGPoint of current (x,y)
 * @param noFurtherThan float in pixels
 * @return CGPoint nearest to wayfinding Path
 */
-(CGPoint)correctPointUsingWayfindPath:(JMapPathPerFloor *)setOfPoints point:(CGPoint)point noFurtherThan:(float)noFurtherThan;

/*!
 * Correct blue dot XY and place it on floor
 * @param setOfPaths NSArray* of JMapPathData object(s) on floor
 * @param allWaypoints NSArray of JMapWaypoint object(s) on floor
 * @param onFloor JMapFloor* of current viewing floor
 * @param point CGPoint of current (x,y)
 * @param noFurtherThan float in pixels
 * @return CGPoint to nearest Path
 */
-(CGPoint)correctPointUsingPaths:(NSArray *)setOfPaths allWaypoint:(NSArray *)allWaypoints onFloor:(JMapFloor *)onFloor point:(CGPoint)point noFurtherThan:(float)noFurtherThan;

/*!
 * Suggests to redraw the existing wayfind path if user exceeds a set distance threshold
 * @param setOfPoints JMapPathPerFloor from wayfind method call
 * @param point CGPoint current location (x,y)
 * @param threshold float distance to trigger rerouting
 */
-(BOOL)shouldCorrectToRerouteWayfindPath:(JMapPathPerFloor *)setOfPoints withCurrentPoint:(CGPoint)currentPoint threshold:(float)threshold;

// General
/*!
 * Get device's current visible Rectangle
 * @return CGRect unit
 */
-(CGRect)visibleRect;

/*!
 * Get size of the world in world units
 * @return CGSize unit
 */
-(CGSize)worldSize;

// World Zoom Scale
/*!
 * Get zoom scale of world units to pixels
 * @return CGFloat unit
 */
-(CGFloat)worldZoomScale;

//===============================
// Floor helpers
/*!
 * Get Floor/Map one above current floor
 * @return JMapFloor* object
 */
-(JMapFloor *)floorUp;

/*!
 * Get Floor/Map one below current floor
 * @return JMapFloor* object
 */
-(JMapFloor *)floorDown;
//===============================
// rect Helpers
/*!
 * Get default Floor/Map Id
 * @return NSNumber* mapId
 */
-(NSNumber *)getVenueDefaultFloorId;

// Get list of styles
/*!
 * Get a list of all styles
 * @return An NSArray of NSString* style names
 */
-(NSArray *)getListOfStyles;

// Get list of styles from shapes
/*!
 * Get a list of all styles from shapes
 * @return An NSArray of NSString* style names
 */
-(NSArray *)getListOfStylesFromShapes;

/*!
 * Catch All String
 * @param thisString NSString*
 * @param thisFloor JMapFloor*
 * @return CGRect unit
 */
-(CGRect)rectForCatchAllString:(NSString *)thisString forFloor:(JMapFloor *)thisFloor;

/*!
 * Get Rectangle of current Map's center
 * @return CGRect unit
 */
-(CGRect)rectForMapCenter;

/*!
 * Get Rectangle for style string
 * @param styleString NSString*
 * @param onFloor JMapFloor*
 * @return CGRect unit
 */
-(CGRect)rectForStyleString:(NSString *)styleString onFloor:(JMapFloor *)onFloor;

/*!
 * Get Rectangle for array of style string
 * @param arrayStyleString NSArray*
 * @param onFloor JMapFloor*
 * @return CGRect unit
 */
-(CGRect)rectForArrayOfStyleString:(NSArray *)arrayStyleString onFloor:(JMapFloor *)onFloor;

// Reset rotation
/*!
 * Reset the Floor/Map's rotation
 */
-(void)resetRotation;

// Units related
//===============================
// Grouping by Categories section
/*!
 * Get a list all destination categories in this building
 * @return An NSArray* of JMapCategoryModel objects
 */
-(NSArray *)getListOfCategories;

/*!
 * Highlight units by selected categories
 * @param thisArray NSArray* of JMapCategoryModel objects
 * @param andAnimate BOOL to set animation on/off
 * @param thisColor UIColor* to highlight unit
 */
-(void)highlightCategories:(NSArray *)thisArray andAnimate:(BOOL)andAnimate withColor:(UIColor *)thisColor;

/*!
 * Unhighlight units by select categories
 * @param thisArray NSArray* of JMapCategoryModel objects
 */
-(void)unHighlightCategories:(NSArray *)thisArray;

//===============================
// Individual units related
/*!
 * Get Destination Proximities by Destination Id
 * @param destinationIdInt NSNumber*
 * @return JMapProximities* object
 */
-(JMapProximities *)returnDestinationProximitiesForDestinationIdInt:(NSNumber *)destinationIdInt;

/*!
 * Get Map coordinates of a unit returned by jMapViewDidTapOnDestination
 * @param thisUnit JMapDestination* object
 * @return An NSArray of JMapPointOnFloor* object(s)
 */
-(NSArray *)getXYFromUnit:(JMapDestination *)thisUnit;

/*!
 * Get Map coordinates of a unit with Floor/Map
 * @param thisUnit JMapDestination* object
 * @param onFloor JMapFloor* oject
 * @return An NSArray of JMapPointOnFloor* object(s)
 */
-(NSArray *)getXYFromUnit:(JMapDestination *)thisUnit onFloor:(JMapFloor *)onFloor;
// setUnitHighlight
// Obsolete
// Use setDestinationHighlight:
//-(void)setUnitHighlight:(id)thisUnit withStyleArray:(NSMutableArray *)thisStyleArray;
//-(void)setUnitHighlight:(id)thisUnit withStyle:(JMapSVGStyle *)thisStyle;
//-(void)setUnitHighlight:(id)thisUnit withColor:(UIColor *)thisColor;

/*!
 * Get Destination highlight status
 * @param thisDestination JMapDestination*
 * @return BOOL for highlight on/off
 */
-(BOOL)getDestinationHighlightStatus:(JMapDestination *)thisDestination;

/*!
 * Set Destination highlight with style array
 * @param destination JMapDestination* to be highlighted
 * @param thisStyleArray NSMutableArray*, list of JMapSVGStyle* objects
 */
-(void)setDestinationHighlight:(JMapDestination *)destination withStyleArray:(NSMutableArray *)thisStyleArray;

/*!
 * Set Destination highlight with style
 * @param destination JMapDestination* to be highlighted
 * @param thisStyle JMapSVGStyle* with specified style
 */
-(void)setDestinationHighlight:(JMapDestination *)destination withStyle:(JMapSVGStyle *)thisStyle;

/*!
 * Set Destination highlight with color
 * @param destination JMapDestination* to be highlighted
 * @param thisColor UIColor* with specified color
 */
-(void)setDestinationHighlight:(JMapDestination *)destination withColor:(UIColor *)thisColor;

/*!
 * Unhighlight Destination unit
 * @param destination JMapDestination* to be unhighlighted
 */
-(void)setDestinationUnHighlight:(JMapDestination *)destination;

/*!
 * Get animation status of Destination
 * @param destination JMapDestination*
 * @return BOOL for animation on/off
 */
-(BOOL)isDestinationAnimated:(JMapDestination *)destination;

// Set unit animation
/*!
 * Set Destination unit animation
 * @param destination JMapDestination* to animate
 * @param doAnimate BOOL, add animation to the destination
 */
-(void)setDestinationAnimation:(JMapDestination *)destination doAnimate:(BOOL)doAnimate;

// Obsolete Feb 22
// Get Category from Unit returned by jMapViewDidTapOnUnit
//-(id)getCategoryFromUnit:(id)thisUnit;
/*!
 * Zoom in on a unit on current Floor/Map
 * @param thisUnit JMapDestination* to zoom to
 * @param onFloor JMapFloor* object of the unit
 * @param withPadding CGSize of the area included in the zoom
 * @param doAnimate BOOL, add animation to the unit
 */
-(void)zoomUnit:(JMapDestination *)thisUnit onFloor:(JMapFloor *)onFloor withPadding:(CGSize)withPadding doAnimate:(BOOL)doAnimate;
//================================
/*!
 * Unhighlight all units
 */
-(void)unhighlightAllUnits;
//================================
// Destinations helpers used after call to getDestinationFromUnit
// Obsoleting (id) Feb 22nd
// Get Unit Name from Unit returned by jMapViewDidTapOnUnit
//-(NSString *)getUnitNameOfDestination:(id)thisDestination;
// Get Description of Destination
//-(NSString *)getDescriptionsOfDestination:(id)thisDestination;
// Get Helper Image of Destination
//-(NSString *)getHelperImageOfDestination:(id)thisDestination;
// Get QRCode of Destination
//-(NSString *)getQRCodeOfDestination:(id)thisDestination;
//================================
// Expose roate
/*!
 * Expose map rotation to handle tooltip, popup card, SVG icon rotations
 */
-(void)iRotatedMap;
//================================

/*!
 * Add a popup card to map with View at coordinate on Floor/Map
 * @param thisView UIView* of the popup card
 * @param atXY CGPoint, placement in x,y coordinates of the popup card
 * @param frozenFrame BOOL to have popup card scale with zoom or not
 * @param toFloor JMapFloor* object to place the popup card
 */
-(void)addPopupCardToMap:(UIView *)thisView atXY:(CGPoint)atXY frozenFrame:(BOOL)frozenFrame toFloor:(JMapFloor *)toFloor;

// Change freeze attrib of a popup card in map
/*!
 * Change freeze attribute of a popup card in map
 * @param thisView UIView* of the popup card
 * @param newFreezeFrame BOOL to have popup card scale with zoom or not
 */
-(void)setFreezeFramePopupCardForView:(UIView *)thisView newFreezeFrame:(BOOL)newFreezeFrame;

// Remove a popup card in map
/*!
 * Remove a popup card to map
 * @param thisView UIView*
 */
-(void)removePopupCardToMap:(UIView *)thisView;

// Bryan: Jan 24th 2016 Obsoleting all JMapBaseElement helpers
// SDK will no longer serve Bezier Shapes to clients
/*
-(void)addPopupCardToMap:(UIView *)thisView atXY:(CGPoint)atXY frozenFrame:(BOOL)frozenFrame withUnit:(id)thisUnit;
 // Change freeze attrib of a popup card in map
-(void)setFreezeFramePopupCardForView:(UIView *)thisView newFreezeFrame:(BOOL)newFreezeFrame withUnit:(id)thisUnit;
*/
//=================================
// Visibility of Icons

/*!
 * Hide all Icons other than given type(s)
 * @param thisTypeArray NSArray*
 */
-(void)showOnlyIconsTypeArray:(NSArray *)thisTypeArray;

/*!
 * Show all Icons of given type
 * @param thisType NSString*
 */
-(void)showOnlyIconsType:(NSString *)thisType;

/*!
 * Show all Icons
 */
-(void)showAllIcons;

/*!
 * Hide all Icons
 */
-(void)hideAllIcons;

/*!
 * Animate all Icons with scale
 * @param scale NSNumber*, the scale factor for animation
 */
-(void)animateAllIcons:(NSNumber *)scale;

/*!
 * Un-animate all Icons
 */
-(void)unAnimateAllIcons;

// Styling of Icons
/*!
 * Highlight all Icons
 */
-(void)highlightAllIcons;

/*!
 * Unhighlight all icons with scale
 */
-(void)unHighlightAllIcons;

/*
 * Highlight all vacant units
 * @param color UIColor* to higlight the vacant units in
 */
-(void)highlightVacantUnitsWithColor:(UIColor *)color;

/*!
 * Remove all effects on Icons, they are displayed, not animated or highlights
 */
-(void)resetAllIcons;

// All AM Icons
/*!
 * Apply default style to all AM Icons
 * @param bg UIColor* background color
 * @param mg UIColor* middleground color
 * @param fg UIColor* foreground color
 */
-(void)applyDefaultWithColorsToAll:(UIColor *)bg mg:(UIColor *)mg fg:(UIColor *)fg;

/*!
 * Apply highlight style to all AM Icons
 * @param bg UIColor* background color
 * @param mg UIColor* middleground color
 * @param fg UIColor* foreground color
 */
-(void)applyHighlightWithColorsToAll:(UIColor *)bg mg:(UIColor *)mg fg:(UIColor *)fg;

/*!
 * Apply custom styling to Amenity Icon at Waypoint
 * @param amenity JMapAmenity* object
 * @param waypoint JMapWaypoint* associated to the amenity
 * @param bg UIColor* background color
 * @param mg UIColor* middleground color
 * @param fg UIColor* foreground color
 */
-(void)applyHighlightWithColorsToAmenity:(JMapAmenity *)amenity waypoint:(JMapWaypoint *)waypoint bg:(UIColor *)bg mg:(UIColor *)mg fg:(UIColor *)fg;

/*!
 * Unhighlight Amenity Icon at Waypoint
 * @param amenity JMapAmenity* object
 * @param waypoint JMapWaypoint* selected
 */
// Unhighlight Amenity
-(void)applyUnHighlightToAmenity:(JMapAmenity *)amenity waypoint:(JMapWaypoint *)waypoint;

// Apply highlight colours for currently tapped Amenity/Mover

/*!
 * Set all AM Icons to default style
 */
-(void)setIconsToDefaultStyle;

/*!
 * Set all Am Icons to highlighted style
 */
-(void)setIconsToHighlightedStyle;
//===================================
// Floor Stack related
/*!
 * Reset any transformation applied to on Floor/Map
 * @param thisView UIView*
 */
-(void)resetTransformOfFloor:(UIView *)thisView;

/*!
 * Get floor view with floor sequence
 * @param thisSequence NSNumber* from JMapFloor sequence
 * @return UIView* object
 */
-(UIView *)floorViewFromSequence:(NSNumber *)thisSequence;
//===================================
// Unit Labels
/*!
 * Reload unit labels for all floors
 */
-(void)reloadUnitLabels;

/*!
 * Remove unit labels for all floors
 */
-(void)removeUnitLabels;

/*!
 * Reload unit labels on one floor
 * @param forFloorId UIView*
 */
-(void)reloadUnitLabelsForFloorView:(UIView *)forFloorId;

/*!
 * Remove unit labels on one floor
 * @param forFloorId UIView*
 */
-(void)removeUnitLabelsForFloorView:(UIView *)forFloorId;
//====================================
// overMapWayFind

/*!
 * Generate default wayfind view
 */
-(void)defaultWayFindView:(JMapPathPerFloor *)pathPerFloor;

/*!
 * Remove all WayFind related views for all floors
 */
-(void)removeAllWayFindViews;

/*!
 * Add WayFind related view on one floor
 * @param thisView UIView* of the wayfind path view
 * @param atXY CGPoint coordinate to place the view
 * @param forFloorId UIView* obtained from floorViewFromSequence helper method
 */
-(void)addWayFindView:(UIView *)thisView atXY:(CGPoint)atXY forFloorId:(UIView *)forFloorId;

/*!
 * Remove WayFind related view on one floor
 * @param thisView UIView* of the wayfind path view
 * @param forFloorId UIView* obtained from floorViewFromSequence helper method
 */
-(void)removeWayFindView:(UIView *)thisView forFloorId:(UIView *)forFloorId;

/*!
 * Place YouAreHere view at coordinates
 * @param point CGPoint of where to place the view on the map
 * @param thisView UIImageView* to be placed
 */
-(UIImageView *)placePersonInView:(CGPoint)point thisView:(UIImageView *)thisView;

/*!
 * Remove YouAreHere view
 * @param thisView UIView*, previously created placePersonInView view
 */
-(void)removePersonInView:(UIView *)thisView;

/*!
 * Get Id of current Floor/Map
 * @param NSNumber* mapId, matches JMapFloor mapId
 */
-(NSNumber *)currentMapId;
//=====================================

/*!
 * Reload all Amenities and Movers
 */
-(void)reloadAmenitiesAndMovers;
//=====================================
// Zones
/*!
 * Get Zone for ClientId
 * @param clientId NSString*, clientId generated in content manager
 */
-(JMapZone *)getZoneByClientId:(NSString *)clientId;

/*!
 * Get Zone for ZoneId
 * @param zoneId NSNumber*, unique zone identifier
 */
-(JMapZone *)getZoneByZoneId:(NSNumber *)zoneId;

/*!
 * Get Waypoints By Zone
 * @param zone JMapZone* object
 * @return list of waypoints associated with the zone
 */
-(NSArray *)getWaypointsByZone:(JMapZone *)zone;
-(NSArray *)getWaypointsByZoneId:(JMapZone *)zone __attribute__((deprecated("Use getWaypointsByZone: instead")));

// Get Destinations By Zone
/*!
 * Get Destinations By Zone
 * @param zone JMapZone* object
 * @return list of destinations associated with the zone
 */
-(NSArray *)getDestinationsByZone:(JMapZone *)zone;
-(NSArray *)getDestinationsByZoneId:(JMapZone *)zone __attribute__((deprecated("Use getDestinationsByZone: instead")));
//=====================================
/*!
 * Load a local or remote map resource by device, language code, map identification number, resource path & map tiling on by default.
 * @param delegate Delegate proocol reference is required.
 * @param code The language code for localized content
 * @param filename A file or http URL referencing the resource map to load
 * @param mapid The map id representing a floor within the map schema
 * @param device The authorised resource accessing map content
 * @return view.
 */
- (instancetype)initDataWithDeviceId:(NSString *)device
                            language:(NSString *)code
                               mapId:(NSNumber *)mapid
                             mapName:(NSURL *)filename
                         andDelegate:(id<JMapDelegate>)delegate;

/*!
 * Load a local or remote map resource by device, language code, map identification number, resource path & map tiling on by default.
 * @param delegate Delegate proocol reference is required.
 * @param datasource Datasource proocol reference is required.
 * @param code The language code for localized content
 * @param filename A file or http URL referencing the resource map to load
 * @param mapid The map id representing a floor within the map schema
 * @param device The authorised resource accessing map content
 * @return JMapContainer view.
 */
 - (instancetype)initDataWithDeviceId:(NSString *)device
                            language:(NSString *)code
                               mapId:(NSNumber *)mapid
                             mapName:(NSURL *)filename
                         andDelegate:(id<JMapDelegate>)delegate
                       andDataSource:(id<JMapDataSource>)datasource;

/*!
 * Load remote map resource language code.
 * @param code The language code for localized content
 * @param delegate Delegate proocol reference is required.
 * @param datasource Datasource proocol reference is required.
 * @return JMapContainer view.
 */
- (instancetype)initDataWithLanguage:(NSString *)code
                         andDelegate:(id<JMapDelegate>)delegate
                       andDataSource:(id<JMapDataSource>)datasource;

/*!
 * Load remote map resource language code.
 * @param code The language code for localized content
 * @param tilingEnabled switch on/off map tiling when it is not needed due to small maps
 * @param delegate Delegate proocol reference is required.
 * @param datasource Datasource proocol reference is required.
 * @return JMapContainer view.
 */
- (instancetype)initDataWithLanguage:(NSString *)code
                         andDelegate:(id<JMapDelegate>)delegate
                       andDataSource:(id<JMapDataSource>)datasource
                 andMapTilingEnabled:(BOOL)tilingEnabled;
/*!
 * Load remote map resource language code.
 * @param code The language code for localized content
 * @param tilingEnabled switch on/off map tiling when it is not needed due to small maps
 * @param delegate Delegate proocol reference is required.
 * @param datasource Datasource proocol reference is required.
 * @param size override the default map tiling size only if map tiling is enabled
 * @return JMapContainer view.
 */
- (instancetype)initDataWithLanguage:(NSString *)code
                         andDelegate:(id<JMapDelegate>)delegate
                       andDataSource:(id<JMapDataSource>)datasource
                 andMapTilingEnabled:(BOOL)tilingEnabled
                      andMapTileSize:(CGFloat)size;

/*!
 * Loads an embedded map document
 * @param fileName The local or remote map resource to load
 * @param inBundle True for Embedded and false remote resource
 */
- (void)setFileName:(NSURL *)fileName isInBundle:(BOOL) inBundle;

/*!
 *  Reload all Map Data
 */
- (void)reloadMapData __attribute__((deprecated("Use reloadMapDataForSelectedLocation: by passing a JMapSelectedLocation reference.")));

/*!
 * Reload all Map Data for selected location
 */
- (void)reloadMapDataForSelectedLocation:(JMapSelectedLocation *)location;

/*!
 * Display a user supplied text tooltip at a given waypoint on the map
 * @param name The title of tooltip to give the control
 * @param wpid The waypoint id (wpid) at which to position tooltip
 */
- (void)showtooltipWithName:(NSString *)name forWayPointID:(NSNumber*)wpid;
/*!
 * Hide a user supplied text tooltip at a given waypoint on the map
 * @param name The title of tooltip to give the control
 * @param wpid The waypoint id (wpid) at which to position tooltip
 */
- (void)hidetooltipWithName:(NSString *)name forWayPointID:(NSNumber*)wpid;

/*!
 * Insert a standard MKPinAnnotation at a given waypoint on the map
 * @param name The tag given to the control
 * @param wpid The waypoint id (wpid) at which to position map pin
 * @param image The custom image artwork to replace stock drop pin
 */
- (void)insertPin:(NSString *)name atWayPointID:(NSNumber*)wpid customUIImage:(UIImage *)image;
/*!
 *  Remove a MKPinAnnotation from the map
 * @param name The tag given to the control
 * @param wpid The waypoint id (wpid) at which to position map pin
 */
- (void)removePin:(NSString *)name;

/*!
 * Reverse Lookup by destination object
 * @param destinationId The id which represents a unit, room or store entity on a map
 * @return Waypoints
 */
- (JMapWaypoint *)getWayPointByDestinationId:(NSNumber *)destinationId;

/*!
 * Fetch the closest waypoint to any given point on the map
 * @param pointOnMap The point to which to query map for the closest way point
 * @return Waypoints
 */
- (JMapWaypoint *)getNearestWayPointForLocationOnMap:(JMAPPoint)pointOnMap;

/*!
 * Updates the "You are here" point on a given Map.
 * @param floorId The current floor object to set the YAH object to
 * @param position A JMAPPoint used to positon the YAH object
 * @param orientation The heading in degrees of the YAH object. Default is 0
 * @param confidence float value measured in pixels
 * @param speed A float measured in pixels/second transition speed
 * @return JMapsYouAreHere
 */
-(JMapsYouAreHere *)updateCurrentLocationWithFloor:(NSString *)floorId
                      currentPosition:(JMAPPoint)position
                          orientation:(NSInteger)orientation
                            confidence:(float)confidence
                                speed:(float)speed;


/*!
 * Hide method for YAH icon
 */
-(void)hideYAH;

/*!
 * Show method for YAH icon
 */
-(void)showYAH;

/*!
 * Get the available building locations
 */
- (void)getVenueLocations;
/*!
 * Get the available building locations
 * @param lcode The language code for map content
 * @param dataSource The JMapDataSource reference for the protocol call backs
 * @param option This enables / disables Map Tiling
 * @return JMapContainerView The map instance for implementation. The JMapDelegate property can be set to this instance prior to be being subviewed
 */
+ (JMapContainerView*)getVenueLocationsForLanguage:(NSString *)lcode withDataSource:(id<JMapDataSource>)dataSource andMapTilingEnabled:(BOOL)option;

/*!
 * Focuses the map to center the "You are here" icon
 */
- (void)focusToYah;

/*!
 * NSArray of the floors(instances of JMapFloor) of the building.
 * @return Array of JMapFloor object(s)
 */
- (NSArray *)getLevels;

/*!
 * Switches the currently viewed level to the one specified by "floorId"
 * @param floorId The new floor to switch the current map to
 * @return The success or failure of request
 */
- (BOOL)setLevelById:(NSNumber *)floorId;

/*!
 * Switches the currently viewed level to the one specified by sequence number
 * @param floorSequence The new floor to switch the current map to
 * @return The success or failure of request
 */
- (BOOL)setLevelBySequence:(NSNumber *)floorSequence;

/*!
 * The floor instance (of JMapFloor) that corresponds to the specified floorId
 * @param floorId The JMapFloor object to fetch
 * @return JMapFloor* object
 */
- (JMapFloor *)getLevelById:(NSInteger)floorId;

/*!
 * The floor instance (of JMapFloor) that corresponds to the specified sequence
 * @param floorSequence The new floor to switch the current map to
 * @return JMapFloor* object
 */
- (JMapFloor *)getLevelBySequence:(NSInteger)floorSequence;

/*!
 * JMapDestination of all the specified storeData including the Jibestream ID
 * @param storeId (clientId) The store, unit or room to fetch
 * @return JMapDestination */
- (JMapDestination* )getJibestreamStore:(NSString *)storeId;

/*!
 * Draws a path to the specified store
 * @param storeId (clientId) The store id of destination
 */
- (void)routeToStore:(JMapDestination *)clientId;
/*!
 * Draws a path to the specified store
 * @param storeId (clientId) The store id of destination
 * @param option Optinal flag to include mover objects in path results
 */
- (void)routeToStore:(JMapDestination *)clientId withMovers:(BOOL)option;

/*!
 * Draws a path to the specified store
 * @param destinationId The destination id of destination
 */
- (void)routeToDestination:(JMapDestination *) destinationId;
/*!
 * Draws a path to the specified store
 * @param destinationId The destination id of destination
 * @param option Optinal flag to include mover objects in path results
 */
- (void)routeToDestination:(JMapDestination *) destinationId withMovers:(BOOL)option;

/*!
 * Draws a path to the specified store
 * @param waypointId The waypoint id of destination
 */
- (void)routeToWaypoint:(JMapWaypoint *) waypointId;
/*!
 * Draws a path to the specified store
 * @param waypointId The waypoint id of destination
 * @param option Optinal flag to include mover objects in path results
 */
- (void)routeToWaypoint:(JMapWaypoint *) waypointId withMovers:(BOOL)option;

/*!
 * NSArray of the path finding data for instances of JMapTextDirection(see below for more details on text directions)) to the specified store
 * @param storeId The store id (clientId) of the destination store
 * @return NSArray array of path data
 */
- (NSArray *)getDirectionsById:(JMapDestination *)destination;
/*!
 * NSArray of the path finding data for instances of JMapTextDirection(see below for more details on text directions)) to the specified store
 * @param storeId The store id (clientId) of the destination store
 * @param option Optinal flag to include mover objects in path results
 * @return NSArray array of path data
 */
- (NSArray *)getDirectionsById:(JMapDestination *)destination withMovers:(BOOL)option;

/*!
 * Convenience methods to getDirectionsById returning text direction data
 * @param storeId The store id (clientId) of the destination store
 * @return JMapTextDirections contains the set of text direction objects
 */
- (JMapTextDirections *)getTextDirectionsByStoreId:(JMapDestination *)destination;

/*!
 * Convenience methods to getDirectionsById to insert text direction labels on to map pass NULL to remove previous inserted text directions
 * @param arrayOfDirectionItems The collection of JMapTextDirections to be intserted along route path
 */
- (void)showTextDirectionItems:(NSArray *)arrayOfDirectionItems;

/*!
 * Highlights the specified destinationId
 * @param destinationId The unit, store or room to highlight on map
 * @param rgb comma seperated values: 255,255,255
 */
- (void)highlightDestination:(NSString*)destinationId andRgbVal:(NSString *)rgb;

/*!
 * Highlights the specified units by category
 * @param categoryId The group of units, stores or rooms to highlight on map
 * @param rgb comma seperated values: 255,255,255
 */
- (void)highlightStoresByCategory:(NSString *)categoryId andRgbVal:(NSString *)rgb;

/*!
 * Set map focus to the highlighted destination
 * @param animated Boolean true or false of the animate the map focus
 */
- (void)focusToHighlightedDestinationsAnimated:(BOOL)animated;

/*! 
 * Highlights the specified service icons
 * @param componentType The set of service icons to hightlight
 */
- (void)highlightServiceIcons:(JMapBaseModelObject *)componentType;

/*!
 * Toggle the visibiliy of the store labels
 * @param hideShowLabels Boolean flag true or false for toggle state
 */
- (void)toggleMapLabels:(BOOL)hideShowLabels;
/*!
 * Toggle the visibiliy of the store labels
 * @param type One of or a combination of JMapToggleLabelTypeLbox, JMapToggleLabelTypeToolTipToggle, JMapToggleLabelTypeBoth
 * @param hideShowLabels Boolean flag true or false for toggle state
 */
- (void)toggleMapLabels:(BOOL)hideShowLabels withType:(JMapToggleLabelType)type __attribute__((deprecated("Use jMapViewShouldDisplayAsTooltipDestinations: instead")));
/*! 
 * Reset the highlight
 */
- (void)resetHighlight;

/*!
 * Scales and positions the map to it's default state
 */
- (void)resetMapPosition;

/*! 
 * Clears the generated waypoint path
 */
- (void)clearWayPoints;

/*! 
 * Clears the visible labels
 */
- (void)clearAllLabels;
/*! 
 * Clears the visible Legends/Icons
 */
- (void)clearAllLegends;
/*! 
 * Clears the map of any drawn paths or highlights and resets the map's scale and position to default
 */
- (void)clearMapAndReset;

/*!
 * NSArray of all the service's ids on that floor.
 * @return NSArray
 */
- (NSArray *)getAmenitiesOnFloor;

/*!
 * NSArray of all the destination ids on that floor.
 * @return NSArray
 */
- (NSArray *)getDestinationsOnFloor;

/*!
 * The width of the map. Can be used, along with height, to convert Geo-coords to x,y
 * @return CGFloat width of map
 */
- (float)getMapWidth;

/*!
 * The height of the map. Can be used, along with height, to convert Geo-coords to x,y
 * @return CGFloat height of map
 */
- (float)getMapHeight;

/*!
 * Get the floor sequence
 * @return OPEN_MAX on failure or floor level on success
*/
- (NSInteger)getSequence;

/*!
 * Display label of destination
 */
-(void)locateLabelByDestinationId:(NSArray*)jMapDestinationArray;
/*!
 * Show Map Amenities
 * @param amenityObjectFilter Amenity object by which to filter amenity icons, passing NULL will display all amenity icons
 */
- (void)prepareMoverItemsWithAmenitiesFilter:(JMapAmenity *)amenityObjectFilter;

/*!
 * @breif Basic Search function
 * @param String of text to search against
 * @return NSArray of JMapDestinations
 */
- (NSArray *)performSearch:(NSString *)searchText;

/*!
 * @name Properties
 */

/*!
 * A readonly context to the map's delegate instance
 */
@property (nonatomic, strong, readonly) JMapVenue *venueObject;
/*!
 * A readonly context to the map's delegate instance
 */
@property (nonatomic, strong, readonly) JMapCanvas *jMapView;
/*!
 * A readonly context to the map's delegate instance
 */
@property (unsafe_unretained, nonatomic) IBOutlet id<JMapDelegate> jMapsDelegate;
/*!
 * A readonly context to the map's datasource instance
 */
@property (unsafe_unretained, nonatomic) IBOutlet id<JMapDataSource> jMapsDataSource;
/*!
 * A readonly context to the map's way finding path data
 */
@property (strong, nonatomic, readonly) NSDictionary *mappedPathData;
/*!
 * A readonly context to the map's current floor when path finding is active
 */
@property (nonatomic, strong, readonly) JMapFloor *currentFloor;
/*!
 * A readonly context to the map's destination floor when path finding is active
 */
@property (nonatomic, strong, readonly) JMapFloor *targetFloor;
/*!
 * A readonly flag of the current label toggle state
 */
@property (nonatomic, assign, readonly) BOOL toggleMapLabels;
/*!
 * A readonly context to the map's userlocation annotation
 */
@property (nonatomic, strong, readonly) JMapsUserLocationAnnotation *userLocation;
/*!
 * The userlocation icon 50x50 max!
 */
@property (strong, nonatomic) UIImage *userLocationIcon;
@property (strong, nonatomic) UIWebView *userLocationSVGIcon;
/*!
 * The userlocation annotation color!
 */
@property (nonatomic, strong) UIColor *annotationColor;
/*!
 * The userlocation pulse ring color!
 */
@property (nonatomic, strong) UIColor *innerPulseColor;
/*!
 * The userlocation outer pulse ring color!
 */
@property (nonatomic, strong) UIColor *outerPulseColor;

@property (nonatomic, readwrite) float userLocationScale;
@property (nonatomic, readwrite) float startAlpha;
@property (nonatomic, readwrite) float endAlpha;
@property (nonatomic, readwrite) float confidenceAlpha;

@property (nonatomic, readwrite) NSTimeInterval pulseAnimationDuration;

@property (nonatomic, readwrite) NSTimeInterval delayBetweenPulseCycles;

/*!
 * sourceDocument - The document source to load
 * To load via http create a http NSURL object -URLWithString: were scheme is http / https
 * To load a local "svg" resource create a file NSURL object -fileURLWithPath:
 * if embedded within bundle specify filename only.
 */
@property (strong, nonatomic) NSURL *sourceDocument;
/*!
 * The You Are Here object, contains current device location, floor and heading
 */
@property (nonatomic, strong, readonly) JMapsYouAreHere *youAreHereToken;
/*!
 * Map view rotation gesture
 */
@property (strong, nonatomic, readonly) UIRotationGestureRecognizer *rotationGestureRecogniser;
/*!
 * Current type labeling being used
 */
@property (nonatomic, readonly) JMapToggleLabelType labelType __attribute__((deprecated("Use jMapViewShouldDisplayAsTooltipDestinations: instead")));
/*!
 * Enable / disable label collision detection
 */
@property (nonatomic) BOOL enableLabelCollision;
/*!
 * Tooltip Style
 */
@property (nonatomic) JMapToolTipStyle toolipEdgeStyle __attribute__((deprecated("Use jMapViewShouldDisplayAsTooltipDestinations: instead")));

/*!
 * Status Map Tiling off/on
 */
@property (nonatomic,getter=isMapTilingEnabled, readonly) bool tilingEnabled;

/*!
 * Device object of building
 */
@property (nonatomic, strong, readonly) JMapDevices *device;

/*!
 * Device Id of device
 */
@property (nonatomic, strong, readonly) NSString *deviceId;

/*!
 * Map Id of Floor/Map
 */
@property (nonatomic, strong, readonly) NSNumber *mapId;

/*!
 * Language code set for location
 */
@property (nonatomic, strong, readonly) NSString *languageCode;

/*!
 * CMS url
 */
@property (nonatomic, strong, readonly) NSString *prefixURL;

/*!
 * Size of tiling on map
 */
@property (nonatomic, strong, readonly) NSNumber *tileSize;
@end

/*! @name Protocols */

/*!
 * Feedback on various map interactions & data exchange.
 */
@protocol JMapDelegate <NSObject>

// Optionals
@optional

// Interaction with map
// Return for tapping on shape on map
// This shape has Destination or Destinations
// The delegate will return Array of Destinations and the center of destination's shape
// Inside array, you will find list of JMapDestinations which occupy shape
/*!
 * Handle tapping on unit with Destination(s)
 * @param thisDestinationArray NSArray*
 * @param destinationCenterPoint JMapPointOnFloor*
 */
-(void)jMapViewDidTapOnDestination:(NSArray *)thisDestinationArray destinationCenterPoint:(JMapPointOnFloor *)destinationCenterPoint;

/*!
 * Handle tapping on a custom interactive layer
 * @param dataDictionary NSDictionary of all data associated with the selected layer
 * @param layerName NSString of the layer name tapped
 */
-(void)jMapViewDidTapOnCustomLayer:(NSDictionary *)dataDictionary withLayerName:(NSString *)layerName;

// jMapTapAtXY tapped on canvas
/*!
 * Handle tap on canvas
 * @param atXY NSValue*
 */
-(void)jMapTapAtXY:(NSValue *)atXY;

// Populating map on-load

// Street Labels
/*!
 * Set whether street names should be processed
 * @param thisFloor JMapFloor*
 * @return BOOL yes/no
 */
-(BOOL)jMapViewShouldProcessStreetNames:(JMapFloor *)thisFloor;

/*!
 * Get street name on Floor/Map
 * @param thisLabel JMapMapLabels*
 * @param thisFloor JMapFloor*
 * @return UIView* of street name label
 */
-(UIView *)jMapViewShouldDisplayStreetName:(JMapMapLabels *)thisLabel onfloor:(JMapFloor *)thisFloor;

/*!
 * Listener for when street name process starts
 * @param thisFloor JMapFloor*
 */
-(void)jMapViewProcessStreetNamesStart:(JMapFloor *)thisFloor;

/*!
 * Listener for when street name process finishes
 * @param thisFloor JMapFloor* object to load street labels
 */
-(void)jMapViewProcessStreetNamesFinish:(JMapFloor *)thisFloor;

/*!
 * Reload street names for all Floors/Maps
 */
-(void)reloadStreetNames;

/*!
 * Remove street names for all Floors/Maps
 */
-(void)removeStreetNames;

// Unit Labels
/*!
 * Set whether unit labels should be processed
 * @param onFloor JMapFloor* object to load labels
 */
- (BOOL)jMapViewShouldProcessUnitLabels:(JMapFloor *)onFloor;

/*!
 * Set whether default unit labels should show trailing ellipses for text wider than label
 * Default is set to NO / false
 */
- (BOOL)jMapViewDefaultUnitLabelsShouldShowTrailingEllipses;

/*!
 * Display unit label for specific destination(s)
 * @param destinations NSArray* of JMapDestination * objects
 * @param onFloor JMapFloor* object to load labels
 * @return BOOL yes/no to be displayed or not
 */
- (BOOL)jMapViewShouldDisplayUnitLabelForDestinations:(NSArray<JMapDestination*>*)destinations onFloor:(JMapFloor *)onFloor;

/*!
 * Set whether to display destinations as tooltips or in-unit label
 * @param destinations NSArray*, list of destinations associated with the unit
 * @param onFloor JMapFloor* object associated to the unit
 * @param insideUnit BOOL* yes/no to have the view displayed inside the unit (usually YES for tooltip, NO for in-line labels)
 * @return UIView* of unit label passed back to be rendered
 */
- (UIView *)jMapViewShouldDisplayAsTooltipDestinations:(NSArray<JMapDestination*>*)destinations onFloor:(JMapFloor *)onFloor insideUnit:(BOOL *)insideUnit;

/*!
 * Set whether to flip in-unit labels or not
 * @returns BOOL yes/no to have unit labels flip with rotation angle
 */
-(BOOL)jMapViewShouldRotateUnitLabels;

/*!
 * Set whether to show LBoxes on unit or not
 * @returns BOOL yes/no to show/hide LBoxes in unit
 */
-(BOOL)jMapViewShouldShowLBoxes;

/*!
 * Listener for when unit label process starts
 * @param onFloor JMapFloor* object
 */
- (void)jMapViewProcessUnitLabelsStart:(JMapFloor *)onFloor;

/*!
 * Listener for when process unit label finishes
 * @param onFloor JMapFloor* object
 */
- (void)jMapViewProcessUnitLabelsFinish:(JMapFloor *)onFloor;

/*!
 *  Get content scale factor on Floor/Map
 * @param newScale NSNumber*, updated scale factor/zoom scale
 * @param onFloor JMapFloor* object
 */
-(void)jMapViewContentScaleFactor:(NSNumber *)newScale onFloor:(JMapFloor *)onFloor;

/*!
 *  Listener for when content scale factor on Floor/Map changes
 * @param nextScale NSNumber*, updated scale factor/zoom scale
 * @param onFloor JMapFloor*
 */
-(void)jMapViewContentScaleFactorChange:(NSNumber *)nextScale onFloor:(JMapFloor *)onFloor;

/*!
 * Set whether the map should load custom css
 * @return BOOL yes/no to look for custom css config file for loading custom styling
 */
- (BOOL)jMapViewShouldLoadCustomCSSDictionaryHandler;

/*!
 *  Set whether to process Amenity Icons and Movers
 * @return BOOL yes/no for loading/displaying amenity icons
 */
-(BOOL)jMapViewShouldProcessAMIcons;

/*!
 *  Set styling for Amenity Icon
 * @param thisIcon JMapAmenity* object to be styled
 * @return JMapAMStyles* object containing defined styling by the user
 */
-(JMapAMStyles *)jMapViewThisAMIconStyle:(JMapAmenity *)thisIcon;

/*!
 *  Listener for when process Amenity Icons starts
 */
-(void)jMapViewProcessAMIconsStart;

/*!
 *  Listener for when process Amenity Icons finishes
 */
-(void)jMapViewProcessAMIconsFinish;

// Amenity/Mover icon tapped
/*!
 *  Handle tapping on Amenity Icon
 * @param thisAMIcon JMapSVGParser* object containing a .amenity property
 * @param atXY NSValue* that can be converted to CGPoint for x,y coordinates
 */
-(void)AMIconTapped:(JMapSVGParser *)thisAMIcon atXY:(NSValue *)atXY;

/*!
 * Set the default label type interaction
 * to one of the following return types.
 * @returns JMapToggleLabelTypeLbox, JMapToggleLabelTypeToolTipToggle, JMapToggleLabelTypeBoth
 */
- (JMapToggleLabelType)jMapViewLabelToggleDefaultType __attribute__((deprecated("Use jMapViewShouldDisplayAsTooltipDestinations: instead")));

// Bryan: Error report
- (void)jMapErrorReport:(NSString *)errorReport;

/*!
 * Map starting to load URL data
 * @param sender mapId
 */
- (void)jMapViewWillStartLoading:(NSNumber *)sender;
/*!
 * Map did load URL data
 * @param sender mapId
 */
- (void)jMapViewDidFinishLoading:(NSNumber *)sender;
/*!
 * Map will begin to draw base layer shapes
 * @param sender The sending map container object
 */
- (void)jMapViewWillDraw:(JMapContainerView *)sender;
/*!
 * Map Did begin to draw base layer shapes
 * @param sender The sending map container object
 */
- (void)jMapViewDidDraw:(JMapContainerView *)sender;
/*!
 * Map load was not successfull
 * @param sender The sending map container object
 * @param error The error state of request
 */
- (void)jMapView:(JMapCanvas *)sender didFailLoadWithError:(NSError *)error;
/*!
 * Provide a custom css dictionary or return null
 * @param sender The sending map container object
 * @returns NSDictionary of custom JSON input file
 */
- (NSDictionary *)jMapViewWillLoadCustomCSSDictionaryHandler:(JMapContainerView *)sender __attribute__((deprecated("Use jMapViewWillLoadCustomCSSDictionaryHandler:")));
/*!
 * Provide a custom css dictionary via a block completion call back
 * @param sender The sending map container object
 * @param completion The completion handler for this method
 */
- (void)jMapViewWillLoadCustomCSSDictionaryHandler:(JMapContainerView *)sender withCompletion:(void(^)(JMapCustomStyleSheet*))completion;
/*!
 * Provide a custom path color object when path finding is active
 * @returns UIColor - The color to render the path color
 */
- (UIColor *)jMapViewRoutePathWayColor __attribute__((deprecated("Use jMapViewRoutePathWayColorAttributes:")));
/*!
 * Provide a custom path color & width attributes when path finding is active
 * @param attributes The completion handler for this method
 */
- (void)jMapViewRoutePathWayColorAttributes:(void(^)(UIColor *pathStrokeColor, CGFloat pathStrokeWidth, UIColor *segmentStrokeColor, CGFloat segmentStrokeWidth, CGFloat pathStrokeOpacity, CGFloat segmentStrokeOpacity))attributes;
/*!
 * Provide a custom shadow color to a map unit, room or store shape
 * @returns UIColor - The color to render shadow
 */
- (UIColor *)jMapViewUnitShadowColor __attribute__((deprecated("Use jMapViewRoutePathWayColorAttributes:")));

/*!
 * The touchInfo dictionary can be populated with of any the given objects noted above
 * Keys:
 *   kJMAPDataUnits
 *   kJMAPMapLegends
 *   kJMAPMapTouchPoint
 *   kJMAPDataLboxes
 *   kJMAPWayPointUnits
 *   kJMAPWayPointLboxes
 *   kJMAPMoverData
 * @param sender The sending map container object
 * @param touchInfo A NSDictionary object consisting of elements related to the map touch event
 */
- (void)jMapView:(JMapContainerView *)sender didSendTouchInfo:(NSDictionary *)touchInfo;
/*!
 * Show label for Unit when touched
 * @param sender The sending map container object
 * @returns true or false
 */
- (BOOL)jMapViewShouldShowLabelForDestinationTouch:(JMapContainerView *)sender;

/*!
 * Provide a new max zoom level between 1 - 5
 * @return The new max zoom
 */
- (CGFloat)jMapViewMaximumZoomLevel __attribute__((deprecated("Use maximumZoomScale of UIScrollView instead. Default minimumZoomScale - 0.3, maximumZoomScale - 10.")));;

@end

/*!
 * Feedback on various map interactions & data exchange.
 */
@protocol JMapDataSource <NSObject>

@required
/*!
 * Provide Authentication Credentials
 * @return @{kJMapAuthenticationTokensUser: @"", kJMapAuthenticationTokensPassword : @"", kJMapAuthenticationTokensAPIKey : @""}
 */
- (NSDictionary *)JMapAuthenticationTokens;

/*!
 * Provide a custom SDK server end point at runtime
 * @param sender The sending map container reference
 * @return The server end point for your environment
 */
- (NSString *)JMapAPIRequestURL:(JMapContainerView *)sender;

/*!
 * Map data is now available
 * @param sender The sending map container reference
 * @param data NSArray of a JMapVenu Object containing all available map data
 * @param error Non-nil in the event of a request failure
 */
- (void)jMapViewDataReady:(JMapContainerView *)sender withVenuData:(JMapVenue *)data didFailLoadWithError:(NSError *)error;

@optional

/*!
 * Map Category Data Ready
 * @param sender The sending map container reference
 * @param data NSArray containing a Category Object of Category Object Models
 * @param error Non-nil in the event of a request failure
 */
- (void)jMapView:(JMapContainerView *)sender didSendAllCategoriesAvailable:(NSArray *)data didFailLoadWithError:(NSError *)error;
/*!
 * Device Refresh Status Data
 * @param sender The sending map container reference
 * @param data NSArray of Refresh Objects
 * @param error Non-nil in the event of a request failure
 */
- (void)jMapView:(JMapContainerView *)sender didSendAllDeviceRefreshDataAvailable:(NSArray *)data didFailLoadWithError:(NSError *)error;

/*!
 * Locations Data Ready
 * @param sender The sending map container reference
 * @param data NSArray of JMapLocations Objects
 * @param error Non-nil in the event of a request failure
 */
- (void)jMapView:(JMapContainerView *)sender didSendAllLocationsAvailable:(NSArray *)data didFailLoadWithError:(NSError *)error;

@end

/*!
 *  This allows for the clearing of map SDK cached data
 */
@interface JMapCacheManagement : NSObject

/*!
 * Clear all cached data before or after initializing of JMapContainerView
 * @param modelData The completion handler on the success or failure
 * @param svgData The completion handler on the success or failure
 */
- (void)clear:(void(^)(NSError *mdlError))modelData svgData:(void(^)(NSError *svgError))svgData;

@end




