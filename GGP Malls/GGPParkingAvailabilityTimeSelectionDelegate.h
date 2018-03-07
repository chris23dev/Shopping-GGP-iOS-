//
//  GGPParkingAvailabilityTimeSelectionDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

@protocol GGPParkingAvailabilityTimeSelectionDelegate <NSObject>

- (void)didSelectTime:(NSString *)time withArrivalTimeHour:(NSInteger)arrivalTime;

@end
