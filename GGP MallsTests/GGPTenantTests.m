//
//  GGPTenantTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 1/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPBrand.h"
#import "GGPCategory.h"
#import "GGPExceptionHours.h"
#import "GGPHours.h"
#import "GGPHours+Tests.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPTenant.h"
#import "GGPUser.h"
#import "NSString+GGPAdditions.h"

@interface GGPTenantTests : XCTestCase

@end

@interface GGPTenant (Testing)

- (NSString *)prettyPrintCategories;
- (NSArray *)filteredCategoryNamesForDisplay;
- (NSString *)formattedOpenHoursStringForDate:(NSDate *)date;
- (NSArray *)openHoursForDate:(NSDate *)date;

- (BOOL)isParentCategory:(GGPCategory *)category;

@end

@implementation GGPTenantTests

- (void)testTenantLogoUrl {
    GGPTenant *tenant1 = OCMPartialMock([GGPTenant new]);
    [OCMStub([tenant1 nonSvgLogoUrl]) andReturn:@"https://somelogourl.com"];
    
    GGPTenant *tenant2 = OCMPartialMock([GGPTenant new]);
    [OCMStub([tenant2 nonSvgLogoUrl]) andReturn:nil];
    
    XCTAssertNotNil(tenant1.tenantLogoUrl);
    XCTAssertNil(tenant2.tenantLogoUrl);
}

- (void)testHoursHeaderHasTodayHours {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant hasHoursForToday]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockTenant formattedOpenHoursStringForDate:OCMOCK_ANY]) andReturn:@"Monday 10AM - 10PM"];
    
    NSString *expectedString = [NSString stringWithFormat:@"%@\t%@", [@"DETAILS_HOURS_HEADER_TODAY" ggp_toLocalized], @"Monday 10AM - 10PM"];
    XCTAssertEqualObjects([mockTenant formattedHoursHeader], expectedString);
}

- (void)testHoursHeaderDoesNotHaveTodayHours {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant hasHoursForToday]) andReturnValue:OCMOCK_VALUE(NO)];
    
    NSString *expectedString = [@"DETAILS_HOURS_HEADER_STORE" ggp_toLocalized];
    XCTAssertEqualObjects([mockTenant formattedHoursHeader], expectedString);
}

- (void)testFormattedWeeklyHours {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    NSArray *operatingHours = @[[GGPHours createTodayOperatingHours]];
    [OCMStub([mockTenant operatingHours]) andReturn:operatingHours];
    
    __block NSInteger callCount = 0;
    [OCMStub([mockTenant formattedWeeklyHours]) andDo:^(NSInvocation *invocation) {
        callCount++;
    }];
    
    [mockTenant formattedWeeklyHours];
    
    XCTAssertEqual(callCount, 1);
}

- (void)testPrettyPrintWeeklyHoursDontExist {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([GGPHours openHoursForDate:[NSDate new] hours:nil andExceptionHours:nil]) andReturn:nil];
    
    [[mockTenant reject] formattedOpenHoursStringForDate:OCMOCK_ANY];

    [mockTenant formattedWeeklyHours];
    
    OCMVerifyAll(mockTenant);
}

- (void)testPrettyPrintCategories {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant brands]) andReturn:@[ [GGPBrand new] ]];
    
    [OCMStub([mockTenant filteredCategoryNamesForDisplay]) andReturn:@[@"category 1", @"category 2"]];
    
    NSString *result = [mockTenant prettyPrintCategories];
    XCTAssertEqualObjects(result, @"category 1, category 2");
}

- (void)testPrettyPrintCategoriesHasNoBrand {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant brands]) andReturn:nil];
    XCTAssertEqualObjects([mockTenant prettyPrintCategories], @"");
}

