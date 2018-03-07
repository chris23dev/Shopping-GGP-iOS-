//
//  GGPTenantTableViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/17/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPTenantListDelegate.h"

@interface GGPTenantTableViewController : UITableViewController

- (void)configureWithTenants:(NSArray *)tenants;
- (void)configureWithTenants:(NSArray *)tenants hideAlpha:(BOOL)hideAlpha;

@property (weak, nonatomic) id<GGPTenantListDelegate> delegate;

@end
