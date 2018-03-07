//
//  GGPSubscriptionDetailViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPSubscriptionDetailViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <XCTest/XCTest.h>

@interface GGPSubscriptionDetailViewControllerTests : XCTestCase

@property GGPSubscriptionDetailViewController *subscriptionDetailViewController;

@end

@interface GGPSubscriptionDetailViewController (Testing)

@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedMallLabel;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;

@property (strong, nonatomic) NSArray *preferredMalls;
- (void)configureLabelsForMallsList;
- (BOOL)selectedMallIsInPreferredMallsList;
- (void)fetchMinimalMalls;

@end

@implementation GGPSubscriptionDetailViewControllerTests

- (void)setUp {
    [super setUp];
    self.subscriptionDetailViewController = [GGPSubscriptionDetailViewController new];
    id mockController = OCMPartialMock(self.subscriptionDetailViewController);
    OCMStub([mockController fetchMinimalMalls]);
}

- (void)tearDown {
    self.subscriptionDetailViewController = nil;
    [super tearDown];
}

- (void)testConfigureLabelsForSingleMall {
    [self.subscriptionDetailViewController view];
    
    id mockSecondaryLabel = OCMPartialMock(self.subscriptionDetailViewController.secondaryLabel);
    id mockTableViewContainer = OCMPartialMock(self.subscriptionDetailViewController.tableViewContainer);
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall name]) andReturn:@"Mock Mall"];
    
    NSString *expectedSingleMallHeading = [NSString stringWithFormat:[@"SUBSCRIPTION_DETAIL_SINGLE_MALL" ggp_toLocalized], [mockMall name]];
    
    OCMExpect([mockSecondaryLabel ggp_collapseVertically]);
    OCMExpect([mockTableViewContainer ggp_collapseVertically]);
    
    self.subscriptionDetailViewController.preferredMalls = @[ mockMall ];
    [self.subscriptionDetailViewController configureLabelsForMallsList];
    
    XCTAssertEqualObjects(self.subscriptionDetailViewController.headingLabel.text, expectedSingleMallHeading);
    
    OCMVerifyAll(mockSecondaryLabel);
    OCMVerifyAll(mockTableViewContainer);
}

- (void)testConfigureLabelsForMultipleMalls {
    [self.subscriptionDetailViewController view];
    
    id mockMall1 = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall1 name]) andReturn:@"Mock Mall"];
    
    id mockMall2 = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall2 name]) andReturn:@"Mock Mall"];
    
    NSArray *mockPreferredMalls = @[ mockMall1, mockMall2 ];
    
    self.subscriptionDetailViewController.preferredMalls = mockPreferredMalls;
    [self.subscriptionDetailViewController configureLabelsForMallsList];
    
    XCTAssertTrue(self.subscriptionDetailViewController.secondaryLabel.text.length);
    XCTAssertEqualObjects(self.subscriptionDetailViewController.headingLabel.text, [@"SUBSCRIPTION_DETAIL_MULTIPLE_MALLS" ggp_toLocalized]);
}

- (void)testCurrentMallIsInPreferredList {
    [self.subscriptionDetailViewController view];
    
    id mockSelectedMallLabel = OCMPartialMock(self.subscriptionDetailViewController.selectedMallLabel);
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    id mockMall = OCMPartialMock([GGPMall new]);
    
    [OCMStub([mockMall mallId]) andReturnValue:@(1)];
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    OCMExpect([mockSelectedMallLabel ggp_collapseVertically]);
    
    self.subscriptionDetailViewController.preferredMalls = @[ mockMall ];
    [self.subscriptionDetailViewController configureLabelsForMallsList];
    
    XCTAssertTrue([self.subscriptionDetailViewController selectedMallIsInPreferredMallsList]);
    OCMVerifyAll(mockSelectedMallLabel);
    
    [mockMallManager stopMocking];
}

- (void)testCurrentMallNotInPreferredList {
    [self.subscriptionDetailViewController view];
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall mallId]) andReturnValue:@(1)];
    
    id mockMall2 = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall2 mallId]) andReturnValue:@(2)];
    [OCMStub([mockMall2 name]) andReturn:@"Mock Mall 2"];
    
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall2];
    
    NSString *expectedLabel = [NSString stringWithFormat:[@"SUBSCRIPTION_DETAIL_NEW_MALL_UPDATE" ggp_toLocalized], [mockMall2 name]];
    
    self.subscriptionDetailViewController.preferredMalls = @[ mockMall ];
    [self.subscriptionDetailViewController configureLabelsForMallsList];
    
    XCTAssertFalse([self.subscriptionDetailViewController selectedMallIsInPreferredMallsList]);
    XCTAssertEqualObjects(self.subscriptionDetailViewController.selectedMallLabel.text, expectedLabel);
    
    [mockMallManager stopMocking];
}

@end
