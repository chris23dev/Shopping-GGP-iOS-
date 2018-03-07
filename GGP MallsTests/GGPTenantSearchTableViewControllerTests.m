//
//  GGPTenantSearchTableViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenant.h"
#import "GGPTenantSearchNoResultsView.h"
#import "GGPTenantSearchTableViewCell.h"
#import "GGPTenantSearchTableViewController.h"
#import "GGPJMapManager.h"

@interface GGPTenantSearchTableViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPTenantSearchTableViewController *tableController;

@end

@interface GGPTenantSearchTableViewController (Testing)

@property (strong, nonatomic) NSArray *tenants;
@property (strong, nonatomic) NSArray *filteredTenants;

@end

@implementation GGPTenantSearchTableViewControllerTests

- (void)setUp {
    [super setUp];
    self.tableController = [GGPTenantSearchTableViewController new];
}

- (void)tearDown {
    self.tableController = nil;
    [super tearDown];
}

- (void)testConfigureWithTenants {
    id mockTableView = OCMPartialMock(self.tableController.tableView);
    OCMExpect([mockTableView reloadData]);
    
    NSArray *mockTenants = @[];
    
    [self.tableController configureWithTenants:mockTenants];
    
    OCMVerifyAll(mockTableView);
    XCTAssertEqual(self.tableController.tenants, mockTenants);
    XCTAssertEqual(self.tableController.filteredTenants, mockTenants);
}

- (void)testDidSelectRow {
    id mockTenant1 = OCMPartialMock([GGPTenant new]);
    id mockTenant2 = OCMPartialMock([GGPTenant new]);
    id mockDelegate = OCMProtocolMock(@protocol(GGPTenantSearchDelegate));
    
    OCMExpect([mockDelegate didSelectTenant:mockTenant2]);
    
    self.tableController.searchDelegate = mockDelegate;
    self.tableController.filteredTenants = @[mockTenant1, mockTenant2];
    
    [self.tableController tableView:self.tableController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    OCMVerifyAll(mockDelegate);
}

- (void)testUpdateSearchResultsEmptySearch {
    UISearchController *mockSearchController = OCMPartialMock([UISearchController new]);
    id mockSearchBar = OCMPartialMock([UISearchBar new]);
    
    [OCMStub([mockSearchBar text]) andReturn:@""];
    [OCMStub([mockSearchController searchBar]) andReturn:mockSearchBar];
    
    [self.tableController updateSearchResultsForSearchController:mockSearchController];
    
    XCTAssertEqualObjects(self.tableController.filteredTenants, self.tableController.tenants);
}

- (void)testFormatTenantNamesForDisplay {
    GGPTenant *mockTenant1 = OCMPartialMock([GGPTenant new]);
    GGPTenant *mockTenant2 = OCMPartialMock([GGPTenant new]);
    GGPTenant *mockTenant3 = OCMPartialMock([GGPTenant new]);
    GGPTenant *mockTenant4 = OCMPartialMock([GGPTenant new]);
    GGPTenant *mockTenant5 = OCMPartialMock([GGPTenant new]);
    
    [OCMStub([mockTenant1 name]) andReturn:@"ATM"];
    [OCMStub([mockTenant2 name]) andReturn:@"ATM"];
    [OCMStub([mockTenant3 name]) andReturn:@"ATM"];
    [OCMStub([mockTenant4 name]) andReturn:@"Sears"];
    [OCMStub([mockTenant5 name]) andReturn:@"ATM"];
    
    [OCMStub(mockTenant5.parentTenant) andReturn:mockTenant4];
    
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    [OCMStub([mockMapController nearbyLocationDescriptionForTenant:mockTenant1]) andReturn:@"near Macy's"];
    [OCMStub([mockMapController nearbyLocationDescriptionForTenant:mockTenant2]) andReturn:@"near Macy's"];
    [OCMStub([mockMapController nearbyLocationDescriptionForTenant:mockTenant3]) andReturn:@"near Sears"];
    
    [OCMStub([mockMapController locationDescriptionForTenant:mockTenant1]) andReturn:@"Level 1, near Macy's"];
    
    [OCMStub([mockMapController locationDescriptionForTenant:mockTenant2]) andReturn:@"Level 2, near Macy's"];
    
    NSArray *mockTenants = @[mockTenant1, mockTenant2, mockTenant3, mockTenant4, mockTenant5];
    
    [self.tableController formatTenantNamesForDisplay:mockTenants];
    
    XCTAssertEqualObjects(mockTenant1.displayName, @"ATM - Level 1, near Macy's");
    XCTAssertEqualObjects(mockTenant2.displayName, @"ATM - Level 2, near Macy's");
    XCTAssertEqualObjects(mockTenant3.displayName, @"ATM - near Sears");
    XCTAssertEqualObjects(mockTenant4.displayName, @"Sears");
    XCTAssertEqualObjects(mockTenant5.displayName, @"ATM - inside Sears");
    
    [mockMapController stopMocking];
}

@end
