//
//  GGPMallResponse.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/9/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPMallResponse.h"
#import "GGPMall.h"

@implementation GGPMallResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"malls": @"content" };
}

+ (NSValueTransformer *)mallsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPMall.class];
}

@end
