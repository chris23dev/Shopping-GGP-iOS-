//
//  GGPParkingLevel.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GGPParkingLevel : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic) NSInteger levelId;
@property (assign, nonatomic) NSInteger garageId;
@property (strong, nonatomic) NSString *levelName;
@property (strong, nonatomic) NSString *zoneName;
@property (strong, nonatomic) NSString *levelDescription;
@property (assign, nonatomic) NSInteger sort;

@end
