//
//  GGPMallRepositoryTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMallMovie.h"
#import "GGPMovie.h"
#import "GGPMovieTheater.h"
#import "GGPMallRepository.h"
#import "GGPEvent.h"
#import "GGPSale.h"
#import "GGPTenant.h"
#import "GGPCategory.h"
#import "GGPSale.h"
#import "NSDate+GGPAdditions.h"

@interface GGPMallRepository (Testing)

+ (void)mapTenants:(NSArray *)Tenants toEvents:(NSArray *)events;
+ (void)mapTenants:(NSArray *)Tenants toSales:(NSArray *)sales;
+ (void)mapParentTenantForTenants:(NSArray *)tenants;
+ (void)mapChildTenantsForTenants:(NSArray *)tenants;
+ (void)mapChildCategoriesForCategories:(NSArray *)categories;
+ (void)mapTenants:(NSArray *)tenants toCategories:(NSArray *)categories;
+ (void)mapSales:(NSArray *)sales toCategories:(NSArray *)categories;
+ (void)sortAndFilterCategories:(NSMutableArray *)categories;

+ (NSArray *)mallMoviesFromTheaters:(NSArray *)theaters;
+ (NSArray *)distinctMoviesFromTheaters:(NSArray *)theaters;
+ (NSArray *)theatersShowingMovie:(NSInteger)movieId fromTheaters:(NSArray *)theaters;
+ (NSArray *)showtimesAtTheater:(GGPMovieTheater *)theater forMovieId:(NSInteger)movieId;

@end

@interface GGPMallRepositoryTests : XCTestCase

@end

@implementation GGPMallRepositoryTests

- (void)testMapTenantsToEvents {
    GGPEvent *mockEvent1 = OCMPartialMock([GGPEvent new]);
    GGPEvent *mockEvent2 = OCMPartialMock([GGPEvent new]);
    GGPTenant *mockTenant1 = OCMClassMock(GGPTenant.class);
    GGPTenant *mockTenant2 = OCMClassMock(GGPTenant.class);
    
    [OCMStub([mockEvent1 tenantId]) andReturnValue:OCMOCK_VALUE(10)];
    [OCMStub([mockEvent2 tenantId]) andReturnValue:OCMOCK_VALUE(20)];
    
    [OCMStub(mockTenant1.tenantId) andReturnValue:OCMOCK_VALUE(10)];
    [OCMStub(mockTenant2.tenantId) andReturnValue:OCMOCK_VALUE(20)];
    
    [GGPMallRepository mapTenants:@[mockTenant2, mockTenant1] toEvents:@[mockEvent1, mockEvent2]];
    
    XCTAssertEqual(mockEvent1.tenant, mockTenant1);
    XCTAssertEqual(mockEvent2.tenant, mockTenant2);
}

- (void)testMapTenantsToSales {
    GGPSale *mockSale1 = OCMPartialMock([GGPSale new]);
    GGPSale *mockSale2 = OCMPartialMock([GGPSale new]);
    id mockSaleTenant1 = OCMClassMock(GGPTenant.class);
    id mockSaleTenant2 = OCMClassMock(GGPTenant.class);
    id mockFullTenant1 = OCMClassMock(GGPTenant.class);
    id mockFullTenant2 = OCMClassMock(GGPTenant.class);
    
    [OCMStub([mockSaleTenant1 tenantId]) andReturnValue:OCMOCK_VALUE(10)];
    [OCMStub([mockSaleTenant2 tenantId]) andReturnValue:OCMOCK_VALUE(20)];
    
    [OCMStub([mockFullTenant1 tenantId]) andReturnValue:OCMOCK_VALUE(10)];
    [OCMStub([mockFullTenant2 tenantId]) andReturnValue:OCMOCK_VALUE(20)];
    
    mockSale1.tenant = mockSaleTenant1;
    mockSale2.tenant = mockSaleTenant2;
    
    [GGPMallRepository mapTenants:@[mockFullTenant2, mockFullTenant1] toSales:@[mockSale1, mockSale2]];
    
    XCTAssertEqual(mockSale1.tenant, mockFullTenant1);
    XCTAssertEqual(mockSale2.tenant, mockFullTenant2);
}

