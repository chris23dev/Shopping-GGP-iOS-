//
//  GGPShowtime.m
//  GGP Malls
//
//  Created by Janet Lin on 12/10/15.
//  Copyright (c) 2015 GGP. All rights reserved.
//

#import "GGPShowtime.h"
#import "NSString+GGPAdditions.h"
#import <Mantle/MTLValueTransformer.h>

static NSString *const kFandangoDateFormat = @"yyyy-MM-dd+HH:mm";

@interface GGPShowtime()
@property (strong, nonatomic) NSDate *movieShowtimeDate;
@end

@implementation GGPShowtime

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"movieShowtimeDate": @"movieShowtime"
             };
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat  = @"yyyy-MM-dd'T'HH:mm";
    return dateFormatter;
}

+ (NSValueTransformer *)movieShowtimeDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

- (BOOL)isScheduledForDate:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    NSDate *requestDate = [cal dateFromComponents:components];
    components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.movieShowtimeDate];
    NSDate *showtimeDate = [cal dateFromComponents:components];
    
     return [requestDate isEqualToDate:showtimeDate];
}

- (NSString *)movieShowtime {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = kCFDateFormatterNoStyle;
    dateFormatter.timeStyle = kCFDateFormatterShortStyle;
    return [dateFormatter stringFromDate:self.movieShowtimeDate];
}

- (NSString *)determineFandangoUrlForFandangoId:(NSInteger)fandangoId andTmsId:(NSString *)tmsId {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat  = kFandangoDateFormat;
    return [NSString stringWithFormat:[@"MOVIES_ORDER_TICKETS_FANDANGO_WEB" ggp_toLocalized], (long)fandangoId, tmsId, [dateFormatter stringFromDate:self.movieShowtimeDate]];
}

@end
