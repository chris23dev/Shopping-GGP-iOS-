//
//  GGPParkingGarageViewController.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPParkingSite.h"
#import "GGPParkingGarage.h"

@interface GGPParkingGarageViewController : UIViewController

- (instancetype)initWithGarage:(GGPParkingGarage *)garage levels:(NSArray *)levels andZones:(NSArray *)zones;

@end
