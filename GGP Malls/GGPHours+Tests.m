//
//  GGPHours+Tests.m
//  GGP Malls
//
//  Created by Janet Lin on 3/1/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPHours+Tests.h"

@implementation GGPHours (Tests)

+ (GGPHours *)createYesterdayOperatingHours {
    NSDateComponents *dateComponent = [NSDateComponents new];
    dateComponent.day = -1;
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponent toDate:[NSDate date] options:0];
    NSString *yesterdayWeekeday = [self weekdayForDate:yesterday];
    
    id mockYesterdayHours = OCMPartialMock([GGPHours new]);
    [OCMStub([mockYesterdayHours valueForKey:@"startDay"]) andReturn:yesterdayWeekeday];
    [OCMStub([mockYesterdayHours startDay]) andReturn:yesterdayWeekeday];
    
    return mockYesterdayHours;
}

+ (GGPHours *)createTodayOperatingHours {
    NSString *todayWeekday = [self weekdayForDate:[NSDate date]];
    id mockTodayHours = OCMPartialMock([GGPHours new]);
    
    [OCMStub([mockTodayHours valueForKey:@"startDay"]) andReturn:todayWeekday];
    [OCMStub([mockTodayHours startDay]) andReturn:todayWeekday];
    
    return mockTodayHours;
}

+ (NSString *)weekdayForDate:(NSDate *)date {
    NSDateFormatter *weekdayFormatter = [NSDateFormatter new];
    [weekdayFormatter setDateFormat:@"EEE"];
    return [[weekdayFormatter stringFromDate:date] uppercaseString];
}

@end
