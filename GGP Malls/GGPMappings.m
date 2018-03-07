//
//  GGPMappings.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMappings.h"

@implementation GGPMappings

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mallId": @"mallId",
             @"tenantIds": @"storeIds"
             };
}

@end
