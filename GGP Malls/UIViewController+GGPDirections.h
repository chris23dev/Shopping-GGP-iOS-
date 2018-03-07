//
//  UIViewController+GGPDirections.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPParkingGarage;
@class GGPTenant;

@interface UIViewController (GGPDirections)

- (NSAttributedString *)ggp_attributedDirectionsStringForTenant:(GGPTenant *)tenant;
- (void)ggp_getDirectionsForTenant:(GGPTenant *)tenant;
- (void)ggp_getDirectionsForLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude;

@end
