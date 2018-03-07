//
//  GGPShoppingViewControllerTests.m
//  GGP Malls
//
//  Created by Janet Lin on 1/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCategory.h"
#import "GGPShoppingViewController.h"
#import "GGPShoppingCategoryViewController.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPShoppingViewController () <GGPShoppingCategoryDelegate>

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) GGPShoppingCategoryViewController *expandedViewController;

- (void)configureCategories;
- (void)addSeeAllSection;
- (void)didExpandCategoryViewController:(GGPShoppingCategoryViewController *)expandedViewController;

@end

@interface GGPShoppingViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPShoppingViewController *shoppingViewController;

@end

@implementation GGPShoppingViewControllerTests

- (void)setUp {
    [super setUp];
    self.shoppingViewController = [GGPShoppingViewController new];
    [self.shoppingViewController view];
}

- (void)tearDown {
    self.shoppingViewController = nil;
    [super tearDown];
}

- (void)testConfigureCategories {
    id mockController = OCMPartialMock(self.shoppingViewController);
    id mockCategory = OCMPartialMock([GGPCategory new]);
    
    [OCMStub([mockController categories]) andReturn:@[mockCategory, mockCategory]];
    
#warning There is a race condition of this test calling configureCategories and the class calling it from the fetchCategories completion. Revisit when adding support for refreshing upon api updates
    for (UIView *arrangedSubview in self.shoppingViewController.stackView.arrangedSubviews) {
        [arrangedSubview removeFromSuperview];
    }
    [self.shoppingViewController configureCategories];
    
    XCTAssertEqual(self.shoppingViewController.stackView.arrangedSubviews.count, 3);
}

@end
