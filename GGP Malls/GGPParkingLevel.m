//
//  GGPParkingLevel.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingLevel.h"

@implementation GGPParkingLevel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"levelId": @"levelId",
             @"garageId": @"garageId",
             @"levelName": @"name",
             @"zoneName": @"zone",
             @"levelDescription": @"description",
             @"sort": @"sort"
             };
}

@end
