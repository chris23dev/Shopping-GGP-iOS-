//
//  GGPEventLinks.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 2/12/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPExternalEventLink.h"
#import <Mantle/NSValueTransformer+MTLPredefinedTransformerAdditions.h>

@interface GGPExternalEventLink ()

@property (strong, nonatomic) NSURL *url;

@end

@implementation GGPExternalEventLink

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"url": @"url",
             @"displayText": @"displayText"
             };
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end


