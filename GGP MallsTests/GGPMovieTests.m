//
//  GGPMovieTests.m
//  GGP Malls
//
//  Created by Janet Lin on 12/15/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPMovie.h"
#import "GGPShowtime.h"
#import "NSDate+GGPAdditions.h"
#import <Overcoat/Overcoat.h>

@interface GGPMovieTests : XCTestCase

@property GGPMovie *movie;
@property NSDictionary *jsonDictionary;

@end

@interface GGPShowtime (Testing)

@property (strong, nonatomic) NSDate *movieShowtimeDate;

@end

@implementation GGPMovieTests

- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"movie" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.movie = (GGPMovie *)[MTLJSONAdapter modelOfClass:GGPMovie.class fromJSONDictionary:self.jsonDictionary error:nil];
}

- (void)tearDown {
    self.movie = nil;
    self.jsonDictionary = nil;
    [super tearDown];
}

- (void)testMovie {
    XCTAssertNotNil(self.movie);
    XCTAssertNotNil(self.movie.title);
    XCTAssertEqual(self.movie.movieId, [self.jsonDictionary[@"id"] integerValue]);
    XCTAssertEqualObjects(self.movie.title, self.jsonDictionary[@"title"]);
    XCTAssertEqualObjects(self.movie.synopsis, self.jsonDictionary[@"synopsis"]);
    XCTAssertEqualObjects(self.movie.mpaaRating, self.jsonDictionary[@"mpaaRating"]);
    XCTAssertEqual(self.movie.duration, [self.jsonDictionary[@"runTimeInMinutes"] integerValue]);
    XCTAssertEqualObjects(self.movie.director, self.jsonDictionary[@"director"]);
    XCTAssertEqual(self.movie.parentId, [self.jsonDictionary[@"parentId"] integerValue]);
    XCTAssertEqual(self.movie.fandangoId, [self.jsonDictionary[@"fandangoId"] integerValue]);
    XCTAssertEqualObjects(self.movie.largePosterImageURL, self.jsonDictionary[@"largePosterImageUrl"]);
    XCTAssertEqualObjects(self.movie.smallPosterImageURL, self.jsonDictionary[@"smallPosterImageUrl"]);
    [self compareStringArray:self.movie.genres toStringArray:self.jsonDictionary[@"genres"]];
    [self compareStringArray:self.movie.actors toStringArray:self.jsonDictionary[@"actors"]];
}

- (void)testShowtimes {
    NSArray *jsonArray = self.jsonDictionary[@"showtimes"];
    NSArray *showtimes = [MTLJSONAdapter modelsOfClass:GGPMovie.class fromJSONArray:jsonArray error:nil];
    XCTAssertEqual(showtimes.count, jsonArray.count);
    for (GGPShowtime *showtime in showtimes) {
        XCTAssertNotNil(showtime);
    }
}

- (void)testPrettyPrintDuration {
    id mockMovie1 = OCMPartialMock([GGPMovie new]);
    [OCMStub([(GGPMovie *)mockMovie1 duration]) andReturnValue:OCMOCK_VALUE(60)];
    XCTAssertEqualObjects([mockMovie1 prettyPrintDuration], @"1 hr 00 min");
    
    id mockMovie2 = OCMPartialMock([GGPMovie new]);
    [OCMStub([(GGPMovie *)mockMovie2 duration]) andReturnValue:OCMOCK_VALUE(125)];
    XCTAssertEqualObjects([mockMovie2 prettyPrintDuration], @"2 hr 05 min");
    
    id mockMovie3 = OCMPartialMock([GGPMovie new]);
    [OCMStub([(GGPMovie *)mockMovie3 duration]) andReturnValue:OCMOCK_VALUE(35)];
    XCTAssertEqualObjects([mockMovie3 prettyPrintDuration], @"0 hr 35 min");
}

- (void)testRetrieveMoviesScheduleForDateFromShowtimesReturnsList {
    GGPShowtime *showTime1 = [GGPShowtime new];
    showTime1.movieShowtimeDate = [NSDate ggp_createDateWithMinutes:0 hour:1 day:1 month:1 year:2016];
    GGPShowtime *showTime2 = [GGPShowtime new];
    showTime2.movieShowtimeDate = [NSDate ggp_createDateWithMinutes:0 hour:2 day:1 month:1 year:2016];
    GGPShowtime *showTime3 = [GGPShowtime new];
    showTime3.movieShowtimeDate = [NSDate ggp_createDateWithMinutes:0 hour:1 day:3 month:2 year:2016];
    GGPShowtime *showTime0 = [GGPShowtime new];
    showTime0.movieShowtimeDate = [NSDate ggp_createDateWithMinutes:0 hour:0 day:1 month:1 year:2016];
    
    id mockMovie = OCMPartialMock(self.movie);
    [OCMStub([mockMovie showtimes]) andReturn:@[showTime1,showTime0,showTime3,showTime2]];
    
    NSDate *date = [NSDate ggp_createDateWithMinutes:0 hour:0 day:1 month:1 year:2016];
    NSArray *todaysSchedule = [mockMovie retrieveScheduleForDate:date];
    XCTAssertEqual(todaysSchedule.count, 3);
    XCTAssertEqualObjects(todaysSchedule[0], showTime0);
    XCTAssertEqualObjects(todaysSchedule[1], showTime1);
    XCTAssertEqualObjects(todaysSchedule[2], showTime2);
}

- (void)compareStringArray:(NSArray *)strArray toStringArray:(NSArray *)otherStrArray {
    XCTAssertEqual(strArray.count, otherStrArray.count);
    for (int i=0; i < strArray.count; i++) {
        XCTAssertEqualObjects(strArray[i], otherStrArray[i]);
    }
}

- (void)testSortTitle {
    GGPMovie *mockMovie1 = OCMPartialMock([GGPMovie new]);
    GGPMovie *mockMovie2 = OCMPartialMock([GGPMovie new]);
    
    [OCMStub([mockMovie1 title]) andReturn:@"the x-men"];
    [OCMStub([mockMovie2 title]) andReturn:@"Angry Birds"];
    
    XCTAssertEqualObjects(mockMovie1.sortTitle, @"x-men");
    XCTAssertEqualObjects(mockMovie2.sortTitle, @"Angry Birds");
}

@end
