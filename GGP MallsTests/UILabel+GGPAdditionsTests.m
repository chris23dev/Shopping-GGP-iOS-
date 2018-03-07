//
//  UILabel+GGPAdditionsTests.m
//  GGP Malls
//
//  Created by Janet Lin on 2/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "UILabel+GGPAdditions.h"

@interface UILabel_GGPAdditionsTests : XCTestCase
@property (strong, nonatomic) UILabel *label;
@end

@implementation UILabel_GGPAdditionsTests

- (void)setUp {
    [super setUp];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2, 4)];
}

- (void)tearDown {
    self.label = nil;
    [super tearDown];
}

- (void)testContentHeightEmpty {
    XCTAssertEqual(0, [self.label ggp_contentHeight]);
}

- (void)testContentHeight {
    UIFont *testFont = [UIFont boldSystemFontOfSize:5];
    self.label.font = testFont;
    self.label.text = @"a";
    XCTAssertEqual(ceil(testFont.lineHeight), [self.label ggp_contentHeight]);
    
    self.label.text = @"abab";
    XCTAssertEqual(ceil(testFont.lineHeight * 4), [self.label ggp_contentHeight]);
}

- (void)testNumberOfRowsIsZero {
    self.label.font = [UIFont boldSystemFontOfSize:2];
    XCTAssertEqual([self.label ggp_lineCount], 0);
}

- (void)testNumberOfRows {
    self.label.font = [UIFont boldSystemFontOfSize:2];
    self.label.text = @"a";
    XCTAssertEqual(1, [self.label ggp_lineCount]);
}

@end
