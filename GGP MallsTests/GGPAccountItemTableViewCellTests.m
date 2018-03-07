//
//  GGPAccountItemTableViewCellTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccountItemTableViewCell.h"
#import <XCTest/XCTest.h>

@interface GGPAccountItemTableViewCellTests : XCTestCase

@property GGPAccountItemTableViewCell *cell;

@end

@implementation GGPAccountItemTableViewCellTests

- (void)setUp {
    [super setUp];
    self.cell = [[NSBundle mainBundle] loadNibNamed:@"GGPAccountItemTableViewCell" owner:self options:nil].firstObject;
}

- (void)tearDown {
    self.cell = nil;
    [super tearDown];
}

- (void)testOutletsInitialized {
    XCTAssertNotNil(self.cell.textLabel);
}

- (void)testConfigureWithText {
    NSString *expectedText = @"test";
    [self.cell configureWithText:expectedText];
    XCTAssertEqual(self.cell.textLabel.text, expectedText);
}

@end
