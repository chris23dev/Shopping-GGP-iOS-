//
//  GGPParkingGarage.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GGPParkingGarage : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic) NSInteger garageId;
@property (strong, nonatomic) NSString *garageName;
@property (strong, nonatomic) NSString *garageDescription;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

@end
