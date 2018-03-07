//
//  GGPJustForYouTableViewControllerTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAlertViewController.h"
#import "GGPEvent.h"
#import "GGPHeroViewController.h"
#import "GGPJustForYouTableViewController.h"
#import "GGPNowOpenViewController.h"
#import "GGPSale.h"
#import "NSDate+GGPAdditions.h"

@interface GGPJustForYouTableViewController (Testing)

- (NSArray *)filteredSalesFromSales:(NSArray *)sales;
- (NSArray *)favoriteEventsFromEvents:(NSArray *)events;

@property (assign, nonatomic) BOOL finishedInitialDataFetch;
@property (strong, nonatomic) NSArray *sales;
@property (strong, nonatomic) GGPSale *featuredSale;
@property (strong, nonatomic) GGPAlertViewController *alertViewController;
@property (strong, nonatomic) GGPNowOpenViewController *nowOpenViewController;
@property (strong, nonatomic) GGPHeroViewController *heroViewController;
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) NSMutableDictionary *saleImageLookup;

@end

@interface GGPJustForYouTableViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPJustForYouTableViewController *justForYouViewController;

@end

@implementation GGPJustForYouTableViewControllerTests

- (void)setUp {
    [super setUp];
    self.justForYouViewController = [GGPJustForYouTableViewController new];
}

- (void)tearDown {
    self.justForYouViewController = nil;
    [super tearDown];
}

- (void)testFilteredSalesFromSales {
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [NSDate ggp_addDays:1 toDate:today];
    
    id mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant isFavorite]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockSale1 = OCMPartialMock([GGPSale new]);
    [OCMStub([mockSale1 tenant]) andReturn:mockTenant];
    [OCMStub([mockSale1 endDateTime]) andReturn:tomorrow];
    
    id mockSale2 = OCMPartialMock([GGPSale new]);
    [OCMStub([mockSale2 tenant]) andReturn:[GGPTenant new]];
    [OCMStub([mockSale2 endDateTime]) andReturn:tomorrow];
    
    id mockSale3 = OCMPartialMock([GGPSale new]);
    [OCMStub([mockSale3 tenant]) andReturn:mockTenant];
    [OCMStub([mockSale3 endDateTime]) andReturn:today];
    
    NSArray *sales = @[mockSale1, mockSale2, mockSale3];
    
    NSArray *filteredSales = [self.justForYouViewController filteredSalesFromSales:sales];
    XCTAssertEqual(filteredSales.count, 2);
    XCTAssertEqual(filteredSales[0], mockSale3);
    XCTAssertEqual(filteredSales[1], mockSale1);
}

- (void)testFavoriteEventsFromEvents {
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [NSDate ggp_addDays:1 toDate:today];
    
    id mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant isFavorite]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockEvent1 = OCMPartialMock([GGPEvent new]);
    [OCMStub([mockEvent1 tenant]) andReturn:mockTenant];
    [OCMStub([mockEvent1 endDateTime]) andReturn:tomorrow];
    
    id mockEvent2 = OCMPartialMock([GGPEvent new]);
    [OCMStub([mockEvent2 tenant]) andReturn:[GGPTenant new]];
    [OCMStub([mockEvent2 endDateTime]) andReturn:tomorrow];
    
    id mockEvent3 = OCMPartialMock([GGPEvent new]);
    [OCMStub([mockEvent3 tenant]) andReturn:mockTenant];
    [OCMStub([mockEvent3 endDateTime]) andReturn:today];
    
    NSArray *sales = @[mockEvent1, mockEvent2, mockEvent3];
    
    NSArray *filteredSales = [self.justForYouViewController filteredSalesFromSales:sales];
    XCTAssertEqual(filteredSales.count, 2);
    XCTAssertEqual(filteredSales[0], mockEvent3);
    XCTAssertEqual(filteredSales[1], mockEvent1);
}

- (void)testNumberOfRowsInSection {
    UITableView *tableView = self.justForYouViewController.tableView;
    
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:0], 0);
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:1], 0);
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:2], 0);
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:3], 0);
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:4], 0);
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:5], 0);
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:6], 0);
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:7], 0);
    
    self.justForYouViewController.finishedInitialDataFetch = YES;
    self.justForYouViewController.alertViewController = [GGPAlertViewController new];
    self.justForYouViewController.featuredSale = [GGPSale new];
    self.justForYouViewController.heroViewController = [GGPHeroViewController new];
    self.justForYouViewController.nowOpenViewController = [GGPNowOpenViewController new];
    self.justForYouViewController.events = @[@1, @2];
    self.justForYouViewController.saleImageLookup = @{@1:@1, @2:@2, @3:@3}.mutableCopy;
    
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:0], 1);
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:1], 1);
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:2], 1);
    // NOTE: If we have a featuredSale, the choose favorites section should empty
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:3], 0);
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:4], 1);
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:5], 1);
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:6], 2);
    XCTAssertEqual([self.justForYouViewController tableView:tableView numberOfRowsInSection:7], 4);
}

@end
