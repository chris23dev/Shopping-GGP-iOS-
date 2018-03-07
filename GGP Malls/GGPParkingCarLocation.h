//
//  GGPParkingCarLocation.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface GGPParkingCarLocation : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *zoneName;
@property (strong, nonatomic) NSString *map;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSNumber *xPosition;
@property (strong, nonatomic) NSNumber *yPosition;

@end
