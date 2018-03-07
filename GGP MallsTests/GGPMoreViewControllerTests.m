//
//  GGPMoreViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAccountViewController.h"
#import "GGPAuthenticationController.h"
#import "GGPCellData.h"
#import "GGPChangeMallViewController.h"
#import "GGPMall.h"
#import "GGPMallInfoViewController.h"
#import "GGPMallManager.h"
#import "GGPModalViewController.h"
#import "GGPMoreTableViewController.h"
#import "GGPMoreViewController.h"
#import "GGPTabBarController.h"
#import "GGPWebViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import "GGPSocialMedia.h"

@interface GGPMoreViewController () <GGPAuthenticationDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentMallDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentMallNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeMallButton;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *privacyTermsButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *instagramButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@property (strong, nonatomic) GGPMall *selectedMall;

- (NSArray *)createTableItems;
- (NSArray *)createAuthenticatedTableItems;
- (NSArray *)createUnauthenticatedTableItems;
- (void)configureSocialIcons;

@end

@interface GGPMoreViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPMoreViewController *moreViewController;

@end

@implementation GGPMoreViewControllerTests

- (void)setUp {
    [super setUp];
    self.moreViewController = [GGPMoreViewController new];
}

- (void)tearDown {
    self.moreViewController = nil;
    [super tearDown];
}

- (void)testCreateTableItemsAuthenticated {
    id mockAccount = OCMClassMock(GGPAccount.class);
    id mockController = OCMPartialMock(self.moreViewController);
    
    [OCMStub([mockAccount isLoggedIn]) andReturnValue:OCMOCK_VALUE(YES)];
    
    OCMExpect([mockController createAuthenticatedTableItems]);
    
    [self.moreViewController createTableItems];
    
    OCMVerifyAll(mockController);
}

- (void)testCreateTableItemsUnauthenticated {
    id mockAccount = OCMClassMock(GGPAccount.class);
    id mockController = OCMPartialMock(self.moreViewController);
    
    [OCMStub([mockAccount isLoggedIn]) andReturnValue:OCMOCK_VALUE(NO)];
    
    OCMExpect([mockController createUnauthenticatedTableItems]);
    
    [self.moreViewController createTableItems];
    
    OCMVerifyAll(mockController);
}

@end
