//
//  UIColor+GGPAdditionsTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/21/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+GGPAdditions.h"

@interface UIColorGGPAdditionsTests : XCTestCase

@end

@implementation UIColorGGPAdditionsTests

- (void)testValidHex {
    UIColor *actualWithHash = [UIColor ggp_colorFromHexString:@"#FFFFFF"];
    UIColor *actualWithoutHash = [UIColor ggp_colorFromHexString:@"FFFFFF"];
    UIColor *expected = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    XCTAssertEqualObjects(actualWithHash, expected);
    XCTAssertEqualObjects(actualWithoutHash, expected);
}

- (void)testInvalidHex {
    XCTAssertNil([UIColor ggp_colorFromHexString:@"white"]);
    XCTAssertNil([UIColor ggp_colorFromHexString:nil]);
    XCTAssertNil([UIColor ggp_colorFromHexString:@"FFFFFFF"]);
}

- (void)testAlpha {
    XCTAssertEqual(CGColorGetAlpha([UIColor ggp_colorFromHexString:@"FFFFFF"].CGColor), 1);
    XCTAssertEqual(CGColorGetAlpha([UIColor ggp_colorFromHexString:@"FFFFFF" andAlpha:0.25].CGColor), 0.25);
}

@end
