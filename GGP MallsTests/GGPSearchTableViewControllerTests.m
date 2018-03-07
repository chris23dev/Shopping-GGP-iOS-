//
//  GGPSearchTableViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/24/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPSearchTableViewCell.h"
#import "GGPSearchTableViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

static NSInteger kHeaderHeight = 30;

@interface GGPSearchTableViewControllerTests : XCTestCase

@property GGPSearchTableViewController *tableViewController;
@property id mockTableViewController;
@property NSArray *recentMalls;
@property NSArray *searchResults;

@end

@interface GGPSearchTableViewController (Testing)

@property NSArray *sections;
@property NSString *headerText;

- (void)checkMallStatus:(GGPMall *)mall;
- (void)showUnavailableAlertForMall:(GGPMall *)mall;
- (void)showDispositioningAlertForMall:(GGPMall *)mall;
- (void)trackCoordinate:(CLLocationCoordinate2D)coordinate distance:(float)distance andMallName:(NSString *)mallName;

@end

@implementation GGPSearchTableViewControllerTests

- (void)setUp {
    [super setUp];
    self.tableViewController = [GGPSearchTableViewController new];
    self.recentMalls = @[[GGPMall new], [GGPMall new], [GGPMall new]];
    self.searchResults = @[[GGPMall new], [GGPMall new]];
    [self.tableViewController view];
    
    id mockTableViewController = OCMPartialMock(self.tableViewController);
    self.mockTableViewController = mockTableViewController;
}

- (void)tearDown {
    self.tableViewController = nil;
    self.recentMalls = nil;
    self.searchResults = nil;
    self.mockTableViewController = nil;
    [super tearDown];
}

- (void)testConfigureTableView {
    self.tableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)testConfigureWithBothSearchResultMallsAndRecentMalls {
    NSString *headerText = @"header";
    [self.tableViewController configureWithSearchResultMalls:self.searchResults recentMalls:self.recentMalls andHeaderText:headerText];
    XCTAssertEqual(self.tableViewController.sections.count, 2);
    XCTAssertEqualObjects(self.tableViewController.sections[0], self.searchResults);
    XCTAssertEqualObjects(self.tableViewController.sections[1], self.recentMalls);
    XCTAssertEqualObjects(self.tableViewController.headerText, headerText);
}

- (void)testConfigureWithOnlySearchResultMalls {
    NSString *headerText = @"header";
    [self.tableViewController configureWithSearchResultMalls:self.searchResults recentMalls:nil andHeaderText:headerText];
    XCTAssertEqual(self.tableViewController.sections.count, 2);
    XCTAssertEqualObjects(self.tableViewController.sections[0], self.searchResults);
    XCTAssertEqualObjects(self.tableViewController.sections[1], @[]);
    XCTAssertEqualObjects(self.tableViewController.headerText, headerText);
}

- (void)testConfigureWithOnlyRecentMalls {
    NSString *headerText = @"header";
    [self.tableViewController configureWithSearchResultMalls:nil recentMalls:self.recentMalls andHeaderText:headerText];
    XCTAssertEqual(self.tableViewController.sections.count, 2);
    XCTAssertEqualObjects(self.tableViewController.sections[1], self.recentMalls);
    XCTAssertEqualObjects(self.tableViewController.headerText, headerText);
}

- (void)testHeightForHeaderInSection {
    XCTAssertEqual(0, [self.tableViewController tableView:self.tableViewController.tableView heightForHeaderInSection:0]);
    [self.tableViewController configureWithSearchResultMalls:self.searchResults recentMalls:self.recentMalls andHeaderText:nil];
    XCTAssertEqual(kHeaderHeight, [self.tableViewController tableView:self.tableViewController.tableView heightForHeaderInSection:0]);
}

- (void)testNumberOfSectionsInTableView {
    [self.tableViewController configureWithSearchResultMalls:self.searchResults recentMalls:self.recentMalls andHeaderText:nil];
    XCTAssertEqual([self.tableViewController numberOfSectionsInTableView:self.tableViewController.tableView], self.tableViewController.sections.count);
}

- (void)testNumberOfRowsInSection {
    [self.tableViewController configureWithSearchResultMalls:self.searchResults recentMalls:self.recentMalls andHeaderText:nil];
    XCTAssertEqual([self.tableViewController tableView:self.tableViewController.tableView numberOfRowsInSection:0], self.searchResults.count);
    XCTAssertEqual([self.tableViewController tableView:self.tableViewController.tableView numberOfRowsInSection:1], self.recentMalls.count);
}

- (void)testTitleForHeaderInSection {
    NSString *headerText = @"header";
    [self.tableViewController configureWithSearchResultMalls:self.searchResults recentMalls:self.recentMalls andHeaderText:headerText];
    XCTAssertEqualObjects(headerText, [self.tableViewController tableView:self.tableViewController.tableView titleForHeaderInSection:0]);
    XCTAssertEqualObjects([@"SELECT_MALL_HEADER_RECENT" ggp_toLocalized], [self.tableViewController tableView:self.tableViewController.tableView titleForHeaderInSection:1]);
}

- (void)testWillDisplayHeaderViewForSection {
    UITableViewHeaderFooterView *headerView = [UITableViewHeaderFooterView new];
    [self.tableViewController tableView:self.tableViewController.tableView willDisplayHeaderView:headerView forSection:0];
    
    XCTAssertEqualObjects(headerView.textLabel.textColor, [UIColor ggp_gray]);
    XCTAssertEqualObjects(headerView.textLabel.font, [UIFont ggp_regularWithSize:15]);
}

- (void)testDidSelectSearchResultMallRowAtIndexPath {
    NSInteger mallId = 1234;
    NSString *mallName = @"mallName";
    NSNumber *coordLat = @23.234;
    NSNumber *coordLong = @42.42;
    NSNumber *distance = @1.5;
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall mallId]) andReturnValue:OCMOCK_VALUE(mallId)];
    [OCMStub([mockMall name]) andReturn:mallName];
    [OCMStub([mockMall latitude]) andReturn:coordLat];
    [OCMStub([mockMall longitude]) andReturn:coordLong];
    [OCMStub([mockMall distance]) andReturn:distance];
    
    OCMExpect([self.mockTableViewController trackCoordinate:CLLocationCoordinate2DMake(coordLat.floatValue, coordLong.floatValue) distance:distance.floatValue andMallName:mallName]);
    
    self.tableViewController.sections = @[@[mockMall],@[]];
    NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.mockTableViewController tableView:self.tableViewController.tableView didSelectRowAtIndexPath:path];
    
    OCMVerifyAll(self.mockTableViewController);
}

- (void)testMallSelectedIsDispositioning {
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall status]) andReturn:@"DISPOSITIONING"];
    
    OCMExpect([self.mockTableViewController showDispositioningAlertForMall:mockMall]);
    
    [self.tableViewController checkMallStatus:mockMall];
    
    OCMVerifyAll(self.mockTableViewController);
}

- (void)testMallSelectedIsLegacy {
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall status]) andReturn:@"LEGACY_PLATFORM"];
    
    OCMExpect([self.mockTableViewController showUnavailableAlertForMall:mockMall]);
    
    [self.tableViewController checkMallStatus:mockMall];
    
    OCMVerifyAll(self.mockTableViewController);
}

@end
