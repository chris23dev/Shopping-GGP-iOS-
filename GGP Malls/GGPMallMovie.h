//
//  GGPMallMovie.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMovie.h"
#import "GGPMovieTheater.h"
#import "GGPShowtime.h"
#import <Foundation/Foundation.h>

@interface GGPMallMovie : NSObject

@property (strong, nonatomic, readonly) GGPMovie *movie;
@property (strong, nonatomic, readonly) NSDictionary *showtimesLookup;
@property (assign, nonatomic, readonly) NSInteger numberOfTheatersAtMall;

- (instancetype)initWithMovie:(GGPMovie *)movie showtimesLookup:(NSDictionary * )showtimesLookup andNumberOfTheatersAtMall:(NSInteger)numberOfTheatersAtMall;

+ (NSArray *)mallMoviesFromList:(NSArray <GGPMallMovie *> *)moviesList forSelectedDate:(NSDate *)selectedDate;

- (NSArray *)retrieveShowtimesForTheater:(GGPMovieTheater *)theater onSelectedDate:(NSDate *)selectedDate;

- (BOOL)isPlayingOnSelectedDate:(NSDate *)selectedDate;

@end
