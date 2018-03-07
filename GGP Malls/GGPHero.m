//
//  GGPHero.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPHero.h"
#import "MTLValueTransformer+GGPAdditions.h"

@implementation GGPHero

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"title": @"title",
              @"heroDescription" : @"description",
              @"imageUrl": @"imageUrl",
              @"startDate": @"startDate",
              @"endDate": @"endDate",
              @"url": @"url",
              @"urlText": @"urlText", };
}

+ (NSValueTransformer *)startDateJSONTransformer {
    return [MTLValueTransformer ggp_dateJSONTransformer];
}

+ (NSValueTransformer *)endDateJSONTransformer {
    return [MTLValueTransformer ggp_dateJSONTransformer];
}

@end
