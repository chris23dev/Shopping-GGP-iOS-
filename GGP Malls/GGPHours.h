//
//  GGPHours.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/9/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLJSONAdapter.h>
#import <Mantle/MTLModel.h>

@interface GGPHours : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic, readonly) NSString *openTime;
@property (strong, nonatomic, readonly) NSString *closeTime;
@property (strong, nonatomic, readonly) NSString *startDay;
@property (strong, nonatomic, readonly) NSString *endDay;
@property (assign, nonatomic, readonly) BOOL isOpen;

- (NSString *)prettyPrintStartDate;
- (NSString *)prettyPrintOpenHoursRange;
- (NSDate *)dateForStartDay;
+ (NSArray *)openHoursForDate:(NSDate *)date hours:(NSArray *)hours andExceptionHours:(NSArray *)exceptionHours;

@end
