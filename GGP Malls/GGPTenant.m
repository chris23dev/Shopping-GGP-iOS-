//
//  GGPTenant.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 1/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPBrand.h"
#import "GGPCategory.h"
#import "GGPExceptionHours.h"
#import "GGPHours.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPProduct.h"
#import "GGPTenant.h"
#import "GGPUser.h"
#import "MTLValueTransformer+GGPAdditions.h"
#import "NSArray+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

static NSString *const kWeeklyHoursHeaderFormat = @"%@\t%@";
static NSString *const kWeeklyHoursFormat = @"%@%@\t%@\n";
static NSString *const kOpenTableUrl = @"http://www.opentable.com/single.aspx?rid=%@&rtype=ism&restref=%@";
static NSString *const kPrefixThe = @"THE ";
static NSString *const kAnchorType = @"ANCHOR";
static NSString *const kSortKey = @"sortName";

@interface GGPTenant ()
@end

@implementation GGPTenant

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tenantId": @"id",
             @"parentId": @"parentId",
             @"childIds": @"childIds",
             @"tenantDescription": @"description",
             @"isFeaturedOpening": @"featuredOpening",
             @"leaseId": @"leaseId",
             @"mallId": @"mallId",
             @"name": @"name",
             @"nonSvgLogoUrl": @"nonSvgLogoUrl",
             @"operatingHours": @"operatingHours",
             @"exceptionHours": @"operatingHoursExceptions",
             @"openTableId": @"openTableId",
             @"phoneNumber": @"phoneNumber",
             @"placeWiseRetailerId": @"placeWiseRetailerId",
             @"tenantOpenDate": @"storeOpenDate",
             @"temporarilyClosed": @"temporarilyClosed",
             @"websiteUrl": @"websiteUrl",
             @"latitude" : @"latitude",
             @"longitude" : @"longitude",
             @"unitType" : @"unit.type",
             @"categories": @"categories",
             @"products": @"productData.types",
             @"brands": @"productData.brands",
             };
}

+ (NSValueTransformer *)categoriesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPCategory.class];
}

+ (NSValueTransformer *)brandsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPBrand.class];
}

+ (NSValueTransformer *)operatingHoursJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPHours.class];
}

+ (NSValueTransformer *)productsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPProduct.class];
}

+ (NSValueTransformer *)exceptionHoursJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPExceptionHours.class];
}

+ (NSValueTransformer *)latitudeJSONTransformer {
    return [MTLValueTransformer ggp_stringToNumberTransformer];
}

+ (NSValueTransformer *)longitudeJSONTransformer {
    return [MTLValueTransformer ggp_stringToNumberTransformer];
}

+ (NSValueTransformer *)tenantOpenDateJSONTransformer {
    return [MTLValueTransformer ggp_dateJSONTransformer];
}

- (NSURL *)tenantLogoUrl {
    return [NSURL URLWithString:self.nonSvgLogoUrl];
}

- (NSString *)displayName {
    NSString *displayName = _displayName ? _displayName : self.name;
    if (self.temporarilyClosed) {
        return [NSString stringWithFormat:@"%@ %@", displayName, [@"TENANT_TEMPORARILY_CLOSED" ggp_toLocalized]];
    } else {
        return displayName;
    }
}

- (NSString *)listOrderName {
    return [self cropThePrefixOfString:self.displayName];
}

- (NSString *)sortName {
    return [self cropThePrefixOfString:self.name];
}

- (NSString *)prettyPrintCategories {
    return [[self filteredCategoryNamesForDisplay] componentsJoinedByString:@", "];
}

- (BOOL)isParentCategory:(GGPCategory *)category {
    return [self.categories ggp_anyWithFilter:^BOOL(GGPCategory *tenantCategory) {
        return tenantCategory.parentId == category.filterId;
    }];
}

- (NSArray *)filteredCategoryNamesForDisplay {
    NSMutableArray *categoryNames = [NSMutableArray new];
    for (GGPCategory *category in self.categories) {
        if (![self isParentCategory:category] && category.name) {
            [categoryNames addObject:category.name];
        }
    }
    return categoryNames;
}

#pragma mark - Hours

- (BOOL)hasMultipleOpenHoursForDate:(NSDate *)date {
    NSArray *hoursForDate = [GGPHours openHoursForDate:date
                                                 hours:self.operatingHours
                                     andExceptionHours:self.exceptionHours];
    return hoursForDate.count > 1;
}

- (BOOL)hasHoursForToday {
    NSArray *hoursForToday = [GGPHours openHoursForDate:[NSDate new]
                                                 hours:self.operatingHours
                                     andExceptionHours:self.exceptionHours];
    
    return hoursForToday.count > 0;
}

