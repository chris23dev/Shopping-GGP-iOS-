//
//  NSString+GGPAdditionsTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/17/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "NSString+GGPAdditions.h"
#import <UIKit/UIKit.h>

@interface NSStringGGPAdditionsTests : XCTestCase

@end

@implementation NSStringGGPAdditionsTests

- (void)testPrettyPrintPhoneNumber {
    NSString *expectedNumber = @"+1-111-222-3333";
    NSString *result = [NSString ggp_prettyPrintPhoneNumber:@"1112223333"];
    XCTAssertEqualObjects(expectedNumber, result);
}

- (void)testPrettyPrintPhoneNumberInvalidCases {
    XCTAssertNil([NSString ggp_prettyPrintPhoneNumber:@"111222333"]);
    XCTAssertNil([NSString ggp_prettyPrintPhoneNumber:@"11122233333"]);
    XCTAssertNil([NSString ggp_prettyPrintPhoneNumber:nil]);
}

@end
