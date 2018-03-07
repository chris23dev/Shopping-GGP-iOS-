//
//  GGPCategory.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/15/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPUser.h"
#import "GGPCategory.h"
#import "GGPTenant.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

NSString *const GGPCategoryTenantOpeningsCode = @"STORE_OPENING";
NSString *const GGPCategoryUserFavoritesCode = @"USER_FAVORITES";
NSString *const GGPCategoryAllStoresCode = @"ALL_STORES";
NSString *const GGPCategoryAllSalesCode = @"ALL_SALES";

static NSString *const kBlackFridayCode = @"BLACK_FRIDAY";
static NSString *const kEasterCode = @"EASTER";
static NSString *const kHolidayCode = @"HOLIDAY";
static NSString *const kValentinesCode = @"VALENTINES";

@implementation GGPCategory

#pragma GGPFilterItem properties
@synthesize type = _type;
@synthesize code = _code;
@synthesize filterId = _filterId;
@synthesize parentId = _parentId;
@synthesize name = _name;
@synthesize filterText = _filterText;
@synthesize childFilters = _childFilters;
@synthesize filteredItems = _filteredItems;
@synthesize count = _count;
@synthesize isParentFilter = _isParentFilter;
@synthesize isAllFilter = _isAllFilter;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"categoryId": @"id",
             @"parentId": @"parentId",
             @"code": @"code",
             @"label": @"label"
             };
}

- (NSInteger)filterId {
    return self.categoryId;
}

- (BOOL)isParent {
    return self.parentId == 0;
}

- (NSString *)name {
    return self.isParentFilter ? [NSString stringWithFormat:@"%@ %@", [@"ALL_PREFIX" ggp_toLocalized], self.label] : self.label;
}

- (GGPFilterType)type {
    return GGPFilterTypeCategory;
}

- (NSString *)filterText {
    return self.name;
}

- (NSArray *)filteredItems {
    if (self.childFilters.count == 0) {
        return _filteredItems;
    } else {
        NSMutableSet *filteredItems = [NSMutableSet new];
        for (GGPCategory *childCategory in self.childFilters) {
            [filteredItems addObjectsFromArray:childCategory.filteredItems];
        }
        return filteredItems.allObjects;
    }
}

- (NSInteger)count {
    return self.filteredItems.count;
}

- (BOOL)isCampaign {
    return [GGPCategory isValidCampaignCategoryCode:self.code];
}

+ (BOOL)isValidCampaignCategoryCode:(NSString *)code {
    NSArray *validCampaigns = @[kBlackFridayCode, kEasterCode, kHolidayCode, kValentinesCode];
    return [validCampaigns containsObject:code];
}

+ (void)removeEmptyAndChildCategoriesFromCategories:(NSMutableArray *)categories {
    NSArray *emptyCategories = [categories ggp_arrayWithFilter:^BOOL(GGPCategory *category) {
        return category.filteredItems.count == 0 || !category.isParent;
    }];
    
    [categories removeObjectsInArray:emptyCategories];
}

+ (NSArray *)createFilterCategoriesFromCategories:(NSArray *)categories withTenants:(NSArray *)tenants {
    NSSortDescriptor *alphabeticalSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSMutableArray *sortedFilters = [categories sortedArrayUsingDescriptors:@[alphabeticalSort]].mutableCopy;
    
    for (GGPCategory *parentFilter in sortedFilters) {
        if (parentFilter.childFilters.count > 0) {
            [parentFilter addAllFilterToSubCategoryList];
        }
    }
    
    [self moveStoreOpeningsToTopOfList:sortedFilters];
    [self addMyFavoritesCategoryToList:sortedFilters fromTenants:tenants];
    [self addAllFilterCategoryToList:sortedFilters];
    
    return sortedFilters;
}

- (void)addAllFilterToSubCategoryList {
    GGPCategory *allFilter = [GGPCategory new];
    allFilter.code = self.code;
    allFilter.label = self.label;
    allFilter.categoryId = self.categoryId;
    allFilter.isParentFilter = YES;
    allFilter.filteredItems = self.filteredItems;
    
    NSMutableArray *childList = self.childFilters.mutableCopy;
    [childList insertObject:allFilter atIndex:0];
    self.childFilters = childList;
}


+ (void)moveStoreOpeningsToTopOfList:(NSMutableArray *)categories {
    NSArray *filteredCategories = [categories ggp_arrayWithFilter:^BOOL(GGPCategory *category) {
        return [category.code isEqualToString:GGPCategoryTenantOpeningsCode];
    }];
    
    if (filteredCategories.count) {
        GGPCategory *storeOpeningsCategory = filteredCategories.firstObject;
        [categories removeObject:storeOpeningsCategory];
        [categories insertObject:storeOpeningsCategory atIndex:0];
    }
}

+ (void)addMyFavoritesCategoryToList:(NSMutableArray *)categories fromTenants:(NSArray *)tenants {
    GGPCategory *category = [GGPCategory new];
    category.code = GGPCategoryUserFavoritesCode;
    category.label = [GGPCategoryUserFavoritesCode ggp_toLocalized];
    category.count = [GGPAccount isLoggedIn] ? [GGPAccount shared].currentUser.favorites.count : 0;
    category.filteredItems = [tenants ggp_arrayWithFilter:^BOOL(GGPTenant *tenant) {
        return tenant.isFavorite;
    }];
    [categories insertObject:category atIndex:0];
}

+ (void)addAllFilterCategoryToList:(NSMutableArray *)categories {
    GGPCategory *allStoresCategory = [GGPCategory new];
    allStoresCategory.isAllFilter = YES;
    allStoresCategory.code = GGPCategoryAllStoresCode;
    allStoresCategory.label = [GGPCategoryAllStoresCode ggp_toLocalized];
    [categories insertObject:allStoresCategory atIndex:0];
}

@end
