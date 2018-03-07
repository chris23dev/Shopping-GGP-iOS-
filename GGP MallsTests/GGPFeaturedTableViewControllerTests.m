//
//  GGPFeaturedTableViewControllerTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAlertViewController.h"
#import "GGPFeaturedTableViewController.h"
#import "GGPHeroViewController.h"
#import "GGPNowOpenViewController.h"
#import "GGPSale.h"
#import "NSDate+GGPAdditions.h"


@interface GGPFeaturedTableViewController (Testing)

- (NSArray *)filteredSalesFromSales:(NSArray *)sales;

@property (assign, nonatomic) BOOL finishedInitialDataFetch;
@property (strong, nonatomic) NSArray *sales;
@property (strong, nonatomic) GGPSale *featuredSale;
@property (strong, nonatomic) GGPAlertViewController *alertViewController;
@property (strong, nonatomic) GGPNowOpenViewController *nowOpenViewController;
@property (strong, nonatomic) GGPHeroViewController *heroViewController;
@property (strong, nonatomic) NSMutableDictionary *saleImageLookup;

@end

@interface GGPFeaturedTableViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPFeaturedTableViewController *featuredViewController;

@end

@implementation GGPFeaturedTableViewControllerTests

- (void)setUp {
    [super setUp];
    self.featuredViewController = [GGPFeaturedTableViewController new];
}

- (void)tearDown {
    self.featuredViewController = nil;
    [super tearDown];
}

- (void)testFilteredSalesFromSales {
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [NSDate ggp_addDays:1 toDate:today];
    
    id mockSale1 = OCMPartialMock([GGPSale new]);
    [OCMStub([mockSale1 isTopRetailer]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockSale1 endDateTime]) andReturn:tomorrow];
    
    id mockSale2 = OCMPartialMock([GGPSale new]);
    [OCMStub([mockSale2 isTopRetailer]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockSale2 endDateTime]) andReturn:today];
    
    NSArray *sales = @[mockSale1, [GGPSale new], mockSale2];
    
    NSArray *filteredSales = [self.featuredViewController filteredSalesFromSales:sales];
    XCTAssertEqual(filteredSales.count, 2);
    XCTAssertEqual(filteredSales[0], mockSale2);
    XCTAssertEqual(filteredSales[1], mockSale1);
}

- (void)testNumberOfRowsInSection {
    UITableView *tableView = self.featuredViewController.tableView;
    
    XCTAssertEqual([self.featuredViewController tableView:tableView numberOfRowsInSection:0], 0);
    XCTAssertEqual([self.featuredViewController tableView:tableView numberOfRowsInSection:1], 0);
    XCTAssertEqual([self.featuredViewController tableView:tableView numberOfRowsInSection:2], 0);
    XCTAssertEqual([self.featuredViewController tableView:tableView numberOfRowsInSection:3], 0);
    XCTAssertEqual([self.featuredViewController tableView:tableView numberOfRowsInSection:4], 0);
    XCTAssertEqual([self.featuredViewController tableView:tableView numberOfRowsInSection:5], 0);
    XCTAssertEqual([self.featuredViewController tableView:tableView numberOfRowsInSection:6], 0);
    
    self.featuredViewController.finishedInitialDataFetch = YES;
    self.featuredViewController.alertViewController = [GGPAlertViewController new];
    self.featuredViewController.featuredSale = [GGPSale new];
    self.featuredViewController.heroViewController = [GGPHeroViewController new];
    self.featuredViewController.nowOpenViewController = [GGPNowOpenViewController new];
    self.featuredViewController.saleImageLookup = @{@1:@1, @2:@2, @3:@3}.mutableCopy;
    
    XCTAssertEqual([self.featuredViewController tableView:tableView numberOfRowsInSection:0], 1);
    XCTAssertEqual([self.featuredViewController tableView:tableView numberOfRowsInSection:1], 1);
    XCTAssertEqual([self.featuredViewController tableView:tableView numberOfRowsInSection:2], 1);
    XCTAssertEqual([self.featuredViewController tableView:tableView numberOfRowsInSection:3], 1);
    XCTAssertEqual([self.featuredViewController tableView:tableView numberOfRowsInSection:4], 1);
    XCTAssertEqual([self.featuredViewController tableView:tableView numberOfRowsInSection:5], 1);
    XCTAssertEqual([self.featuredViewController tableView:tableView numberOfRowsInSection:6], 4);
}

@end
