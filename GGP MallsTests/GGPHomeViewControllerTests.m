//
//  GGPHomeViewControllerTests.m
//  GGP Malls
//
//  Created by Janet Lin on 1/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPCellData.h"
#import "GGPDiningViewController.h"
#import "GGPFeaturedTableViewController.h"
#import "GGPHomeViewController.h"
#import "GGPJustForYouTableViewController.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMallRepository.h"
#import "GGPMovieTheater.h"
#import "GGPRibbonTabNavigationController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface GGPHomeViewControllerTests : XCTestCase

@property GGPHomeViewController *homeViewController;

@end

@interface GGPHomeViewController (Testing)

@property (weak, nonatomic) IBOutlet UIView *headerContainer;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *ribbonContainer;
@property (weak, nonatomic) IBOutlet UIView *contentContainer;

@property (strong, nonatomic) NSArray *ribbonControllers;
@property (assign, nonatomic) BOOL hasTheater;

- (void)configureRibbon;

@end

@implementation GGPHomeViewControllerTests

- (void)setUp {
    [super setUp];
    self.homeViewController = [GGPHomeViewController new];
    [self.homeViewController view];
}

- (void)tearDown {
    self.homeViewController = nil;
    [super tearDown];
}

- (void)testConfigureRibbonWithTheater {
    self.homeViewController.hasTheater = YES;
    [self.homeViewController configureRibbon];
    
    XCTAssertEqual(self.homeViewController.ribbonControllers.count, 4);
}

- (void)testConfigureRibbonNoTheater {
    self.homeViewController.hasTheater = NO;
    [self.homeViewController configureRibbon];
    
    XCTAssertEqual(self.homeViewController.ribbonControllers.count, 3);
}

- (void)testConfigureRibbonLoggedIn {
    id mockAccount = OCMClassMock(GGPAccount.class);
    
    [OCMStub([mockAccount isLoggedIn]) andReturnValue:OCMOCK_VALUE(YES)];
    
    [self.homeViewController configureRibbon];
    
    XCTAssertTrue([self.homeViewController.ribbonControllers.firstObject isKindOfClass:GGPJustForYouTableViewController.class]);
}

- (void)testConfigureRibbonNotLoggedIn {
    id mockAccount = OCMClassMock(GGPAccount.class);
    
    [OCMStub([mockAccount isLoggedIn]) andReturnValue:OCMOCK_VALUE(NO)];
    
    [self.homeViewController configureRibbon];
    
    XCTAssertTrue([self.homeViewController.ribbonControllers.firstObject isKindOfClass:GGPFeaturedTableViewController.class]);
}

@end
