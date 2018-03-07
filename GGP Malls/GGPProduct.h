//
//  GGPProduct.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Mantle/MTLJSONAdapter.h>
#import <Mantle/MTLModel.h>
#import "GGPFilterItem.h"

@interface GGPProduct : MTLModel <MTLJSONSerializing, GGPFilterItem>

@property (strong, nonatomic) NSString *label;

// calculated
@property (strong, nonatomic, readonly) NSString *parentCode;
@property (strong, nonatomic, readonly) NSString *childCode;

+ (NSArray *)productsListFromTenants:(NSArray *)tenants;
+ (NSArray *)nonParentItemChildItemsFromProducts:(NSArray *)products;

@end
