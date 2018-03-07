//
//  GGPRefineOptionsDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPRefineSortType.h"

@protocol GGPRefineOptionsDelegate <NSObject>

- (void)didUpdateSortType:(GGPRefineSortType)sortType;
- (void)didUpdateFilteredTenants:(NSArray *)tenants;
- (void)didUpdateIncludeUserFavorites:(BOOL)includeUserFavorites;

@end
