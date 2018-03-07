//
//  GGPShoppingRefineStoreFilterTableViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/12/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPUser.h"
#import "GGPAccount.h"
#import "GGPTenant.h"
#import "GGPShoppingRefineStoreFilterTableViewController.h"

@interface GGPShoppingRefineStoreFilterTableViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPShoppingRefineStoreFilterTableViewController *tableViewController;

@end

@interface GGPShoppingRefineStoreFilterTableViewController (Testing)

@property (strong, nonatomic) NSMutableArray *filteredTenants;
@property (strong, nonatomic) NSArray *tenants;
@property (assign, nonatomic) BOOL includeUserFavorites;

- (void)handleSelectedTenant:(GGPTenant *)tenant;
- (void)handleDeselectedTenant:(GGPTenant *)tenant;

- (void)handleFavoritesRowSelected;
- (void)handleFavoritesRowDeselected;

- (void)clearAllTapped;

- (BOOL)userHasFavoritesInTenants;

@end

@implementation GGPShoppingRefineStoreFilterTableViewControllerTests

- (void)setUp {
    [super setUp];
    self.tableViewController = [GGPShoppingRefineStoreFilterTableViewController new];
    [self.tableViewController view];
}

- (void)tearDown {
    self.tableViewController = nil;
    [super tearDown];
}

- (void)testHandleSelectedTenantDoesNotContainTenant {
    GGPTenant *mockTenant = [GGPTenant new];
    
    id mockTableViewController = OCMPartialMock(self.tableViewController);
    [OCMStub([mockTableViewController filteredTenants]) andReturn:[NSMutableArray new]];
    
    
    [mockTableViewController handleSelectedTenant:mockTenant];
    XCTAssertEqual([mockTableViewController filteredTenants].count, 1);
}

- (void)testHandleSelectedTenantDoesContainTenant {
    GGPTenant *filteredTenant = [GGPTenant new];
    
    id mockTableViewController = OCMPartialMock(self.tableViewController);
    [OCMStub([mockTableViewController filteredTenants]) andReturn:[NSMutableArray arrayWithObject:filteredTenant]];
    
    
    [mockTableViewController handleSelectedTenant:filteredTenant];
    XCTAssertEqual([mockTableViewController filteredTenants].count, 1);
}

- (void)testHandleDeselectedTenantContainsTenant {
    GGPTenant *filteredTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([filteredTenant tenantId]) andReturnValue:OCMOCK_VALUE(@(123))];
    
    id mockTableViewController = OCMPartialMock(self.tableViewController);
    [OCMStub([mockTableViewController filteredTenants]) andReturn:[NSMutableArray arrayWithObject:filteredTenant]];
    
    GGPTenant *tappedTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([tappedTenant tenantId]) andReturnValue:OCMOCK_VALUE(@(123))];
    
    [mockTableViewController handleDeselectedTenant:filteredTenant];
    XCTAssertEqual([mockTableViewController filteredTenants].count, 0);
}

- (void)testHandleDeselectedTenantDoesNotContainsTenant {
    GGPTenant *filteredTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([filteredTenant tenantId]) andReturnValue:OCMOCK_VALUE(@(123))];
    
    id mockTableViewController = OCMPartialMock(self.tableViewController);
    [OCMStub([mockTableViewController filteredTenants]) andReturn:[NSMutableArray arrayWithObject:filteredTenant]];
    
    GGPTenant *tappedTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([tappedTenant tenantId]) andReturnValue:OCMOCK_VALUE(@(11111))];
    
    [mockTableViewController handleDeselectedTenant:tappedTenant];
    XCTAssertEqual([mockTableViewController filteredTenants].count, 1);
}

