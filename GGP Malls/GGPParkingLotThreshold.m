//
//  GGPParkingLotThreshold.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingLotThreshold.h"

@implementation GGPParkingLotThreshold

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"minPercentage": @"min",
              @"maxPercentage": @"max",
              @"alphaPercentage": @"alpha",
              @"colorHex": @"colorHex" };
}

@end
