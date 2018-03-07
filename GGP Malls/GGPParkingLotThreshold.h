//
//  GGPParkingLotThreshold.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface GGPParkingLotThreshold : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic) NSInteger minPercentage;
@property (assign, nonatomic) NSInteger maxPercentage;
@property (assign, nonatomic) NSInteger alphaPercentage;
@property (strong, nonatomic) NSString *colorHex;

@end
