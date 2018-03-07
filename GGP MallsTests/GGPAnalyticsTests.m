//
//  GGPAnalyticsTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 2/24/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAnalytics.h"

@interface GGPAnalyticsTests : XCTestCase

@end

@interface GGPAnalytics (Test)

- (void)safeSetValue:(NSString *)value forKey:(NSString *)key toDictionary:(NSMutableDictionary *)dictionary;
- (void)setLowercaseValuesForContextData:(NSMutableDictionary *)contextData;

@end

@implementation GGPAnalyticsTests

- (void)testSetLowercaseValuesForContextData {
    NSMutableDictionary *contextData = [NSMutableDictionary dictionary];
    [contextData setObject:@5 forKey:@"keyNumber"];
    [contextData setObject:@"TEST" forKey:@"keyString"];
    
    [[GGPAnalytics shared] setLowercaseValuesForContextData:contextData];
    
    XCTAssertEqualObjects(contextData[@"keyNumber"], @5);
    XCTAssertEqualObjects(contextData[@"keyString"], @"test");
}

- (void)testSafeSetValue {
    NSMutableDictionary *contextData = [NSMutableDictionary dictionary];
    
    [[GGPAnalytics shared] safeSetValue:nil forKey:@"key" toDictionary:contextData];
    XCTAssertEqual(0, contextData.count);
    
    [[GGPAnalytics shared] safeSetValue:@"" forKey:@"key" toDictionary:contextData];
    XCTAssertEqual(0, contextData.count);
    
    [[GGPAnalytics shared] safeSetValue:@"VALUE" forKey:@"key" toDictionary:contextData];
    XCTAssertEqual(1, contextData.count);
    XCTAssertEqualObjects(@"VALUE", contextData[@"key"]);
}

@end