- (void)testFilteredCategoryNamesForDisplay {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    
    GGPCategory *mockCategory1 = OCMPartialMock([GGPCategory new]);
    GGPCategory *mockCategory2 = OCMPartialMock([GGPCategory new]);
    GGPCategory *mockCategory3 = OCMPartialMock([GGPCategory new]);
    
    [OCMStub([mockCategory1 name]) andReturn:@"Food"];
    [OCMStub([mockCategory2 name]) andReturn:@"Restaurants"];
    [OCMStub([mockCategory2 name]) andReturn:nil];
    [OCMStub([mockTenant categories]) andReturn:@[ mockCategory1, mockCategory2, mockCategory3 ]];
    
    [OCMStub([mockTenant isParentCategory:mockCategory1]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockTenant isParentCategory:mockCategory2]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockTenant isParentCategory:mockCategory3]) andReturnValue:OCMOCK_VALUE(NO)];
    
    NSArray *result = [mockTenant filteredCategoryNamesForDisplay];
    
    XCTAssertEqual(result.count, 1);
    XCTAssertEqualObjects(result.firstObject, @"Restaurants");
}

- (void)testIsParentCategory {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    id mockCategory1 = OCMPartialMock([GGPCategory new]);
    id mockCategory2 = OCMPartialMock([GGPCategory new]);
    
    [OCMStub([mockCategory1 parentId]) andReturnValue:OCMOCK_VALUE(3)];
    [OCMStub([mockCategory1 filterId]) andReturnValue:OCMOCK_VALUE(18)];
    [OCMStub([mockCategory2 parentId]) andReturnValue:OCMOCK_VALUE(0)];
    [OCMStub([mockCategory2 filterId]) andReturnValue:OCMOCK_VALUE(3)];

    [OCMStub([mockTenant categories]) andReturn:@[ mockCategory1, mockCategory2 ]];
    
    XCTAssertFalse([mockTenant isParentCategory:mockCategory1]);
    XCTAssertTrue([mockTenant isParentCategory:mockCategory2]);
}

- (void)testOpenTableUrl {
    GGPTenant *mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant openTableId]) andReturnValue:@(1234)];
    
    NSURL *expectedUrl = [NSURL URLWithString:@"http://www.opentable.com/single.aspx?rid=1234&rtype=ism&restref=1234"];
    
    XCTAssertEqualObjects([mockTenant openTableUrl], expectedUrl);
}

- (void)testIsFavorite {
    id mockAccount = OCMPartialMock([GGPAccount shared]);
    id mockUser = OCMPartialMock([GGPUser new]);
    [OCMStub([mockAccount currentUser]) andReturn:mockUser];
    [OCMStub([mockUser favorites]) andReturn:@[@(100), @(200)]];
    
    GGPTenant *mockTenant1 = OCMPartialMock([GGPTenant new]);
    GGPTenant *mockTenant2 = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant1 placeWiseRetailerId]) andReturnValue:OCMOCK_VALUE(100)];
    [OCMStub([mockTenant1 placeWiseRetailerId]) andReturnValue:OCMOCK_VALUE(300)];
    
    XCTAssertTrue(mockTenant1.isFavorite);
    XCTAssertFalse(mockTenant2.isFavorite);
    
    [mockAccount stopMocking];
}

- (void)testSortName {
    GGPTenant *mockTenant1 = OCMPartialMock([GGPTenant new]);
    GGPTenant *mockTenant2 = OCMPartialMock([GGPTenant new]);
    
    [OCMStub([mockTenant1 name]) andReturn:@"the gap"];
    [OCMStub([mockTenant2 name]) andReturn:@"Then and Now"];
    
    XCTAssertEqualObjects(mockTenant1.sortName, @"GAP");
    XCTAssertEqualObjects(mockTenant2.sortName, @"THEN AND NOW");
}

- (void)testListOrderName {
    GGPTenant *mockTenant1 = OCMPartialMock([GGPTenant new]);
    GGPTenant *mockTenant2 = OCMPartialMock([GGPTenant new]);
    GGPTenant *mockTenantClosed = OCMPartialMock([GGPTenant new]);
    
    [OCMStub([mockTenant1 name]) andReturn:@"the gap"];
    [OCMStub([mockTenant2 name]) andReturn:@"Then and Now"];
    [OCMStub([mockTenantClosed temporarilyClosed]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockTenantClosed name]) andReturn:@"The Closed Tenant"];
    
    XCTAssertEqualObjects(mockTenant1.listOrderName, @"GAP");
    XCTAssertEqualObjects(mockTenant2.listOrderName, @"THEN AND NOW");
    XCTAssertEqualObjects(mockTenantClosed.listOrderName, @"CLOSED TENANT (TEMPORARILY CLOSED)");
}

