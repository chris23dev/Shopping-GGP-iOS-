//
//  GGPMovieDetailViewControllerTests.m
//  GGP Malls
//
//  Created by Janet Lin on 2/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPMovie.h"
#import "GGPMallMovie.h"
#import "GGPMallRepository.h"
#import "GGPMovieDatesCollectionViewController.h"
#import "GGPMovieDetailViewController.h"
#import "GGPMovieTheater.h"
#import "GGPNavigationTitleView.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSInteger const kMinumumTopDistanceBetweenDetailsAndShowtimesHeader = 20;

@interface GGPMovieDetailViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPMovieDetailViewController *detailViewController;
@property (strong, nonatomic) GGPMallMovie *mallMovie;

@end

@interface GGPMovieDetailViewController (Testing) <GGPMovieDatesCollectionDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreDurationLabel;
@property (weak, nonatomic) IBOutlet UIView *datePickerContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerContainerViewTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *showtimesHeaderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showtimeHeaderTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *plotSummaryHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *plotSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *castHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *castLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreInfoHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreInfoLabel;

@property (strong, nonatomic) GGPMallMovie *movie;

- (NSString *)prettyPrintMoreInfo;
- (NSString *)prettyPrintDetails;
- (NSString *)prettyPrintCast;
- (NSString *)prettyPrintShowtimeHeaderDate:(NSDate *)date;
- (NSArray *)determineShowtimeDatesForMovie:(GGPMovie *)movie;

- (void)shareButtonTapped;

@end

@implementation GGPMovieDetailViewControllerTests

- (void)setUp {
    [super setUp];
    self.mallMovie = [self createMockMovie];
    self.detailViewController = [[GGPMovieDetailViewController alloc] initWithMallMovie:self.mallMovie andSelectedDate:[NSDate new]];
}

- (GGPMallMovie *)createMockMovie {
    NSDate *date = [NSDate new];
    
    id mockShowtime = OCMPartialMock([GGPShowtime new]);
    [OCMStub([mockShowtime movieShowtimeDate]) andReturn:date];
    
    id mockMallMovie = OCMPartialMock([GGPMallMovie new]);
    
    GGPMovie *mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([mockMovie movieId]) andReturnValue:OCMOCK_VALUE(100)];
    [OCMStub([mockMovie title]) andReturn:@"title"];
    [OCMStub([mockMovie genres]) andReturn:@[@"action", @"fantasy"]];
    [OCMStub([mockMovie duration]) andReturnValue:OCMOCK_VALUE(60)];
    [OCMStub([mockMovie synopsis]) andReturn:@"this is a plot summary"];
    [OCMStub([mockMovie actors]) andReturn:@[@"actor name", @"anotherActor name"]];
    [OCMStub([mockMovie director]) andReturn:@"director"];
    [OCMStub([mockMovie distributor]) andReturn:@"distributor"];
    [OCMStub([mockMovie showtimes]) andReturn:@[mockShowtime]];
    
    [OCMStub([mockMallMovie movie]) andReturn:mockMovie];
    
    return mockMallMovie;
}

- (void)tearDown {
    self.mallMovie = nil;
    self.detailViewController = nil;
    [super tearDown];
}

- (void)testTabBarHidden {
    id mockTabController = OCMPartialMock([UITabBarController new]);
    id mockController = OCMPartialMock(self.detailViewController);
    
    [OCMStub([mockController tabBarController]) andReturn:mockTabController];
    
    [self.detailViewController viewWillAppear:NO];
    
    XCTAssertTrue(self.detailViewController.tabBarController.tabBar.hidden);
}

- (void)testTextWithEmptyMovie {
    GGPMovieDetailViewController *emptyController = [[GGPMovieDetailViewController alloc] initWithMallMovie:[GGPMallMovie new] andSelectedDate:[NSDate new]];
    
    [emptyController viewDidLoad];
    
    XCTAssertNil(emptyController.plotSummaryHeaderLabel.text);
    XCTAssertNil(emptyController.castHeaderLabel.text);
    XCTAssertNil(emptyController.castLabel.text);
    XCTAssertNil(emptyController.moreInfoHeaderLabel.text);
    XCTAssertNil(emptyController.moreInfoLabel.text);
}

