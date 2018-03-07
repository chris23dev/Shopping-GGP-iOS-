//
//  GGPShowtime.h
//  GGP Malls
//
//  Created by Janet Lin on 12/10/15.
//  Copyright (c) 2015 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

@interface GGPShowtime : MTLModel <MTLJSONSerializing>

/**
 *  User friendly formatted string for movie showtime (ex: 1:30pm)
 */
@property (strong, nonatomic, readonly) NSString *movieShowtime;

/**
 *  Movie showtime in format of NSDate object for easy comparing and ordering
 */
@property (strong, nonatomic, readonly) NSDate *movieShowtimeDate;

- (BOOL)isScheduledForDate:(NSDate *)date;

- (NSString *)determineFandangoUrlForFandangoId:(NSInteger)fandangoId andTmsId:(NSString *)tmsId;

@end
