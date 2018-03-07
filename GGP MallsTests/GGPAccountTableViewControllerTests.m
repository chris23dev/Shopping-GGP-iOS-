//
//  GGPAccountTableViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccountItemTableViewCell.h"
#import "GGPAccountTableViewController.h"
#import "GGPCellData.h"

@interface GGPAccountTableViewControllerTests : XCTestCase

@property GGPAccountTableViewController *tableController;

@end

@interface GGPAccountTableViewController (Testing)

@property NSArray *accountItems;
- (void)registerNibs;

@end

@implementation GGPAccountTableViewControllerTests

- (void)setUp {
    [super setUp];
    self.tableController = [GGPAccountTableViewController new];
    [self.tableController view];
}

- (void)tearDown {
    self.tableController = nil;
    [super tearDown];
}

- (void)testViewDidLoad {
    id mockController = OCMPartialMock(self.tableController);
    OCMExpect([mockController registerNibs]);
    [self.tableController viewDidLoad];
    XCTAssertFalse(self.tableController.tableView.scrollEnabled);
    OCMVerifyAll(mockController);
}

- (void)testConfigureWithItems {
    NSArray *expectedAccountItems = @[];
    [self.tableController configureWithAccountItems:expectedAccountItems];
    XCTAssertEqual(self.tableController.accountItems, expectedAccountItems);
}

- (void)testCellForRowAtIndexPathForPrimaryCell {
    NSString *expectedText = @"TEXT";
    
    id mockItem = OCMPartialMock([GGPCellData new]);
    [OCMStub([mockItem title]) andReturn:expectedText];
    
    self.tableController.accountItems = @[mockItem];
    [self.tableController.tableView reloadData];
    
    id mockCell = OCMPartialMock([GGPAccountItemTableViewCell new]);
    OCMExpect([mockCell configureWithText:expectedText]);
    
    id mockTableView = OCMPartialMock(self.tableController.tableView);
    [OCMStub([mockTableView dequeueReusableCellWithIdentifier:GGPAccountItemTableViewCellReuseIdentifier forIndexPath:OCMOCK_ANY]) andReturn:mockCell];
    
    id resultCell = [self.tableController tableView:self.tableController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    
    XCTAssertTrue([resultCell isKindOfClass:[GGPAccountItemTableViewCell class]]);
    OCMVerifyAll(mockCell);
}

@end
