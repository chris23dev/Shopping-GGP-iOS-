//
//  GGPMovieTheaterTableViewControllerTests.m
//  GGP Malls
//
//  Created by Janet Lin on 12/16/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPMallMovie.h"
#import "GGPMovie.h"
#import "GGPMovieDatesCollectionViewController.h"
#import "GGPMoviesDatePickerHeaderView.h"
#import "GGPMoviesTableViewCell.h"
#import "GGPMovieTheater.h"
#import "GGPMovieTheaterDetailsCell.h"
#import "GGPMovieTheaterTableViewController.h"
#import "GGPShowtime.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface GGPMovieTheaterTableViewControllerTests : XCTestCase

@property GGPMovieTheaterTableViewController *viewController;
@property GGPMovieTheater *theater;

@end

@interface GGPMovieTheaterTableViewController (Testing)

@property (strong, nonatomic) GGPMovieDatesCollectionViewController *datesCollectionViewController;
@property (strong, nonatomic) NSArray <GGPMallMovie *> *mallMovies;
@property (strong, nonatomic) NSArray <GGPMovieTheater *> *theaters;
@property (strong, nonatomic) GGPMovieTheater *theater;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSArray *mallMoviesWithShowtimes;
@property (assign, nonatomic) BOOL moviesShowingForSelectedDate;

- (NSArray *)showtimesForWeek;

@end

@implementation GGPMovieTheaterTableViewControllerTests

- (void)setUp {
    [super setUp];
    self.theater = [GGPMovieTheater new];
    self.viewController = [GGPMovieTheaterTableViewController new];
}

- (void)tearDown {
    self.theater = nil;
    self.viewController = nil;
    [super tearDown];
}

- (void)testReturnsCorrectNumberOfSectionsInTableView {
    XCTAssertEqual([self.viewController numberOfSectionsInTableView:self.viewController.tableView], 2);
}

- (void)testReturnsCorrectHeightForRowAtIndexPath {
    XCTAssertEqual([self.viewController tableView:self.viewController.tableView heightForRowAtIndexPath:[NSIndexPath new]], UITableViewAutomaticDimension);
}

- (void)testRegisterMoviesLogoTableViewCellWithCorrectCellNib {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    GGPMovieTheaterDetailsCell *cell = [self.viewController.tableView dequeueReusableCellWithIdentifier:GGPMoviesCellReuseIdentifier forIndexPath:indexPath];
    XCTAssertNotNil(cell);
}

- (void)testRegisterMoviesTableViewCellWithCorrectCellNib {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    GGPMoviesTableViewCell *cell = [self.viewController.tableView dequeueReusableCellWithIdentifier:GGPMoviesCellReuseIdentifier forIndexPath:indexPath];
    XCTAssertNotNil(cell);
}

- (void)testRegisterMoviesHeaderView {
    GGPMoviesDatePickerHeaderView *headerView = [self.viewController.tableView dequeueReusableHeaderFooterViewWithIdentifier:GGPMoviesDatePickerHeaderViewReuseIdentifier];
    XCTAssertNotNil(headerView);
}

- (void)testReturnsCorrectNumberOfRowsInMoviesSectionNoTheaters {
    id mockViewController = OCMPartialMock(self.viewController);
    [OCMStub([mockViewController theaters]) andReturn:@[]];
    XCTAssertEqual([self.viewController tableView:self.viewController.tableView numberOfRowsInSection:1], 0);
}

- (void)testReturnsCorrectNumberOfRowsInMoviesSectionNoMovies {
    id mockViewController = OCMPartialMock(self.viewController);
    [OCMStub([mockViewController theaters]) andReturn:@[[GGPMovieTheater new]]];
    [OCMStub([mockViewController mallMovies]) andReturn:@[]];
    XCTAssertEqual([self.viewController tableView:self.viewController.tableView numberOfRowsInSection:1], 1);
}

- (void)testReturnsCorrectNumberOfRowsInMoviesSectionWithMovies {
    id mockViewController = OCMPartialMock(self.viewController);
    [OCMStub([mockViewController theaters]) andReturn:@[[GGPMovieTheater new]]];
    
    id mockMAllMovie = OCMPartialMock([GGPMallMovie new]);
    id mockMallMovie2 = OCMPartialMock([GGPMallMovie new]);
    NSArray *mallMovies = @[mockMAllMovie, mockMallMovie2];
    
    [OCMStub([mockViewController mallMoviesWithShowtimes]) andReturn:mallMovies];
    
    XCTAssertEqual([self.viewController tableView:self.viewController.tableView numberOfRowsInSection:1], mallMovies.count);
}

- (void)testReturnsCorrectNumberOfRowsInTheaterHeaderSection {
    id mockViewController = OCMPartialMock(self.viewController);
    [OCMStub([mockViewController theaters]) andReturn:@[[GGPMovieTheater new]]];
    XCTAssertEqual([self.viewController tableView:self.viewController.tableView numberOfRowsInSection:0], 1);
}

- (void)testLogoCell {
    id mockTheater = OCMPartialMock(self.theater);
    [OCMStub([mockTheater tmsId]) andReturn:@""];
    self.viewController.theater = mockTheater;
    id mockCell = OCMClassMock(GGPMovieTheaterDetailsCell.class);
    OCMExpect([mockCell configureWithTheaterName:OCMOCK_ANY Location:OCMOCK_ANY andImageUrl:OCMOCK_ANY]);
    id mockTableView = OCMPartialMock(self.viewController.tableView);
    [OCMStub([mockTableView dequeueReusableCellWithIdentifier:GGPMovieTheaterDetailsCellReuseIdentifier forIndexPath:OCMOCK_ANY]) andReturn:mockCell];
    
    NSIndexPath *path  = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.viewController tableView:self.viewController.tableView cellForRowAtIndexPath:path];
    
    OCMVerify(mockCell);
}

@end
