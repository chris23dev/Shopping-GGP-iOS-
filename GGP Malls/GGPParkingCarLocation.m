//
//  GGPParkingCarLocation.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingCarLocation.h"

@implementation GGPParkingCarLocation

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"zoneName": @"zone",
             @"map": @"map",
             @"uuid": @"uuid",
             @"xPosition": @"position.x",
             @"yPosition": @"position.y"
             };
}

@end