- (void)testMapParentTenantForTenants {
    GGPTenant *tenant1 = OCMPartialMock([GGPTenant new]);
    GGPTenant *tenant2 = OCMPartialMock([GGPTenant new]);
    GGPTenant *tenant3 = OCMPartialMock([GGPTenant new]);
    GGPTenant *tenant4 = OCMPartialMock([GGPTenant new]);
    
    [OCMStub(tenant1.tenantId) andReturnValue:OCMOCK_VALUE(1)];
    [OCMStub(tenant2.tenantId) andReturnValue:OCMOCK_VALUE(2)];
    [OCMStub(tenant3.tenantId) andReturnValue:OCMOCK_VALUE(3)];
    [OCMStub(tenant4.tenantId) andReturnValue:OCMOCK_VALUE(4)];
    
    [OCMStub(tenant2.childIds) andReturn:@[@100, @101]];
    [OCMStub(tenant3.childIds) andReturn:@[@4]];
    [OCMStub(tenant4.parentId) andReturnValue:OCMOCK_VALUE(3)];
    
    NSArray *mockTenants = @[tenant1, tenant2, tenant3, tenant4];
    [GGPMallRepository mapParentTenantForTenants:mockTenants];
    
    XCTAssertNil(tenant1.parentTenant);
    XCTAssertNil(tenant2.parentTenant);
    XCTAssertNil(tenant3.parentTenant);
    XCTAssertEqual(tenant4.parentTenant, tenant3);
}

- (void)testMapChildTenantsForTenants {
    GGPTenant *tenant1 = OCMPartialMock([GGPTenant new]);
    GGPTenant *tenant2 = OCMPartialMock([GGPTenant new]);
    GGPTenant *tenant3 = OCMPartialMock([GGPTenant new]);
    
    [OCMStub(tenant1.tenantId) andReturnValue:OCMOCK_VALUE(1)];
    [OCMStub(tenant2.tenantId) andReturnValue:OCMOCK_VALUE(2)];
    [OCMStub(tenant3.tenantId) andReturnValue:OCMOCK_VALUE(3)];
    
    [OCMStub(tenant2.childIds) andReturn:@[@1, @3]];
    
    NSArray *mockTenants = @[tenant1, tenant2, tenant3];
    [GGPMallRepository mapChildTenantsForTenants:mockTenants];
    
    XCTAssertNil(tenant1.childTenants);
    XCTAssertNil(tenant3.childTenants);
    XCTAssertEqual(2, tenant2.childTenants.count);
    XCTAssertTrue([tenant2.childTenants containsObject:tenant1]);
    XCTAssertTrue([tenant2.childTenants containsObject:tenant3]);
}

- (void)testMapChildCategoriesForCategories {
    GGPCategory *category1 = OCMPartialMock([GGPCategory new]);
    GGPCategory *category2 = OCMPartialMock([GGPCategory new]);
    GGPCategory *category3 = OCMPartialMock([GGPCategory new]);
    GGPCategory *category4 = OCMPartialMock([GGPCategory new]);
    GGPCategory *category5 = OCMPartialMock([GGPCategory new]);
    
    [OCMStub([category1 filterId]) andReturnValue:OCMOCK_VALUE(1)];
    [OCMStub([category2 filterId]) andReturnValue:OCMOCK_VALUE(2)];
    [OCMStub([category3 filterId]) andReturnValue:OCMOCK_VALUE(3)];
    [OCMStub([category4 filterId]) andReturnValue:OCMOCK_VALUE(4)];
    [OCMStub([category5 filterId]) andReturnValue:OCMOCK_VALUE(5)];
    
    [OCMStub([category2 parentId]) andReturnValue:OCMOCK_VALUE(1)];
    [OCMStub([category3 parentId]) andReturnValue:OCMOCK_VALUE(1)];
    [OCMStub([category5 parentId]) andReturnValue:OCMOCK_VALUE(4)];
    
    [OCMStub([category2 filteredItems]) andReturn:@[[GGPTenant new]]];
    [OCMStub([category3 filteredItems]) andReturn:nil];
    [OCMStub([category5 filteredItems]) andReturn:@[[GGPTenant new]]];
    
    [GGPMallRepository mapChildCategoriesForCategories:@[category1, category2, category3, category4, category5]];
    
    XCTAssertEqual(category1.childFilters.count, 1);
    XCTAssertEqual(category2.childFilters.count, 0);
    XCTAssertEqual(category3.childFilters.count, 0);
    XCTAssertEqual(category4.childFilters.count, 1);
    XCTAssertEqual(category5.childFilters.count, 0);
    
    XCTAssertTrue([category1.childFilters containsObject:category2]);
    XCTAssertTrue([category4.childFilters containsObject:category5]);
}

