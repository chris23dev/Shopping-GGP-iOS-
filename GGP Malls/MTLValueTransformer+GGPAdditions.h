//
//  MTLValueTransformer+GGPAdditions.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MTLValueTransformer (GGPAdditions)

+ (NSValueTransformer *)ggp_stringToNumberTransformer;
+ (NSValueTransformer *)ggp_dateJSONTransformer;
+ (NSValueTransformer *)ggp_dateJSONTransformerWithFormat:(NSString *)dateFormat;

@end
