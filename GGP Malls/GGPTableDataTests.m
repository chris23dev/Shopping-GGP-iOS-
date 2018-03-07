//
//  GGPCellDataTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCellData.h"

@interface GGPCellDataTests : XCTestCase

@property GGPCellData *cellDatum;

@end

@interface GGPCellData (Testing)

@property NSString *title;

@end

@implementation GGPCellDataTests

- (void)setUp {
    [super setUp];
    self.cellDatum = [GGPCellData new];
}

- (void)tearDown {
    self.cellDatum = nil;
    [super tearDown];
}

- (void)testInitWithTitleandTapHandler {
    NSString *expectedTitle = @"Title";
    self.cellDatum = [self.cellDatum initWithTitle:expectedTitle andTapHandler:OCMOCK_ANY];
    XCTAssertEqualObjects(expectedTitle, self.cellDatum.title);
}

@end
