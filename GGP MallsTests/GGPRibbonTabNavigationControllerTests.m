//
//  GGPRibbonTabNavigationControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPRibbonNavigationViewController.h"
#import "GGPRibbonTabNavigationController.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPRibbonTabNavigationController ()

@property (strong, nonatomic) GGPRibbonNavigationViewController *ribbonViewController;
@property (strong, nonatomic) UIViewController *activeViewController;

@end

@interface GGPRibbonTabNavigationControllerTests : XCTestCase

@property (strong, nonatomic) GGPRibbonTabNavigationController *ribbonController;

@end

@implementation GGPRibbonTabNavigationControllerTests

- (void)setUp {
    [super setUp];
    self.ribbonController = [GGPRibbonTabNavigationController new];
}

- (void)tearDown {
    self.ribbonController = nil;
    [super tearDown];
}

- (void)testSetActiveController {
    id mockOldActiveController = OCMPartialMock([UIViewController new]);
    id mockNewActiveController = OCMPartialMock([UIViewController new]);
    id mockRibbonController = OCMPartialMock(self.ribbonController);
    
    self.ribbonController.activeViewController = mockOldActiveController;
    
    OCMExpect([mockOldActiveController ggp_removeFromParentViewController]);
    OCMExpect([mockRibbonController ggp_addChildViewController:mockNewActiveController toPlaceholderView:self.ribbonController.contentContainer]);
    
    self.ribbonController.activeViewController = mockNewActiveController;
    
    OCMVerifyAll(mockOldActiveController);
    OCMVerifyAll(mockRibbonController);
    
    XCTAssertEqual(self.ribbonController.activeViewController, mockNewActiveController);
}


@end
