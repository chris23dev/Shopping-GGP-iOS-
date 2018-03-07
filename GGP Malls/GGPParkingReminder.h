//
//  GGPParkingReminder.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Mantle/MTLModel.h>

extern NSString *const GGPParkingReminderUpdatedNotification;
extern NSString *const GGPParkingReminderNotificationHasSavedReminderKey;

@interface GGPParkingReminder : MTLModel

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *note;
@property (assign, nonatomic, readonly) BOOL isValid;

- (instancetype)initWithLocation:(CLLocation *)location andNote:(NSString *)note;

- (void)saveToUserDefaults;

+ (void)clearSavedReminder;

+ (GGPParkingReminder *)retrieveSavedReminder;

@end
