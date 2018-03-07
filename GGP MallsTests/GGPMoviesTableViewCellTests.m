//
//  GGPMoviesTableViewCellTests.m
//  GGP Malls
//
//  Created by Janet Lin on 12/21/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPMallMovie.h"
#import "GGPMoviesTableViewCell.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

@interface GGPMoviesTableViewCellTests : XCTestCase

@property GGPMoviesTableViewCell *cell;

@end

@interface GGPMoviesTableViewCell (Testing)

@property (weak, nonatomic) IBOutlet UIView *movieCardView;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;

@property (strong, nonatomic) GGPMovie *movie;

- (void)configureControls;
- (void)configureWithMallMovie:(GGPMallMovie *)mallMovie andSelectedDate:(NSDate *)selectedDate;
- (void)determineTimesContainerHeightConstraintWithNumberOfMovieTimes:(NSInteger)count;

@end

@implementation GGPMoviesTableViewCellTests

- (void)setUp {
    [super setUp];
    self.cell = [[NSBundle mainBundle] loadNibNamed:@"GGPMoviesTableViewCell"
                                              owner:self
                                            options:nil].lastObject;
}

- (void)tearDown {
    self.cell = nil;
    [super tearDown];
}

- (void)testOutletsInitialized {
    XCTAssertNotNil(self.cell.moviePosterImageView);
    XCTAssertNotNil(self.cell.movieNameLabel);
    XCTAssertNotNil(self.cell.movieCardView);
    XCTAssertNotNil(self.cell.movieDetailsLabel);
}

- (void)testConfigureControls {
    [self.cell configureControls];
    
    XCTAssertEqualObjects(self.cell.movieNameLabel.font, [UIFont ggp_boldWithSize:14]);
    XCTAssertEqualObjects(self.cell.movieNameLabel.textColor, [UIColor blackColor]);
    XCTAssertEqual(self.cell.movieNameLabel.numberOfLines, 0);
    XCTAssertEqualObjects(self.cell.movieDetailsLabel.font, [UIFont ggp_lightWithSize:14]);
    XCTAssertEqualObjects(self.cell.movieDetailsLabel.textColor, [UIColor blackColor]);
    XCTAssertEqualObjects(self.cell.movieCardView.backgroundColor, [UIColor whiteColor]);
    XCTAssertEqualObjects(self.cell.backgroundColor, [UIColor ggp_lightGray]);
}

- (void)testConfigureWithMovie {
    GGPMallMovie *mockMallMovie = OCMPartialMock([GGPMallMovie new]);
    
    NSString *title = @"title";
    NSString *mpaaRating = @"PG-13";
    
    GGPMovie *mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([mockMovie movieId]) andReturnValue:OCMOCK_VALUE(1)];
    [OCMStub([mockMovie title]) andReturn:title];
    [OCMStub([mockMovie mpaaRating]) andReturn:mpaaRating];
    [OCMStub([mockMovie largePosterImageURL]) andReturn:@"a.url"];
    [OCMStub([mockMovie duration]) andReturnValue:OCMOCK_VALUE(120)];
    
    [OCMStub([mockMallMovie movie]) andReturn:mockMovie];
    
    [self.cell configureWithMallMovie:mockMallMovie andSelectedDate:OCMOCK_ANY];

    XCTAssertEqualObjects(self.cell.movie, mockMovie);
    XCTAssertEqualObjects(self.cell.movieNameLabel.text, title);
    XCTAssertNotNil(self.cell.moviePosterImageView);
    XCTAssertEqualObjects(self.cell.movieDetailsLabel.text, @"PG-13,  2 hr 00 min");
}

@end
