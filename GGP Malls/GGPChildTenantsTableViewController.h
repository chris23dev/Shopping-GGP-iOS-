//
//  GGPChildTenantsTableViewController.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPTenant.h"

@interface GGPChildTenantsTableViewController : UITableViewController

- (void)configureWithParentTenant:(GGPTenant *)parentTenant;

@end
