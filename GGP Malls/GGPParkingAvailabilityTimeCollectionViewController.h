//
//  GGPParkingAvailabilityTimeCollectionViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingAvailabilityTimeSelectionDelegate.h"
#import <UIKit/UIKit.h>

@interface GGPParkingAvailabilityTimeCollectionViewController : UICollectionViewController

@property (weak, nonatomic) id <GGPParkingAvailabilityTimeSelectionDelegate> timeDelegate;
- (void)configureWithSelectedDate:(NSDate *)selectedDate;

@end
