//
//  GGPFilterCategoriesViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFilterCategoriesViewController.h"
#import "GGPCategory.h"
#import "GGPFilterSubCategoriesViewController.h"
#import "GGPFilterTableCellData.h"

@interface GGPFilterCategoriesViewControllerTests : XCTestCase

@property GGPFilterCategoriesViewController *viewController;

@end

@interface GGPFilterCategoriesViewController (Testing)

@property NSArray *filterItems;
@property GGPFilterSubCategoriesViewController *subCategoryViewController;

- (void)configureWithItems:(NSArray *)items;
- (NSArray *)tableCellItemsForCategories:(NSArray *)categories;
- (void)categoryItemTappedWithTitle:(NSString *)title andSubCategories:(NSArray *)subCategories;

@end

@implementation GGPFilterCategoriesViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [GGPFilterCategoriesViewController new];
}

- (void)tearDown {
    self.viewController = nil;
    [super tearDown];
}

- (void)testCategoryItemTappedWithTitle {
    id mockViewController = OCMPartialMock(self.viewController);
    NSArray *mockSubCategories = @[];
    
    [OCMStub([mockViewController subCategoryViewController]) andReturn:[GGPFilterSubCategoriesViewController new]];
    [OCMStub([mockViewController navigationController]) andReturn:[UINavigationController new]];
    
    OCMExpect([self.viewController.navigationController pushViewController:self.viewController.subCategoryViewController animated:YES]);
    
    [self.viewController categoryItemTappedWithTitle:OCMOCK_ANY andSubCategories:mockSubCategories];
    
    OCMVerifyAll(mockViewController);
}

- (void)testTableCellItemsForCategories {
    GGPCategory *mockCategoryWithSubCategories = OCMPartialMock([GGPCategory new]);
    GGPCategory *mockChildItem = OCMPartialMock([GGPCategory new]);
    NSString *expectedTitle = @"mock name";
    
    [OCMStub([mockCategoryWithSubCategories name]) andReturn:expectedTitle];
    [OCMStub([mockCategoryWithSubCategories childFilters]) andReturn:@[ mockChildItem ]];
    
    NSArray *mockCategories = @[ mockCategoryWithSubCategories ];
    NSArray *tableCellItemsForCategories = [self.viewController tableCellItemsForCategories:mockCategories];
    GGPFilterTableCellData *dataItem = tableCellItemsForCategories.firstObject;
    
    XCTAssertEqual(tableCellItemsForCategories.count, 1);
    XCTAssertTrue(dataItem.hasChildItems);
    XCTAssertTrue(dataItem.tapHandler);
    XCTAssertEqualObjects(dataItem.title, expectedTitle);
}

@end
