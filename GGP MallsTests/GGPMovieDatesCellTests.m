//
//  GGPMovieDatesCellTests.m
//  GGP Malls
//
//  Created by Janet Lin on 2/4/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMovieDatesCell.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

@interface GGPMovieDatesCellTests : XCTestCase

@property (strong, nonatomic) GGPMovieDatesCell *cell;

@end

@interface GGPMovieDatesCell (Testing)
@property (weak, nonatomic) IBOutlet UIView *contentContainerView;
@property (weak, nonatomic) IBOutlet UIView *dateMonthContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *activeArrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *dayOfTheWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedBottomBorderView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)setActiveStyle;
- (void)setInactiveStyle;
@end

@implementation GGPMovieDatesCellTests

- (void)setUp {
    [super setUp];
    self.cell = [[[NSBundle mainBundle] loadNibNamed:@"GGPMovieDatesCell" owner:self options:nil] lastObject];
}

- (void)tearDown {
    self.cell = nil;
    [super tearDown];
}

- (void)testOutletsInitialized {
    XCTAssertNotNil(self.cell.contentContainerView);
    XCTAssertNotNil(self.cell.dateMonthContainerView);
    XCTAssertNotNil(self.cell.activeArrowImageView);
    XCTAssertNotNil(self.cell.dayOfTheWeekLabel);
    XCTAssertNotNil(self.cell.monthLabel);
    XCTAssertNotNil(self.cell.selectedBottomBorderView);
    XCTAssertNotNil(self.cell.dateLabel);
}

- (void)testControlConfigurations {
    XCTAssertEqualObjects(self.cell.backgroundColor, [UIColor clearColor]);
    XCTAssertEqualObjects(self.cell.contentContainerView.backgroundColor, [UIColor whiteColor]);
    XCTAssertEqualObjects(self.cell.monthLabel.font, [UIFont ggp_regularWithSize:12]);
    XCTAssertEqualObjects(self.cell.dayOfTheWeekLabel.font, [UIFont ggp_boldWithSize:12]);
    XCTAssertEqualObjects(self.cell.dayOfTheWeekLabel.textColor, [UIColor whiteColor]);
    XCTAssertEqualObjects(self.cell.dateLabel.font, [UIFont ggp_boldWithSize:25]);
}

- (void)testActiveStyle {
    [self.cell setActiveStyle];
    XCTAssertFalse(self.cell.activeArrowImageView.hidden);
    XCTAssertEqualObjects(self.cell.selectedBottomBorderView.backgroundColor, [UIColor ggp_colorFromHexString:@"#C1C1C1"]);
    XCTAssertEqualObjects(self.cell.dateMonthContainerView.backgroundColor, [UIColor whiteColor]);
    XCTAssertEqualObjects(self.cell.dayOfTheWeekLabel.backgroundColor, [UIColor ggp_blue]);
    
    XCTAssertEqualObjects(self.cell.monthLabel.textColor, [UIColor ggp_darkGray]);
    XCTAssertEqualObjects(self.cell.dateLabel.textColor, [UIColor ggp_darkGray]);
}

- (void)testInactiveStyle {
    [self.cell setInactiveStyle];
    XCTAssertTrue(self.cell.activeArrowImageView.hidden);
    XCTAssertEqualObjects(self.cell.selectedBottomBorderView.backgroundColor, [UIColor clearColor]);
    XCTAssertEqualObjects(self.cell.dateMonthContainerView.backgroundColor, [UIColor ggp_colorFromHexString:@"#3C3C3C"]);
    XCTAssertEqualObjects(self.cell.dayOfTheWeekLabel.backgroundColor, [UIColor ggp_colorFromHexString:@"#262626"]);
    
    XCTAssertEqualObjects(self.cell.monthLabel.textColor, [UIColor whiteColor]);
    XCTAssertEqualObjects(self.cell.dateLabel.textColor, [UIColor whiteColor]);
}

- (void)testConfigureWithDateActive {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:10];
    [components setMonth:1];
    [components setYear:2016];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    [self.cell configureWithDate:date isActive:YES];
    XCTAssertEqualObjects(self.cell.dayOfTheWeekLabel.text, @"SUN");
    XCTAssertEqualObjects(self.cell.dateLabel.text, @"10");
    XCTAssertEqualObjects(self.cell.monthLabel.text, @"JAN");
    XCTAssertFalse(self.cell.activeArrowImageView.hidden);
}

- (void)testConfigureWithDateInactive {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:2];
    [components setMonth:2];
    [components setYear:2016];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    [self.cell configureWithDate:date isActive:NO];
    XCTAssertEqualObjects(self.cell.dayOfTheWeekLabel.text, @"TUE");
    XCTAssertEqualObjects(self.cell.dateLabel.text, @"2");
    XCTAssertEqualObjects(self.cell.monthLabel.text, @"FEB");
    XCTAssertTrue(self.cell.activeArrowImageView.hidden);
}

@end
