//
//  GGPWayfindingRouteDetailTableViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenant.h"
#import "GGPWayfindingRouteDetailHeaderFooterView.h"
#import "GGPWayfindingRouteDetailTableViewCell.h"
#import "GGPWayfindingRouteDetailTableViewController.h"
#import <XCTest/XCTest.h>

@interface GGPWayfindingRouteDetailTableViewControllerTests : XCTestCase

@property GGPWayfindingRouteDetailTableViewController *tableViewController;
@property NSArray *directions;
@property GGPTenant *fromTenant;
@property GGPTenant *toTenant;

@end

@interface GGPWayfindingRouteDetailTableViewController (Testing)

@property (strong, nonatomic) GGPWayfindingRouteDetailHeaderFooterView *headerView;
@property (strong, nonatomic) GGPWayfindingRouteDetailHeaderFooterView *footerView;
@property (strong, nonatomic) NSArray *directionsList;
@property (strong, nonatomic) GGPTenant *fromTenant;
@property (strong, nonatomic) GGPTenant *toTenant;

@end

@implementation GGPWayfindingRouteDetailTableViewControllerTests

- (void)setUp {
    [super setUp];
    self.directions = @[@"GO LEFT HERE"];
    self.fromTenant = [GGPTenant new];
    self.toTenant = [GGPTenant new];
    self.tableViewController = [GGPWayfindingRouteDetailTableViewController new];
    [self.tableViewController configureWithDirections:self.directions fromTenant:self.fromTenant toTenant:self.toTenant];
    [self.tableViewController view];
}

- (void)tearDown {
    self.tableViewController = nil;
    self.directions = nil;
    self.fromTenant = nil;
    self.toTenant = nil;
    [super tearDown];
}

- (void)testConfigureTable {
    XCTAssertNotNil(self.tableViewController.directionsList);
    XCTAssertNotNil(self.tableViewController.fromTenant);
    XCTAssertNotNil(self.tableViewController.toTenant);
    XCTAssertNotNil(self.tableViewController.headerView);
    XCTAssertNotNil(self.tableViewController.footerView);
    XCTAssertEqual(self.tableViewController.fromTenant, self.fromTenant);
    XCTAssertEqual(self.tableViewController.toTenant, self.toTenant);
}

- (void)testNumberOfRowsInSection {
    XCTAssertEqual([self.tableViewController.tableView numberOfRowsInSection:0], self.directions.count);
}

@end
