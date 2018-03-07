//
//  GGPBrandTests.m
//  GGP Malls
//
//  Created by Janet Lin on 12/16/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPBrand.h"
#import "GGPTenant.h"
#import <Mantle/MTLJSONAdapter.h>

@interface GGPBrand (Testing)

+ (NSArray *)uniqueBrandsFromTenants:(NSArray *)tenants;
- (NSArray *)retrieveFilteredListFromTenants:(NSArray *)tenants;

@end

@interface GGPBrandTests : XCTestCase

@property (strong, nonatomic) GGPBrand *brand;
@property (strong, nonatomic) NSDictionary *jsonDictionary;

@end

@implementation GGPBrandTests

- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"brand" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.brand = (GGPBrand *)[MTLJSONAdapter modelOfClass:GGPBrand.class fromJSONDictionary:self.jsonDictionary error:nil];

}

- (void)tearDown {
    self.brand = nil;
    self.jsonDictionary = nil;
    [super tearDown];
}

- (void)testBrandProperties {
    XCTAssertNotNil(self.brand);
    XCTAssertEqual(self.brand.filterId, [self.jsonDictionary[@"id"] integerValue]);
    XCTAssertEqualObjects(self.brand.name, self.jsonDictionary[@"name"]);
}

- (void)testUniqueBrandsFromFilterables {
    id mockTenant1 = OCMPartialMock([GGPTenant new]);
    id mockTenant2 = OCMPartialMock([GGPTenant new]);
    
    id mockBrand1 = OCMPartialMock([GGPBrand new]);
    [OCMStub([mockBrand1 name]) andReturn:@"unique brand"];
    
    id mockBrand2 = OCMPartialMock([GGPBrand new]);
    [OCMStub([mockBrand2 name]) andReturn:@"nother unique brand"];
    
    [OCMStub([mockTenant1 brands]) andReturn:@[ mockBrand1 ]];
    [OCMStub([mockTenant2 brands]) andReturn:@[ mockBrand1, mockBrand2 ]];
    
    NSArray *tenants = @[ mockTenant1, mockTenant2 ];
    XCTAssertEqual([GGPBrand uniqueBrandsFromTenants:tenants].count, 2);
}

- (void)testRetrieveFilteredListFromTenants {
    NSString *matchName = @"addidas";
    NSString *nonMatchName = @"Asics";
    
    GGPBrand *mockBrand = OCMPartialMock([GGPBrand new]);
    mockBrand.name = matchName;
    
    id mockTenantMatch = OCMPartialMock([GGPTenant new]);
    GGPBrand *mockBrandMatch = OCMPartialMock([GGPBrand new]);
    mockBrandMatch.name = matchName;
    
    id mockTenantNonMatch = OCMPartialMock([GGPTenant new]);
    GGPBrand *mockBrandNonMatch = OCMPartialMock([GGPBrand new]);
    mockBrandNonMatch.name = nonMatchName;
    
    [OCMStub([mockTenantMatch brands]) andReturn:@[ mockBrandMatch ]];
    [OCMStub([mockTenantNonMatch products]) andReturn:@[ mockBrandNonMatch ]];
    
    NSArray *mockTenants = @[ mockTenantMatch, mockTenantNonMatch ];
    
    XCTAssertEqual([mockBrand retrieveFilteredListFromTenants:mockTenants].count, 1);
}

@end
