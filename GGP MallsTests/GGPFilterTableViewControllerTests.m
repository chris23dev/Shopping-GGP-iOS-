//
//  GGPFilterTableViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFilterTableCell.h"
#import "GGPFilterTableViewController.h"
#import "GGPCellData.h"

@interface GGPFilterTableViewControllerTests : XCTestCase

@property GGPFilterTableViewController *tableViewController;

@end

@interface GGPFilterTableViewController (Testing)

@property (strong, nonatomic) NSArray *filterItems;

@end

@implementation GGPFilterTableViewControllerTests

- (void)setUp {
    [super setUp];
    self.tableViewController = [GGPFilterTableViewController new];
}

- (void)tearDown {
    self.tableViewController = nil;
    [super tearDown];
}

- (void)testCellsRegistered {
    [self.tableViewController view];
    GGPFilterTableCell *cell = [self.tableViewController.tableView dequeueReusableCellWithIdentifier:GGPFilterCellReuseIdentifier];
    XCTAssertNotNil(cell);
}

- (void)testConfigureWithFilterCategories {
    NSArray *mockFilterCategories = @[];
    self.tableViewController.filterItems = mockFilterCategories;
    XCTAssertEqual(self.tableViewController.filterItems, mockFilterCategories);
}

- (void)testCellForRow {
    [self.tableViewController view];
    
    id mockCellData = OCMPartialMock([GGPCellData new]);
    [OCMStub([mockCellData title]) andReturn:@"Title"];
    
    self.tableViewController.filterItems = @[ mockCellData ];
    [self.tableViewController.tableView reloadData];
    
    id mockCell = OCMClassMock([GGPFilterTableCell class]);
    OCMExpect([mockCell configureWithCellData:mockCellData]);
    
    id mockTableView = OCMPartialMock(self.tableViewController.tableView);
    [OCMStub([mockTableView dequeueReusableCellWithIdentifier:GGPFilterCellReuseIdentifier forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) andReturn:mockCell];
    
    OCMVerify(mockCell);
}

- (void)testDidSelectRowWithTapHandler {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    id mockCategoryItem = OCMPartialMock([GGPCellData new]);
    [OCMStub([mockCategoryItem tapHandler]) andReturn:^(){
        [expectation fulfill];
    }];
    
    self.tableViewController.filterItems = @[ mockCategoryItem ];
    [self.tableViewController tableView:self.tableViewController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

@end
