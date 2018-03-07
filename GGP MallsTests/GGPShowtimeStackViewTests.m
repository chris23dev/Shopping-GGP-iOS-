//
//  GGPShowtimeStackViewTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPShowtimeStackView.h"

@interface GGPShowtimeStackViewTests : XCTestCase

@property GGPShowtimeStackView *stackView;

@end

@interface GGPShowtimeStackView (Testing)

- (NSInteger)spacersNeededForShowTimeCount:(NSInteger)showTimeCount;

@end

@implementation GGPShowtimeStackViewTests

- (void)setUp {
    [super setUp];
    self.stackView = [GGPShowtimeStackView new];
}

- (void)tearDown {
    self.stackView = nil;
    [super tearDown];
}

- (void)testSpacesNeededForShowTimeCount {
    XCTAssertEqual([self.stackView spacersNeededForShowTimeCount:1], 2);
    XCTAssertEqual([self.stackView spacersNeededForShowTimeCount:2], 1);
    XCTAssertEqual([self.stackView spacersNeededForShowTimeCount:3], 0);
    XCTAssertEqual([self.stackView spacersNeededForShowTimeCount:4], 2);
    XCTAssertEqual([self.stackView spacersNeededForShowTimeCount:5], 1);
    XCTAssertEqual([self.stackView spacersNeededForShowTimeCount:6], 0);
}

@end