- (void)testPrettyPrintMoreInfo {
    NSString *expected = [NSString stringWithFormat:@"Director: %@\nDistributor: %@",
                          self.mallMovie.movie.director, self.mallMovie.movie.distributor];
    XCTAssertEqualObjects([self.detailViewController prettyPrintMoreInfo], expected);
}

-  (void)testPrettyPrintOnlyDirector {
    id mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([mockMovie director]) andReturn:@"director"];
    GGPMovieDetailViewController *controller = [GGPMovieDetailViewController new];
    controller.movie = mockMovie;
    
    XCTAssertEqualObjects([controller prettyPrintMoreInfo], @"Director: director");
}

- (void)testPrettyPrintOnlyDistributor {
    id mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([mockMovie distributor]) andReturn:@"distributor"];
    GGPMovieDetailViewController *controller = [GGPMovieDetailViewController new];
    controller.movie = mockMovie;
    
    XCTAssertEqualObjects([controller prettyPrintMoreInfo], @"Distributor: distributor");
}

- (void)testPrettyPrintDetails {
    NSString *expected = @"action/fantasy,  1 hr 00 min";
    XCTAssertEqualObjects([self.detailViewController prettyPrintDetails], expected);
}

- (void)testPrettyPrintDetailsNoGenres {
    id mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([(GGPMovie*)mockMovie duration]) andReturnValue:OCMOCK_VALUE(120)];
    GGPMovieDetailViewController *controller = [GGPMovieDetailViewController new];
    controller.movie = mockMovie;
    
    XCTAssertEqualObjects([controller prettyPrintDetails], @"2 hr 00 min");
}

- (void)testPrettyPrintDetailsSingleGenre {
    id mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([(GGPMovie*)mockMovie duration]) andReturnValue:OCMOCK_VALUE(120)];
    [OCMStub([mockMovie genres]) andReturn:@[@"fantasy"]];
    GGPMovieDetailViewController *controller = [GGPMovieDetailViewController new];
    controller.movie = mockMovie;
    
    XCTAssertEqualObjects([controller prettyPrintDetails], @"fantasy,  2 hr 00 min");
}

- (void)testPrettyPrintCast {
    NSString *expected = [NSString stringWithFormat:@"%@, %@ in %@", self.mallMovie.movie.actors[0], self.mallMovie.movie.actors[1], self.mallMovie.movie.title];
    XCTAssertEqualObjects([self.detailViewController prettyPrintCast], expected);
}

- (void)testPrettyPrintCastSingleCast {
    id mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([mockMovie actors]) andReturn:@[@"actor name"]];
    [OCMStub([mockMovie title]) andReturn:@"title"];
    GGPMovieDetailViewController *controller = [GGPMovieDetailViewController new];
    controller.movie = mockMovie;
    
    NSString *expected = [NSString stringWithFormat:@"actor name in title"];
    XCTAssertEqualObjects([controller prettyPrintCast], expected);
}

- (void)testConfigureDatePicker {
    [self.detailViewController viewDidLoad];
    
    XCTAssertFalse(self.detailViewController.datePickerContainerView.hidden);
    XCTAssertTrue(self.detailViewController.showtimeHeaderTopConstraint.constant != kMinumumTopDistanceBetweenDetailsAndShowtimesHeader);
}

