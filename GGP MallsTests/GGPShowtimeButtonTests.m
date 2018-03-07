//
//  GGPShowtimeButtonTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMovieTheater.h"
#import "GGPShowtime.h"
#import "GGPShowtimeButton.h"

@interface GGPShowtimeButtonTests : XCTestCase

@property GGPShowtimeButton *button;

@end

@interface GGPShowtimeButton (Testing)

@property (strong, nonatomic) GGPMovieTheater *theater;
@property (strong, nonatomic) GGPShowtime *showtime;
@property (assign, nonatomic) NSInteger fandangoId;

- (void)showTimeTapped;

@end

@implementation GGPShowtimeButtonTests

- (void)setUp {
    [super setUp];
    self.button = [GGPShowtimeButton new];
}

- (void)tearDown {
    self.button = nil;
    [super tearDown];
}

- (void)testShowtimeTappedNoFandangoId {
    id mockUIApplication = OCMPartialMock([UIApplication sharedApplication]);
    
    NSString *websiteUrl = @"website.url";
    id mockTheater = OCMPartialMock([GGPMovieTheater new]);
    [OCMStub([mockTheater websiteUrl]) andReturn:websiteUrl];
    [OCMStub([mockTheater tmsId]) andReturn:nil];
    
    id mockShowtime = OCMPartialMock([GGPShowtime new]);
    
    self.button = [[GGPShowtimeButton alloc] initWithTheater:mockTheater
                                                    showtime:mockShowtime
                                               andFandangoId:0];
    
    OCMExpect([mockUIApplication openURL:[NSURL URLWithString:websiteUrl]]);
    
    [self.button showTimeTapped];
    
    OCMVerifyAll(mockUIApplication);
}

- (void)testShowtimeTappedWithFandangoId {
    id mockUIApplication = OCMPartialMock([UIApplication sharedApplication]);
    
    NSString *websiteUrl = @"website.url";
    id mockTheater = OCMPartialMock([GGPMovieTheater new]);
    [OCMStub([mockTheater websiteUrl]) andReturn:websiteUrl];
    [OCMStub([mockTheater tmsId]) andReturn:@"tms1"];
    
    id mockShowtime = OCMPartialMock([GGPShowtime new]);
    
    
    self.button = [[GGPShowtimeButton alloc] initWithTheater:mockTheater
                                                    showtime:mockShowtime
                                               andFandangoId:124];
    
    NSString *fandangoString = [self.button.showtime determineFandangoUrlForFandangoId:self.button.fandangoId andTmsId:self.button.theater.tmsId];
    
    OCMExpect([mockUIApplication openURL:[NSURL URLWithString:fandangoString]]);
    
    [self.button showTimeTapped];
    
    OCMVerifyAll(mockUIApplication);
}

@end
