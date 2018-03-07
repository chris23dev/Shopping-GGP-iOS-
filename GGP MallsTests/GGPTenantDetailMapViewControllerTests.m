//
//  GGPTenantDetailMapViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPTenant.h"
#import "GGPTenantDetailMapViewController.h"
#import "UIViewController+GGPAdditions.h"
#import <Foundation/Foundation.h>

@interface GGPTenantDetailMapViewController ()

@property (strong, nonatomic) GGPTenant *tenant;

@end

@interface GGPTenantDetailMapViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPTenantDetailMapViewController *tenantMapViewController;
@property (strong, nonatomic) GGPTenant *tenant;

@end

@implementation GGPTenantDetailMapViewControllerTests

- (void)setUp {
    [super setUp];
    self.tenant = [GGPTenant new];
    self.tenantMapViewController = [[GGPTenantDetailMapViewController alloc] initWithTenant:self.tenant];
}

- (void)tearDown {
    self.tenant = nil;
    self.tenantMapViewController = nil;
    [super tearDown];
}

- (void)testInitialization {
    XCTAssertEqual(self.tenantMapViewController.tenant, self.tenant);
}

- (void)testViewWillAppear {
    id mockTenantMapVC = OCMPartialMock(self.tenantMapViewController);
    id mockMapVC = OCMPartialMock([GGPJMapManager shared].mapViewController);
    OCMExpect([mockTenantMapVC ggp_addChildViewController:[OCMArg isKindOfClass:[GGPJMapViewController class]] toPlaceholderView:self.tenantMapViewController.view]);
    OCMExpect([mockMapVC zoomToTenant:self.tenant withIcons:YES]);
    
    [self.tenantMapViewController viewWillAppear:YES];
    
    OCMVerifyAll(mockTenantMapVC);
    OCMVerifyAll(mockMapVC);
    
    [mockMapVC stopMocking];
}

- (void)testViewWillDisappear {
    id mockMapVC = OCMPartialMock([GGPJMapManager shared].mapViewController);
    OCMExpect([mockMapVC ggp_removeFromParentViewController]);
    
    [self.tenantMapViewController viewWillDisappear:YES];
    
    OCMVerifyAll(mockMapVC);
    
    [mockMapVC stopMocking];
}

@end
