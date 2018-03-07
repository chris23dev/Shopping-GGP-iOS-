//
//  GGPCarMapViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/24/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPParkingCarLocation;
@class GGPParkingSite;

@interface GGPCarMapViewController : UIViewController

- (instancetype)initWithCarLocation:(GGPParkingCarLocation *)carLocation andSite:(GGPParkingSite *)site;

@end
