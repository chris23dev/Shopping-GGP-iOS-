//
//  GGPParkingAvailabilityClient.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/30/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingAvailabilityClient.h"
#import "GGPParkingLot.h"
#import "NSString+GGPAdditions.h"

static NSString *const kPublisherIdParameter = @"pub_id";
static NSString *const kCheckParameter = @"chk";
static NSString *const kPointParameter = @"pt";
static NSString *const kDetailLevelParameter = @"det";
static NSString *const kMaxLotsParameter = @"max";
static NSString *const kBaseURL = @"http://api.parkme.com/";
static NSString *const kLotsEndpoint = @"Lots";
static NSString *const kPublisherId = @"754e2686";
static NSString *const kKey = @"068a!";
static NSString *const kParkingLotsKey = @"Facilities";
static NSInteger const kRadiusMeters = 2000;
static NSString *const kMaxLots = @"50";
static NSString *const kFullDetailsKey = @"1";
static NSString *const kDurationKey = @"duration";
static NSString *const kDefaultDuration = @"60";
static NSString *const kEntryTimeKey = @"entry_time";

@implementation GGPParkingAvailabilityClient

+ (instancetype)shared {
    static GGPParkingAvailabilityClient *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[GGPParkingAvailabilityClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });
    
    return instance;
}

- (void)retrieveParkingLotsForCoordinate:(CLLocationCoordinate2D)coordinate time:(NSString *)timeString andCompletion:(void(^)(NSArray *parkingLots))completion {
    NSString *pipedLocation = [self pipedLocationFromCoordinates:coordinate andRadius:kRadiusMeters];
    NSString *checkHash = [self checkHashFromPipedLocation:pipedLocation andKey:kKey];
    
    NSDictionary *params = @{ kPublisherIdParameter : kPublisherId,
                              kCheckParameter : checkHash,
                              kPointParameter : pipedLocation,
                              kDetailLevelParameter : kFullDetailsKey,
                              kMaxLotsParameter : kMaxLots,
                              kDurationKey: kDefaultDuration,
                              kEntryTimeKey: timeString };
    
    [self GET:kLotsEndpoint parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:NSDictionary.class]) {
            NSArray *jsonArray = responseObject[kParkingLotsKey];
            completion([MTLJSONAdapter modelsOfClass:GGPParkingLot.class fromJSONArray:jsonArray error:nil]);
        } else {
            completion(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GGPLogError(@"Error retrieving parking lot availability: %@", error.localizedDescription);
        completion(nil);
    }];
}

- (NSString *)pipedLocationFromCoordinates:(CLLocationCoordinate2D)coordinates andRadius:(NSInteger)radius {
    return [NSString stringWithFormat:@"%f|%f|%ld", coordinates.longitude, coordinates.latitude, (long)radius];
}

- (NSString *)checkHashFromPipedLocation:(NSString *)pipedLocation andKey:(NSString *)key {
    return [[NSString stringWithFormat:@"%@%@", pipedLocation, key] ggp_md5Hash];
}

@end
