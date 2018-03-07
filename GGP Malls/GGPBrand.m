//
//  GGPBrand.m
//  GGP Malls
//
//  Created by Janet Lin on 12/16/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPBrand.h"
#import "GGPFilterType.h"
#import "GGPTenant.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

@implementation GGPBrand

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
    return @{ @"brandId": @"id",
              @"name": @"name", };
}

- (NSInteger)filterId {
    return self.brandId;
}

- (NSString *)filterText {
    return self.name;
}

- (GGPFilterType)type {
    return GGPFilterTypeBrand;
}

+ (NSArray *)brandsListFromTenants:(NSArray *)tenants {
    NSArray *uniqueBrands = [self uniqueBrandsFromTenants:tenants];
    
    for (GGPBrand *brand in uniqueBrands) {
        brand.filteredItems = [brand retrieveFilteredListFromTenants:tenants];
    }
    
    return [uniqueBrands ggp_sortListAscendingForKey:@"name"];
}

+ (NSArray *)uniqueBrandsFromTenants:(NSArray *)tenants {
    NSMutableSet *brands = [NSMutableSet new];

    for (GGPTenant *tenant in tenants) {
        if (tenant.brands.count > 0) {
            [brands addObjectsFromArray:tenant.brands];
        }
    }

    return brands.allObjects;
}

- (NSArray *)retrieveFilteredListFromTenants:(NSArray *)tenants {
    return [tenants ggp_arrayWithFilter:^BOOL(GGPTenant *tenant) {
        return [tenant.brands ggp_anyWithFilter:^BOOL(GGPBrand *brand) {
            return [brand.name isEqualToString:self.name];
        }];
    }];
}

- (BOOL)isEqual:(GGPBrand *)brand {
    return self.filterId == brand.filterId;
}

- (NSUInteger)hash {
    return self.filterId;
}

@end
