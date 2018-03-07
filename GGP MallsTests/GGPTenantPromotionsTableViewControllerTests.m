//
//  GGPTenantPromotionsTableViewControllerIdTests.m
//  GGP Malls
//
//  Created by Janet Lin on 1/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPEvent.h"
#import "GGPSale.h"
#import "GGPTenantPromotionCell.h"
#import "GGPTenantDetailListHeaderView.h"
#import "GGPTenantPromotionsTableViewController.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

@interface GGPTenantPromotionsTableViewControllerIdTests : XCTestCase

@property (strong, nonatomic) GGPTenantPromotionsTableViewController *tableVC;
@property (strong, nonatomic) NSArray *mockSales;
@end

@interface GGPTenantPromotionsTableViewController (Testing)
@property (strong, nonatomic) NSArray *promotions;
@end

@interface GGPTenantPromotionCell (Testing)
@property (weak, nonatomic) IBOutlet UILabel *promoTitleLabel;
@end

@implementation GGPTenantPromotionsTableViewControllerIdTests

- (void)setUp {
    [super setUp];
    self.mockSales = @[[GGPSale new], [GGPSale new]];
    self.tableVC = [GGPTenantPromotionsTableViewController new];
}

- (void)tearDown {
    self.mockSales = nil;
    self.tableVC = nil;
    [super tearDown];
}

- (void)testCellIsRegistered {
    GGPTenantPromotionCell *cell = [self.tableVC.tableView dequeueReusableCellWithIdentifier:GGPTenantPromotionCellReuseIdentifier];
    XCTAssertNotNil(cell);
    
    GGPTenantDetailListHeaderView *header = [self.tableVC.tableView dequeueReusableHeaderFooterViewWithIdentifier:GGPTenantDetailListHeaderViewId];
    XCTAssertNotNil(header);
}

- (void)testConfigureWithSaleAndEvents {
    NSArray *sales = [self createArrayOfMockSales];
    NSArray *events = [self createArrayOfMockEvents];
    [self.tableVC configureWithSales:sales andEvents:events];
    XCTAssertNotNil(self.tableVC.promotions);
    XCTAssertEqual([self.tableVC tableView:self.tableVC.tableView numberOfRowsInSection:0], 7);
    XCTAssertEqualObjects([self cellAtRowIndex:0].promoTitleLabel.text, @"Event02");
    XCTAssertEqualObjects([self cellAtRowIndex:1].promoTitleLabel.text, @"Event01");
    XCTAssertEqualObjects([self cellAtRowIndex:2].promoTitleLabel.text, @"Event03");
    XCTAssertEqualObjects([self cellAtRowIndex:3].promoTitleLabel.text, @"Sale01");
    XCTAssertEqualObjects([self cellAtRowIndex:4].promoTitleLabel.text, @"Sale02");
    XCTAssertEqualObjects([self cellAtRowIndex:5].promoTitleLabel.text, @"Sale03");
    XCTAssertEqualObjects([self cellAtRowIndex:6].promoTitleLabel.text, @"Sale04");
}

- (NSArray *)createArrayOfMockSales {
    GGPSale *sale1 = OCMPartialMock([GGPSale new]);
    GGPSale *sale2 = OCMPartialMock([GGPSale new]);
    GGPSale *sale3 = OCMPartialMock([GGPSale new]);
    GGPSale *sale4 = OCMPartialMock([GGPSale new]);
    
    [OCMStub(sale1.title) andReturn:@"Sale01"];
    [OCMStub(sale2.title) andReturn:@"Sale02"];
    [OCMStub(sale3.title) andReturn:@"Sale03"];
    [OCMStub(sale4.title) andReturn:@"Sale04"];
    
    [OCMStub(sale1.endDateTime) andReturn:[NSDate ggp_createDateWithMinutes:0 hour:1 day:1 month:2 year:2016]];
    [OCMStub(sale2.endDateTime) andReturn:[NSDate ggp_createDateWithMinutes:0 hour:1 day:2 month:2 year:2016]];
    [OCMStub(sale3.endDateTime) andReturn:[NSDate ggp_createDateWithMinutes:0 hour:1 day:3 month:2 year:2016]];
    [OCMStub(sale4.endDateTime) andReturn:[NSDate ggp_createDateWithMinutes:0 hour:1 day:4 month:2 year:2016]];
    
    return @[sale4, sale2, sale1, sale3];
}

- (NSArray *)createArrayOfMockEvents {
    GGPEvent *event1 = OCMPartialMock([GGPEvent new]);
    GGPEvent *event2 = OCMPartialMock([GGPEvent new]);
    GGPEvent *event3 = OCMPartialMock([GGPEvent new]);
    
    [OCMStub(event1.title) andReturn:@"Event01"];
    [OCMStub(event2.title) andReturn:@"Event02"];
    [OCMStub(event3.title) andReturn:@"Event03"];
    
    return @[event2, event1, event3];
}

- (GGPTenantPromotionCell *)cellAtRowIndex:(NSInteger)rowIndex {
    return (GGPTenantPromotionCell *)[self.tableVC tableView:self.tableVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
}
@end
