//
//  GGPCategory.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/15/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLJSONAdapter.h>
#import <Mantle/MTLModel.h>
#import "GGPFilterItem.h"

extern NSString *const GGPCategoryTenantOpeningsCode;
extern NSString *const GGPCategoryUserFavoritesCode;
extern NSString *const GGPCategoryAllStoresCode;
extern NSString *const GGPCategoryAllSalesCode;

@interface GGPCategory : MTLModel <MTLJSONSerializing, GGPFilterItem>

@property (assign, nonatomic) NSInteger categoryId;
@property (strong, nonatomic) NSString *label;
@property (assign, nonatomic, readonly) BOOL isCampaign;

+ (NSArray *)createFilterCategoriesFromCategories:(NSArray *)categories withTenants:(NSArray *)tenants;
+ (void)removeEmptyAndChildCategoriesFromCategories:(NSArray *)categories;
+ (BOOL)isValidCampaignCategoryCode:(NSString *)code;

- (void)addAllFilterToSubCategoryList;

@end
