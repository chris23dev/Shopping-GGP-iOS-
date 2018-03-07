//
//  GGPAlert.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAlert.h"
#import "MTLValueTransformer+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"

@implementation GGPAlert

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return  @{
              @"alertId": @"id",
              @"effectiveStartDateTime": @"effectiveStartDateTime",
              @"effectiveEndDateTime": @"effectiveEndDateTime",
              @"message": @"message"
              };
}

+ (NSValueTransformer *)effectiveStartDateTimeJSONTransformer {
    return [MTLValueTransformer ggp_dateJSONTransformer];
}

+ (NSValueTransformer *)effectiveEndDateTimeJSONTransformer {
    return [MTLValueTransformer ggp_dateJSONTransformer];
}

- (BOOL)isValidStartDate {
    return [self.effectiveStartDateTime ggp_isOnOrBeforeDate:[NSDate new]];
}

@end
