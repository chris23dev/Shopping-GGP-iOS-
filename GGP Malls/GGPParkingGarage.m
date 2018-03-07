//
//  GGPParkingGarage.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingGarage.h"

@implementation GGPParkingGarage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"garageId": @"garageId",
             @"garageName": @"name",
             @"garageDescription": @"description",
             @"latitude": @"latitude",
             @"longitude": @"longitude",
             };
}

@end
