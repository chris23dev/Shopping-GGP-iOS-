//
//  GGPParkingLotTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingLot.h"

@interface GGPParkingLotTests : XCTestCase

@end

@implementation GGPParkingLotTests

- (void)testIsValid {
    GGPParkingLot *parkingLot = [GGPParkingLot new];
    
    XCTAssertFalse(parkingLot.isValid);
    
    parkingLot.occupancies = @[];
    XCTAssertFalse(parkingLot.isValid);
    
    parkingLot.occupancies = @[@"test"];
    XCTAssertTrue(parkingLot.isValid);
}

@end
