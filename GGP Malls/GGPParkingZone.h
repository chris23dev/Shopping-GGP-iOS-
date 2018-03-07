//
//  GGPParkingZone.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GGPParkingZone : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *zoneName;
@property (assign, nonatomic) NSInteger availableSpots;
@property (assign, nonatomic) NSInteger occupiedSpots;

@end