- (void)testDisplayName {
    GGPTenant *mockTenantOpen = OCMPartialMock([GGPTenant new]);
    GGPTenant *mockTenantClosed = OCMPartialMock([GGPTenant new]);
    
    [OCMStub([mockTenantOpen temporarilyClosed]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockTenantOpen name]) andReturn:@"Open Tenant"];
    [OCMStub([mockTenantClosed temporarilyClosed]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockTenantClosed name]) andReturn:@"Closed Tenant"];
    
    XCTAssertEqualObjects(mockTenantOpen.displayName, @"Open Tenant");
    XCTAssertEqualObjects(mockTenantClosed.displayName, @"Closed Tenant (Temporarily Closed)");
}

- (void)testOpenTenantsFromAllTenants {
    id mockClosedTenant = OCMPartialMock([GGPTenant new]);
    id mockOpenTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockOpenTenant temporarilyClosed]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockClosedTenant temporarilyClosed]) andReturnValue:OCMOCK_VALUE(YES)];
    
    NSArray *expectedTenants = @[mockOpenTenant];
    NSArray *allTenants = @[mockClosedTenant, mockOpenTenant];
    
    XCTAssertEqual([GGPTenant openTenantsFromAllTenants:allTenants].count, 1);
    XCTAssertEqualObjects([GGPTenant openTenantsFromAllTenants:allTenants], expectedTenants);
}

- (void)testWayFindingEnabledTenantsFromAllTenants {
    id mockNonWayfindingTenant = OCMPartialMock([GGPTenant new]);
    id mockWayfindingTenant = OCMPartialMock([GGPTenant new]);
    id mockJMapManager = OCMPartialMock([GGPJMapManager shared]);
    
    [OCMStub([mockJMapManager wayfindingAvailableForTenant:mockNonWayfindingTenant]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockJMapManager wayfindingAvailableForTenant:mockWayfindingTenant]) andReturnValue:OCMOCK_VALUE(YES)];
    
    NSArray *expectedTenants = @[ mockWayfindingTenant ];
    NSArray *allTenants = @[ mockNonWayfindingTenant, mockWayfindingTenant ];
    
    XCTAssertEqual([GGPTenant wayFindingEnabledTenantsFromAllTenants:allTenants].count, 1);
    XCTAssertEqualObjects([GGPTenant wayFindingEnabledTenantsFromAllTenants:allTenants], expectedTenants);
    
    [mockJMapManager stopMocking];
}

- (void)testPerformSearchWithParams {
    id mockTenant1 = OCMPartialMock([GGPTenant new]);
    id mockTenant2 = OCMPartialMock([GGPTenant new]);
    id mockTenant3 = OCMPartialMock([GGPTenant new]);
    id mockTenant4 = OCMPartialMock([GGPTenant new]);
    id mockTenant5 = OCMPartialMock([GGPTenant new]);
    
    [OCMStub([mockTenant1 name]) andReturn:@"Sears"];
    [OCMStub([mockTenant2 name]) andReturn:@"Banana Palace"];
    [OCMStub([mockTenant3 name]) andReturn:@"Apple"];
    [OCMStub([mockTenant4 name]) andReturn:@"Starbucks"];
    [OCMStub([mockTenant5 name]) andReturn:@"Nordstrom"];
    
    [OCMStub([mockTenant3 displayName]) andReturn:@"Apple - inside Banana Place"];
    [OCMStub([mockTenant4 displayName]) andReturn:@"Starbucks - near Sears"];
    
    NSArray *allTenants = @[ mockTenant1, mockTenant2, mockTenant3, mockTenant4, mockTenant5 ];
    NSArray *filteredTenants = [NSArray new];
    
    filteredTenants = [GGPTenant filteredTenantsBySearchText:@"a" fromTenants:allTenants];
    XCTAssertEqual(filteredTenants.count, 4);
    XCTAssertTrue([filteredTenants containsObject:mockTenant1]);
    XCTAssertTrue([filteredTenants containsObject:mockTenant2]);
    XCTAssertTrue([filteredTenants containsObject:mockTenant3]);
    XCTAssertTrue([filteredTenants containsObject:mockTenant4]);
    
    filteredTenants = [GGPTenant filteredTenantsBySearchText:@"banana" fromTenants:allTenants];
    XCTAssertEqual(filteredTenants.count, 2);
    XCTAssertTrue([filteredTenants containsObject:mockTenant2]);
    XCTAssertTrue([filteredTenants containsObject:mockTenant3]);
    
    filteredTenants = [GGPTenant filteredTenantsBySearchText:@"sea" fromTenants:allTenants];
    XCTAssertEqual(filteredTenants.count, 2);
    XCTAssertTrue([filteredTenants containsObject:mockTenant1]);
    XCTAssertTrue([filteredTenants containsObject:mockTenant4]);
    
    filteredTenants = [GGPTenant filteredTenantsBySearchText:@"banana nord" fromTenants:allTenants];
    XCTAssertEqual(filteredTenants.count, 3);
    XCTAssertTrue([filteredTenants containsObject:mockTenant2]);
    XCTAssertTrue([filteredTenants containsObject:mockTenant3]);
    XCTAssertTrue([filteredTenants containsObject:mockTenant5]);
    
    filteredTenants = [GGPTenant filteredTenantsBySearchText:@"notaname" fromTenants:allTenants];
    XCTAssertEqual(filteredTenants.count, 0);
}

