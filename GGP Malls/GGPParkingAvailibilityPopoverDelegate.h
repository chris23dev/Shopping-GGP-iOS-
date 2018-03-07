//
//  GGPParkingAvailibilityPopoverDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GGPParkingAvailibilityPopoverDelegate <NSObject>

- (void)didUpdateDate:(NSDate *)date withTime:(NSString *)timeString andArrivalTimeHour:(NSInteger)arrivalTime;
- (void)didTapDoneButtonWithArrivalString:(NSString *)arrivalString;

@end
