//
//  GGPNavigationControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAlert.h"
#import "GGPAppContainerViewController.h"
#import "GGPDirectoryViewController.h"
#import "GGPHomeViewController.h"
#import "GGPNavigationController.h"
#import "GGPParkingReminder.h"
#import "GGPParkingReminderViewController.h"
#import "GGPShoppingViewController.h"
#import <Foundation/Foundation.h>

@interface GGPNavigationController (Testing) <UINavigationControllerDelegate>

@end

@interface GGPNavigationControllerTests : XCTestCase

@property (strong, nonatomic) GGPNavigationController *navController;

@end

@implementation GGPNavigationControllerTests

- (void)setUp {
    [super setUp];
    self.navController = [GGPNavigationController new];
    [self.navController view];
}

- (void)tearDown {
    self.navController = nil;
    [super tearDown];
}

- (void)testViewDidLoad {
    [self.navController viewDidLoad];
    
    XCTAssertEqual(self.navController.delegate, self.navController);
}

- (void)testWillShowViewController {
    UIViewController *testController = [UIViewController new];
    
    [self.navController navigationController:self.navController willShowViewController:testController animated:NO];
    
    XCTAssertNotNil(testController.navigationItem.backBarButtonItem);
}

@end
