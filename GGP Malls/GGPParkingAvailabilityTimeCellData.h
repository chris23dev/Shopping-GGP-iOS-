//
//  GGPParkingAvailabilityTimeCellData.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/2/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCellData.h"

extern NSInteger const GGPParkingAvailabilityArrivalTimeNow;
extern NSInteger const GGPParkingAvailabilityArrivalTimeMorning;
extern NSInteger const GGPParkingAvailabilityArrivalTimeAfternoon;
extern NSInteger const GGPParkingAvailabilityArrivalTimeEvening;

@interface GGPParkingAvailabilityTimeCellData : GGPCellData

- (instancetype)initWithTitle:(NSString *)title activeImage:(UIImage *)activeImage inactiveImage:(UIImage *)inactiveImage arrivalTimeHour:(NSInteger)arrivalTimeHour andTapHandler:(void (^)())tapHandler;

@property (assign, nonatomic, readonly) NSInteger arrivalTimeHour;

@end
