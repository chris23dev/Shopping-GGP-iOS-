//
//  GGPTenantSearchTableViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantSearchDelegate.h"
#import <UIKit/UIKit.h>

@interface GGPTenantSearchTableViewController : UITableViewController <UISearchResultsUpdating>

@property (weak, nonatomic) id <GGPTenantSearchDelegate> searchDelegate;

- (void)formatTenantNamesForDisplay:(NSArray *)tenants;
- (void)configureWithTenants:(NSArray *)tenants;
- (void)configureWithTenants:(NSArray *)tenants excludeUnMappedTenants:(BOOL)excludeUnMappedTenants;

@end
