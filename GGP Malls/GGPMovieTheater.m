//
//  GGPMovieTheater.m
//  GGP Malls
//
//  Created by Janet Lin on 12/11/15.
//  Copyright (c) 2015 GGP. All rights reserved.
//

#import "GGPMovie.h"
#import "GGPMovieTheater.h"
#import "NSArray+GGPAdditions.h"

@interface GGPMovieTheater()

@property (strong, nonatomic) NSArray *movies;

@end

@implementation GGPMovieTheater

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dictionary = @{ @"theatreId": @"id",
                                  @"movies": @"movies",
                                  @"tmsId": @"tmsId" };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:dictionary];
}

+ (NSValueTransformer *)moviesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPMovie.class];
}

@end
