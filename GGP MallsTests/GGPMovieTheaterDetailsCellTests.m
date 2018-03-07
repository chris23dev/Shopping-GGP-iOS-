//
//  GGPMoviesLogoTableViewCellTests.m
//  GGP Malls
//
//  Created by Janet Lin on 2/3/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMovieTheaterDetailsCell.h"
#import "GGPLogoImageView.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"


@interface GGPMovieTheaterDetailsCellTests : XCTestCase

@property (strong, nonatomic) GGPMovieTheaterDetailsCell *cell;

@end

@interface GGPMovieTheaterDetailsCell ()

@property (weak, nonatomic) IBOutlet GGPLogoImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *theaterNameButton;
@property (weak, nonatomic) IBOutlet UILabel *theaterLocationLabel;
- (IBAction)theaterNameButtonTapped:(id)sender;

@end

@implementation GGPMovieTheaterDetailsCellTests

- (void)setUp {
    [super setUp];
    self.cell = [[[NSBundle mainBundle] loadNibNamed:@"GGPMovieTheaterDetailsCell" owner:self options:nil] lastObject];
}

- (void)tearDown {
    self.cell = nil;
    [super tearDown];
}

- (void)testOutletsInitialized {
    XCTAssertNotNil(self.cell.logoImageView);
    XCTAssertNotNil(self.cell.theaterNameButton);
    XCTAssertNotNil(self.cell.theaterLocationLabel);
}

- (void)testControlsConfigured {
    [self.cell configureWithTheaterName:nil Location:nil andImageUrl:nil];

    XCTAssertEqualObjects(self.cell.theaterNameButton.titleLabel.font, [UIFont ggp_boldWithSize:18]);
    XCTAssertEqualObjects(self.cell.theaterNameButton.currentTitleColor, [UIColor ggp_blue]);
    
    XCTAssertEqualObjects(self.cell.theaterLocationLabel.font, [UIFont ggp_lightWithSize:16]);
    XCTAssertEqualObjects(self.cell.theaterLocationLabel.textColor, [UIColor blackColor]);
}

- (void)testConfigureCell {
    NSURL *url = [NSURL URLWithString:@"www.website.url"];
    NSString *name = @"Theater Name";
    NSString *location = @"location";
    
    id mockImageView = OCMPartialMock(self.cell.logoImageView);
    OCMExpect([mockImageView setImageWithURL:url defaultName:name]);
    
    self.cell.logoImageView = mockImageView;
    [self.cell configureWithTheaterName:name Location:location andImageUrl:url];
    
    OCMVerifyAll(mockImageView);
    XCTAssertEqual(self.cell.theaterLocationLabel.text, location);
    XCTAssertEqual(self.cell.theaterNameButton.currentTitle, name);
    [mockImageView stopMocking];
}

- (void)testTeaterNameButtonTapped {
    id testHeaderDelegate = OCMProtocolMock(@protocol(GGPMovieTheaterDetailsCellDelegate));
    OCMExpect([testHeaderDelegate handleTheaterNameButtonTapped]);
    self.cell.theaterDetailCellDelegate = testHeaderDelegate;
    
    [self.cell theaterNameButtonTapped:nil];
    
    OCMVerifyAll(testHeaderDelegate);
    [testHeaderDelegate stopMocking];
}

@end
