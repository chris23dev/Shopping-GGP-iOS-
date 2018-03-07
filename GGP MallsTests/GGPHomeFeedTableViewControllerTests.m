//
//  GGPHomeFeedTableViewControllerTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCategory.h"
#import "GGPHomeFeedTableViewController.h"
#import "GGPHero.h"
#import "GGPJMapManager.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPPromotion.h"
#import "GGPTenant.h"
#import "NSDate+GGPAdditions.h"

@interface GGPHomeFeedTableViewController (Testing)

- (NSArray *)allUniqueNowOpenTenantsFromTenants:(NSArray *)tenants;
- (GGPHero *)heroForDisplayFromHeroes:(NSArray *)heroes;
- (BOOL)shouldShowPromotionCellForRow:(NSInteger)row;
- (BOOL)shouldShowLoadingCell;
- (NSInteger)numberOfPagesForItemCount:(NSInteger)itemCount andPageSize:(NSInteger)pageSize;
- (NSInteger)startIndexForPage:(NSInteger)page withPageSize:(NSInteger)pageSize;
- (NSInteger)pageFetchLengthForCurrentPage:(NSInteger)currentPage totalPages:(NSInteger)totalPages pageSize:(NSInteger)pageSize andItemCount:(NSInteger)itemCount;
- (NSArray *)alertActionsForPromotion:(GGPPromotion *)promotion;

@property (strong, nonatomic) NSArray *sales;
@property (strong, nonatomic) NSMutableDictionary *saleImageLookup;

@end

@interface GGPHomeFeedTableViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPHomeFeedTableViewController *feedViewController;

@end

@implementation GGPHomeFeedTableViewControllerTests

- (void)setUp {
    [super setUp];
    self.feedViewController = [GGPHomeFeedTableViewController new];
}

- (void)tearDown {
    self.feedViewController = nil;
    [super tearDown];
}

- (void)testAllUniqueNowOpenTenants {
    GGPCategory *nowOpenCategory = OCMPartialMock([GGPCategory new]);
    [OCMStub([nowOpenCategory code]) andReturn:GGPCategoryTenantOpeningsCode];
    
    id mockTenant1 = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant1 isFeaturedOpening]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockTenant2 = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant2 categories]) andReturn:@[nowOpenCategory]];
    
    id mockTenant3 = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant3 isFeaturedOpening]) andReturnValue:OCMOCK_VALUE(YES)];
    
    NSArray *tenants = @[mockTenant1, mockTenant2, [GGPTenant new], mockTenant3];
    NSArray *uniqueTenants = [self.feedViewController allUniqueNowOpenTenantsFromTenants:tenants];
    
    XCTAssertEqual(uniqueTenants.count, 3);
    XCTAssertEqual(uniqueTenants[0], mockTenant1);
    XCTAssertEqual(uniqueTenants[1], mockTenant3);
    XCTAssertEqual(uniqueTenants[2], mockTenant2);
}

- (void)testHeroForDisplay {
    id mockHero1 = OCMPartialMock([GGPHero new]);
    id mockHero2 = OCMPartialMock([GGPHero new]);
    
    NSDate *today = [NSDate date];
    
    [OCMStub([mockHero1 startDate]) andReturn:[NSDate ggp_addDays:1 toDate:today]];
    [OCMStub([mockHero1 endDate]) andReturn:[NSDate ggp_addDays:2 toDate:today]];
    
    [OCMStub([mockHero2 startDate]) andReturn:[NSDate ggp_subtractDays:1 fromDate:today]];
    [OCMStub([mockHero2 endDate]) andReturn:today];
    
    GGPHero *result1 = [self.feedViewController heroForDisplayFromHeroes:@[mockHero1, mockHero2]];
    GGPHero *result2 = [self.feedViewController heroForDisplayFromHeroes:@[mockHero1]];
    
    XCTAssertEqual(result1, mockHero2);
    XCTAssertNil(result2);
}

- (void)testShouldShowPromotionCellForRow {
    self.feedViewController.saleImageLookup = @{}.mutableCopy;
    XCTAssertFalse([self.feedViewController shouldShowPromotionCellForRow:0]);
    
    self.feedViewController.saleImageLookup = @{@1:@1, @2:@2}.mutableCopy;
    XCTAssertTrue([self.feedViewController shouldShowPromotionCellForRow:0]);
    XCTAssertTrue([self.feedViewController shouldShowPromotionCellForRow:1]);
    XCTAssertFalse([self.feedViewController shouldShowPromotionCellForRow:2]);
    XCTAssertFalse([self.feedViewController shouldShowPromotionCellForRow:3]);
}

