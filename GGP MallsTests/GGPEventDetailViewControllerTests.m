//
//  GGPEventDetailViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPEvent.h"
#import "GGPEventDetailViewController.h"
#import "GGPExternalEventLink.h"
#import "GGPLogoImageView.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPTenant.h"
#import "UIColor+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <Foundation/Foundation.h>
#import "UIButton+GGPAdditions.h"

@interface GGPEventDetailViewController (Testing)

@property (weak, nonatomic) IBOutlet GGPLogoImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UIView *locationContainer;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIView *dateContainer;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *primaryLinkButton;
@property (weak, nonatomic) IBOutlet UIButton *secondaryLinkButton;
@property (weak, nonatomic) IBOutlet UILabel *eventDetailHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *mapHeaderLabel;
@property (weak, nonatomic) IBOutlet UIView *mapContainer;
@property (strong, nonatomic) GGPEvent *event;

- (void)configureControls;
- (void)configureLocation;
- (void)configureEventLinks;
- (void)configurePrimaryLink;
- (void)configureSecondaryLink;
- (void)configureTenantMap;
- (BOOL)shouldShowEntertainmentTitle;

@end

@interface GGPEventDetailViewControllerTests : XCTestCase

@property GGPEventDetailViewController *detailController;

@end

@implementation GGPEventDetailViewControllerTests

- (void)setUp {
    [super setUp];
    self.detailController = [GGPEventDetailViewController new];
    [self.detailController view];
}

- (void)tearDown {
    self.detailController = nil;
    [super tearDown];
}

- (void)testOutletsInitialized {
    XCTAssertNotNil(self.detailController.eventImageView);
    XCTAssertNotNil(self.detailController.locationButton);
    XCTAssertNotNil(self.detailController.eventNameLabel);
    XCTAssertNotNil(self.detailController.dateLabel);
    XCTAssertNotNil(self.detailController.descriptionTextView);
    XCTAssertNotNil(self.detailController.primaryLinkButton);
    XCTAssertNotNil(self.detailController.secondaryLinkButton);
    XCTAssertNotNil(self.detailController.eventDetailHeaderLabel);
}

- (void)testTabBarHidden {
    id mockTabController = OCMPartialMock([UITabBarController new]);
    id mockController = OCMPartialMock(self.detailController);
    
    [OCMStub([mockController tabBarController]) andReturn:mockTabController];
    
    [self.detailController viewWillAppear:NO];
    
    XCTAssertTrue(self.detailController.tabBarController.tabBar.hidden);
}

- (void)testConfigureControls {
    id mockEvent = OCMClassMock([GGPEvent class]);
    [OCMStub([mockEvent title]) andReturn:@"mock title"];
    [OCMStub([mockEvent promotionDates]) andReturn:@"mock dates"];
    self.detailController.event = mockEvent;
    
    [self.detailController configureControls];
    
    XCTAssertEqualObjects(self.detailController.eventNameLabel.text, @"mock title");
    XCTAssertEqualObjects(self.detailController.dateLabel.text, @"mock dates");
}

- (void)testConfigureTenantNameDefault {
    id mockTenant = OCMClassMock([GGPTenant class]);
    [OCMStub([mockTenant name]) andReturn:@"mock name"];
    id mockEvent = OCMClassMock([GGPEvent class]);
    [OCMStub([mockEvent tenant]) andReturn:mockTenant];
    self.detailController.event = mockEvent;
    
    [self.detailController configureLocation];
    
    XCTAssertEqualObjects(self.detailController.locationButton.currentTitle, @"mock name");
    XCTAssertTrue(self.detailController.locationButton.enabled);
    XCTAssertEqualObjects(self.detailController.locationButton.currentTitleColor, [UIColor ggp_blue]);
}

- (void)testConfigureTenantNameWithNoTenant {
    id mockButton = OCMPartialMock(self.detailController.locationButton);
    OCMExpect([mockButton ggp_collapseVertically]);
    
    GGPEvent *mockEvent = OCMClassMock([GGPEvent class]);
    [OCMStub([mockEvent tenant]) andReturn:nil];
    [OCMStub([mockEvent location]) andReturn:@"mock location"];
    self.detailController.event = mockEvent;
    
    [self.detailController configureLocation];
    
    XCTAssertEqualObjects(self.detailController.locationButton.currentTitle, @"mock location");
    OCMVerify(mockButton);
}

- (void)testConfigureEventWithNoExternalLinks {
    id mockController = OCMPartialMock(self.detailController);
    id mockEvent = OCMPartialMock([GGPEvent new]);
    
    id mockPrimaryButton = OCMPartialMock(self.detailController.primaryLinkButton);
    id mockSecondaryButton = OCMPartialMock(self.detailController.secondaryLinkButton);
    
    [OCMStub([mockEvent externalLinks]) andReturn:nil];
    [OCMStub([mockController event]) andReturn:mockEvent];
    
    OCMExpect([mockPrimaryButton ggp_collapseVertically]);
    OCMExpect([mockSecondaryButton ggp_collapseVertically]);
    
    [self.detailController configureEventLinks];
    
    OCMVerifyAll(mockPrimaryButton);
    OCMVerifyAll(mockSecondaryButton);
}

