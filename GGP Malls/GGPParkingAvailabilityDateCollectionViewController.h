//
//  GGPParkingAvailabilityDateCollectionViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPParkingAvailabilityDateSelectionDelegate.h"

@interface GGPParkingAvailabilityDateCollectionViewController : UICollectionViewController

@property (weak, nonatomic) id <GGPParkingAvailabilityDateSelectionDelegate> dateDelegate;

@end
