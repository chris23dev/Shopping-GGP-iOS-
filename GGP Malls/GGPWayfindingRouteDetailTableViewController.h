//
//  GGPWayfindingRouteDetailTableViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

@class GGPTenant;
#import <UIKit/UIKit.h>

@interface GGPWayfindingRouteDetailTableViewController : UITableViewController

- (void)configureWithDirections:(NSArray *)directions fromTenant:(GGPTenant *)fromTenant toTenant:(GGPTenant *)toTenant;

@end
