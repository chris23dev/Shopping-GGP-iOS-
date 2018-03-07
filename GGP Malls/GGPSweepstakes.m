//
//  GGPSweepstakes.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/12/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPSweepstakes.h"
#import "MTLValueTransformer+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"

static NSString *const kDateFormat = @"yyyy-MM-dd";

@implementation GGPSweepstakes

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title": @"title",
             @"sweepstakesDescription" : @"description",
             @"imageUrl": @"imageUrl",
             @"startDate": @"startDate",
             @"endDate": @"endDate"
             };
}

+ (NSValueTransformer *)startDateJSONTransformer {
    return [MTLValueTransformer ggp_dateJSONTransformerWithFormat:kDateFormat];
}

+ (NSValueTransformer *)endDateJSONTransformer {
    return [MTLValueTransformer ggp_dateJSONTransformerWithFormat:kDateFormat];
}

- (BOOL)isValid {
    return [[NSDate date] ggp_isBetweenStartDate:self.startDate andEndDate:self.endDate withGranularity:NSCalendarUnitDay];
}

@end
