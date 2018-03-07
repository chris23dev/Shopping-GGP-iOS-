//
//  GGPParkingAvailabilityTimeCellData.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/2/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingAvailabilityTimeCellData.h"

NSInteger const GGPParkingAvailabilityArrivalTimeNow = 0;
NSInteger const GGPParkingAvailabilityArrivalTimeMorning = 10;
NSInteger const GGPParkingAvailabilityArrivalTimeAfternoon = 14;
NSInteger const GGPParkingAvailabilityArrivalTimeEvening = 18;

@interface GGPParkingAvailabilityTimeCellData ()

@property (assign, nonatomic) NSInteger arrivalTimeHour;

@end

@implementation GGPParkingAvailabilityTimeCellData

- (instancetype)initWithTitle:(NSString *)title activeImage:(UIImage *)activeImage inactiveImage:(UIImage *)inactiveImage arrivalTimeHour:(NSInteger)arrivalTimeHour andTapHandler:(void (^)())tapHandler {
    self = [super initWithTitle:title
                    activeImage:activeImage
                  inactiveImage:inactiveImage
                  andTapHandler:tapHandler];
    if (self) {
        self.arrivalTimeHour = arrivalTimeHour;
    }
    return self;
}

@end
