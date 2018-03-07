//
//  GGPShoppingCategoryViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCategory.h"
#import "GGPShoppingCategoryViewController.h"
#import "GGPShoppingSubCategoryViewController.h"
#import "GGPShoppingTableViewController.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPShoppingCategoryViewController (Testing)

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIStackView *subCategoryStackView;

@property (strong, nonatomic) GGPCategory *category;
@property (strong, nonatomic) NSMutableArray *subCategoryViewControllers;
@property (strong, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) BOOL isExpanded;

- (void)expandCategory;
- (void)categoryTapped;
- (void)toggleCategory;

@end

@interface GGPShoppingCategoryViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPShoppingCategoryViewController *viewController;

@end

@implementation GGPShoppingCategoryViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [GGPShoppingCategoryViewController new];
}

- (void)tearDown {
    self.viewController = nil;
    [super tearDown];
}

- (void)testExpandCategory {
    [self.viewController view];
    [self.viewController collapseCategory];
    
    id mockController = OCMPartialMock(self.viewController);
    id mockCategory = OCMPartialMock([GGPCategory new]);
    
    [OCMStub([mockCategory name]) andReturn:@"name"];
    [OCMStub([mockCategory count]) andReturnValue:OCMOCK_VALUE(2)];
    [OCMStub([mockCategory childFilters]) andReturn:@[mockCategory, mockCategory]];
    [OCMStub([mockController category]) andReturn:mockCategory];
    
    [self.viewController expandCategory];
    
    XCTAssertFalse([self.viewController.subCategoryStackView.arrangedSubviews containsObject:self.viewController.titleLabel]);
    XCTAssertEqual(self.viewController.subCategoryStackView.arrangedSubviews.count, 2);
    XCTAssertEqual(self.viewController.subCategoryViewControllers.count, 2);
}

- (void)testCollapseCategory {
    [self.viewController view];
    
    id mockController = OCMPartialMock(self.viewController);
    id mockCategory = OCMPartialMock([GGPCategory new]);
    
    [OCMStub([mockCategory name]) andReturn:@"name"];
    [OCMStub([mockCategory count]) andReturnValue:OCMOCK_VALUE(2)];
    [OCMStub([mockCategory childFilters]) andReturn:@[mockCategory, mockCategory]];
    [OCMStub([mockController category]) andReturn:mockCategory];
    
    [self.viewController expandCategory];
    [self.viewController collapseCategory];
    
    XCTAssertTrue([self.viewController.subCategoryStackView.arrangedSubviews containsObject:self.viewController.titleLabel]);
    XCTAssertEqual(self.viewController.subCategoryStackView.arrangedSubviews.count, 1);
    XCTAssertEqual(self.viewController.subCategoryViewControllers.count, 0);
}

- (void)testCategoryTappedHasSubCategoriesNotExpanded {
    id mockController = OCMPartialMock(self.viewController);
    id mockCategory = OCMPartialMock([GGPCategory new]);
    
    [OCMStub([mockCategory childFilters]) andReturn:@[[GGPCategory new]]];
    [OCMStub([mockController category]) andReturn:mockCategory];
    [OCMStub([mockController subCategoryViewControllers]) andReturn:nil];
    
    OCMExpect([mockController expandCategory]);
    
    [self.viewController categoryTapped];
    
    OCMVerifyAll(mockController);
}

- (void)testCategoryTappedNoSubCategoriesNotExpanded {
    id mockController = OCMPartialMock(self.viewController);
    id mockCategory = OCMPartialMock([GGPCategory new]);
    id mockNavController = OCMPartialMock([UINavigationController new]);
    
    [OCMStub([mockCategory childFilters]) andReturn:nil];
    [OCMStub([mockController category]) andReturn:mockCategory];
    [OCMStub([mockController subCategoryViewControllers]) andReturn:nil];
    [OCMStub([mockController navigationController]) andReturn:mockNavController];
    
    OCMExpect([mockNavController pushViewController:[OCMArg isKindOfClass:[GGPShoppingTableViewController class]] animated:YES]);
    
    [self.viewController categoryTapped];
    
    OCMVerifyAll(mockNavController);
}

- (void)testCategoryTappedAlreadyExpanded {
    id mockController = OCMPartialMock(self.viewController);
    id mockCategory = OCMPartialMock([GGPCategory new]);
    
    [OCMStub([mockCategory childFilters]) andReturn:@[[GGPCategory new]]];
    [OCMStub([mockController category]) andReturn:mockCategory];
    [OCMStub([mockController subCategoryViewControllers]) andReturn:@[[GGPShoppingSubCategoryViewController new]]];
    
    OCMExpect([mockController collapseCategory]);
    
    [self.viewController categoryTapped];
    
    OCMVerifyAll(mockController);
}

@end