- (void)testHandleDeselectedTenantIsFavorite {
    GGPTenant *tappedTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([tappedTenant isFavorite]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockTableViewController = OCMPartialMock(self.tableViewController);
    
    [mockTableViewController handleDeselectedTenant:tappedTenant];
    XCTAssertFalse([mockTableViewController includeUserFavorites]);
}

- (void)testHandleFavoritesRowSelectedTenantIsFavoriteNotFiltered {
    GGPTenant *nonFilteredFavoriteTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([nonFilteredFavoriteTenant isFavorite]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockTableViewController = OCMPartialMock(self.tableViewController);
    [OCMStub([mockTableViewController tenants]) andReturn:@[nonFilteredFavoriteTenant]];
    [OCMStub([mockTableViewController filteredTenants]) andReturn:[NSMutableArray new]];
    
    [mockTableViewController handleFavoritesRowSelected];
    
    XCTAssertTrue([mockTableViewController includeUserFavorites]);
    XCTAssertEqual([mockTableViewController filteredTenants].count, 1);
}

- (void)testHandleFavoritesRowSelectedTenantNotFavoriteNotFiltered {
    GGPTenant *nonFilteredNonFavoriteTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([nonFilteredNonFavoriteTenant isFavorite]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockTableViewController = OCMPartialMock(self.tableViewController);
    [OCMStub([mockTableViewController tenants]) andReturn:@[nonFilteredNonFavoriteTenant]];
    [OCMStub([mockTableViewController filteredTenants]) andReturn:[NSMutableArray new]];
    
    [mockTableViewController handleFavoritesRowSelected];
    
    XCTAssertTrue([mockTableViewController includeUserFavorites]);
    XCTAssertEqual([mockTableViewController filteredTenants].count, 0);
}

- (void)testHandleFavoritesRowSelectedTenantIsFavoriteIsFiltered {
    GGPTenant *filteredFavoriteTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([filteredFavoriteTenant isFavorite]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockTableViewController = OCMPartialMock(self.tableViewController);
    [OCMStub([mockTableViewController tenants]) andReturn:@[filteredFavoriteTenant]];
    [OCMStub([mockTableViewController filteredTenants]) andReturn:[NSMutableArray arrayWithObject:filteredFavoriteTenant]];
    
    [mockTableViewController handleFavoritesRowSelected];
    
    XCTAssertTrue([mockTableViewController includeUserFavorites]);
    XCTAssertEqual([mockTableViewController filteredTenants].count, 1);
}

- (void)testHandleFavoritesRowDeSelectedTenantIsFavoriteNotFiltered {
    GGPTenant *filteredTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([filteredTenant tenantId]) andReturnValue:OCMOCK_VALUE(@(123))];
    
    GGPTenant *nonFilteredFavoriteTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([nonFilteredFavoriteTenant isFavorite]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockTableViewController = OCMPartialMock(self.tableViewController);
    [OCMStub([mockTableViewController tenants]) andReturn:@[nonFilteredFavoriteTenant]];
    [OCMStub([mockTableViewController filteredTenants]) andReturn:[NSMutableArray arrayWithObject:filteredTenant]];
    
    [mockTableViewController handleFavoritesRowDeselected];
    
    XCTAssertFalse([mockTableViewController includeUserFavorites]);
    XCTAssertEqual([mockTableViewController filteredTenants].count, 1);
}

- (void)testHandleFavoritesRowDeSelectedTenantNotFavoriteNotFiltered {
    GGPTenant *filteredTenant = OCMPartialMock([GGPTenant new]);
    
    GGPTenant *nonFilteredNonFavoriteTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([nonFilteredNonFavoriteTenant isFavorite]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockTableViewController = OCMPartialMock(self.tableViewController);
    [OCMStub([mockTableViewController tenants]) andReturn:@[nonFilteredNonFavoriteTenant]];
    [OCMStub([mockTableViewController filteredTenants]) andReturn:[NSMutableArray arrayWithObject:filteredTenant]];
    
    [mockTableViewController handleFavoritesRowDeselected];
    
    XCTAssertFalse([mockTableViewController includeUserFavorites]);
    XCTAssertEqual([mockTableViewController filteredTenants].count, 1);
}

- (void)testHandleFavoritesRowDeSelectedTenantIsFavoriteIsFiltered {
    id mockTableViewController = OCMPartialMock([GGPShoppingRefineStoreFilterTableViewController new]);
    
    GGPTenant *favoriteTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([favoriteTenant isFavorite]) andReturnValue:OCMOCK_VALUE(YES)];
    
    [OCMStub([mockTableViewController filteredTenants]) andReturn:@[favoriteTenant]];
    
    [self.tableViewController handleFavoritesRowDeselected];
    
    XCTAssertFalse([self.tableViewController includeUserFavorites]);
    XCTAssertEqual([self.tableViewController filteredTenants].count, 0);
}

- (void)testClearAllTapped {
    GGPTenant *tenant = OCMPartialMock([GGPTenant new]);
    
    self.tableViewController.filteredTenants = [NSMutableArray arrayWithObject:tenant];

    [self.tableViewController clearAllTapped];
    
    XCTAssertFalse(self.tableViewController.includeUserFavorites);
    XCTAssertEqual(self.tableViewController.filteredTenants.count, 0);
}

- (void)testUserHasFavoritesInTenantsNoFavorites {
    GGPUser *mockUser = OCMPartialMock([GGPUser new]);
    [OCMStub([mockUser favorites]) andReturn:@[]];
    
    id mockAccount = OCMPartialMock([GGPAccount shared]);
    [OCMStub([mockAccount currentUser]) andReturn:mockUser];
    
    XCTAssertFalse([self.tableViewController userHasFavoritesInTenants]);
}

- (void)testUserHasFavoritesInTenantsHasFavorites {
    id mockTableViewController = OCMPartialMock(self.tableViewController);
    
    GGPTenant *mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant placeWiseRetailerId]) andReturnValue:OCMOCK_VALUE(123)];
    NSInteger placeWiseId = mockTenant.placeWiseRetailerId;
    
    GGPUser *mockUser = OCMPartialMock([GGPUser new]);
    [OCMStub([mockUser favorites]) andReturn:@[@(placeWiseId)]];
    
    id mockAccount = OCMPartialMock([GGPAccount shared]);
    [OCMStub([mockAccount currentUser]) andReturn:mockUser];
    
    [OCMStub([mockTableViewController tenants]) andReturn:@[mockTenant]];
    
    XCTAssertTrue([self.tableViewController userHasFavoritesInTenants]);
}

- (void)testUserHasNoFavoritesInTenantsHasFavorites {
    id mockTableViewController = OCMPartialMock(self.tableViewController);
    
    GGPTenant *mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant placeWiseRetailerId]) andReturnValue:OCMOCK_VALUE(123)];
    NSInteger placeWiseId = mockTenant.placeWiseRetailerId;
    
    GGPUser *mockUser = OCMPartialMock([GGPUser new]);
    [OCMStub([mockUser favorites]) andReturn:@[@(placeWiseId)]];
    
    id mockAccount = OCMPartialMock([GGPAccount shared]);
    [OCMStub([mockAccount currentUser]) andReturn:mockUser];
    
    GGPTenant *tenantFromCategory = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTableViewController tenants]) andReturn:@[tenantFromCategory]];
    
    XCTAssertFalse([self.tableViewController userHasFavoritesInTenants]);
}

@end