- (void)testUniqueTenantsFromAllTenants {
    GGPTenant *mockTenantUnique = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenantUnique placeWiseRetailerId]) andReturnValue:@(123)];
    
    GGPTenant *mockTenantUnique2 = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenantUnique2 name]) andReturnValue:@(1234)];
    
    GGPTenant *mockTenantDupe = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenantDupe name]) andReturnValue:@(123)];
    
    NSArray *allTenants = @[ mockTenantUnique, mockTenantUnique2, mockTenantDupe ];
    
    XCTAssertEqual([GGPTenant uniqueTenantsByBrandFromAllTenants:allTenants].count, 2);
}

- (void)testIsChildTenant {
    GGPTenant *mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant parentId]) andReturnValue:OCMOCK_VALUE(0)];
    XCTAssertFalse(mockTenant.isChildTenant);
    
    mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant parentId]) andReturnValue:OCMOCK_VALUE(1)];
    XCTAssertTrue(mockTenant.isChildTenant);
    
    mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant parentId]) andReturnValue:OCMOCK_VALUE(250)];
    XCTAssertTrue(mockTenant.isChildTenant);
}

- (void)testIsRelatedToTenant {
    NSInteger childId = 1;
    NSInteger parentId = 10;
    NSInteger notReleatedId = 3;
    
    GGPTenant *mockChildTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub(mockChildTenant.tenantId) andReturnValue:OCMOCK_VALUE(childId)];
    [OCMStub([mockChildTenant parentId]) andReturnValue:OCMOCK_VALUE(parentId)];
    
    GGPTenant *mockParent = OCMPartialMock([GGPTenant new]);
    [OCMStub(mockParent.tenantId) andReturnValue:OCMOCK_VALUE(parentId)];
    [OCMStub(mockParent.childIds) andReturn:@[@(childId)]];
    
    GGPTenant *mockNotRelated = OCMPartialMock([GGPTenant new]);
    [OCMStub(mockNotRelated.tenantId) andReturnValue:OCMOCK_VALUE(notReleatedId)];
    
    XCTAssertFalse([mockChildTenant isRelatedToTenant:nil]);
    XCTAssertFalse([mockChildTenant isRelatedToTenant:mockNotRelated]);
    XCTAssertTrue([mockChildTenant isRelatedToTenant:mockParent]);
    XCTAssertFalse([mockParent isRelatedToTenant:mockNotRelated]);
    XCTAssertTrue([mockParent isRelatedToTenant:mockChildTenant]);
}

- (void)testNameIncludingParent {
    GGPTenant *mockParent = OCMPartialMock([GGPTenant new]);
    [OCMStub(mockParent.name) andReturn:@"Parent"];
    
    GGPTenant *mockChild = OCMPartialMock([GGPTenant new]);
    [OCMStub(mockChild.name) andReturn:@"Child"];
    mockChild.parentTenant = mockParent;
    
    XCTAssertEqualObjects(@"Child - inside Parent", mockChild.nameIncludingParent);
}

@end
