//
//  GGPParkingLot.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@class JMapWaypoint;

@interface GGPParkingLot : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSArray *encodedPolyLines;
@property (strong, nonatomic) NSArray *occupancies;
@property (assign, nonatomic) NSInteger facilityId;
@property (assign, nonatomic, readonly) BOOL isValid;

@property (strong, nonatomic) NSArray *waypoints;

@end
