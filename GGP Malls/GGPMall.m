//
//  GGPMall.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/9/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPAddress.h"
#import "GGPHours.h"
#import "GGPMall.h"
#import "GGPMallConfig.h"
#import "GGPSocialMedia.h"
#import "NSArray+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "MTLValueTransformer+GGPAdditions.h"
#import "GGPExceptionHours.h"

static NSString *const kLegacyStatus = @"LEGACY_PLATFORM";
static NSString *const kDispositioningStatus = @"DISPOSITIONING";
static NSString *const kDispositionedStatus = @"DISPOSITIONED";

static NSInteger const kFashionShowMallId = 1091;
static NSInteger const kPrinceKuhioPlazaMallId = 1115;
static NSInteger const kGrandCanalMallId = 1077;

NSString *const GGPSelectedMallIsInactiveNotification = @"GGPSelectedMallIsInactiveNotification";

@interface GGPMall ()

@property (assign, nonatomic) NSInteger mallId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) GGPSocialMedia *socialMedia;
@property (assign, nonatomic) BOOL hasTheater;

@end

@implementation GGPMall

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"mallId": @"id",
              @"name": @"name",
              @"address": @"address",
              @"config": @"config",
              @"phoneNumber": @"phoneNumber",
              @"logoUrl": @"logoUrl",
              @"nonSvgLogoUrl": @"nonSvgLogoUrl",
              @"inverseNonSvgLogoUrl": @"inverseNonSvgLogoUrl",
              @"websiteUrl": @"websiteUrl",
              @"latitude": @"latitude",
              @"longitude": @"longitude",
              @"parkingDescription": @"parkingDescription",
              @"distance": @"distanceFromSearchLocation",
              @"operatingHours": @"operatingHours",
              @"exceptionHours": @"operatingHoursExceptions",
              @"socialMedia" :@"socialMedia",
              @"hasTheater" :@"hasTheater",
              @"status": @"status",
              @"timeZone": @"timeZone", };
}

+ (NSValueTransformer *)socialMediaJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:GGPSocialMedia.class];
}

+ (NSValueTransformer *)addressJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:GGPAddress.class];
}

+ (NSValueTransformer *)configJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:GGPMallConfig.class];
}

+ (NSValueTransformer *)exceptionHoursJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPExceptionHours.class];
}

+ (NSValueTransformer *)operatingHoursJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPHours.class];
}

+ (NSValueTransformer *)latitudeJSONTransformer {
    return [MTLValueTransformer ggp_stringToNumberTransformer];
}

+ (NSValueTransformer *)longitudeJSONTransformer {
    return [MTLValueTransformer ggp_stringToNumberTransformer];
}

- (NSArray *)todaysHours {
    NSDate *today = [NSDate new];
    NSString *currentWeekday = [today ggp_shortDayStringFromDate];
    
    for (GGPExceptionHours *exceptionHours in self.exceptionHours) {
        if ([exceptionHours isValidForDate:today]) {
            return exceptionHours.isOpen ? @[exceptionHours] : nil;
        }
    }
    
    NSArray *todaysHours = [self.operatingHours ggp_arrayWithFilter:^BOOL(GGPHours *hours) {
        return [hours.startDay isEqualToString:currentWeekday];
    }];
    GGPHours *firstHourItem = todaysHours.firstObject;
    return firstHourItem.isOpen ? todaysHours : nil;
}

- (NSString *)formattedOpenHoursString {
    NSString *formattedOpenHoursString = @"";

    for (GGPHours *hour in self.todaysHours) {
        formattedOpenHoursString = [formattedOpenHoursString stringByAppendingString:[NSString stringWithFormat:@"%@\n", [hour prettyPrintOpenHoursRange]]];
    }
    
    return [formattedOpenHoursString ggp_removeTrailingNewLine];
}

- (NSString *)formattedTodaysHoursString {
    if (self.isOpenNow) {
        return [NSString stringWithFormat:@"%@: %@", [@"MORE_WERE_OPEN" ggp_toLocalized], self.formattedOpenHoursString];
    } else if (self.isOpenToday) {
        return [NSString stringWithFormat:@"%@: %@", [@"MORE_TODAYS_HOURS" ggp_toLocalized], self.formattedOpenHoursString];
    } else {
        return [@"MORE_CLOSED" ggp_toLocalized];
    }
}

- (UIImage *)loadingImage {
    if (self.mallId == kPrinceKuhioPlazaMallId) {
        return [UIImage imageNamed:@"ggp_loadscreen_prince_kuhio"];
    } else if (self.mallId == kFashionShowMallId) {
        return [UIImage imageNamed:@"ggp_loadscreen_fashion_show"];
    } else if (self.mallId == kGrandCanalMallId) {
        return [UIImage imageNamed:@"ggp_loadscreen_grand_canal"];
    } else {
        return [UIImage imageNamed:@"ggp_onboarding_background"];
    }
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:GGPMall.class]) {
        return NO;
    }
    
    return self.mallId == ((GGPMall *)object).mallId;
}

- (BOOL)isOpenToday {
    return self.todaysHours.count > 0;
}

- (BOOL)isOpenNow {
    return [self isOpenOnDate:[NSDate date]];
}

- (BOOL)isOpenOnDate:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    for (GGPHours *hour in self.todaysHours) {
        [dateComponents setMinute:[[hour.openTime substringFromIndex:3] integerValue]];
        [dateComponents setHour:[[hour.openTime substringToIndex:2] integerValue]];
        NSDate *openDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
        
        [dateComponents setMinute:[[hour.closeTime substringFromIndex:3] integerValue]];
        [dateComponents setHour:[[hour.closeTime substringToIndex:2] integerValue]];
        NSDate *closeDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
        
        if ([date ggp_isBetweenStartDate:openDate andEndDate:closeDate withGranularity:NSCalendarUnitMinute]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isLegacy {
    return [self.status isEqualToString:kLegacyStatus];
}

- (BOOL)isDispositioning {
    return [self.status isEqualToString:kDispositioningStatus];
}

- (BOOL)isDispositioned {
    return [self.status isEqualToString:kDispositionedStatus];
}

- (BOOL)isInactive {
    return self.isDispositioned || self.isDispositioning;
}

- (BOOL)hasWayFinding {
    return self.config.wayfindingEnabled;
}

- (CLLocationCoordinate2D)coordinates {
    BOOL hasCoodinates = self.latitude && self.longitude;
    return hasCoodinates ? CLLocationCoordinate2DMake(self.latitude.floatValue, self.longitude.floatValue) : kCLLocationCoordinate2DInvalid;
}

- (NSString *)cityStateAddress {
    return [NSString stringWithFormat:@"%@, %@", self.address.city, self.address.state];
}

- (NSString *)distanceString {
    return self.distance.floatValue == 1.0 ? @"1 mile" : [NSString stringWithFormat:@"%.1f miles", self.distance.floatValue];
}

- (NSDictionary *)openHoursDictionaryForDates:(NSArray *)dateRange {
    NSMutableDictionary *hoursDictionary = [NSMutableDictionary new];
    
    for (NSDate *date in dateRange) {
        NSArray *hours = [GGPHours openHoursForDate:date
                                              hours:self.operatingHours
                                  andExceptionHours:self.exceptionHours];
        
        [hoursDictionary setObject:hours forKey:date];
    }
    
    return hoursDictionary;
}

@end
