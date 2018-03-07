//
//  GGPParkingAvailabilityPopoverViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingAvailibilityPopoverDelegate.h"
#import <UIKit/UIKit.h>

@interface GGPParkingAvailabilityPopoverViewController : UIViewController

@property (weak, nonatomic) id <GGPParkingAvailibilityPopoverDelegate> popoverDelegate;

@end
