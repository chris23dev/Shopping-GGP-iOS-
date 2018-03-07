//
//  GGPProduct.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPProduct.h"
#import "GGPTenant.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

@interface GGPProduct ()

@property (assign, nonatomic) BOOL isChildAllFilter;

@end

@implementation GGPProduct

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
    return @{ @"code": @"code",
              @"label": @"label" };
}

- (NSString *)parentCode {
    return [self.code componentsSeparatedByString:@"/"].firstObject;
}

- (NSString *)childCode {
    return [self.code componentsSeparatedByString:@"/"].lastObject;
}

- (NSString *)name {
    return self.isChildAllFilter ? [NSString stringWithFormat:@"%@ %@", [@"ALL_PREFIX" ggp_toLocalized], [self.code ggp_toLocalized]] : [self.childCode ggp_toLocalized];
}

- (NSString *)filterText {
    if ([self.code containsString:@"/"]) {
        NSString *parentName = [self.code componentsSeparatedByString:@"/"].firstObject;
        NSString *childName = [self.code componentsSeparatedByString:@"/"].lastObject;
        return [NSString stringWithFormat:@"%@ / %@", [parentName ggp_toLocalized], [childName ggp_toLocalized]];
    } else {
        return self.name;
    }
}

- (GGPFilterType)type {
    return GGPFilterTypeProduct;
}

+ (NSArray *)productsListFromTenants:(NSArray *)tenants {
    NSArray *allUniqueProducts = [self uniqueProductsFromTenants:tenants];
    NSArray *uniqueParentProducts = [self uniqueParentProductsFromAllProducts:allUniqueProducts andTenants:tenants];
    return [uniqueParentProducts ggp_sortListAscendingForKey:@"name"];
}

+ (NSArray *)uniqueProductsFromTenants:(NSArray *)tenants {
    NSMutableDictionary *uniqueProductLookup = [NSMutableDictionary new];
    for (GGPTenant *tenant in tenants) {
        for (GGPProduct *product in tenant.products) {
            if (![uniqueProductLookup.allKeys containsObject:product.code]) {
                [uniqueProductLookup setObject:product forKey:product.code];
            }
        }
    }
    return uniqueProductLookup.allValues;
}

+ (NSArray *)uniqueParentProductsFromAllProducts:(NSArray *)allProducts andTenants:(NSArray *)tenants {
    NSArray *parentCodes = [allProducts ggp_arrayWithMap:^(GGPProduct *product) {
        return product.parentCode;
    }];
    
    NSArray *parentProducts = [allProducts ggp_arrayWithFilter:^BOOL(GGPProduct *product) {
        return [parentCodes containsObject:product.code];
    }];
    
    for (GGPProduct *parentProduct in parentProducts) {
        parentProduct.isParentFilter = YES;
        parentProduct.childFilters = [self childItemsForParentItem:parentProduct fromAllProducts:allProducts andTenants:tenants];
    }

    return parentProducts;
}

+ (NSArray *)childItemsForParentItem:(GGPProduct *)parentItem fromAllProducts:(NSArray *)allProducts andTenants:(NSArray *)tenants {
    NSMutableSet *childItems = [NSMutableSet new];
    
    for (GGPProduct *product in allProducts) {
        if ([product.parentCode isEqualToString:parentItem.code] && ![product.code isEqualToString:parentItem.code]) {
            product.filteredItems = [product retrieveFilteredListFromTenants:tenants];
            [childItems addObject:product];
        }
    }
    
    NSMutableArray *childList = [childItems.allObjects ggp_sortListAscendingForKey:@"name"].mutableCopy;
    [self addAllFilterToChildList:childList forParent:parentItem];
    
    return childList;
}

+ (void)addAllFilterToChildList:(NSMutableArray *)childList forParent:(GGPProduct *)parent {
    GGPProduct *allFilter = [GGPProduct new];
    allFilter.isChildAllFilter = YES;
    allFilter.code = parent.code;
    
    NSMutableSet *allFilterTenants = [NSMutableSet new];
    for (GGPProduct *childFilter in childList) {
        [allFilterTenants addObjectsFromArray:childFilter.filteredItems];
    }
    allFilter.filteredItems = allFilterTenants.allObjects;
    
    [childList insertObject:allFilter atIndex:0];
}

+ (NSArray *)nonParentItemChildItemsFromProducts:(NSArray *)products {
    return [products ggp_arrayWithFilter:^BOOL(GGPProduct *product) {
        return !product.isChildAllFilter;
    }];
}

- (NSArray *)retrieveFilteredListFromTenants:(NSArray *)tenants {
    return [tenants ggp_arrayWithFilter:^BOOL(GGPTenant *tenant) {
        return [tenant.products ggp_anyWithFilter:^BOOL(GGPProduct *product) {
            return [product.code isEqualToString:self.code];
        }];
    }];
}

@end
