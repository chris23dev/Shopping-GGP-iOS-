//
//  GGPMall.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/9/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPMallConfig.h"
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <Mantle/MTLJSONAdapter.h>
#import <Mantle/MTLModel.h>

@class GGPHours;
@class GGPAddress;
@class GGPSocialMedia;

extern NSString *const GGPSelectedMallIsInactiveNotification;

@interface GGPMall : MTLModel <MTLJSONSerializing>

// Mapped properties
@property (assign, nonatomic, readonly) NSInteger mallId;
@property (strong, nonatomic, readonly) GGPAddress *address;
@property (strong, nonatomic, readonly) GGPMallConfig *config;
@property (strong, nonatomic, readonly) GGPSocialMedia *socialMedia;
@property (strong, nonatomic, readonly) NSArray *exceptionHours;
@property (strong, nonatomic, readonly) NSArray *operatingHours;
@property (strong, nonatomic, readonly) NSNumber *distance;
@property (strong, nonatomic, readonly) NSNumber *latitude;
@property (strong, nonatomic, readonly) NSNumber *longitude;
@property (strong, nonatomic, readonly) NSString *inverseNonSvgLogoUrl;
@property (strong, nonatomic, readonly) NSString *logoUrl;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *nonSvgLogoUrl;
@property (strong, nonatomic, readonly) NSString *parkingDescription;
@property (strong, nonatomic, readonly) NSString *phoneNumber;
@property (strong, nonatomic, readonly) NSString *status;
@property (strong, nonatomic, readonly) NSString *timeZone;
@property (strong, nonatomic, readonly) NSString *websiteUrl;
@property (assign, nonatomic, readonly) BOOL hasTheater;

// Calculated properties
@property (assign, nonatomic, readonly) CLLocationCoordinate2D coordinates;
@property (strong, nonatomic, readonly) NSArray *todaysHours;
@property (strong, nonatomic, readonly) NSString *formattedTodaysHoursString;
@property (strong, nonatomic, readonly) UIImage *loadingImage;
@property (strong, nonatomic, readonly) NSString *cityStateAddress;
@property (strong, nonatomic, readonly) NSString *distanceString;
@property (assign, nonatomic, readonly) BOOL isDispositioned;
@property (assign, nonatomic, readonly) BOOL isDispositioning;
@property (assign, nonatomic, readonly) BOOL isInactive;
@property (assign, nonatomic, readonly) BOOL isLegacy;
@property (assign, nonatomic, readonly) BOOL isOpenNow;
@property (assign, nonatomic, readonly) BOOL isOpenToday;
@property (assign, nonatomic, readonly) BOOL hasWayFinding;

- (NSDictionary *)openHoursDictionaryForDates:(NSArray *)dateRange;

@end
