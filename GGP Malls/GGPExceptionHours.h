//
//  GGPExceptionHours.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/24/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPHours.h"

@interface GGPExceptionHours : GGPHours

@property (strong, nonatomic, readonly) NSString *startMonthDay;
@property (strong, nonatomic, readonly) NSString *endMonthDay;
@property (strong, nonatomic, readonly) NSString *validUntilDate;
@property (strong, nonatomic, readonly) NSString *holidayName;

- (BOOL)isValidForDate:(NSDate *)date;

@end