- (void)testConfigureEventWithOneExternalLink {
    id mockController = OCMPartialMock(self.detailController);
    id mockEvent = OCMPartialMock([GGPEvent new]);
    
    id mockPrimaryButton = OCMPartialMock(self.detailController.primaryLinkButton);
    id mockSecondaryButton = OCMPartialMock(self.detailController.secondaryLinkButton);
    
    [OCMStub([mockEvent externalLinks]) andReturn:@[[GGPExternalEventLink new]]];
    [OCMStub([mockController event]) andReturn:mockEvent];
    
    [[mockPrimaryButton reject] ggp_collapseVertically];
    OCMExpect([mockSecondaryButton ggp_collapseVertically]);
    OCMExpect([mockPrimaryButton ggp_styleAsDarkActionButton]);
    
    [self.detailController configureEventLinks];
    
    OCMVerifyAll(mockPrimaryButton);
    OCMVerifyAll(mockSecondaryButton);
}

- (void)testConfigureEventWithTwoExternalLinks {
    id mockController = OCMPartialMock(self.detailController);
    id mockEvent = OCMPartialMock([GGPEvent new]);
    
    id mockPrimaryButton = OCMPartialMock(self.detailController.primaryLinkButton);
    id mockSecondaryButton = OCMPartialMock(self.detailController.secondaryLinkButton);
    
    [OCMStub([mockEvent externalLinks]) andReturn:@[[GGPExternalEventLink new], [GGPExternalEventLink new]]];
    [OCMStub([mockController event]) andReturn:mockEvent];
    
    [[mockPrimaryButton reject] ggp_collapseVertically];
    [[mockSecondaryButton reject] ggp_collapseVertically];
    OCMExpect([mockPrimaryButton ggp_styleAsDarkActionButton]);
    OCMExpect([mockSecondaryButton ggp_styleAsLightActionButton]);
    
    [self.detailController configureEventLinks];
    
    OCMVerifyAll(mockPrimaryButton);
    OCMVerifyAll(mockSecondaryButton);
}

- (void)testShouldShowEntertainmentTitleGrandCanalNoTenant {
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall mallId]) andReturnValue:OCMOCK_VALUE(1077)];
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    XCTAssertTrue([self.detailController shouldShowEntertainmentTitle]);
    
    [mockMallManager stopMocking];
}

- (void)testShouldShowEntertainmentTitleGrandCanalHasTenant {
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall mallId]) andReturnValue:OCMOCK_VALUE(1077)];
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    id mockEvent = OCMPartialMock([GGPEvent new]);
    [OCMStub([mockEvent tenant]) andReturn:[GGPTenant new]];
    self.detailController.event = mockEvent;
    
    XCTAssertFalse([self.detailController shouldShowEntertainmentTitle]);
    
    [mockMallManager stopMocking];
}

- (void)testShouldShowEntertainmentTitleNotGrandCanal {
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall mallId]) andReturnValue:OCMOCK_VALUE(1000)];
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    XCTAssertFalse([self.detailController shouldShowEntertainmentTitle]);
    
    [mockMallManager stopMocking];
}

- (void)testConfigureTenantMapWithTenant {
    id mockLabel = OCMPartialMock(self.detailController.mapHeaderLabel);
    id mockMapContainer = OCMPartialMock(self.detailController.mapContainer);
    id mockEvent = OCMPartialMock([GGPEvent new]);
    [OCMStub([mockEvent tenant]) andReturn:[GGPTenant new]];
    
    self.detailController.event = mockEvent;
    
    [[mockLabel reject] ggp_collapseVertically];
    [[mockMapContainer reject] ggp_collapseVertically];
    
    [self.detailController configureTenantMap];
    
    OCMVerifyAll(mockLabel);
    OCMVerifyAll(mockMapContainer);
}

- (void)testConfigureTenantMapNoTenant {
    id mockLabel = OCMPartialMock(self.detailController.mapHeaderLabel);
    id mockMapContainer = OCMPartialMock(self.detailController.mapContainer);
    id mockEvent = OCMPartialMock([GGPEvent new]);
    [OCMStub([mockEvent tenant]) andReturn:nil];
    
    self.detailController.event = mockEvent;
    
    OCMExpect([mockLabel ggp_collapseVertically]);
    OCMExpect([mockMapContainer ggp_collapseVertically]);
    
    [self.detailController configureTenantMap];
    
    OCMVerifyAll(mockLabel);
    OCMVerifyAll(mockMapContainer);
}

- (NSArray *)createEventLinks {
    id mockEventLink = OCMClassMock([GGPExternalEventLink class]);
    [OCMStub([mockEventLink url]) andReturn:@"http://mockurl.com"];
    [OCMStub([mockEventLink displayText]) andReturn:@"mock display text"];
    return @[mockEventLink];
}

@end
