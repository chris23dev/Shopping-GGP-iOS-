//
//  GGPJMapViewController+Zoom.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapViewController.h"

@class JMapFloor;
@class GGPTenant;

@interface GGPJMapViewController (Zoom)

- (void)configureTapToZoomRecognizer;
- (void)zoomToMall;
- (void)zoomToTenant:(GGPTenant *)tenant withIcons:(BOOL)shouldShowIcons;
- (void)centerMapForParkingInfo;
- (void)updateUnitLabelsWithScale:(NSNumber *)newScale;

@end
