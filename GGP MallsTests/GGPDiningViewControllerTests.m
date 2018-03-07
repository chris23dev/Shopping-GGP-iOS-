//
//  GGPDiningViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAnalytics.h"
#import "GGPBrand.h"
#import "GGPCategory.h"
#import "GGPDiningViewController.h"
#import "GGPMallRepository.h"
#import "GGPTenant.h"
#import "GGPTenantDetailViewController.h"
#import "GGPTenantListDelegate.h"
#import "GGPTenantTableViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <Foundation/Foundation.h>

@interface GGPDiningViewController (Testing) <GGPTenantListDelegate>

@property IBOutlet UIView *tableViewContainer;
@property GGPTenantTableViewController *tenantTableViewController;

- (void)configureControls;
- (void)retrieveTenantsForDining;
- (void)configureTableViewWithTenants:(NSArray *)tenants;
- (NSArray *)filterTenantsForDining:(NSArray *)tenants;

@end

@interface GGPDiningViewControllerTests : XCTestCase

@property GGPDiningViewController *diningController;

@end

@implementation GGPDiningViewControllerTests

- (void)setUp {
    [super setUp];
    self.diningController = [GGPDiningViewController new];
}

- (void)tearDown {
    self.diningController = nil;
    [super tearDown];
}

- (void)testViewDidLoad {
    id mockController = OCMPartialMock(self.diningController);
    OCMExpect([mockController configureControls]);
    OCMExpect([mockController retrieveTenantsForDining]);
    
    [self.diningController viewDidLoad];
    
    OCMVerifyAll(mockController);
}

- (void)testViewWillAppear {
    id mockAnalytics = OCMPartialMock([GGPAnalytics shared]);
    OCMExpect([mockAnalytics trackScreen:GGPAnalyticsScreenDining]);
    
    [self.diningController viewWillAppear:YES];
    
    OCMVerifyAll(mockAnalytics);
    
    [mockAnalytics stopMocking];
}

- (void)testConfigureControls {
    id mockController = OCMPartialMock(self.diningController);
    [OCMStub([mockController tableViewContainer]) andReturn:[UIView new]];
    OCMExpect([mockController ggp_addChildViewController:[OCMArg isKindOfClass:GGPTenantTableViewController.class] toPlaceholderView:self.diningController.tableViewContainer]);
    
    [self.diningController configureControls];
    
    XCTAssertNotNil(self.diningController.tenantTableViewController);
    XCTAssertEqual(self.diningController.tenantTableViewController.delegate, self.diningController);
    OCMVerifyAll(mockController);
}

- (void)testConfigureTableViewWithTenants {
    NSArray *mockTenants = @[[GGPTenant new]];
    id mockController = OCMPartialMock(self.diningController);
    [OCMStub([mockController filterTenantsForDining:OCMOCK_ANY]) andReturn:mockTenants];
    id mockTableController = OCMPartialMock([GGPTenantTableViewController new]);
    self.diningController.tenantTableViewController = mockTableController;
    OCMExpect([mockTableController configureWithTenants:mockTenants]);
    
    [self.diningController configureTableViewWithTenants:nil];
    
    OCMVerifyAll(mockTableController);
}

- (void)testFilterTenantsForDining {
    NSArray *tenants = [self tenantsForDiningFilterTest];
    NSArray *filteredTenants = [self.diningController filterTenantsForDining:tenants];

    GGPTenant *filteredTenant = filteredTenants.firstObject;
    GGPCategory *filteredCategory = filteredTenant.categories.firstObject;
    
    XCTAssertEqual(filteredTenants.count, 1);
    XCTAssertEqual(filteredCategory.code, @"FOOD");
}

- (NSArray *)tenantsForDiningFilterTest {
    GGPTenant *mockTenant1 = OCMPartialMock([GGPTenant new]);
    GGPTenant *mockTenant2 = OCMPartialMock([GGPTenant new]);
    GGPTenant *mockTenant3 = OCMPartialMock([GGPTenant new]);
    
    GGPBrand *mockBrand1 = OCMPartialMock([GGPBrand new]);
    GGPBrand *mockBrand2 = OCMPartialMock([GGPBrand new]);
    
    GGPCategory *mockCategory1 = OCMPartialMock([GGPCategory new]);
    GGPCategory *mockCategory2 = OCMPartialMock([GGPCategory new]);
    
    [OCMStub([mockCategory1 code]) andReturn:@"FOOD"];
    [OCMStub([mockCategory2 code]) andReturn:@"NOTFOOD"];
    [OCMStub([mockCategory1 valueForKey:@"code"]) andReturn:@"FOOD"];
    [OCMStub([mockCategory2 valueForKey:@"code"]) andReturn:@"NOTFOOD"];
    
    [OCMStub([mockTenant1 categories]) andReturn:@[ mockCategory1 ]];
    [OCMStub([mockTenant2 categories]) andReturn:@[ mockCategory2 ]];
    
    [OCMStub([mockTenant1 brands]) andReturn:@[ mockBrand1] ];
    [OCMStub([mockTenant2 brands]) andReturn:@[ mockBrand2] ];
    [OCMStub([mockTenant3 brands]) andReturn:nil];
    
    return @[mockTenant1, mockTenant2, mockTenant3];
}

@end
