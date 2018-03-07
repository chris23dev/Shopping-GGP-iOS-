//
//  NSURL+GGPAdditions.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "NSURL+GGPAdditions.h"

@implementation NSURL (GGPAdditions)

+ (NSURL *)ggp_urlWithString:(NSString *)requestString andParameters:(NSDictionary *)parameters {
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in [parameters.allKeys sortedArrayUsingSelector: @selector(compare:)]) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:parameters[key]]];
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithString:requestString];
    components.queryItems = queryItems;
    
    return components.URL;
}

@end