- (void)testMapTenantsToCategories {
    GGPCategory *category1 = OCMPartialMock([GGPCategory new]);
    GGPCategory *category2 = OCMPartialMock([GGPCategory new]);
    
    [OCMStub([category1 filterId]) andReturnValue:OCMOCK_VALUE(1)];
    [OCMStub([category2 filterId]) andReturnValue:OCMOCK_VALUE(2)];
    
    GGPTenant *tenant1 = OCMPartialMock([GGPTenant new]);
    GGPTenant *tenant2 = OCMPartialMock([GGPTenant new]);
    GGPTenant *tenant3 = OCMPartialMock([GGPTenant new]);
    
    [OCMStub([tenant1 categories]) andReturn:@[category1]];
    [OCMStub([tenant2 categories]) andReturn:@[category1, category2]];
    [OCMStub([tenant3 categories]) andReturn:nil];
    
    [GGPMallRepository mapTenants:@[tenant1, tenant2, tenant3] toCategories:@[category1, category2]];
    
    XCTAssertEqual(category1.filteredItems.count, 2);
    XCTAssertEqual(category2.filteredItems.count, 1);
    
    XCTAssertTrue([category1.filteredItems containsObject:tenant1]);
    XCTAssertTrue([category1.filteredItems containsObject:tenant2]);
    XCTAssertTrue([category2.filteredItems containsObject:tenant2]);
}

- (void)testMapSalesToCategories {
    GGPCategory *category1 = OCMPartialMock([GGPCategory new]);
    GGPCategory *category2 = OCMPartialMock([GGPCategory new]);
    GGPCategory *category3 = OCMPartialMock([GGPCategory new]);
    
    [OCMStub([category1 filterId]) andReturnValue:OCMOCK_VALUE(1)];
    [OCMStub([category2 filterId]) andReturnValue:OCMOCK_VALUE(2)];
    [OCMStub([category3 filterId]) andReturnValue:OCMOCK_VALUE(3)];
    
    GGPSale *sale1 = OCMPartialMock([GGPSale new]);
    GGPSale *sale2 = OCMPartialMock([GGPSale new]);
    GGPSale *sale3 = OCMPartialMock([GGPSale new]);
    
    [OCMStub([sale1 categories]) andReturn:@[category1]];
    [OCMStub([sale1 campaignCategories]) andReturn:@[category3]];
    [OCMStub([sale2 categories]) andReturn:@[category1, category2]];
    [OCMStub([sale3 categories]) andReturn:nil];
    [OCMStub([sale3 campaignCategories]) andReturn:@[category3]];
    
    [GGPMallRepository mapSales:@[sale1, sale2, sale3] toCategories:@[category1, category2, category3]];
    
    XCTAssertEqual(category1.filteredItems.count, 2);
    XCTAssertEqual(category2.filteredItems.count, 1);
    XCTAssertEqual(category3.filteredItems.count, 2);
    
    XCTAssertTrue([category1.filteredItems containsObject:sale1]);
    XCTAssertTrue([category1.filteredItems containsObject:sale2]);
    XCTAssertTrue([category2.filteredItems containsObject:sale2]);
    XCTAssertTrue([category3.filteredItems containsObject:sale1]);
    XCTAssertTrue([category3.filteredItems containsObject:sale3]);
}

- (void)testSortAndFilterCategories {
    GGPCategory *category1 = [GGPCategory new];
    GGPCategory *category2 = [GGPCategory new];
    GGPCategory *category3 = [GGPCategory new];
    GGPCategory *category4 = [GGPCategory new];
    
    category1.parentId = 0;
    category1.name = @"Department Stores";
    category1.code = @"NOT_CAMPAIGN";
    category1.filteredItems = @[[GGPSale new]];
    
    category2.parentId = 0;
    category2.name = @"Fall Fashion";
    category2.code = @"EASTER";
    category2.filteredItems = @[[GGPSale new]];
    
    category3.parentId = 0;
    category3.name = @"Shoes";
    category3.code = @"NOT_CAMPAIGN";
    category3.filteredItems = @[[GGPSale new]];
    
    category4.parentId = 1;
    category4.name = @"Home";
    category4.code = @"NOT_CAMPAIGN";
    category4.filteredItems = @[[GGPSale new]];
    
    NSMutableArray *categories = @[category1, category2, category3, category4].mutableCopy;
    
    [GGPMallRepository sortAndFilterCategories:categories];
    
    XCTAssertEqual(categories.count, 3);
    XCTAssertEqual(categories[0], category2);
    XCTAssertEqual(categories[1], category1);
    XCTAssertEqual(categories[2], category3);
}

