//
//  GGPMallMovie.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMallMovie.h"
#import "NSArray+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"

static NSString *const kSortKey = @"movie.title";

@interface GGPMallMovie ()

@property (strong, nonatomic) GGPMovie *movie;
@property (strong, nonatomic) NSDictionary *showtimesLookup;
@property (assign, nonatomic) NSInteger numberOfTheatersAtMall;

@end

@implementation GGPMallMovie

- (instancetype)initWithMovie:(GGPMovie *)movie showtimesLookup:(NSDictionary *)showtimesLookup andNumberOfTheatersAtMall:(NSInteger)numberOfTheatersAtMall {
    self = [super init];
    if (self) {
        self.movie = movie;
        self.showtimesLookup = showtimesLookup;
        self.numberOfTheatersAtMall = numberOfTheatersAtMall;
    }
    return self;
}

+ (NSArray *)mallMoviesFromList:(NSArray *)moviesList forSelectedDate:(NSDate *)selectedDate {
    return [moviesList ggp_arrayWithFilter:^BOOL(GGPMallMovie *mallMovie) {
        return [mallMovie isPlayingOnSelectedDate:selectedDate];
    }];
}

- (BOOL)isPlayingOnSelectedDate:(NSDate *)selectedDate {
    for (NSArray *theaterShowtimes in self.showtimesLookup.allValues) {
        BOOL exists = [theaterShowtimes ggp_anyWithFilter:^BOOL(GGPShowtime *showtime) {
            return [showtime isScheduledForDate:selectedDate];
        }];
        
        if (exists) {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *)retrieveShowtimesForTheater:(GGPMovieTheater *)theater onSelectedDate:(NSDate *)selectedDate {
    NSArray *showtimesForTheater = [self.showtimesLookup objectForKey:theater];
    
    return [showtimesForTheater ggp_arrayWithFilter:^BOOL(GGPShowtime *showtime) {
        return [showtime isScheduledForDate:selectedDate];
    }];
}

@end
