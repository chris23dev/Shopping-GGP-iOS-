//
//  GGPTenant.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 1/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import <Mantle/MTLJSONAdapter.h>

@interface GGPTenant : MTLModel <MTLJSONSerializing>

// Mapped properties
@property (assign, nonatomic, readonly) NSInteger tenantId;
@property (assign, nonatomic, readonly) NSInteger parentId;
@property (strong, nonatomic, readonly) NSArray *childIds;
@property (assign, nonatomic, readonly) NSInteger mallId;
@property (assign, nonatomic, readonly) NSInteger leaseId;
@property (assign, nonatomic, readonly) NSInteger openTableId;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *phoneNumber;
@property (strong, nonatomic, readonly) NSString *nonSvgLogoUrl;
@property (strong, nonatomic, readonly) NSString *websiteUrl;
@property (strong, nonatomic, readonly) NSArray *operatingHours;
@property (strong, nonatomic, readonly) NSArray *exceptionHours;
@property (assign, nonatomic, readonly) NSInteger placeWiseRetailerId;
@property (strong, nonatomic, readonly) NSDate *tenantOpenDate;
@property (strong, nonatomic, readonly) NSNumber *latitude;
@property (strong, nonatomic, readonly) NSNumber *longitude;
@property (strong, nonatomic, readonly) NSString *unitType;
@property (strong, nonatomic, readonly) NSArray *products;
@property (strong, nonatomic, readonly) NSArray *brands;
@property (strong, nonatomic, readonly) NSArray *categories;
@property (assign, nonatomic, readonly) BOOL temporarilyClosed;

// Calculated properties
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *listOrderName;
@property (strong, nonatomic) NSString *sortName;
@property (strong, nonatomic) GGPTenant *parentTenant;
@property (strong, nonatomic) NSArray *childTenants;
@property (strong, nonatomic, readonly) NSString *tenantDescription;
@property (strong, nonatomic, readonly) NSURL *tenantLogoUrl;
@property (assign, nonatomic, readonly) BOOL hasHoursForToday;
@property (assign, nonatomic, readonly) BOOL isFavorite;
@property (assign, nonatomic, readonly) BOOL isAnchor;
@property (assign, nonatomic, readonly) BOOL isFeaturedOpening;
@property (assign, nonatomic, readonly) BOOL isChildTenant;
@property (strong, nonatomic, readonly) NSString *nameIncludingParent;

- (NSString *)prettyPrintCategories;
- (NSString *)formattedWeeklyHours;
- (NSString *)formattedHoursHeader;
- (NSURL *)openTableUrl;
+ (NSArray *)openTenantsFromAllTenants:(NSArray *)tenants;
+ (NSArray *)uniqueTenantsByBrandFromAllTenants:(NSArray *)tenants;
+ (NSArray *)wayFindingEnabledTenantsFromAllTenants:(NSArray *)tenants;
+ (NSArray *)filteredTenantsBySearchText:(NSString *)searchText fromTenants:(NSArray *)tenants;
- (BOOL)isRelatedToTenant:(GGPTenant *)compareTenant;

@end
