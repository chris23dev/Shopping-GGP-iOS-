//
//  GGPMallConfig.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLJSONAdapter.h>
#import <Mantle/MTLModel.h>

@class GGPParkingLotThreshold;

@interface GGPMallConfig : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic, readonly) NSInteger wayfindingMinDistance;
@property (strong, nonatomic, readonly) NSArray *parkingLotThresholds;
@property (strong, nonatomic, readonly) NSDate *holidayHoursDisplayDate;
@property (strong, nonatomic, readonly) NSDate *holidayHoursStartDate;
@property (strong, nonatomic, readonly) NSDate *holidayHoursEndDate;
@property (assign, nonatomic, readonly) BOOL isParkingAvailabilityEnabled;
@property (assign, nonatomic, readonly) BOOL parkingAvailable;
@property (assign, nonatomic, readonly) BOOL productEnabled;
@property (assign, nonatomic, readonly) BOOL wayfindingEnabled;
@property (assign, nonatomic, readonly) BOOL parkAssistEnabled;

@end
