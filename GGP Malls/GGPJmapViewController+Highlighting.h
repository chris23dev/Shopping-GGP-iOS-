//
//  GGPJmapViewController+Highlighting.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapViewController.h"

@class JMapDestination;
@class JMapFloor;

@interface GGPJMapViewController (Highlighting)

- (void)unhighlightUnitsBasedOnFilters;
- (void)highlightTenants:(NSArray *)tenants;
- (void)handleTappedDestination:(JMapDestination *)tappedDestination;
- (void)clearHighlightedDestinations;

@end
