//
//  GGPShoppingRefineStoreFilterTableViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPRefineStoreFilterDelegate.h"
#import <UIKit/UIKit.h>

@interface GGPShoppingRefineStoreFilterTableViewController : UITableViewController

@property (weak, nonatomic) id<GGPRefineStoreFilterDelegate> storeFilterDelegate;

- (instancetype)initWithFilteredTenants:(NSArray *)filteredTenants includeUserFavorites:(BOOL)includeUserFavorites andTenants:(NSArray *)tenants;
- (void)updateWithSearchResults:(NSArray *)searchResults;

@end
