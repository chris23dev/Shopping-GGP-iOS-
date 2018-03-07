//
//  GGPProductTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPProduct.h"
#import "GGPTenant.h"

static NSString *const kDefaultCode = @"mens/shoes";
static NSString *const kNonMatchingCode = @"womens/shoes";

@interface GGPProduct ()

@property (assign, nonatomic) BOOL isChildAllFilter;

+ (NSArray *)uniqueProductsFromTenants:(NSArray *)tenants;
+ (NSArray *)uniqueParentProductsFromAllProducts:(NSArray *)allProducts andTenants:(NSArray *)tenants;
+ (NSArray *)childItemsForParentItem:(GGPProduct *)parentItem fromAllProducts:(NSArray *)allProducts andTenants:(NSArray *)tenants;
+ (void)addAllFilterToChildList:(NSMutableArray *)childList forParent:(GGPProduct *)parent;
+ (NSArray *)nonParentItemChildItemsFromProducts:(NSArray *)products;
- (NSArray *)retrieveFilteredListFromTenants:(NSArray *)tenants;

@end

@interface GGPProductTests : XCTestCase

@property GGPProduct *product;

@end

@implementation GGPProductTests

- (void)setUp {
    [super setUp];
    self.product = [[GGPProduct alloc] initWithDictionary:@{ @"code": @"womens/swimwear" } error:nil];
}

- (void)tearDown {
    self.product = nil;
    [super tearDown];
}

- (void)testParentCode {
    XCTAssertEqualObjects(self.product.parentCode, @"womens");
}

- (void)testChildCode {
    XCTAssertEqualObjects(self.product.childCode, @"swimwear");
}

- (void)testFilterByProductCode {
    GGPProduct *filterProduct = [GGPProduct new];
    filterProduct.code = kDefaultCode;
    
    id mockTenantMatch = OCMPartialMock([GGPTenant new]);
    GGPProduct *mockProductMatch = [GGPProduct new];
    mockProductMatch.code = kDefaultCode;
    
    id mockTenantNonMatch = OCMPartialMock([GGPTenant new]);
    GGPProduct *mockProductNonMatch = [GGPProduct new];
    mockProductNonMatch.code = kNonMatchingCode;
    
    [OCMStub([mockTenantMatch products]) andReturn:@[ mockProductMatch ]];
    [OCMStub([mockTenantNonMatch products]) andReturn:@[ mockProductNonMatch ]];
    
    NSArray *mockTenants = @[ mockTenantMatch, mockTenantNonMatch ];
    
    XCTAssertEqual([filterProduct retrieveFilteredListFromTenants:mockTenants].count, 1);
}

- (void)testUniqueProductsFromFilterables {
    GGPProduct *product1 = [GGPProduct new];
    GGPProduct *product2 = [GGPProduct new];
    GGPProduct *product3 = [GGPProduct new];
    product1.code = @"womens/shoes";
    product2.code = @"mens/shirts";
    product3.code = @"womens/shoes";
    
    GGPTenant *tenant1 = [GGPTenant new];
    GGPTenant *tenant2 = [GGPTenant new];
    [tenant1 setValue:@[product1, product2] forKey:@"products"];
    [tenant2 setValue:@[product3] forKey:@"products"];
    NSArray *tenants = @[tenant1, tenant2];
    
    NSArray *uniqueProducts = [GGPProduct uniqueProductsFromTenants:tenants];
    XCTAssertEqual(2, uniqueProducts.count);
    XCTAssertEqualObjects(@"womens/shoes", ((GGPProduct *)uniqueProducts[0]).code);
    XCTAssertEqualObjects(@"mens/shirts", ((GGPProduct *)uniqueProducts[1]).code);
    
    uniqueProducts = [GGPProduct uniqueProductsFromTenants:nil];
    XCTAssertEqual(0, uniqueProducts.count);
}

- (void)testUniqueParentProductsFromAllProducts {
    GGPProduct *mockProductParent = [GGPProduct new];
    mockProductParent.code = @"womens";
    
    GGPProduct *mockProduct1 = [GGPProduct new];
    mockProduct1.code = @"womens/shoes";
    
    GGPProduct *mockProduct2 = [GGPProduct new];
    mockProduct1.code = @"womens/shirts";
    
    NSArray *duplicateParentProducts = @[ mockProductParent, mockProduct1, mockProduct2 ];
    XCTAssertEqual([GGPProduct uniqueParentProductsFromAllProducts:duplicateParentProducts andTenants:nil].count, 1);
}

- (void)testChildItemsForParent {
    GGPProduct *mockParent = [GGPProduct new];
    mockParent.code = @"mens";
    
    GGPProduct *mockChildProduct1 = [GGPProduct new];
    mockChildProduct1.code = @"mens/loafers";
    
    GGPProduct *mockChildProduct2 = [GGPProduct new];
    mockChildProduct2.code = @"mens/shirts";
    
    GGPProduct *mockChildProduct3 = [GGPProduct new];
    mockChildProduct3.code = @"womens/shirts";
    
    NSArray *mockAllProducts = @[ mockChildProduct1, mockChildProduct2, mockChildProduct3 ];
    XCTAssertEqual([GGPProduct childItemsForParentItem:mockParent fromAllProducts:mockAllProducts andTenants:nil].count, 3);
}

- (void)testNonParentItemChildItemsFromFilterables {
    GGPProduct *nonParentFilter = [GGPProduct new];
    nonParentFilter.isChildAllFilter = NO;
    
    GGPProduct *isParentFilter = [GGPProduct new];
    isParentFilter.isChildAllFilter = YES;
    
    NSArray *allProductItems = @[ nonParentFilter, isParentFilter ];
    XCTAssertEqual([GGPProduct nonParentItemChildItemsFromProducts:allProductItems].count, 1);
}

@end
