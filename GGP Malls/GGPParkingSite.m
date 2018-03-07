//
//  GGPParkingSite.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingSite.h"
#import "NSArray+GGPAdditions.h"

@implementation GGPParkingSite

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"secret": @"key",
             @"siteName": @"site",
             @"garages": @"garages",
             @"levels": @"levels"
             };
}

+ (NSValueTransformer *)garagesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPParkingGarage.class];
}

+ (NSValueTransformer *)levelsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GGPParkingLevel.class];
}

+ (GGPParkingLevel *)levelForZoneName:(NSString *)zoneName fromLevels:(NSArray *)levels {
    return [levels ggp_firstWithFilter:^BOOL(GGPParkingLevel *level) {
        return [level.zoneName isEqualToString:zoneName];
    }];
}

+ (NSArray *)levelsForGarageId:(NSInteger)garageId fromLevels:(NSArray *)levels {
    return [levels ggp_arrayWithFilter:^BOOL(GGPParkingLevel *level) {
        return level.garageId == garageId;
    }];
}

+ (GGPParkingGarage *)garageForGarageId:(NSInteger)garageId fromGarages:(NSArray *)garages {
    return [garages ggp_firstWithFilter:^BOOL(GGPParkingGarage *garage) {
        return garage.garageId == garageId;
    }];
}

+ (GGPParkingZone *)zoneForZoneName:(NSString *)zoneName fromZones:(NSArray *)zones {
    return [zones ggp_firstWithFilter:^BOOL(GGPParkingZone *zone) {
        return [zone.zoneName isEqualToString:zoneName];
    }];
}

@end
