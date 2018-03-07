//
//  GGPMovieTheaterTests.m
//  GGP Malls
//
//  Created by Janet Lin on 12/14/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPHours.h"
#import "GGPMovie.h"
#import "GGPMovieTheater.h"
#import "GGPShowtime.h"
#import "GGPExceptionHours.h"
#import "NSDate+GGPAdditions.h"
#import <Overcoat/Overcoat.h>

@interface GGPMovieTheaterTests : XCTestCase

@property GGPMovieTheater *movieTheater;
@property NSDictionary *jsonDictionary;

@end

@interface GGPMovieTheater (Testing)

- (NSArray *)sortedMovies:(NSArray *)unsortedMovies;
- (NSArray *)moviesWithShowTimeForDate:(NSDate *)date;

@end

@implementation GGPMovieTheaterTests

- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"movieTheater" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.movieTheater = (GGPMovieTheater *)[MTLJSONAdapter modelOfClass:GGPMovieTheater.class fromJSONDictionary:self.jsonDictionary error:nil];
}

- (void)tearDown {
    self.movieTheater = nil;
    self.jsonDictionary = nil;
    [super tearDown];
}

- (void)testTheaterProperties {
    XCTAssertNotNil(self.movieTheater);
    XCTAssertEqual(self.movieTheater.theatreId, [self.jsonDictionary[@"id"] integerValue]);
    XCTAssertEqual(self.movieTheater.mallId, [self.jsonDictionary[@"mallId"] integerValue]);
    XCTAssertEqualObjects(self.movieTheater.name, self.jsonDictionary[@"name"]);
    XCTAssertEqualObjects(self.movieTheater.phoneNumber, self.jsonDictionary[@"phoneNumber"]);
    XCTAssertEqualObjects(self.movieTheater.nonSvgLogoUrl, self.jsonDictionary[@"nonSvgLogoUrl"]);
    XCTAssertEqual(self.movieTheater.operatingHours.count, ((NSArray *)self.jsonDictionary[@"operatingHours"]).count);
    XCTAssertEqual(self.movieTheater.exceptionHours.count, ((NSArray *)self.jsonDictionary[@"operatingHoursExceptions"]).count);
}

- (void)testOperatingHoursExceptions {
    NSArray *jsonArray = self.jsonDictionary[@"operatingHoursExceptions"];
    NSArray *hourExceptions = [MTLJSONAdapter modelsOfClass:GGPExceptionHours.class fromJSONArray:jsonArray error:nil];
    XCTAssertEqual(hourExceptions.count, jsonArray.count);
    for (GGPExceptionHours *hourException in hourExceptions) {
        XCTAssertNotNil(hourException);
    }
}

- (void)testMovies {
    NSArray *jsonArray = self.jsonDictionary[@"movies"];
    NSArray *movies = [MTLJSONAdapter modelsOfClass:GGPMovie.class fromJSONArray:jsonArray error:nil];
    XCTAssertEqual(movies.count, jsonArray.count);
    for (GGPMovie *movie in movies) {
        XCTAssertNotNil(movie);
    }
}

@end
