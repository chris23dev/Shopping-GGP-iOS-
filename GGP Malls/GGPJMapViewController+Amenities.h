//
//  GGPJMapViewController+Amenities.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapViewController.h"

@class GGPAmenity;

@interface GGPJMapViewController (Amenities)

- (void)configureAmenities;
- (void)highlightAmenity:(GGPAmenity *)amenity;
- (void)reloadAmenityFilters;
- (void)resetAmenityFilters;
- (BOOL)amenityExistsOnFloor:(JMapFloor *)floor;

@end
