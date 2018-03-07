//
//  GGPSocialMedia.m
//  GGP Malls
//
//  Created by Janet Lin on 1/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPSocialMedia.h"
#import <Mantle/NSValueTransformer+MTLPredefinedTransformerAdditions.h>

@interface GGPSocialMedia ()

@property (strong, nonatomic) NSURL *facebookUrl;
@property (strong, nonatomic) NSURL *instagramUrl;
@property (strong, nonatomic) NSURL *pinterestUrl;
@property (strong, nonatomic) NSURL *twitterUrl;

@end

@implementation GGPSocialMedia

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return  @{
              @"facebookUrl": @"facebookUrl",
              @"instagramUrl": @"instagramUrl",
              @"pinterestUrl": @"pinterestUrl",
              @"twitterUrl": @"twitterUrl"
              };
}

+ (NSValueTransformer *)facebookUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)instagramUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)pinterestUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)twitterUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
