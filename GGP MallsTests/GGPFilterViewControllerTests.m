//
//  GGPFilterViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/23/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPFilterCategoriesViewController.h"
#import "GGPFilterLandingViewController.h"
#import "GGPMall.h"
#import "GGPMallManager.h"

@interface GGPFilterViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPFilterLandingViewController *filterViewController;

@end

@interface GGPFilterLandingViewController (Testing)

@property IBOutlet UIView *tableContainer;

@property GGPFilterCategoriesViewController *filterCategoriesViewController;

- (void)categoryItemTapped;
- (NSArray *)configureParentFilterCategories;

@end

@implementation GGPFilterViewControllerTests

- (void)setUp {
    [super setUp];
    self.filterViewController = [GGPFilterLandingViewController new];
}

- (void)tearDown {
    self.filterViewController = nil;
    [super tearDown];
}

- (void)testConfigureParentCategoriesProductEnaled {
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig productEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    XCTAssertEqual([self.filterViewController configureParentFilterCategories].count, 3);
    [mockMallManager stopMocking];
}

- (void)testConfigureParentCategoriesProductDisabled {
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig productEnabled]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    XCTAssertEqual([self.filterViewController configureParentFilterCategories].count, 1);
    [mockMallManager stopMocking];
}

- (void)testCategoryItemTapped {
    id mockViewController = OCMPartialMock(self.filterViewController);
    
    [OCMStub([mockViewController navigationController]) andReturn:[UINavigationController new]];
    [OCMStub([mockViewController filterCategoriesViewController]) andReturn:[GGPFilterCategoriesViewController new]];
    
    OCMExpect([self.filterViewController.navigationController pushViewController:self.filterViewController.filterCategoriesViewController animated:YES]);
    
    [self.filterViewController categoryItemTapped];
    
    OCMVerifyAll(mockViewController);
}

@end