- (void)testMallMoviesFromTheaters {
    GGPMovie *movie = OCMPartialMock([GGPMovie new]);
    [OCMStub([movie movieId]) andReturnValue:OCMOCK_VALUE(2)];
    [OCMStub([movie title]) andReturn:@"The Titanic"];
    [OCMStub([movie showtimes]) andReturn:@[[NSDate new]]];
    
    GGPMovie *movie2 = OCMPartialMock([GGPMovie new]);
    [OCMStub([movie2 movieId]) andReturnValue:OCMOCK_VALUE(2)];
    [OCMStub([movie2 title]) andReturn:@"The Titanic"];
    [OCMStub([movie2 showtimes]) andReturn:@[[NSDate new]]];
    
    id mockTheater = OCMPartialMock([GGPMovieTheater new]);
    [OCMStub([mockTheater theatreId]) andReturnValue:OCMOCK_VALUE(1)];
    [OCMStub([mockTheater movies]) andReturn:@[movie]];
    
    id mockTheater2 = OCMPartialMock([GGPMovieTheater new]);
    [OCMStub([mockTheater2 theatreId]) andReturnValue:OCMOCK_VALUE(2)];
    [OCMStub([mockTheater2 movies]) andReturn:@[movie2]];
    
    NSArray *theaters = @[mockTheater, mockTheater2];
    
    NSArray *mallMovies = [GGPMallRepository mallMoviesFromTheaters:theaters];
    GGPMallMovie *mallMovie = mallMovies.firstObject;
    
    XCTAssertEqual(mallMovies.count, 1);
    XCTAssertEqual(mallMovie.showtimesLookup.allKeys.count, 2);
}

- (void)testDistinctMoviesFromTheaters {
    id mockTheater = OCMPartialMock([GGPMovieTheater new]);
    
    id mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([mockMovie movieId]) andReturnValue:OCMOCK_VALUE(1)];
    
    [OCMStub([mockTheater movies]) andReturn:@[mockMovie, mockMovie]];
    
    NSArray *theaters = @[mockTheater];
    
    XCTAssertEqual([GGPMallRepository distinctMoviesFromTheaters:theaters].count, 1);
}

- (void)testTheatersShowingMovieFromTheaters {
    id mockTheater = OCMPartialMock([GGPMovieTheater new]);
    
    id mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([mockMovie movieId]) andReturnValue:OCMOCK_VALUE(1)];
    
    [OCMStub([mockTheater movies]) andReturn:@[mockMovie, mockMovie]];
    
    NSArray *theaters = @[mockTheater];
    
    XCTAssertEqual([GGPMallRepository theatersShowingMovie:1 fromTheaters:theaters].count, 1);
}

- (void)testShowtimesAtTheaterForMovieId {
    NSDate *today = [NSDate new];
    
    id mockTheater = OCMPartialMock([GGPMovieTheater new]);
    
    id mockShowtime = OCMPartialMock([GGPShowtime new]);
    [OCMStub([mockShowtime movieShowtimeDate]) andReturn:today];
    
    id mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([mockMovie movieId]) andReturnValue:OCMOCK_VALUE(1)];
    [OCMStub([mockMovie showtimes]) andReturn:@[mockShowtime]];
    
    [OCMStub([mockTheater movies]) andReturn:@[mockMovie, mockMovie]];
    
    XCTAssertEqual([GGPMallRepository showtimesAtTheater:mockTheater forMovieId:1].count, 1);
}

- (void)testShowtimesAtTheaterForMovieIdNoShowtimes {
    id mockTheater = OCMPartialMock([GGPMovieTheater new]);
    
    id mockMovie = OCMPartialMock([GGPMovie new]);
    [OCMStub([mockMovie movieId]) andReturnValue:OCMOCK_VALUE(1)];
    [OCMStub([mockMovie showtimes]) andReturn:@[]];
    
    [OCMStub([mockTheater movies]) andReturn:@[mockMovie, mockMovie]];
    
    XCTAssertEqual([GGPMallRepository showtimesAtTheater:mockTheater forMovieId:1].count, 0);
}

@end
