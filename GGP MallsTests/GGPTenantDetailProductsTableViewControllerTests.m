//
//  GGPTenantDetailProductsTableViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPProduct.h"
#import "GGPTenantDetailProductsTableViewController.h"

@interface GGPTenantDetailProductsTableViewControllerTests : XCTestCase

@property GGPTenantDetailProductsTableViewController *tableViewController;

@end

@interface GGPTenantDetailProductsTableViewController (Testing)

@property (strong, nonatomic) NSArray *sections;

- (GGPProduct *)parentItemForSection:(NSInteger)section;
- (GGPProduct *)childItemForIndex:(NSIndexPath *)indexPath;
- (NSArray *)childItemsForSection:(NSInteger)section;

@end

@implementation GGPTenantDetailProductsTableViewControllerTests

- (NSArray *)createSectionData {
    GGPProduct *parentFilterItem1 = [GGPProduct new];
    parentFilterItem1.code = @"electronics";
    GGPProduct *parentFilterItem2 = [GGPProduct new];
    parentFilterItem2.code = @"boys-clothing";
    
    GGPProduct *childItem1 = [GGPProduct new];
    childItem1.code = @"tablets";
    GGPProduct *childItem2 = [GGPProduct new];
    childItem2.code = @"sweaters";
    
    parentFilterItem1.childFilters = @[ childItem1 ];
    parentFilterItem2.childFilters = @[ childItem2 ];
    
    return @[ parentFilterItem1, parentFilterItem2 ];
}

- (void)setUp {
    [super setUp];
    self.tableViewController = [GGPTenantDetailProductsTableViewController new];
    self.tableViewController.sections = [self createSectionData];
}

- (void)tearDown {
    self.tableViewController = nil;
    [super tearDown];
}

- (void)testParentItemForSection {
    GGPProduct *expectedParentItem = [self.tableViewController parentItemForSection:0];
    XCTAssertEqualObjects(expectedParentItem.name, @"Electronics");
}

- (void)testChildItemsForSection {
    XCTAssertEqual([self.tableViewController childItemsForSection:0].count, 1);
}

- (void)testChildItemForIndex {
    GGPProduct *expectedChild = [self.tableViewController childItemForIndex:0];
    XCTAssertEqualObjects(expectedChild.name, @"Tablets");
}

@end
