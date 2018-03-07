//
//  GGPParkingReminderTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingReminder.h"
#import "NSDate+GGPAdditions.h"

@interface GGPParkingReminder ()

@property (strong, nonatomic) NSDate *createdDate;

@end

@interface GGPParkingReminderTests : XCTestCase

@end

@implementation GGPParkingReminderTests

- (void)testIsValid {
    GGPParkingReminder *reminder = [GGPParkingReminder new];
    NSDate *now = [NSDate date];
    
    reminder.createdDate = [NSDate ggp_subtractDays:1 fromDate:now];
    reminder.location = [CLLocation new];
    XCTAssertTrue(reminder.isValid);
    
    reminder.createdDate = [NSDate ggp_subtractDays:3 fromDate:now];
    reminder.location = [CLLocation new];
    XCTAssertFalse(reminder.isValid);
    
    reminder.createdDate = [NSDate ggp_subtractDays:1 fromDate:now];
    reminder.location = nil;
    XCTAssertFalse(reminder.isValid);
}

@end
