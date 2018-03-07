//
//  GGPFilterSubCategoriesViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFilterSubCategoriesViewController.h"

@interface GGPFilterSubCategoriesViewControllerTests : XCTestCase

@property GGPFilterSubCategoriesViewController *viewController;

@end

@interface GGPFilterSubCategoriesViewController (Testing)

@end

@implementation GGPFilterSubCategoriesViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [GGPFilterSubCategoriesViewController new];
}

- (void)tearDown {
    self.viewController = nil;
    [super tearDown];
}

@end
