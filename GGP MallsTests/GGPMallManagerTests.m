//
//  GGPMallManagerTests.m
//  GGP Malls
//
//  Created by Janet Lin on 1/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPURLCache.h"

@interface GGPMallManagerTests : XCTestCase

@end

@interface GGPMallManager (Testing)

- (NSArray *)recentMallsWithSelectedMall:(GGPMall *)selectedMall;

@end

@interface GGPMall (Testing)

@property (assign, nonatomic) NSInteger mallId;
@property (strong, nonatomic) NSString *name;

@end

@implementation GGPMallManagerTests

- (void)setUp {
    [super setUp];
    [self cleanup];
}

- (void)tearDown {
    [self cleanup];
    [super tearDown];
}

- (void)cleanup {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kRecentMallListKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)testSetSelectedMallAddsToRecentMall {
    GGPMall *mall = [GGPMall new];
    mall.mallId = 1;
    [GGPMallManager shared].selectedMall = mall;
    
    XCTAssertEqualObjects([GGPMallManager shared].recentMalls.firstObject, mall);
}

- (void)testMallUpdatesInRecentMallList {
    GGPMall *originalMall = [GGPMall new];
    originalMall.mallId = 1;
    originalMall.name = @"Original";
    
    GGPMall *updatedMall = [GGPMall new];
    updatedMall.mallId = 1;
    updatedMall.name = @"Updated";
    
    [GGPMallManager shared].selectedMall = originalMall;
    [GGPMallManager shared].selectedMall = updatedMall;
    
    NSArray *recentMalls = [GGPMallManager shared].recentMalls;
    
    XCTAssertEqual(recentMalls.count, 1);
    XCTAssertEqualObjects(((GGPMall *)recentMalls[0]).name, updatedMall.name);
}

- (void)testMaxRecentMalls {
    NSInteger maxRecentMalls = 5;
    
    // Fill recent malls list to max
    for (int i = 0; i < maxRecentMalls; i++) {
        GGPMall *mall = [GGPMall new];
        mall.mallId = i;
        [GGPMallManager shared].selectedMall = mall;
    }
    
    // try to add one more
    GGPMall *mall = [GGPMall new];
    mall.mallId = maxRecentMalls;
    [GGPMallManager shared].selectedMall = mall;
    XCTAssertEqual([GGPMallManager shared].recentMalls.count, maxRecentMalls);
    
    // ensure that updated malls are removed before the max count check
    [GGPMallManager shared].selectedMall = mall;
    XCTAssertEqual([GGPMallManager shared].recentMalls.count, maxRecentMalls);
}

@end