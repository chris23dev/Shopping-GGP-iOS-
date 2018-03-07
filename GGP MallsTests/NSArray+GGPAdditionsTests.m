//
//  NSArray+GGPAdditionsTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPEvent.h"
#import "GGPSale.h"
#import "GGPTenant.h"
#import "NSArray+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"

@interface NSArrayGGPAdditionsTests : XCTestCase

@end

@interface NSArray (GGPAdditionsTests)

- (NSArray *)ggp_sortListAscendingForKey:(NSString *)sortKey;
- (NSArray *)ggp_sortListForPrimarySortKey:(NSString *)primarySortKey primaryAscending:(BOOL)primaryAscending secondarySortkey:(NSString *)secondarySortKey secondaryAscending:(BOOL)secondaryAscending;
- (NSArray *)ggp_removeDuplicates;

@end

@implementation NSArrayGGPAdditionsTests

- (void)testSortListAscendingForKey {
    NSDate *today = [NSDate new];
    
    id mockEventFirst = OCMPartialMock([GGPEvent new]);
    [OCMStub([mockEventFirst endDateTime]) andReturn:today];
    
    id mockEventSecond = OCMPartialMock([GGPEvent new]);
    [OCMStub([mockEventSecond endDateTime]) andReturn:[NSDate ggp_addDays:1 toDate:today]];
    
    id mockEventThird = OCMPartialMock([GGPEvent new]);
    [OCMStub([mockEventThird endDateTime]) andReturn:[NSDate ggp_addDays:2 toDate:today]];
    
    NSArray *unsortedList = @[mockEventSecond, mockEventThird, mockEventFirst];
    NSArray *expectedSortedList = @[mockEventFirst, mockEventSecond, mockEventThird];
    XCTAssertEqualObjects([unsortedList ggp_sortListAscendingForKey:@"endDateTime"], expectedSortedList);
}

- (void)testRemoveDuplicates {
    id mockEvent = OCMPartialMock([GGPEvent new]);
    NSArray *duplicateList = @[mockEvent, mockEvent, mockEvent];
    NSArray *expectedList = @[mockEvent];
    XCTAssertEqualObjects([duplicateList ggp_removeDuplicates], expectedList);
}

- (void)testSortListPrimaryKeyAndSecondaryKey {
    NSDate *today = [NSDate new];
    
    id mockTenantFirst = OCMPartialMock([GGPTenant new]);
    id mockSaleFirst = OCMPartialMock([GGPSale new]);
    [OCMStub([mockTenantFirst name]) andReturn:@"A Name"];
    [OCMStub([mockSaleFirst endDateTime]) andReturn:today];
    [OCMStub([mockSaleFirst tenant]) andReturn:mockTenantFirst];
    
    id mockTenantSecond = OCMPartialMock([GGPTenant new]);
    id mockSaleSecond = OCMPartialMock([GGPSale new]);
    [OCMStub([mockSaleSecond endDateTime]) andReturn:[NSDate ggp_addDays:2 toDate:today]];
    [OCMStub([mockTenantSecond name]) andReturn:@"B Name"];
    [OCMStub([mockSaleSecond tenant]) andReturn:mockTenantSecond];
    
    id mockSaleThird = OCMPartialMock([GGPSale new]);
    [OCMStub([mockSaleThird endDateTime]) andReturn:[NSDate ggp_addDays:1 toDate:today]];
    [OCMStub([mockSaleThird tenant]) andReturn:mockTenantSecond];
    
    NSArray *unsortedList = @[mockSaleSecond, mockSaleThird, mockSaleFirst];
    NSArray *expectedSortedList = @[mockSaleFirst, mockSaleThird, mockSaleSecond];
    
    XCTAssertEqualObjects([unsortedList ggp_sortListForPrimarySortKey:@"saleSortName" primaryAscending:YES secondarySortkey:@"endDateTime" secondaryAscending:YES], expectedSortedList);
}

- (void)testArrayWithFilter {
    NSArray *numbers = @[@1, @2, @3];
    
    NSArray *results = [numbers ggp_arrayWithFilter:nil];
    XCTAssertEqual(3, results.count);
    
    results = [@[] ggp_arrayWithFilter:nil];
    XCTAssertEqual(0, results.count);
    
    results = [numbers ggp_arrayWithFilter:^BOOL(NSNumber *number) {
        return number.intValue < 3;
    }];
    XCTAssertEqual(2, results.count);
    XCTAssertEqual(1, ((NSNumber *)results[0]).intValue);
    XCTAssertEqual(2, ((NSNumber *)results[1]).intValue);
    
    results = [numbers ggp_arrayWithFilter:^BOOL(NSNumber *number) {
        return number.intValue > 3;
    }];
    XCTAssertEqual(0, results.count);
}

- (void)testFirstWithFilter {
    NSArray *numbers = @[@1, @2];
    
    NSNumber *result = [numbers ggp_firstWithFilter:nil];
    XCTAssertEqual(1, result.intValue);
    
    result = [@[] ggp_firstWithFilter:nil];
    XCTAssertNil(result);
    
    result = [numbers ggp_firstWithFilter:^BOOL(NSNumber *number) {
        return number.intValue > 3;
    }];
    XCTAssertNil(result);
    
    result = [numbers ggp_firstWithFilter:^BOOL(NSNumber *number) {
        return number.intValue < 3;
    }];
    XCTAssertEqual(1, result.intValue);
}

- (void)testAnyWithFilter {
    NSArray *numbers = @[@1, @2];
    
    BOOL exists = [numbers ggp_anyWithFilter:nil];
    XCTAssertTrue(exists);
    
    exists = [@[] ggp_anyWithFilter:nil];
    XCTAssertFalse(exists);
    
    exists = [numbers ggp_anyWithFilter:^BOOL(NSNumber *number) {
        return number.intValue > 3;
    }];
    XCTAssertFalse(exists);
    
    exists = [numbers ggp_anyWithFilter:^BOOL(NSNumber *number) {
        return number.intValue < 3;
    }];
    XCTAssertTrue(exists);
}

- (void)testArrayWithMap {
    GGPTenant *tenant1 = [GGPTenant new];
    GGPTenant *tenant2 = [GGPTenant new];
    GGPTenant *tenant3 = [GGPTenant new];
    GGPTenant *tenant4 = [GGPTenant new];
    [tenant1 setValue:@"duplicateName" forKey:@"name"];
    [tenant3 setValue:@"uniqueName" forKey:@"name"];
    [tenant4 setValue:@"duplicateName" forKey:@"name"];
    
    NSArray *tenants = @[tenant1, tenant2, tenant3, tenant4];
    
    NSArray *mapped = [tenants ggp_arrayWithMap:^id(GGPTenant *tenant) {
        return tenant.name;
    }];
    XCTAssertEqual(3, mapped.count);
    XCTAssertEqualObjects(tenant1.name, mapped[0]);
    XCTAssertEqualObjects(tenant3.name, mapped[1]);
    XCTAssertEqualObjects(tenant4.name, mapped[2]);
    
    mapped = [tenants ggp_arrayWithMap:nil];
    XCTAssertEqual(0, mapped.count);
}

@end
