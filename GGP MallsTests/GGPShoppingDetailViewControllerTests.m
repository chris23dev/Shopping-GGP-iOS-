//
//  GGPShoppingDetailViewControllerTests.m
//  GGP Malls
//
//  Created by Janet Lin on 1/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPButton.h"
#import "GGPFadedImageView.h"
#import "GGPFeedbackManager.h"
#import "GGPJMapManager.h"
#import "GGPJmapViewController+Highlighting.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPLogoImageView.h"
#import "GGPModalViewController.h"
#import "GGPNavigationTitleView.h"
#import "GGPShoppingDetailMapViewController.h"
#import "GGPShoppingDetailViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface GGPShoppingDetailViewControllerTests : XCTestCase
@property GGPShoppingDetailViewController *shoppingController;
@property GGPSale *mockSale;
@end

@interface GGPShoppingDetailViewController (Testing)
@property (weak, nonatomic) IBOutlet GGPFadedImageView *saleImageView;
@property (weak, nonatomic) IBOutlet GGPLogoImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *saleTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *dateContainer;
@property (weak, nonatomic) IBOutlet UIView *locationContainer;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet GGPButton *locationButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *mapHeaderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageHeightConstraint;

@property (strong, nonatomic) GGPSale *sale;

- (void)configureControls;
- (void)configureDescriptionText;
- (void)configureSaleImage;
- (void)configureTenantImage;
- (void)mapContainerTapped;

@end

@implementation GGPShoppingDetailViewControllerTests

static NSString *const kMockSaleTitle = @"sale title";
static NSString *const kMockSaleTenantName = @"tenant name";
static NSString* const kMockpromotionDates = @"JAN 5 - FEB 12";

- (void)setUp {
    [super setUp];
    [self setupMockSale];
    self.shoppingController = [[GGPShoppingDetailViewController alloc] initWithSale:self.mockSale];
    [self.shoppingController view];
}

- (void)tearDown {
    [(id)self.mockSale stopMocking];
    self.shoppingController = nil;
    self.mockSale = nil;
    [super tearDown];
}

- (void)setupMockSale {
    id mockSale = OCMClassMock(GGPSale.class);
    [OCMStub([mockSale title]) andReturn:kMockSaleTitle];
    [OCMStub([mockSale tenantName]) andReturn:kMockSaleTenantName];
    [OCMStub([mockSale promotionDates]) andReturn:kMockpromotionDates];
    self.mockSale = mockSale;
}

- (void)testTabBarHidden {
    id mockTabController = OCMPartialMock([UITabBarController new]);
    id mockController = OCMPartialMock(self.shoppingController);
    
    [OCMStub([mockController tabBarController]) andReturn:mockTabController];
    
    [self.shoppingController viewWillAppear:NO];
    
    XCTAssertTrue(self.shoppingController.tabBarController.tabBar.hidden);
}

- (void)testConfigureControls {
    XCTAssertEqualObjects(self.shoppingController.saleTitleLabel.text, kMockSaleTitle);
    XCTAssertEqualObjects(self.shoppingController.dateLabel.text, kMockpromotionDates);
    XCTAssertEqualObjects(self.shoppingController.locationButton.currentTitle, kMockSaleTenantName);
}

- (void)testMapContainerTapped {
    id mockModalViewController = OCMPartialMock([GGPModalViewController new]);
    
    OCMExpect([mockModalViewController initWithRootViewController:[OCMArg isKindOfClass:[GGPShoppingDetailMapViewController class]] andOnClose:OCMOCK_ANY]);
    
    [self.shoppingController mapContainerTapped];
    
    OCMVerify(mockModalViewController);
}

@end
