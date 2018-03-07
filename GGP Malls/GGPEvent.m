//
//  GGPEvent.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPEvent.h"
#import "GGPExternalEventLink.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMappings.h"
#import "GGPTenant.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import <Mantle/MTLValueTransformer.h>

@interface GGPEvent ()

@property (strong, nonatomic, readonly) NSArray *mappingsArray;

@end

@implementation GGPEvent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             // Event mappings
             @"eventId": @"id",
             @"mappingsArray": @"mappings",
             @"eventImageUrl" : @"imageUrl",
             @"location": @"location",
             @"teaserDescription": @"teaserDescription",
             @"eventDescription": @"description",
             @"isFeatured": @"isFeatured",
             @"externalLinks": @"externalLinks",
             
             // Promotion mappings
             @"promotionId": @"id",
             @"title" : @"name",
             @"startDateTime": @"startDateTime",
             @"endDateTime": @"endDateTime",
             };
}

+ (NSValueTransformer *)externalLinksJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPExternalEventLink.class];
}

+ (NSValueTransformer *)mappingsArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPMappings.class];
}

- (GGPMappings *)mappings {
    return self.mappingsArray[0];
}

- (NSInteger)mallId {
    return self.mappings.mallId;
}

- (NSInteger)tenantId {
    return [self.mappings.tenantIds.firstObject integerValue];
}

- (NSURL *)imageUrl {
    NSString *urlString = nil;
    
    if (self.eventImageUrl.length) {
        urlString = self.eventImageUrl;
    } else if (self.tenant.nonSvgLogoUrl.length) {
        urlString = self.tenant.nonSvgLogoUrl;
    }
    
    return [NSURL URLWithString:urlString];
}

#pragma mark UIActivityItemSource

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    return activityType == UIActivityTypeMail ? [NSString stringWithFormat:@"%@ | %@", self.title, self.location] : nil;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    [self trackSocialShareForNetwork:[GGPAnalytics socialNetworkForActivityType:activityType]];
    
    NSString *mallUrl = [GGPMallManager shared].selectedMall.websiteUrl;
    NSString *eventUrl = [NSString stringWithFormat:[@"SHARE_EVENT_URL" ggp_toLocalized], mallUrl, (long)self.promotionId];
    
    if (activityType == UIActivityTypeMail) {
        NSString *body = [NSString stringWithFormat:[@"SHARE_EVENT_EMAIL_BODY" ggp_toLocalized], self.location, [GGPMallManager shared].selectedMall.name, eventUrl];
        return [NSString stringWithFormat:@"%@%@", body, [@"SHARE_EMAIL_FOOTER" ggp_toLocalized]];
    } else {
        return [NSString stringWithFormat:@"%@ | %@ %@", self.title, self.location, eventUrl];
    }
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

@end
