//
//  GGPParkingSite.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "GGPParkingLevel.h"
#import "GGPParkingGarage.h"
#import "GGPParkingZone.h"

@interface GGPParkingSite : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *siteName;
@property (strong, nonatomic) NSString *secret;
@property (strong, nonatomic) NSArray *garages;
@property (strong, nonatomic) NSArray *levels;

+ (GGPParkingLevel *)levelForZoneName:(NSString *)zoneName fromLevels:(NSArray *)levels;
+ (NSArray *)levelsForGarageId:(NSInteger)garageId fromLevels:(NSArray *)levels;
+ (GGPParkingGarage *)garageForGarageId:(NSInteger)garageId fromGarages:(NSArray *)garages;
+ (GGPParkingZone *)zoneForZoneName:(NSString *)zoneName fromZones:(NSArray *)zones;

@end
