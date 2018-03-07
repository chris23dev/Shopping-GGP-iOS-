//
//  GGPRefineStoreFilterDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

@protocol GGPRefineStoreFilterDelegate <NSObject>

- (void)didUpdateFilteredTenants:(NSArray *)tenants;
- (void)didUpdateFavoriteTenants:(BOOL)includeUserFavorites;

@end
