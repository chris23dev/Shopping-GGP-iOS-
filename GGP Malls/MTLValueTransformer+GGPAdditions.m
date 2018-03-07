//
//  MTLValueTransformer+GGPAdditions.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "MTLValueTransformer+GGPAdditions.h"

static NSString *const kDefaultDateFormat = @"yyyy-MM-dd'T'HH:mm";

@implementation MTLValueTransformer (GGPAdditions)

#pragma mark - Date

+ (NSValueTransformer *)ggp_dateJSONTransformer {
    return [self ggp_dateJSONTransformerWithFormat:kDefaultDateFormat];
}

+ (NSValueTransformer *)ggp_dateJSONTransformerWithFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = dateFormat;
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [dateFormatter stringFromDate:date];
    }];
}

#pragma mark - String

+ (NSValueTransformer *)ggp_stringToNumberTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        return @(value.floatValue);
    } reverseBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        return value.stringValue;
    }];
}

@end
