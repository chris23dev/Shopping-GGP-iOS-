//
//  GGPParkingZone.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingZone.h"

@implementation GGPParkingZone

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"zoneName": @"name",
             @"availableSpots": @"counts.available",
             @"occupiedSpots": @"counts.occupied"
             };
}

@end
