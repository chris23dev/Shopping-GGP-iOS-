//
//  GGPTenantDetailRibbonCellDataTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantDetailRibbonCellData.h"
#import <XCTest/XCTest.h>

@interface GGPTenantDetailRibbonCellData (Testing)

@property NSString *title;
@property UIImage *image;
@property void (^tapHandler)();

@end

@interface GGPTenantDetailRibbonCellDataTests : XCTestCase

@property GGPTenantDetailRibbonCellData *cellData;

@end

@implementation GGPTenantDetailRibbonCellDataTests

- (void)setUp {
    [super setUp];
    self.cellData = [GGPTenantDetailRibbonCellData new];
}

- (void)tapHandler {}

- (void)tearDown {
    self.cellData = nil;
    [super tearDown];
}

- (void)testInitWithTitle {
    NSString *expectedTitle = @"Title";
    UIImage *expectedImage = [UIImage imageNamed:@"ggp_icon_call"];
    
    self.cellData = [self.cellData initWithTitle:expectedTitle image:expectedImage andTapHandler:OCMOCK_ANY];
    
    XCTAssertEqualObjects(expectedTitle, self.cellData.title);
    XCTAssertEqualObjects(expectedImage, self.cellData.image);
}

@end
