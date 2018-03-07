//
//  GGPParkingLotOccupancy.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingLotOccupancy.h"

@implementation GGPParkingLotOccupancy

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return  @{
              @"occupancyPercentage": @"occ_pct"
              };
}

@end
