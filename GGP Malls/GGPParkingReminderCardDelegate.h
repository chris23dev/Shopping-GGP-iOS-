//
//  GGPParkingReminderCardDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/17/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GGPParkingReminderCardDelegate <NSObject>

- (void)clearReminderTapped;
- (void)placePinTapped;

@end
