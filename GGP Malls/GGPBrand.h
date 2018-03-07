//
//  GGPBrand.h
//  GGP Malls
//
//  Created by Janet Lin on 12/16/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>
#import "GGPFilterItem.h"

@interface GGPBrand : MTLModel <MTLJSONSerializing, GGPFilterItem>

@property (assign, nonatomic) NSInteger brandId;

+ (NSArray *)brandsListFromTenants:(NSArray *)tenants;

@end
