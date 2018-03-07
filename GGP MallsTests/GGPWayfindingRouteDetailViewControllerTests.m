//
//  GGPWayfindingRouteDetailViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/17/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenant.h"
#import "GGPWayfindingRouteDetailTableViewController.h"
#import "GGPWayfindingRouteDetailViewController.h"
#import <XCTest/XCTest.h>

@interface GGPWayfindingRouteDetailViewControllerTests : XCTestCase

@property NSArray *directionsList;
@property GGPTenant *fromTenant;
@property GGPTenant *toTenant;
@property GGPWayfindingRouteDetailViewController *viewController;

@end

@interface GGPWayfindingRouteDetailViewController (Testing)

@property (weak, nonatomic) IBOutlet UIView *tableContainer;

@property (strong, nonatomic) GGPWayfindingRouteDetailTableViewController *tableViewController;
@property (strong, nonatomic) NSArray *directions;
@property (strong, nonatomic) GGPTenant *fromTenant;
@property (strong, nonatomic) GGPTenant *toTenant;

- (void)configureTableView;

@end

@implementation GGPWayfindingRouteDetailViewControllerTests

- (void)setUp {
    [super setUp];
    self.directionsList = @[@"GO LEFT"];
    self.fromTenant = [GGPTenant new];
    self.toTenant = [GGPTenant new];
    self.viewController = [[GGPWayfindingRouteDetailViewController alloc] initWithDirectionsList:self.directionsList fromTenant:self.fromTenant toTenant:self.toTenant];
    [self.viewController view];
}

- (void)tearDown {
    self.viewController = nil;
    self.directionsList = nil;
    self.fromTenant = nil;
    self.toTenant = nil;
    [super tearDown];
}

- (void)testInit {
    XCTAssertNotNil(self.viewController.directions);
    XCTAssertNotNil(self.viewController.fromTenant);
    XCTAssertNotNil(self.viewController.toTenant);
}

- (void)testOutlets {
    XCTAssertNotNil(self.viewController.tableContainer);
}

- (void)testConfigureControls {
    XCTAssertNotNil(self.viewController.title);
}

- (void)testConfigureTableView {
    id mockTableViewController = OCMPartialMock([GGPWayfindingRouteDetailTableViewController new]);
    
    self.viewController.tableViewController = mockTableViewController;
    
//    OCMExpect([mockTableViewController configureWithDirections:self.directionsList fromTenant:self.fromTenant toTenant:self.toTenant]);
    
    [self.viewController configureTableView];
    
    XCTAssertNotNil(self.viewController.tableViewController);
    XCTAssertTrue([self.viewController.tableViewController isKindOfClass:[GGPWayfindingRouteDetailTableViewController class]]);
//    
//    OCMVerifyAll(mockTableViewController);
}

@end
