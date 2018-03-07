//
//  GGPDateRange.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

@interface GGPDateRange : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic, readonly) NSInteger mallId;
@property (strong, nonatomic, readonly) NSString *code;
@property (strong, nonatomic, readonly) NSString *label;
@property (strong, nonatomic, readonly) NSString *url;
@property (strong, nonatomic, readonly) NSDate *displayDate;
@property (strong, nonatomic, readonly) NSDate *startDate;
@property (strong, nonatomic, readonly) NSDate *endDate;
@property (strong, nonatomic, readonly) NSString *type;
@property (strong, nonatomic, readonly) NSArray *categories;

// calculated
@property (strong, nonatomic, readonly) NSString *hoursUrl;

+ (GGPDateRange *)blackFridayDateRangeFromDateRanges:(NSArray *)dateRanges;
+ (GGPDateRange *)holidayHoursDateRangeFromDateRanges:(NSArray *)dateRanges;

+ (BOOL)hasHolidayHoursFromDateRanges:(NSArray *)dateRanges;
+ (BOOL)hasBlackFridayHoursFromDateRanges:(NSArray *)dateRanges;

@end
