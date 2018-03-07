//
//  GGPSale.m
//  GGP Malls
//
//  Created by Janet Lin on 1/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCategory.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPSale.h"
#import "GGPTenant.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPSale ()

@property (strong, nonatomic) NSString *saleImageUrl;
@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) NSArray *brands;

@end

@implementation GGPSale

@synthesize tenant = _tenant;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             // Sale mappings
             @"tenant": @"store",
             @"type": @"type",
             @"displayDateTime": @"displayDateTime",
             @"saleDescription": @"description",
             @"isFeatured": @"featured",
             @"categories" : @"categories",
             @"campaignCategories" : @"campaignCategories",
             @"isTopRetailer": @"topRetailer",
             
             // Promotion mappings
             @"promotionId": @"id",
             @"title": @"title",
             @"startDateTime": @"startDateTime",
             @"endDateTime": @"endDateTime",
             @"saleImageUrl" : @"imageUrl",
             };
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat  = @"yyyy-MM-dd'T'HH:mm";
    return dateFormatter;
}

+ (NSValueTransformer *)createDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)displayDateTimeJSONTransformer {
    return [self createDateJSONTransformer];
}

+ (NSValueTransformer *)categoriesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPCategory.class];
}

+ (NSValueTransformer *)campaignCategoriesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPCategory.class];
}

- (NSURL *)imageUrl {
    return [NSURL URLWithString:self.saleImageUrl];
}

- (NSString *)tenantName {
    return _tenant.name;
}

- (NSString *)saleSortName {
     return self.tenant.sortName ? self.tenant.sortName : @"";
}

- (NSString *)location {
    return self.tenant ? self.tenant.name : [GGPMallManager shared].selectedMall.name;
}

- (BOOL)isFavorite {
    return self.tenant.isFavorite;
}

#pragma mark UIActivityItemSource

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    return activityType == UIActivityTypeMail ? [NSString stringWithFormat:@"%@ | %@", self.title, self.tenant.name] : nil;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    [self trackSocialShareForNetwork:[GGPAnalytics socialNetworkForActivityType:activityType]];
    
    NSString *mallUrl = [GGPMallManager shared].selectedMall.websiteUrl;
    NSString *saleUrl = [NSString stringWithFormat:[@"SHARE_SALE_URL" ggp_toLocalized], mallUrl, (long)self.promotionId];
    
    if (activityType == UIActivityTypeMail) {
        NSString *body = [NSString stringWithFormat:[@"SHARE_SALE_EMAIL_BODY" ggp_toLocalized], self.tenant.name, [GGPMallManager shared].selectedMall.name, saleUrl];
        return [NSString stringWithFormat:@"%@%@", body, [@"SHARE_EMAIL_FOOTER" ggp_toLocalized]];
    } else {
        return [NSString stringWithFormat:@"%@ | %@ %@", self.title, self.tenant.name, saleUrl];
    }
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

+ (NSArray *)tenantsFromSales:(NSArray *)sales {
    NSMutableSet *tenants = [NSMutableSet new];
    for (GGPSale *sale in sales) {
        [tenants addObject:sale.tenant];
    }
    return [tenants allObjects];
}

@end
