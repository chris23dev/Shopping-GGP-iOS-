//
//  GGPParkingLotOccupancy.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GGPParkingLotOccupancy : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic) NSInteger occupancyPercentage;

@end
