//
//  GGPCategoryTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/16/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <Mantle/MTLJSONAdapter.h>
#import "GGPCategory.h"
#import "GGPTenant.h"

@interface GGPCategory (Testing)

+ (void)moveStoreOpeningsToTopOfList:(NSMutableArray *)categories;
+ (void)addMyFavoritesCategoryToList:(NSMutableArray *)categories fromTenants:(NSArray *)tenants;

@end

@interface GGPCategoryTests : XCTestCase

@property (strong, nonatomic) GGPCategory *category;
@property (strong, nonatomic) NSDictionary *jsonDictionary;

@end

@implementation GGPCategoryTests

- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"category" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.category = (GGPCategory *)[MTLJSONAdapter modelOfClass:GGPCategory.class fromJSONDictionary:self.jsonDictionary error:nil];
    
}

- (void)tearDown {
    self.category = nil;
    self.jsonDictionary = nil;
    [super tearDown];
}

- (void)testCategory {
    XCTAssertNotNil(self.category);
    XCTAssertNotNil(self.category.code);
    XCTAssertEqual(self.category.filterId, [self.jsonDictionary[@"id"] integerValue]);
    XCTAssertEqual(self.category.parentId, [self.jsonDictionary[@"parentId"] integerValue]);
    XCTAssertEqual(self.category.code, self.jsonDictionary[@"code"]);
}

- (void)testRemoveEmptyAndChildCategories {
    id mockCategory1 = OCMPartialMock([GGPCategory new]);
    id mockCategory2 = OCMPartialMock([GGPCategory new]);
    id mockCategory3 = OCMPartialMock([GGPCategory new]);
    
    [OCMStub([mockCategory1 filteredItems]) andReturn:@[[GGPTenant new]]];
    [OCMStub([mockCategory2 filteredItems]) andReturn:@[[GGPTenant new]]];
    [OCMStub([mockCategory3 filteredItems]) andReturn:nil];
    
    [OCMStub([mockCategory1 parentId]) andReturnValue:OCMOCK_VALUE(0)];
    [OCMStub([mockCategory2 parentId]) andReturnValue:OCMOCK_VALUE(1)];
    [OCMStub([mockCategory3 parentId]) andReturnValue:OCMOCK_VALUE(0)];
    
    NSMutableArray *mockCategories = @[mockCategory1, mockCategory2].mutableCopy;
    
    [GGPCategory removeEmptyAndChildCategoriesFromCategories:mockCategories];
    
    XCTAssertEqual(mockCategories.count, 1);
    XCTAssertEqual(mockCategories.firstObject, mockCategory1);
}

- (void)testAddAllFilterToSubCategoryList {
    NSString *parentCode = @"parentCode";
    NSString *parentLabel = @"parentLabel";
    NSInteger parentId = 1;
    NSArray *parentFilteredItems = @[[GGPTenant new]];
    
    GGPCategory *mockParent = OCMPartialMock([GGPCategory new]);
    [OCMStub([mockParent code]) andReturn:parentCode];
    [OCMStub([mockParent label]) andReturn:parentLabel];
    [OCMStub([mockParent categoryId]) andReturnValue:OCMOCK_VALUE(parentId)];
    [OCMStub([mockParent filteredItems]) andReturn:parentFilteredItems];
    
    id mockChild = OCMPartialMock([GGPCategory new]);
    
    mockParent.childFilters = @[mockChild];
    
    [mockParent addAllFilterToSubCategoryList];
    
    NSArray *result = mockParent.childFilters;
    
    GGPCategory *allFilter = result.firstObject;
    
    XCTAssertEqual(result.count, 2);
    XCTAssertEqual(result[1], mockChild);
    XCTAssertEqual(allFilter.code, parentCode);
    XCTAssertEqual(allFilter.label, parentLabel);
    XCTAssertEqual(allFilter.filterId, parentId);
    XCTAssertEqualObjects(allFilter.filteredItems, parentFilteredItems);
}

- (void)testMoveStoreOpeningsToTopOfList {
    GGPCategory *mockStoreOpeningCategory = OCMPartialMock([GGPCategory new]);
    [OCMStub([mockStoreOpeningCategory code]) andReturn:GGPCategoryTenantOpeningsCode];
    [OCMStub([mockStoreOpeningCategory valueForKey:@"code"]) andReturn:GGPCategoryTenantOpeningsCode];
    
    GGPCategory *mockOtherCategory = OCMPartialMock([GGPCategory new]);
    [OCMStub([mockOtherCategory code]) andReturn:@"other"];
    
    NSMutableArray *categories = @[mockOtherCategory, mockStoreOpeningCategory].mutableCopy;
    
    [GGPCategory moveStoreOpeningsToTopOfList:categories];
    
    XCTAssertEqual(categories.count, 2);
    XCTAssertEqual(categories[0], mockStoreOpeningCategory);
    XCTAssertEqual(categories[1], mockOtherCategory);
}

- (void)testAddMyFavoritesCategory {
    GGPCategory *mockOtherCategory = OCMPartialMock([GGPCategory new]);
    [OCMStub([mockOtherCategory code]) andReturn:@"other"];
    
    NSMutableArray *categories = @[mockOtherCategory].mutableCopy;
    
    id mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant isFavorite]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockTenant2 = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant2 isFavorite]) andReturnValue:OCMOCK_VALUE(NO)];
    
    NSArray *tenants = @[mockTenant, mockTenant2];
    
    [GGPCategory addMyFavoritesCategoryToList:categories fromTenants:tenants];
    
    XCTAssertEqual(categories.count, 2);
    
    GGPCategory *firstCategory = categories.firstObject;
    XCTAssertEqual(firstCategory.code, GGPCategoryUserFavoritesCode);
    XCTAssertEqual(firstCategory.filteredItems.count, 1);
}

- (void)testIsValidCampaignCode {
    XCTAssertTrue([GGPCategory isValidCampaignCategoryCode:@"BLACK_FRIDAY"]);
    XCTAssertTrue([GGPCategory isValidCampaignCategoryCode:@"EASTER"]);
    XCTAssertTrue([GGPCategory isValidCampaignCategoryCode:@"HOLIDAY"]);
    XCTAssertTrue([GGPCategory isValidCampaignCategoryCode:@"VALENTINES"]);
    XCTAssertFalse([GGPCategory isValidCampaignCategoryCode:@"NOT_A_CAMPAIGN"]);
    XCTAssertFalse([GGPCategory isValidCampaignCategoryCode:@""]);
    XCTAssertFalse([GGPCategory isValidCampaignCategoryCode:nil]);
}

@end
