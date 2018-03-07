//
//  GGPShowtimeTests.m
//  GGP Malls
//
//  Created by Janet Lin on 12/15/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPShowtime.h"
#import "NSDate+GGPAdditions.h"
#import <Overcoat/Overcoat.h>

@interface GGPShowtimeTests : XCTestCase
@property GGPShowtime *showtime;
@end

@interface GGPShowtime (Testing)

@property (strong, nonatomic) NSDate *movieShowtimeDate;

@end

@implementation GGPShowtimeTests

NSString *const kShowtimeFormat = @"[0-9]*[0-9]:[0-9][0-9] (?:PM|AM)";

- (void)setUp {
    [super setUp];
    self.showtime = [GGPShowtime new];
    self.showtime.movieShowtimeDate = [NSDate ggp_createDateWithMinutes:0 hour:2 day:5 month:5 year:2004];
}

- (void)tearDown {
    self.showtime = nil;
    [super tearDown];
}

- (void)testShowtime {
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"showtime" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    GGPShowtime *showtime = (GGPShowtime *)[MTLJSONAdapter modelOfClass:GGPShowtime.class fromJSONDictionary:jsonDictionary error:nil];
    
    XCTAssertNotNil(showtime);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat  = @"yyyy-MM-dd'T'HH:mm";
    XCTAssertEqualObjects(showtime.movieShowtimeDate, [dateFormatter dateFromString: jsonDictionary[@"movieShowtime"]]);
}

- (void)testShowtimeIsNotScheduled {
    XCTAssertFalse([self.showtime isScheduledForDate:[NSDate ggp_createDateWithMinutes:0 hour:2 day:6 month:5 year:2004]]);
}

- (void)testShowtimeIsScheduled {
    XCTAssertTrue([self.showtime isScheduledForDate:[NSDate ggp_createDateWithMinutes:0 hour:2 day:5 month:5 year:2004]]);
}

- (void)testShowtimePrintsMovieShowTimeFormatCorrectly {
    NSRange range = [self.showtime.movieShowtime rangeOfString:kShowtimeFormat options:NSRegularExpressionSearch];
    XCTAssertTrue(range.location != NSNotFound);
}

- (void)testShowTimePrintMovieShowTimeFormatMorning {
    NSRange range = [[self.showtime movieShowtime] rangeOfString:kShowtimeFormat options:NSRegularExpressionSearch];
    XCTAssertTrue(range.location != NSNotFound);
}

- (void)testShowtimeFormattedCorrectlyForSingleNumberHour {
    self.showtime.movieShowtimeDate = [NSDate ggp_createDateWithMinutes:0 hour:2 day:2 month:2 year:2014];
    XCTAssertEqualObjects(self.showtime.movieShowtime, @"2:00 AM");
}

- (void)testShowtimeFormattedCorrectlyForTwoNumberHour {
    self.showtime.movieShowtimeDate = [NSDate ggp_createDateWithMinutes:0 hour:11 day:2 month:2 year:2016];
    XCTAssertEqualObjects(self.showtime.movieShowtime, @"11:00 AM");
}

- (void)testdetermineURLWithFandangoId {
    NSString *tmsId = @"AB12C";
    NSInteger fandangoId = 123456;
    self.showtime.movieShowtimeDate = [NSDate ggp_createDateWithMinutes:0 hour:11 day:3 month:2 year:2016];
    
    NSString *fandangoUrl = [self.showtime determineFandangoUrlForFandangoId:fandangoId andTmsId:tmsId];
    XCTAssertEqualObjects(fandangoUrl, @"http://www.fandango.com/redirect.aspx?mid=123456&tid=AB12C&date=2016-02-03+11:00");
}

@end
