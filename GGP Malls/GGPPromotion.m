//
//  GGPPromotion.m
//  GGP Malls
//
//  Created by Janet Lin on 2/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPPromotion.h"
#import "GGPTenant.h"
#import "NSString+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"

@implementation GGPPromotion

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    @throw [self createImplementationException: NSStringFromSelector(_cmd)];
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

+ (NSValueTransformer *)startDateTimeJSONTransformer {
    return [self createDateJSONTransformer];
}

+ (NSValueTransformer *)endDateTimeJSONTransformer {
    return [self createDateJSONTransformer];
}

- (NSString *)promotionDates {
    return [NSDate ggp_prettyPrintStartDate:self.startDateTime andEndDate:self.endDateTime];
}

+ (NSValueTransformer *)tenantJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:GGPTenant.class];
}

- (NSURL *)imageUrl {
    @throw [GGPPromotion createImplementationException: NSStringFromSelector(_cmd)];
}

+ (NSException *)createImplementationException:(NSString *)selector {
     GGPMustOverride;
}

- (void)trackSocialShareForNetwork:(NSString *)network {
    if (network.length) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary: @{
                               GGPAnalyticsContextDataEventSaleName: self.title,
                               GGPAnalyticsContextDataSocialNetwork: network
                               }];
        
        if (self.tenant) {
            [data setValue:self.tenant.name forKey:GGPAnalyticsContextDataTenantName];
        }
        
        [[GGPAnalytics shared] trackAction:GGPAnalyticsActionSocialShare withData:data];
    }
}

- (BOOL)isForFavorite {
    return self.tenant && self.tenant.isFavorite;
}

@end