- (NSString *)formattedHoursHeader {
    if (self.hasHoursForToday) {
        NSDate *today = [NSDate new];
        NSString *openHoursString = [self formattedOpenHoursStringForDate:today];
        NSString *hoursHeaderLabel = @"";
        
        if ([self hasMultipleOpenHoursForDate:today]) {
            openHoursString = [openHoursString stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
        }
        
        hoursHeaderLabel = [NSString stringWithFormat:kWeeklyHoursHeaderFormat, [@"DETAILS_HOURS_HEADER_TODAY" ggp_toLocalized], openHoursString];
        
        return hoursHeaderLabel;
    } else {
        return [@"DETAILS_HOURS_HEADER_STORE" ggp_toLocalized];
    }
}

- (NSString *)formattedWeeklyHours {
    NSString *hoursString = @"";
    
    for (GGPHours *hour in self.operatingHours) {
        NSString *weekDayString = [hour prettyPrintStartDate];
        
        NSDate *date = [self dateForWeekday:hour.startDay];
        NSString *timeString = [self formattedOpenHoursStringForDate:date];
        
        hoursString = [NSString stringWithFormat:kWeeklyHoursFormat, hoursString, weekDayString, timeString];
    }
    
    return [hoursString ggp_removeTrailingNewLine];
}

- (NSString *)formattedOpenHoursStringForDate:(NSDate *)date {
    NSString *formattedOpenHoursString = @"";
    NSArray *hoursForDate = [GGPHours openHoursForDate:date
                                                 hours:self.operatingHours
                                     andExceptionHours:self.exceptionHours];
    
    for (GGPHours *hour in hoursForDate) {
        formattedOpenHoursString = [formattedOpenHoursString stringByAppendingString:[NSString stringWithFormat:@"%@\n", [hour prettyPrintOpenHoursRange]]];
    }
    
    return [formattedOpenHoursString ggp_removeTrailingNewLine];
}

- (NSDate *)dateForWeekday:(NSString *)weekday {
    NSDate *today = [NSDate date];
    for (NSDate *date in [NSDate ggp_upcomingWeekDatesForStartDate:today]) {
        if ([weekday isEqualToString:[date ggp_shortDayStringFromDate]]) {
            return date;
        }
    }
    return nil;
}

#pragma mark - Opentable

- (NSURL *)openTableUrl {
    NSString *restaurantID = [NSString stringWithFormat:@"%ld", (long)self.openTableId];
    NSString *stringURL = [NSString stringWithFormat:kOpenTableUrl, restaurantID, restaurantID];
    return [NSURL URLWithString:stringURL];
}

#pragma mark - Only open tenants

+ (NSArray *)openTenantsFromAllTenants:(NSArray *)tenants {
    return [tenants ggp_arrayWithFilter:^BOOL(GGPTenant *tenant) {
        return !tenant.temporarilyClosed;
    }];
}

+ (NSArray *)wayFindingEnabledTenantsFromAllTenants:(NSArray *)tenants {
    return [tenants ggp_arrayWithFilter:^BOOL(GGPTenant *tenant) {
        return [[GGPJMapManager shared] wayfindingAvailableForTenant:tenant];
    }];
}

#pragma mark - Unique

+ (NSArray *)uniqueTenantsByBrandFromAllTenants:(NSArray *)tenants {
    NSMutableArray *uniqueTenants = [NSMutableArray new];
    
    for (GGPTenant *tenant in tenants) {
        BOOL exists = [uniqueTenants ggp_anyWithFilter:^BOOL(GGPTenant *evaluatedTenant) {
            return evaluatedTenant.placeWiseRetailerId == tenant.placeWiseRetailerId;
        }];
        if (!exists) {
            [uniqueTenants addObject:tenant];
        }
    }
    
    return uniqueTenants;
}

#pragma mark - Filter tenants

+ (NSArray *)filteredTenantsBySearchText:(NSString *)searchText fromTenants:(NSArray *)tenants {
    NSMutableSet *filteredTenants = [NSMutableSet new];
    NSArray *searchParams = [searchText componentsSeparatedByString:@" "];
    
    for (NSString *searchParam in searchParams) {
        [filteredTenants addObjectsFromArray:[tenants ggp_arrayWithFilter:^BOOL(GGPTenant *tenant) {
            return [tenant.displayName localizedStandardContainsString:searchParam];
        }]];
    }
    
    NSSortDescriptor *alphabeticalSort = [NSSortDescriptor sortDescriptorWithKey:kSortKey ascending:YES];
    return [filteredTenants sortedArrayUsingDescriptors:@[ alphabeticalSort ]];
}

- (BOOL)isFavorite {
    return [[GGPAccount shared].currentUser.favorites containsObject:@(self.placeWiseRetailerId)];
}

- (BOOL)isAnchor {
    return [self.unitType isEqualToString:kAnchorType];
}

- (BOOL)isChildTenant {
    return self.parentId > 0;
}

- (BOOL)isRelatedToTenant:(GGPTenant *)compareTenant {
    if (!compareTenant) {
        return NO;
    }
    
    BOOL isChild = self.isChildTenant && self.parentId == compareTenant.tenantId;
    BOOL isParent = [self.childIds containsObject:@(compareTenant.tenantId)];
    
    return isChild || isParent;
}

- (NSString *)nameIncludingParent {
    return [NSString stringWithFormat:@"%@ - %@ %@", self.name, [@"WAYFINDING_INSIDE" ggp_toLocalized].lowercaseString, self.parentTenant.name];
}

#pragma mark - Helper

- (NSString *)cropThePrefixOfString:(NSString *)string {
    if ([[string uppercaseString] hasPrefix:kPrefixThe]) {
        return [string substringFromIndex:kPrefixThe.length].uppercaseString;
    }
    return string.uppercaseString;
}

@end
