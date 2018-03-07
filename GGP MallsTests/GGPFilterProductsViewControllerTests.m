//
//  GGPFilterProductsViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFilterProductsViewController.h"
#import "GGPTenant.h"

@interface GGPFilterProductsViewControllerTests : XCTestCase

@property GGPFilterProductsViewController *viewController;

@end

@interface GGPFilterProductsViewController (Testing)

@property NSArray *tenants;

@end

@implementation GGPFilterProductsViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [GGPFilterProductsViewController new];
}

- (void)tearDown {
    self.viewController = nil;
    [super tearDown];
}

- (void)testInitWithTenants {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    NSArray *tenantsArray = @[ mockTenant ];
    self.viewController = [[GGPFilterProductsViewController alloc] initWithTenants:tenantsArray];
    XCTAssertEqualObjects(self.viewController.tenants, tenantsArray);
}

@end
