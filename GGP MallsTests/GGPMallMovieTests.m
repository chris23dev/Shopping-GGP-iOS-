//
//  GGPMallMovieTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMovieTheater.h"
#import "GGPShowtime.h"
#import "GGPMallMovie.h"
#import "GGPMallRepository.h"
#import "NSDate+GGPAdditions.h"

@interface GGPMallMovieTests : XCTestCase

@end

@interface GGPMallMovie (Testing)

+ (NSArray *)mallMoviesFromList:(NSArray *)moviesList forSelectedDate:(NSDate *)selectedDate;

- (NSArray *)retrieveShowtimesForTheater:(GGPMovieTheater *)theater onSelectedDate:(NSDate *)selectedDate;

- (BOOL)isPlayingOnSelectedDate:(NSDate *)selectedDate;

@end

@implementation GGPMallMovieTests

- (void)testMallMoviesFromListForSelectedDateHasMovies {
    id mockTheater = OCMPartialMock([GGPMovieTheater new]);
    
    id mockShowTime = OCMPartialMock([GGPShowtime new]);
    [OCMStub([mockShowTime movieShowtimeDate]) andReturn:[NSDate new]];
    
    id mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([mockMovie showtimes]) andReturn:@[mockShowTime]];
    
    [OCMStub([mockTheater movies]) andReturn:@[mockMovie]];
    
    NSDictionary *lookup = @{ mockTheater: @[mockShowTime] };
    GGPMallMovie *mallMovie = [[GGPMallMovie alloc] initWithMovie:mockMovie showtimesLookup:lookup andNumberOfTheatersAtMall:0];
    
    XCTAssertEqual([GGPMallMovie mallMoviesFromList:@[mallMovie] forSelectedDate:[NSDate new]].count, 1);
}

- (void)testMallMoviesFromListForSelectedDateNoMovies {
    NSDate *tomorrow = [NSDate ggp_addDays:1 toDate:[NSDate new]];
    
    id mockTheater = OCMPartialMock([GGPMovieTheater new]);
    
    id mockShowTime = OCMPartialMock([GGPShowtime new]);
    [OCMStub([mockShowTime movieShowtimeDate]) andReturn:tomorrow];
    
    id mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([mockMovie showtimes]) andReturn:@[mockShowTime]];
    
    [OCMStub([mockTheater movies]) andReturn:@[mockMovie]];
    
    NSDictionary *lookup = @{ mockTheater: @[mockShowTime] };
    GGPMallMovie *mallMovie = [[GGPMallMovie alloc] initWithMovie:mockMovie showtimesLookup:lookup andNumberOfTheatersAtMall:0];
    
    XCTAssertEqual([GGPMallMovie mallMoviesFromList:@[mallMovie] forSelectedDate:[NSDate new]].count, 0);
}

- (void)testIsPlayingOnSelectedDateTrue {
    id mockTheater = OCMPartialMock([GGPMovieTheater new]);
    
    id mockShowTime = OCMPartialMock([GGPShowtime new]);
    [OCMStub([mockShowTime movieShowtimeDate]) andReturn:[NSDate new]];
    
    id mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([mockMovie showtimes]) andReturn:@[mockShowTime]];
    
    [OCMStub([mockTheater movies]) andReturn:@[mockMovie]];
    
    NSDictionary *lookup = @{ mockTheater: @[mockShowTime] };
    GGPMallMovie *mallMovie = [[GGPMallMovie alloc] initWithMovie:mockMovie showtimesLookup:lookup andNumberOfTheatersAtMall:0];
    
    XCTAssertTrue([mallMovie isPlayingOnSelectedDate:[NSDate new]]);
}

- (void)testIsPlayingOnSelectedDateFalse {
    NSDate *today = [NSDate new];
    NSDate *tomorrow = [NSDate ggp_addDays:1 toDate:today];
    
    id mockTheater = OCMPartialMock([GGPMovieTheater new]);
    
    id mockShowTime = OCMPartialMock([GGPShowtime new]);
    [OCMStub([mockShowTime movieShowtimeDate]) andReturn:tomorrow];
    
    id mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([mockMovie showtimes]) andReturn:@[mockShowTime]];
    
    [OCMStub([mockTheater movies]) andReturn:@[mockMovie]];
    
    NSDictionary *lookup = @{ mockTheater: @[mockShowTime] };
    GGPMallMovie *mallMovie = [[GGPMallMovie alloc] initWithMovie:mockMovie showtimesLookup:lookup andNumberOfTheatersAtMall:0];
    
    XCTAssertFalse([mallMovie isPlayingOnSelectedDate:today]);
}

- (void)testRetrieveShowtimesForTheaterOnSelectedDateHasShowTimes {
    NSDate *today = [NSDate new];
    
    GGPMovieTheater *mockTheater = OCMPartialMock([GGPMovieTheater new]);
    [OCMStub([mockTheater name]) andReturn:@"theater"];
    [OCMStub([mockTheater tmsId]) andReturn:@"tmsid1"];
    [OCMStub([mockTheater theatreId]) andReturnValue:OCMOCK_VALUE(2)];
    
    GGPShowtime *mockShowTime = OCMPartialMock([GGPShowtime new]);
    [OCMStub([mockShowTime movieShowtimeDate]) andReturn:today];
    
    GGPMovie *mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([mockMovie movieId]) andReturnValue:OCMOCK_VALUE(1)];
    [OCMStub([mockMovie showtimes]) andReturn:@[mockShowTime]];
    
    [OCMStub([mockTheater movies]) andReturn:@[mockMovie]];
    
    NSDictionary *lookup = @{ mockTheater: @[mockShowTime] };
    GGPMallMovie *mallMovie = [[GGPMallMovie alloc] initWithMovie:mockMovie showtimesLookup:lookup andNumberOfTheatersAtMall:0];
    
    NSArray *showtimesForTheater = [mallMovie retrieveShowtimesForTheater:mockTheater
                                                           onSelectedDate:today];
    
    XCTAssertEqual(showtimesForTheater.count, 1);
}

@end
