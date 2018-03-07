//
//  GGPParkingReminder.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingReminder.h"

NSString *const GGPParkingReminderUpdatedNotification = @"GGPParkingReminderUpdatedNotification";
NSString *const GGPParkingReminderNotificationHasSavedReminderKey = @"hasSavedReminder";

static NSString *const kParkingReminderKey = @"parkingReminder";
static NSTimeInterval const kValidTimeLength = 60 * 60 * 48; //48 hours

@interface GGPParkingReminder ()

@property (strong, nonatomic) NSDate *createdDate;

@end

@implementation GGPParkingReminder

- (instancetype)initWithLocation:(CLLocation *)location andNote:(NSString *)note {
    self = [super init];
    if (self) {
        self.location = location;
        self.note = note;
    }
    return self;
}

- (BOOL)isValid {
    NSTimeInterval timeSinceCreation = [[NSDate date] timeIntervalSinceDate:self.createdDate];
    return timeSinceCreation < kValidTimeLength && self.location;
}

- (void)saveToUserDefaults {
    self.createdDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self] forKey:kParkingReminderKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GGPParkingReminderUpdatedNotification object:nil
                                                      userInfo: @{ GGPParkingReminderNotificationHasSavedReminderKey : @(YES) }];
}

+ (void)clearSavedReminder {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kParkingReminderKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GGPParkingReminderUpdatedNotification object:nil
                                                      userInfo: @{ GGPParkingReminderNotificationHasSavedReminderKey : @(NO) }];
}

+ (GGPParkingReminder *)retrieveSavedReminder {
    NSData *reminderData = [[NSUserDefaults standardUserDefaults] objectForKey:kParkingReminderKey];
    return reminderData ? [NSKeyedUnarchiver unarchiveObjectWithData:reminderData] : nil;
}

@end
