//
//  GGPTenantTableViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/17/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPTenantTableViewController.h"
#import "GGPTenantTableCell.h"
#import "GGPTenant.h"

@interface GGPTenantTableViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPTenantTableViewController *tenantTableViewController;

@end

@interface GGPTenantTableViewController (Testing)

- (BOOL)shouldDisplaySwipeHintForRow:(NSInteger)row andCell:(GGPTenantTableCell *)cell;

@property (strong, nonatomic) NSArray *tenants;
@property (assign, nonatomic) BOOL hideAlpha;
@property (assign, nonatomic) BOOL isCellExpanded;
@property (assign, nonatomic) BOOL displayedSwipeHint;

@end

@implementation GGPTenantTableViewControllerTests

- (void)setUp {
    [super setUp];
    self.tenantTableViewController = [GGPTenantTableViewController new];
    [self.tenantTableViewController view];
}

- (void)tearDown {
    self.tenantTableViewController = nil;
    [super tearDown];
}

- (void)testTenantCellIsRegistered {
    GGPTenantTableCell *cell = [self.tenantTableViewController.tableView dequeueReusableCellWithIdentifier:GGPTenantTableCellReuseIdentifier];
    XCTAssertNotNil(cell);
}

- (void)testDidSelectRow {
    NSArray *tenants = @[[GGPTenant new], [GGPTenant new]];
    id mockDelegate = OCMProtocolMock(@protocol(GGPTenantListDelegate));
    self.tenantTableViewController.delegate = mockDelegate;
    OCMExpect([mockDelegate selectedTenant:tenants[1]]);
    
    [self.tenantTableViewController tableView:self.tenantTableViewController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    OCMVerify(mockDelegate);
}

- (NSArray *)createArrayOfMockTenants {
    GGPTenant *tenant1 = OCMPartialMock([GGPTenant new]);
    GGPTenant *tenant2 = OCMPartialMock([GGPTenant new]);
    GGPTenant *tenant3 = OCMPartialMock([GGPTenant new]);
    GGPTenant *tenant4 = OCMPartialMock([GGPTenant new]);
    
    [OCMStub(tenant1.name) andReturn:@"Bebe"];
    [OCMStub(tenant2.name) andReturn:@"Aldo"];
    [OCMStub(tenant3.name) andReturn:@"Candy"];
    [OCMStub(tenant4.name) andReturn:@"Banana"];
    
    return @[tenant1, tenant2, tenant3, tenant4];
}

- (void)testSectionIndexTitles {
    self.tenantTableViewController.hideAlpha = YES;
    self.tenantTableViewController.isCellExpanded = YES;
    XCTAssertNil([self.tenantTableViewController sectionIndexTitlesForTableView:self.tenantTableViewController.tableView]);
    
    self.tenantTableViewController.hideAlpha = YES;
    self.tenantTableViewController.isCellExpanded = NO;
    XCTAssertNil([self.tenantTableViewController sectionIndexTitlesForTableView:self.tenantTableViewController.tableView]);
    
    self.tenantTableViewController.hideAlpha = NO;
    self.tenantTableViewController.isCellExpanded = YES;
    XCTAssertNil([self.tenantTableViewController sectionIndexTitlesForTableView:self.tenantTableViewController.tableView]);
    
    self.tenantTableViewController.hideAlpha = NO;
    self.tenantTableViewController.isCellExpanded = NO;
    XCTAssertNotNil([self.tenantTableViewController sectionIndexTitlesForTableView:self.tenantTableViewController.tableView]);
}

- (void)testShouldDisplaySwipeHintForRow {
    GGPTenantTableCell *cell = [GGPTenantTableCell new];
    
    self.tenantTableViewController.displayedSwipeHint = NO;
    cell.rightButtons = @[[MGSwipeButton new]];
    XCTAssertFalse([self.tenantTableViewController shouldDisplaySwipeHintForRow:0 andCell:cell]);
    XCTAssertTrue([self.tenantTableViewController shouldDisplaySwipeHintForRow:1 andCell:cell]);
    XCTAssertTrue([self.tenantTableViewController shouldDisplaySwipeHintForRow:2 andCell:cell]);
    XCTAssertTrue([self.tenantTableViewController shouldDisplaySwipeHintForRow:3 andCell:cell]);
    XCTAssertFalse([self.tenantTableViewController shouldDisplaySwipeHintForRow:4 andCell:cell]);
    
    self.tenantTableViewController.displayedSwipeHint = YES;
    cell.rightButtons = @[[MGSwipeButton new]];
    XCTAssertFalse([self.tenantTableViewController shouldDisplaySwipeHintForRow:0 andCell:cell]);
    XCTAssertFalse([self.tenantTableViewController shouldDisplaySwipeHintForRow:1 andCell:cell]);
    XCTAssertFalse([self.tenantTableViewController shouldDisplaySwipeHintForRow:2 andCell:cell]);
    XCTAssertFalse([self.tenantTableViewController shouldDisplaySwipeHintForRow:3 andCell:cell]);
    XCTAssertFalse([self.tenantTableViewController shouldDisplaySwipeHintForRow:4 andCell:cell]);
    
    self.tenantTableViewController.displayedSwipeHint = NO;
    cell.rightButtons = @[];
    XCTAssertFalse([self.tenantTableViewController shouldDisplaySwipeHintForRow:0 andCell:cell]);
    XCTAssertFalse([self.tenantTableViewController shouldDisplaySwipeHintForRow:1 andCell:cell]);
    XCTAssertFalse([self.tenantTableViewController shouldDisplaySwipeHintForRow:2 andCell:cell]);
    XCTAssertFalse([self.tenantTableViewController shouldDisplaySwipeHintForRow:3 andCell:cell]);
    XCTAssertFalse([self.tenantTableViewController shouldDisplaySwipeHintForRow:4 andCell:cell]);
}

@end
