//
//  GGPMovie.h
//  GGP Malls
//
//  Created by Janet Lin on 12/10/15.
//  Copyright (c) 2015 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>
#import "GGPShowtime.h"
#import <UIKit/UIKit.h>

@interface GGPMovie : MTLModel <MTLJSONSerializing, UIActivityItemSource>

// Mapped
@property (assign, nonatomic, readonly) NSInteger movieId;
@property (strong, nonatomic, readonly) NSString *smallPosterImageURL;
@property (strong, nonatomic, readonly) NSString *largePosterImageURL;
@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSString *mpaaRating;
@property (assign, nonatomic, readonly) NSInteger duration;
@property (strong, nonatomic, readonly) NSArray *showtimes;
@property (strong, nonatomic, readonly) NSArray *actors;
@property (strong, nonatomic, readonly) NSString *director;
@property (strong, nonatomic, readonly) NSString *distributor;
@property (strong, nonatomic, readonly) NSArray *genres;
@property (strong, nonatomic, readonly) NSString *synopsis;
@property (assign, nonatomic, readonly) NSInteger fandangoId;
@property (assign, nonatomic, readonly) NSInteger parentId;
@property (strong, nonatomic, readonly) NSURL *posterUrl;

// Calculated
@property (strong, nonatomic) NSString *sortTitle;
@property (strong, nonatomic) NSString *theaterName;

- (NSArray *)retrieveScheduleForDate:(NSDate *)date;
- (NSString *)prettyPrintDuration;

@end
