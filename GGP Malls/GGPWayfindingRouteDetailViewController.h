//
//  GGPWayfindingRouteDetailViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

@class GGPTenant;
#import <UIKit/UIKit.h>

@interface GGPWayfindingRouteDetailViewController : UIViewController

- (instancetype)initWithDirectionsList:(NSArray *)directions fromTenant:(GGPTenant *)fromTenant toTenant:(GGPTenant *)toTenant;

@end
