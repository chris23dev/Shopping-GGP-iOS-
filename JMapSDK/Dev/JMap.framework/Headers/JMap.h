//
//  JMap.h
//  JMap
//
//  Created by jibestream on 2015-04-16.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JMap/JMAPFoundation.h>
#import <JMap/JMapContainerView.h>
#import <JMap/JMapCustomStyleSheet.h>

#import <JMap/UIKitHelper.h>

/*!
 * Map Annotation Classes
 */
#import <JMap/JMapBaseModelObject.h>
// Deprecating JMapFullMap and using JMapFloor instead
//#import <JMap/JMapFullMap.h>
#import <JMap/JMapLocations.h>
#import <JMap/JMapFloor.h>
#import <JMap/JMapCategoryModel.h>
#import <JMap/JMapSelectedLocation.h>
#import <JMap/JMapsYouAreHere.h>

#import <JMap/JMapToolTips.h>
#import <JMap/JMapLabel.h>
#import <JMap/JMapTextDirections.h>
#import <JMap/JMapsUserLocationAnnotation.h>

// Text directions
#import <JMap/JMapDestinationRangedMeasurment.h>
#import <JMap/JMapDestinationRangedComparator.h>
#import <JMap/JMapTextDirectionEntry.h>
#import <JMap/JMapTextDirectionInstruction.h>
#import <JMap/JMapTextDirectionProcessor.h>
#import <JMap/JMapTextDirectionParser.h>

// Bryan: added classes
#import <JMap/JMapSVGParser.h>
#import <JMap/JMapSVGIconView.h>
#import <JMap/JMapSVGUnitView.h>
#import <JMap/JMapSVGLBoxView.h>
#import <JMap/JMapFrame.h>
#import <JMap/JMapViewCommander.h>
#import <JMap/JMapUnitLabelContainer.h>

// WayFinding
#import <JMap/JMapASEdge.h>
#import <JMap/JMapASNode.h>
#import <JMap/JMapPathPerFloor.h>
#import <JMap/JMapNeighbor.h>
#import <JMap/JMapASGrid.h>
#import <JMap/JMapASSearch.h>

// Bryan: JMapDataModel
#import <JMap/JMapDataModel.h>

// Over Map Views
#import <JMap/JMapOverMapViewCollection.h>

// Styling
#import <JMap/JMapSVGStyle.h>

//! Project version number for JMap.
FOUNDATION_EXPORT double JMapVersionNumber;

//! Project version string for JMap.
FOUNDATION_EXPORT const unsigned char JMapVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JMap/PublicHeader.h>