- (void)testDetermineShowtimeDatesForMovieSameDay {
    NSDate *showtime1 = [NSDate ggp_createDateWithMinutes:0 hour:0 day:2 month:2 year:2016];
    id mockShowTime1 = OCMClassMock(GGPShowtime.class);
    [OCMStub([mockShowTime1 movieShowtimeDate]) andReturn:showtime1];
    
    NSDate *showtime2 = [NSDate ggp_createDateWithMinutes:30 hour:0 day:2 month:2 year:2016];
    id mockShowTime2 = OCMClassMock(GGPShowtime.class);
    [OCMStub([mockShowTime2 movieShowtimeDate]) andReturn:showtime2];
    
    NSDate *showtime3 = [NSDate ggp_createDateWithMinutes:45 hour:0 day:2 month:2 year:2016];
    id mockShowTime3 = OCMClassMock(GGPShowtime.class);
    [OCMStub([mockShowTime3 movieShowtimeDate]) andReturn:showtime3];
    
    id mockMovie = OCMClassMock(GGPMovie.class);
    [OCMStub([mockMovie showtimes]) andReturn:@[mockShowTime1, mockShowTime2, mockShowTime3]];
    
    NSArray *sortedDates = [self.detailViewController determineShowtimeDatesForMovie:mockMovie];
    XCTAssertEqual(sortedDates.count, 1);
    NSDate *actualShowtime = [NSDate ggp_createDateWithMinutes:0 hour:0 day:2 month:2 year:2016];
    XCTAssertEqualObjects(sortedDates[0], actualShowtime);
}

- (void)testDetermineShowtimeDatesForMovieSortsDates {
    NSDate *showtime1 = [NSDate ggp_createDateWithMinutes:0 hour:0 day:3 month:2 year:2016];
    id mockShowTime1 = OCMClassMock(GGPShowtime.class);
    [OCMStub([mockShowTime1 movieShowtimeDate]) andReturn:showtime1];
    
    NSDate *showtime2 = [NSDate ggp_createDateWithMinutes:0 hour:0 day:2 month:2 year:2016];
    id mockShowTime2 = OCMClassMock(GGPShowtime.class);
    [OCMStub([mockShowTime2 movieShowtimeDate]) andReturn:showtime2];
    
    NSDate *showtime3 = [NSDate ggp_createDateWithMinutes:0 hour:0 day:5 month:2 year:2016];
    id mockShowTime3 = OCMClassMock(GGPShowtime.class);
    [OCMStub([mockShowTime3 movieShowtimeDate]) andReturn:showtime3];
    
    id mockMovie = OCMClassMock(GGPMovie.class);
    [OCMStub([mockMovie showtimes]) andReturn:@[mockShowTime1, mockShowTime2, mockShowTime3]];
    
    NSArray *sortedDates = [self.detailViewController determineShowtimeDatesForMovie:mockMovie];
    XCTAssertEqual(sortedDates.count, 3);
    XCTAssertEqualObjects(sortedDates[0], showtime2);
    XCTAssertEqualObjects(sortedDates[1], showtime1);
    XCTAssertEqualObjects(sortedDates[2], showtime3);
}

- (void)testSelectedDate {
//    NSDate *date = [NSDate ggp_createDateWithMinutes:0 hour:2 day:1 month:1 year:2016];
//    id mockShowtimesVC = OCMPartialMock(self.detailViewController.showtimesCollectionViewController);
//    OCMExpect([mockShowtimesVC updateWithShowtimes:OCMOCK_ANY]);
//    self.detailViewController.showtimesCollectionViewController = mockShowtimesVC;
//    
//    [self.detailViewController selectedDate:date];
    
//    XCTAssertEqualObjects(self.detailViewController.showtimesHeaderLabel.text, @"Showtimes for Jan 1");
//    XCTAssertEqual(self.detailViewController.scrollView.contentOffset.y, CGPointZero.y);
//    OCMVerifyAll(mockShowtimesVC);
}

- (void)testSelectedTimeForMovieFandangoId {
//    id mockUIApplication = OCMPartialMock([UIApplication sharedApplication]);
//    OCMExpect([mockUIApplication openURL:OCMOCK_ANY]);
//    
//    [self.detailViewController selectedTime:nil forMovieFandangoId:12345];
//    OCMVerifyAll(mockUIApplication);
}

@end
