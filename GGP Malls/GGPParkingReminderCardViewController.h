//
//  GGPParkingReminderCardViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/17/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPParkingReminderCardDelegate.h"

@interface GGPParkingReminderCardViewController : UIViewController

@property (strong, nonatomic) NSString *noteText;
@property (weak, nonatomic) id<GGPParkingReminderCardDelegate> cardDelegate;

- (void)configureForDefaultState;
- (void)configureForLocationSaved;
- (void)configureForExistingLocationWithNote:(NSString *)note;

@end
