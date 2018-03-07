//
//  GGPRefineFilterDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

@protocol GGPRefineFilterDelegate <NSObject>

- (void)didUpdateFilteredSales:(NSArray *)filteredSales withTenants:(NSArray *)tenants;

@end
