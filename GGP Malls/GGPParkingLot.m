//
//  GGPParkingLot.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingLot.h"
#import "GGPParkingLotOccupancy.h"
#import <Mantle/MTLValueTransformer.h>

@implementation GGPParkingLot

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return  @{ @"encodedPolyLines": @"ppoly_arr",
               @"occupancies": @"occupancy",
               @"facilityId": @"f_id" };
}

+ (NSValueTransformer *)occupanciesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPParkingLotOccupancy.class];
}

- (BOOL)isValid {
    return self.occupancies.count > 0;
}

@end
