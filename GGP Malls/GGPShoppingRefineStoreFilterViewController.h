//
//  GGPShoppingRefineStoreFilterViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPRefineOptionsDelegate.h"
#import <UIKit/UIKit.h>

@interface GGPShoppingRefineStoreFilterViewController : UIViewController

@property (weak, nonatomic) id<GGPRefineOptionsDelegate> refineDelegate;

- (instancetype)initWithFilteredTenants:(NSArray *)filteredTenants includeUserFavorites:(BOOL)includeUserFavorites andTenants:(NSArray *)tenants;

@end
