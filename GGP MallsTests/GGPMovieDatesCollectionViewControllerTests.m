//
//  GGPMovieDatesCollectionViewControllerTests.m
//  GGP Malls
//
//  Created by Janet Lin on 2/4/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMovie.h"
#import "GGPMovieDatesCell.h"
#import "GGPMovieDatesCollectionViewController.h"
#import "GGPShowTime.h"
#import "NSDate+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

@interface GGPMovieDatesCollectionViewControllerTests : XCTestCase
@property GGPMovieDatesCollectionViewController *dateCollectionVC;
@property NSArray *movies;
@property id mockShowtime;
@end

@interface GGPMovieDatesCollectionViewController (Testing)
@property NSArray *showtimeDates;
@property NSIndexPath *selectedDatePath;
@end

@interface GGPMovieDatesCell (Testing)
@property (weak, nonatomic) IBOutlet UIImageView *activeArrowImageView;
@end

@implementation GGPMovieDatesCollectionViewControllerTests

- (void)setUp {
    [super setUp];
    NSDate *showtimeDate = [NSDate ggp_createDateWithMinutes:0 hour:0 day:5 month:2 year:2016];
    
    self.mockShowtime = OCMClassMock(GGPShowtime.class);
    [OCMStub([self.mockShowtime movieShowtimeDate]) andReturn:showtimeDate];
    
    id mockMovie = OCMClassMock(GGPMovie.class);
    [OCMStub([mockMovie showtimes]) andReturn:@[self.mockShowtime]];

    self.movies = @[mockMovie];
    
    self.dateCollectionVC = [[GGPMovieDatesCollectionViewController alloc] initWithShowtimeDates:@[self.mockShowtime] andSelectedDate:[NSDate new]];
    
    [self.dateCollectionVC collectionView];
}

- (void)tearDown {
    self.dateCollectionVC = nil;
    self.movies = nil;
    [super tearDown];
}

- (void)testInitWithSevenShowtimes {
    NSArray *showtimes = @[self.mockShowtime, self.mockShowtime, self.mockShowtime, self.mockShowtime, self.mockShowtime, self.mockShowtime, self.mockShowtime];
    GGPMovieDatesCollectionViewController *timeCollectionVC = [[GGPMovieDatesCollectionViewController alloc] initWithShowtimeDates:showtimes andSelectedDate:[NSDate new]];
    XCTAssertEqual(timeCollectionVC.showtimeDates.count, showtimes.count);
}

- (void)testViewDidLoad {
    XCTAssertTrue(self.dateCollectionVC.collectionView.bounces);
    XCTAssertFalse(self.dateCollectionVC.collectionView.showsHorizontalScrollIndicator);
    XCTAssertFalse(self.dateCollectionVC.collectionView.showsVerticalScrollIndicator);
    XCTAssertEqualObjects(self.dateCollectionVC.collectionView.dataSource, self.dateCollectionVC);
}

- (void)testInitWithMovies {
    XCTAssertEqual(self.dateCollectionVC.showtimeDates.count, 1);
    XCTAssertEqualObjects(self.dateCollectionVC.showtimeDates[0], self.mockShowtime);
    XCTAssertEqualObjects(self.dateCollectionVC.selectedDatePath, [NSIndexPath indexPathForRow:0 inSection:0]);
    XCTAssertNotNil(self.dateCollectionVC.collectionViewLayout);
}

- (void)testRegisterMovieDatesCellNib {
    GGPMovieDatesCell *cell = [self.dateCollectionVC.collectionView dequeueReusableCellWithReuseIdentifier:GGPMovieDatesCellReuseIdentifier forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertNotNil(cell);
}

- (void)testCellForItemAtIndexPathActive {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    self.dateCollectionVC.selectedDatePath = path;
    GGPMovieDatesCell *cell = (GGPMovieDatesCell *)[self.dateCollectionVC collectionView:self.dateCollectionVC.collectionView cellForItemAtIndexPath:path];
    XCTAssertFalse(cell.activeArrowImageView.hidden);
}

- (void)testCellForItemAtIndexPathInactive {
    self.dateCollectionVC.selectedDatePath = [NSIndexPath indexPathForRow:2 inSection:0];
    GGPMovieDatesCell *cell = (GGPMovieDatesCell *)[self.dateCollectionVC collectionView:self.dateCollectionVC.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertTrue(cell.activeArrowImageView.hidden);
}

- (void)testDidSelectItemAtIndexPathSelectedDifferentPath {
    NSIndexPath *selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.dateCollectionVC.selectedDatePath = [NSIndexPath indexPathForRow:2 inSection:0];
    id mockCollectionView = OCMPartialMock(self.dateCollectionVC.collectionView);
    OCMExpect([mockCollectionView reloadData]);
    
    [self.dateCollectionVC collectionView:mockCollectionView didSelectItemAtIndexPath:selectedPath];
    XCTAssertEqualObjects(self.dateCollectionVC.selectedDatePath, selectedPath);
    
    OCMVerifyAll(mockCollectionView);
    [mockCollectionView stopMocking];
}

- (void)testDidSelectItemAtIndexPathSelectedSamePath {
    NSIndexPath *selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.dateCollectionVC.selectedDatePath = selectedPath;
    id mockCollectionView = OCMPartialMock(self.dateCollectionVC.collectionView);
    [[mockCollectionView reject] reloadData];
    
    [self.dateCollectionVC collectionView:mockCollectionView didSelectItemAtIndexPath:selectedPath];
    XCTAssertEqualObjects(self.dateCollectionVC.selectedDatePath, selectedPath);
    
    OCMVerifyAll(mockCollectionView);
    [mockCollectionView stopMocking];
}

@end
