//
//  GGPSubscriptionDetailTableViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPSubscriptionDetailTableViewController.h"

@interface GGPSubscriptionDetailTableViewControllerTests : XCTestCase

@property GGPSubscriptionDetailTableViewController *tableViewController;

@end

@interface GGPSubscriptionDetailTableViewController (Testing)

- (NSString *)userMallIdStringFromRowIndex:(NSInteger)index;
@property NSInteger selectedIndex;

@end

@implementation GGPSubscriptionDetailTableViewControllerTests

- (void)setUp {
    [super setUp];
    self.tableViewController = [GGPSubscriptionDetailTableViewController new];
}

- (void)tearDown {
    self.tableViewController = nil;
    [super tearDown];
}

- (void)testExample {
    NSString *expectedString = @"mallId1";
    XCTAssertEqualObjects([self.tableViewController userMallIdStringFromRowIndex:0], expectedString);
}

- (void)testDeselect {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableViewController.tableView deselectRowAtIndexPath:path animated:YES];
    XCTAssertEqual([self.tableViewController.tableView cellForRowAtIndexPath:path].accessoryType, UITableViewCellAccessoryNone);
}

@end
