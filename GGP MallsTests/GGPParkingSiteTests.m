//
//  GGPParkingSiteTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/12/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingSite.h"

@interface GGPParkingSiteTests : XCTestCase

@end

@implementation GGPParkingSiteTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLevelForZoneName {
    GGPParkingLevel *level1 = [GGPParkingLevel new];
    GGPParkingLevel *level2 = [GGPParkingLevel new];
    level1.zoneName = @"zone1";
    level2.zoneName = @"zone2";
    
    NSArray *levels = @[level1, level2];
    
    XCTAssertEqualObjects(level1, [GGPParkingSite levelForZoneName:@"zone1" fromLevels:levels]);
    XCTAssertEqualObjects(level2, [GGPParkingSite levelForZoneName:@"zone2" fromLevels:levels]);
    XCTAssertNil([GGPParkingSite levelForZoneName:@"zone3" fromLevels:levels]);
    XCTAssertNil([GGPParkingSite levelForZoneName:nil fromLevels:levels]);
    XCTAssertNil([GGPParkingSite levelForZoneName:@"zone1" fromLevels:nil]);
}

- (void)testLevelsForGarageId {
    GGPParkingLevel *level1 = [GGPParkingLevel new];
    GGPParkingLevel *level2 = [GGPParkingLevel new];
    GGPParkingLevel *level3 = [GGPParkingLevel new];
    level1.garageId = 1;
    level2.garageId = 1;
    level3.garageId = 2;
    
    NSArray *levels = @[level1, level2, level3];
    
    NSArray *garage1Levels = [GGPParkingSite levelsForGarageId:1 fromLevels:levels];
    NSArray *garage2Levels = [GGPParkingSite levelsForGarageId:2 fromLevels:levels];
    
    XCTAssertEqual(2, garage1Levels.count);
    XCTAssertTrue([garage1Levels containsObject:level1]);
    XCTAssertTrue([garage1Levels containsObject:level2]);
    XCTAssertEqual(1, garage2Levels.count);
    XCTAssertTrue([garage2Levels containsObject:level3]);
    XCTAssertEqual(0, [GGPParkingSite levelsForGarageId:3 fromLevels:levels].count);
    XCTAssertEqual(0, [GGPParkingSite levelsForGarageId:1 fromLevels:nil].count);
}

- (void)testGarageForGarageId {
    GGPParkingGarage *garage1 = [GGPParkingGarage new];
    GGPParkingGarage *garage2 = [GGPParkingGarage new];
    garage1.garageId = 1;
    garage2.garageId = 2;
    
    NSArray *garages = @[garage1, garage2];
    
    XCTAssertEqualObjects(garage1, [GGPParkingSite garageForGarageId:1 fromGarages:garages]);
    XCTAssertEqualObjects(garage2, [GGPParkingSite garageForGarageId:2 fromGarages:garages]);
    XCTAssertNil([GGPParkingSite garageForGarageId:3 fromGarages:garages]);
    XCTAssertNil([GGPParkingSite garageForGarageId:1 fromGarages:nil]);
}

- (void)testZoneForZoneName {
    GGPParkingZone *zone1 = [GGPParkingZone new];
    GGPParkingZone *zone2 = [GGPParkingZone new];
    zone1.zoneName = @"zone1";
    zone2.zoneName = @"zone2";
    
    NSArray *zones = @[zone1, zone2];
    
    XCTAssertEqualObjects(zone1, [GGPParkingSite zoneForZoneName:@"zone1" fromZones:zones]);
    XCTAssertEqualObjects(zone2, [GGPParkingSite zoneForZoneName:@"zone2" fromZones:zones]);
    XCTAssertNil([GGPParkingSite zoneForZoneName:@"zone3" fromZones:zones]);
    XCTAssertNil([GGPParkingSite zoneForZoneName:nil fromZones:zones]);
    XCTAssertNil([GGPParkingSite zoneForZoneName:@"zone1" fromZones:nil]);
}

@end
