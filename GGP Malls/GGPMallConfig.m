//
//  GGPMallConfig.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMallConfig.h"
#import "GGPParkingLotThreshold.h"
#import "MTLValueTransformer+GGPAdditions.h"

@implementation GGPMallConfig

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"isParkingAvailabilityEnabled": @"parkingAvailabilityEnabled",
              @"parkingAvailable": @"parkingAvailable",
              @"parkAssistEnabled": @"parkAssistEnabled",
              @"parkingLotThresholds": @"lotThresholds",
              @"productEnabled": @"productEnabled",
              @"wayfindingEnabled": @"wayfindingEnabled",
              @"wayfindingMinDistance": @"wayfindingMinDistance",
              @"holidayHoursDisplayDate": @"holidayHoursDisplayDate",
              @"holidayHoursStartDate": @"holidayHoursStartDate",
              @"holidayHoursEndDate": @"holidayHoursEndDate", };
}

+ (NSValueTransformer *)parkingLotThresholdsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPParkingLotThreshold.class];
}

+ (NSValueTransformer *)holidayHoursDisplayDateJSONTransformer {
    return [MTLValueTransformer ggp_dateJSONTransformer];
}

+ (NSValueTransformer *)holidayHoursStartDateJSONTransformer {
    return [MTLValueTransformer ggp_dateJSONTransformer];
}

+ (NSValueTransformer *)holidayHoursEndDateJSONTransformer {
    return [MTLValueTransformer ggp_dateJSONTransformer];
}

@end
