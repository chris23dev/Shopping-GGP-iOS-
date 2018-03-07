//
//  GGPCarLocationsTableViewController.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/12/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPParkingSite;

@interface GGPCarLocationsTableViewController : UITableViewController

- (instancetype)initWithSite:(GGPParkingSite *)site searchText:(NSString *)searchText andCarLocations:(NSArray *)carLocations;

@end
