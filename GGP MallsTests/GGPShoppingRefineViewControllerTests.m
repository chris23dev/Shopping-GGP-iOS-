//
//  GGPShoppingRefineViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPSale.h"
#import "GGPRefineOptions.h"
#import "GGPShoppingRefineViewController.h"
#import "NSDate+GGPAdditions.h"

static NSInteger const kStoreFilterSection = 0;

@interface GGPShoppingRefineViewControllerTests : XCTestCase

@property GGPShoppingRefineViewController *viewController;

@end

@interface GGPShoppingRefineViewController (Testing)

@property NSArray *sales;
@property GGPRefineOptions *refineOptions;

- (BOOL)isClearAllRowForIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)filterSales:(NSArray *)sales forFilteredTenants:(NSArray *)filteredTenants;
- (NSArray *)sortSales:(NSArray *)filteredSales forSortType:(GGPRefineSortType)sortType;

@end

@implementation GGPShoppingRefineViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [GGPShoppingRefineViewController new];
}

- (void)tearDown {
    self.viewController = nil;
    [super tearDown];
}

- (void)testIsClearAllRowForIndexPathIsSectionIsRowHasTenants {
    id mockViewController = OCMPartialMock(self.viewController);
    id mockRefineOptions = OCMPartialMock([GGPRefineOptions new]);
    GGPTenant *mockTenant = [GGPTenant new];
    
    [OCMStub([mockRefineOptions tenants]) andReturn:@[mockTenant]];
    [OCMStub([mockViewController refineOptions]) andReturn:mockRefineOptions];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    
    XCTAssertTrue([mockViewController isClearAllRowForIndexPath:indexPath]);
}

- (void)testIsClearAllRowForIndexPathIsSectionIsRowNoTenants {
    id mockViewController = OCMPartialMock(self.viewController);
    id mockRefineOptions = OCMPartialMock([GGPRefineOptions new]);
    
    [OCMStub([mockRefineOptions tenants]) andReturn:@[]];
    [OCMStub([mockViewController refineOptions]) andReturn:mockRefineOptions];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    XCTAssertFalse([mockViewController isClearAllRowForIndexPath:indexPath]);
}

- (void)testIsClearAllRowForIndexPathIsSectionNotRowNoTenants {
    id mockViewController = OCMPartialMock(self.viewController);
    id mockRefineOptions = OCMPartialMock([GGPRefineOptions new]);
    
    [OCMStub([mockRefineOptions tenants]) andReturn:@[]];
    [OCMStub([mockViewController refineOptions]) andReturn:mockRefineOptions];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    XCTAssertFalse([mockViewController isClearAllRowForIndexPath:indexPath]);
}

- (void)testIsClearAllRowForIndexPathNotSectionNotRowNoTenants {
    id mockViewController = OCMPartialMock(self.viewController);
    id mockRefineOptions = OCMPartialMock([GGPRefineOptions new]);
    
    [OCMStub([mockRefineOptions tenants]) andReturn:@[]];
    [OCMStub([mockViewController refineOptions]) andReturn:mockRefineOptions];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    XCTAssertFalse([mockViewController isClearAllRowForIndexPath:indexPath]);
}

- (void)testIsClearAllRowForIndexPathIsSectionNotRowWithTenants {
    id mockViewController = OCMPartialMock(self.viewController);
    id mockRefineOptions = OCMPartialMock([GGPRefineOptions new]);
    GGPTenant *mockTenant = [GGPTenant new];
    
    [OCMStub([mockRefineOptions tenants]) andReturn:@[mockTenant]];
    [OCMStub([mockViewController refineOptions]) andReturn:mockRefineOptions];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:kStoreFilterSection];
    
    XCTAssertFalse([mockViewController isClearAllRowForIndexPath:indexPath]);
}

- (void)testIsClearAllRowForIndexPathNotSectionIsRowWithTenants {
    id mockViewController = OCMPartialMock(self.viewController);
    id mockRefineOptions = OCMPartialMock([GGPRefineOptions new]);
    GGPTenant *mockTenant = [GGPTenant new];
    
    [OCMStub([mockRefineOptions tenants]) andReturn:@[mockTenant]];
    [OCMStub([mockViewController refineOptions]) andReturn:mockRefineOptions];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
    
    XCTAssertFalse([mockViewController isClearAllRowForIndexPath:indexPath]);
}

- (void)testFilterSalesfromFilteredTenantsHasFilteredSales {
    GGPTenant *filteredTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([filteredTenant tenantId]) andReturnValue:OCMOCK_VALUE(123)];
    
    GGPSale *mockSale = OCMPartialMock([GGPSale new]);
    [OCMStub([mockSale tenant]) andReturn:filteredTenant];
    
    NSArray *sales = @[mockSale];
    NSArray *filteredTenants = @[filteredTenant];
    
    XCTAssertEqual([self.viewController filterSales:sales forFilteredTenants:filteredTenants].count, 1);
}

- (void)testFilterSalesfromFilteredTenantsNoFilteredSales {
    GGPTenant *filteredTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([filteredTenant tenantId]) andReturnValue:OCMOCK_VALUE(123)];
    
    GGPTenant *saleTenant = [GGPTenant new];
    GGPSale *mockSale = OCMPartialMock([GGPSale new]);
    [OCMStub([mockSale tenant]) andReturn:saleTenant];
    
    NSArray *sales = @[mockSale];
    NSArray *filteredTenants = @[filteredTenant];
    
    XCTAssertEqual([self.viewController filterSales:sales forFilteredTenants:filteredTenants].count, 0);
}

- (void)testSortSalesforSortType {
    NSDate *today = [NSDate new];
    NSDate *tomorrow = [NSDate ggp_addDays:1 toDate:today];
    
    GGPTenant *ATenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([ATenant name]) andReturn:@"Abercrombie"];
    
    GGPSale *ASale = OCMPartialMock([GGPSale new]);
    [OCMStub([ASale tenant]) andReturn:ATenant];
    [OCMStub([ASale endDateTime]) andReturn:tomorrow];
    
    GGPTenant *BTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([BTenant name]) andReturn:@"bebe"];
    
    GGPSale *BSale = OCMPartialMock([GGPSale new]);
    [OCMStub([BSale tenant]) andReturn:BTenant];
    [OCMStub([BSale endDateTime]) andReturn:today];
    
    GGPTenant *CTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([CTenant name]) andReturn:@"Carters"];
    
    GGPSale *CSale = OCMPartialMock([GGPSale new]);
    [OCMStub([CSale tenant]) andReturn:CTenant];
    [OCMStub([CSale endDateTime]) andReturn:tomorrow];
    
    NSArray *sales = @[ASale, BSale, CSale];
    NSArray *salesAlphaOrdered = @[ASale, BSale, CSale];
    NSArray *salesReversedAlphaOrdered = @[CSale, BSale, ASale];
    NSArray *salesOrderedByDate = @[BSale, ASale, CSale];
    
    XCTAssertEqualObjects([self.viewController sortSales:sales forSortType:GGPRefineSortByAlpha], salesAlphaOrdered);
    XCTAssertEqualObjects([self.viewController sortSales:sales forSortType:GGPRefineSortByReverseAlpha], salesReversedAlphaOrdered);
    XCTAssertEqualObjects([self.viewController sortSales:sales forSortType:GGPRefineSortByEndDate], salesOrderedByDate);
}

@end