- (void)testShouldShowLoadingCell {
    self.feedViewController.sales = @[];
    self.feedViewController.saleImageLookup = @{}.mutableCopy;
    XCTAssertFalse([self.feedViewController shouldShowLoadingCell]);
    
    self.feedViewController.sales = @[@1];
    self.feedViewController.saleImageLookup = @{@1:@1}.mutableCopy;
    XCTAssertFalse([self.feedViewController shouldShowLoadingCell]);
    
    self.feedViewController.sales = @[@1, @2];
    self.feedViewController.saleImageLookup = @{@1:@1}.mutableCopy;
    XCTAssertTrue([self.feedViewController shouldShowLoadingCell]);
    
    self.feedViewController.sales = @[@1];
    self.feedViewController.saleImageLookup = @{@1:@1, @2:@2}.mutableCopy;
    XCTAssertFalse([self.feedViewController shouldShowLoadingCell]);
}

- (void)testNumberOfPages {
    NSInteger const pageSize = 10;
    
    XCTAssertEqual([self.feedViewController numberOfPagesForItemCount:0 andPageSize:pageSize], 0);
    XCTAssertEqual([self.feedViewController numberOfPagesForItemCount:9 andPageSize:pageSize], 1);
    XCTAssertEqual([self.feedViewController numberOfPagesForItemCount:10 andPageSize:pageSize], 1);
    XCTAssertEqual([self.feedViewController numberOfPagesForItemCount:19 andPageSize:pageSize], 2);
    XCTAssertEqual([self.feedViewController numberOfPagesForItemCount:30 andPageSize:pageSize], 3);
}

- (void)testStartIndexForPage {
    NSInteger const pageSize = 10;
    
    XCTAssertEqual([self.feedViewController startIndexForPage:1 withPageSize:pageSize], 0);
    XCTAssertEqual([self.feedViewController startIndexForPage:2 withPageSize:pageSize], 10);
    XCTAssertEqual([self.feedViewController startIndexForPage:3 withPageSize:pageSize], 20);
}

- (void)testPageFetchLength {
    NSInteger const pageSize = 10;
    NSInteger const totalPages = 2;
    
    XCTAssertEqual([self.feedViewController pageFetchLengthForCurrentPage:1 totalPages:totalPages pageSize:pageSize andItemCount:20], 10);
    XCTAssertEqual([self.feedViewController pageFetchLengthForCurrentPage:2 totalPages:totalPages pageSize:pageSize andItemCount:20], 10);
    XCTAssertEqual([self.feedViewController pageFetchLengthForCurrentPage:2 totalPages:totalPages pageSize:pageSize andItemCount:17], 7);
}

- (void)testAlertActionsForPromotionHasMapDestination {
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    GGPMall *mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall hasWayFinding]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    id mockJMapManager = OCMPartialMock([GGPJMapManager shared]);
    [OCMStub([mockJMapManager wayfindingAvailableForTenant:OCMOCK_ANY]) andReturnValue:@YES];
    
    GGPTenant *mockTenant = OCMPartialMock([GGPTenant new]);
    
    GGPPromotion *mockPromotion = OCMPartialMock([GGPPromotion new]);
    [OCMStub([mockPromotion tenant]) andReturn:mockTenant];
    
    XCTAssertEqual([self.feedViewController alertActionsForPromotion:mockPromotion].count, 4);
    
    [mockJMapManager stopMocking];
}

- (void)testAlertActionsForPromotionNoMapDestination {
    id mockJMapManager = OCMPartialMock([GGPJMapManager shared]);
    [OCMStub([mockJMapManager wayfindingAvailableForTenant:OCMOCK_ANY]) andReturnValue:@NO];
    
    GGPTenant *mockTenant = OCMPartialMock([GGPTenant new]);
    
    GGPPromotion *mockPromotion = OCMPartialMock([GGPPromotion new]);
    [OCMStub([mockPromotion tenant]) andReturn:mockTenant];
    
    XCTAssertEqual([self.feedViewController alertActionsForPromotion:mockPromotion].count, 3);
    
    [mockJMapManager stopMocking];
}

@end
