//
//  GGPDateRanges.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCategory.h"
#import "GGPDateRange.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "NSArray+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"
#import "MTLValueTransformer+GGPAdditions.h"

static NSString *const kDateFormat = @"yyyy-MM-dd";
static NSString *const kBlackFridayCode = @"BLACK_FRIDAY_HOURS";
static NSString *const kHolidayHoursCode = @"HOLIDAY_HOURS";

@implementation GGPDateRange

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"mallId": @"mallId",
              @"code" : @"code",
              @"label": @"label",
              @"displayDate": @"displayDate",
              @"startDate": @"startDate",
              @"endDate": @"endDate",
              @"type": @"type",
              @"url": @"url",
              @"categories": @"categories", };
}

+ (NSValueTransformer *)displayDateJSONTransformer {
    return [MTLValueTransformer ggp_dateJSONTransformerWithFormat:kDateFormat];
}

+ (NSValueTransformer *)startDateJSONTransformer {
    return [MTLValueTransformer ggp_dateJSONTransformerWithFormat:kDateFormat];
}

+ (NSValueTransformer *)endDateJSONTransformer {
    return [MTLValueTransformer ggp_dateJSONTransformerWithFormat:kDateFormat];
}

+ (NSValueTransformer *)categoriesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPCategory.class];
}

- (NSString *)hoursUrl {
    GGPMall *selectedMall = [GGPMallManager shared].selectedMall;
    return [NSString stringWithFormat:@"%@/%@", selectedMall.websiteUrl, self.url];
}

+ (GGPDateRange *)dateRangeWithCode:(NSString *)code fromDateRanges:(NSArray *)dateRanges {
    return [dateRanges ggp_firstWithFilter:^BOOL(GGPDateRange *dateRange) {
        return [dateRange.code isEqualToString:code];
    }];
}

#pragma mark - Black Friday

+ (GGPDateRange *)blackFridayDateRangeFromDateRanges:(NSArray *)dateRanges {
    return [self dateRangeWithCode:kBlackFridayCode fromDateRanges:dateRanges];
}

+ (BOOL)hasBlackFridayHoursFromDateRanges:(NSArray *)dateRanges {
    GGPDateRange *blackFridayDateRange = [self blackFridayDateRangeFromDateRanges:dateRanges];
    
    if (!blackFridayDateRange) {
        return NO;
    }
    
    NSDate *today = [NSDate new];
    return [today ggp_isBetweenStartDate:blackFridayDateRange.displayDate
                              andEndDate:blackFridayDateRange.endDate
                         withGranularity:NSCalendarUnitDay];
}

#pragma mark - Holiday Hours

+ (GGPDateRange *)holidayHoursDateRangeFromDateRanges:(NSArray *)dateRanges {
    return [self dateRangeWithCode:kHolidayHoursCode fromDateRanges:dateRanges];
}

+ (BOOL)hasHolidayHoursFromDateRanges:(NSArray *)dateRanges {
    GGPDateRange *holidayDateRange = [self holidayHoursDateRangeFromDateRanges:dateRanges];
    
    if (!holidayDateRange) {
        return NO;
    }
    
    NSDate *today = [NSDate new];
    return [today ggp_isBetweenStartDate:holidayDateRange.displayDate
                              andEndDate:[NSDate ggp_subtractDays:7 fromDate:holidayDateRange.endDate]
                         withGranularity:NSCalendarUnitDay];
}

@end
