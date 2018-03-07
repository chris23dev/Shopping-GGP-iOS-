//
//  GGPParkingGarageLevelViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPParkingLevel;
@class GGPParkingZone;

@interface GGPParkingGarageLevelViewController : UIViewController

- (instancetype)initWithLevel:(GGPParkingLevel *)level andZone:(GGPParkingZone *)zone;

@end
