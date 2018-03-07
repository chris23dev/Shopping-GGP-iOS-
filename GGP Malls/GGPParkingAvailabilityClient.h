//
//  GGPParkingAvailabilityClient.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/30/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>

@interface GGPParkingAvailabilityClient : AFHTTPSessionManager

+ (instancetype)shared;

- (void)retrieveParkingLotsForCoordinate:(CLLocationCoordinate2D)coordinate time:(NSString *)timeString andCompletion:(void(^)(NSArray *parkingLots))completion;

@end
