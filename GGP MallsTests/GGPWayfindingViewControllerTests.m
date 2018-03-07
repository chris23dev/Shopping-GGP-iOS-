//
//  GGPWayfindingViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPJMapViewController+Wayfinding.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPTenant.h"
#import "GGPWayfindingDetailCardViewController.h"
#import "GGPWayfindingDisclaimerCardViewController.h"
#import "GGPWayfindingFloor.h"
#import "GGPWayfindingPickerViewController.h"
#import "GGPWayfindingToast.h"
#import "GGPWayfindingViewController.h"
#import "UIColor+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <JMap/JMap.h>

@interface GGPWayfindingViewController (Testing)

@property IBOutlet UIView *searchContainer;
@property IBOutlet UIView *mapContainer;
@property IBOutlet UIView *detailCardContainer;
@property IBOutlet NSLayoutConstraint *detailCardContainerBottomConstraint;

@property GGPTenant *toTenant;
@property GGPTenant *fromTenant;
@property GGPWayfindingDetailCardViewController *detailCardViewController;
@property GGPWayfindingDisclaimerCardViewController *disclaimerCardViewController;
@property GGPWayfindingToast *wayfindingToast;

- (void)configurePicker;
- (void)configureMap;
- (void)configureDetailCardContainer;
- (void)configureDisclaimerCard;
- (void)removeDisclaimerCardFromContainer;
- (void)populateCardContainerWithViewController:(UIViewController *)viewController;
- (void)displayDetailCardForWayfindingFloor:(GGPWayfindingFloor *)wayfindingFloor;
- (void)hideDetailCard;
- (void)configureDirectionCard;
- (void)didUpdateFloor:(JMapFloor *)floor;

@end

@interface GGPWayfindingViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPWayfindingViewController *wayfindingController;
@property (strong, nonatomic) GGPTenant *tenant;

@end

@implementation GGPWayfindingViewControllerTests

- (void)setUp {
    [super setUp];
    self.tenant = [GGPTenant new];
    self.wayfindingController = [[GGPWayfindingViewController alloc] initWithTenant:self.tenant];
}

- (void)tearDown {
    self.tenant = nil;
    self.wayfindingController = nil;
    [super tearDown];
}

- (void)testInitialization {
    [self.wayfindingController view];
    XCTAssertNotNil(self.wayfindingController.searchContainer);
    XCTAssertNotNil(self.wayfindingController.mapContainer);
    XCTAssertEqual(self.wayfindingController.toTenant, self.tenant);
    XCTAssertNotNil(self.wayfindingController.detailCardContainer);
}

- (void)testTabBarHidden {
    id mockTabController = OCMPartialMock([UITabBarController new]);
    id mockController = OCMPartialMock(self.wayfindingController);
    
    [OCMStub([mockController tabBarController]) andReturn:mockTabController];
    
    [self.wayfindingController viewWillAppear:NO];
    
    XCTAssertTrue(self.wayfindingController.tabBarController.tabBar.hidden);
}

- (void)testViewWillAppear {
    id mockController = OCMPartialMock(self.wayfindingController);
    id mockNavController = OCMPartialMock([UINavigationController new]);
    [OCMStub([mockController navigationController]) andReturn:mockNavController];
    OCMExpect([mockController configureMap]);
    
    [self.wayfindingController viewWillAppear:YES];
    
    OCMVerify(mockController);
    XCTAssertTrue(self.wayfindingController.navigationController.navigationBarHidden);
}

- (void)testViewWillDisappear {
    id mockController = OCMPartialMock(self.wayfindingController);
    id mockNavController = OCMPartialMock([UINavigationController new]);
    [OCMStub([mockController navigationController]) andReturn:mockNavController];
    
    [self.wayfindingController viewWillDisappear:YES];
    
    OCMVerifyAll(mockController);
    XCTAssertFalse(self.wayfindingController.navigationController.navigationBarHidden);
}

- (void)testConfigurePicker {
    id mockController = OCMPartialMock(self.wayfindingController);
    OCMExpect([mockController ggp_addChildViewController:[OCMArg isKindOfClass:[GGPWayfindingPickerViewController class]] toPlaceholderView:self.wayfindingController.searchContainer]);
    
    [self.wayfindingController configurePicker];
    
    OCMVerifyAll(mockController);
}

- (void)testConfigureMap {
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    OCMExpect([mockMapController resetMapView]);
    OCMExpect([mockMapController zoomToMall]);
    
    [self.wayfindingController configureMap];
    
    OCMVerifyAll(mockMapController);
    
    [mockMapController stopMocking];
}

- (void)testConfigureDetailCardContainer {
    [self.wayfindingController view];
    [self.wayfindingController configureDetailCardContainer];
    XCTAssertEqual(self.wayfindingController.detailCardContainerBottomConstraint.constant, -self.wayfindingController.detailCardContainer.frame.size.height);
    XCTAssertEqualObjects(self.wayfindingController.detailCardContainer.backgroundColor, [UIColor clearColor]);
}

- (void)testDisplayDetailCard {
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    id mockController = OCMPartialMock(self.wayfindingController);
    
    OCMStub([mockMapController dataForWayfindingAnalytics]);
    
    OCMExpect([mockController populateCardContainerWithViewController:OCMOCK_ANY]);
    
    [self.wayfindingController displayDetailCardForWayfindingFloor:[GGPWayfindingFloor new]];
    
    XCTAssertNotNil(self.wayfindingController.detailCardViewController);
    XCTAssertEqual(self.wayfindingController.detailCardContainerBottomConstraint.constant, 0);
    
    OCMVerifyAll(mockController);
    
    [mockMapController stopMocking];
}

- (void)testDisplayDisclaimerCardOneTenantSelected {
    id mockFromTenant = OCMClassMock(GGPTenant.class);
    id mockController = OCMPartialMock(self.wayfindingController);
    id mockDisclaimerCardViewController = OCMPartialMock([GGPWayfindingDisclaimerCardViewController new]);
    
    [OCMStub([mockController fromTenant]) andReturn:mockFromTenant];
    [OCMStub([mockController toTenant]) andReturn:nil];
    [OCMStub([mockController disclaimerCardViewController]) andReturn:mockDisclaimerCardViewController];
    
    OCMExpect([mockController populateCardContainerWithViewController:mockDisclaimerCardViewController]);
    
    [self.wayfindingController configureDisclaimerCard];
    
    OCMVerifyAll(mockController);
}

- (void)testDontDisplayDisclaimerCardBothTenantsSelected {
    id mockFromTenant = OCMClassMock(GGPTenant.class);
    id mockToTenant = OCMClassMock(GGPTenant.class);
    id mockController = OCMPartialMock(self.wayfindingController);
    id mockDisclaimerCardViewController = OCMPartialMock([GGPWayfindingDisclaimerCardViewController new]);
    
    [OCMStub([mockController fromTenant]) andReturn:mockFromTenant];
    [OCMStub([mockController toTenant]) andReturn:mockToTenant];
    [OCMStub([mockController disclaimerCardViewController]) andReturn:mockDisclaimerCardViewController];
    
    [[mockController reject] populateCardContainerWithViewController:mockDisclaimerCardViewController];
    
    [self.wayfindingController configureDisclaimerCard];
    
    OCMVerifyAll(mockController);
}

- (void)testConfigureDirectionCardSingleLevel {
    id mockFloor1 = OCMPartialMock([GGPWayfindingFloor new]);
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    id mockWayfindingController = OCMPartialMock(self.wayfindingController);
    
    [OCMStub([mockMapController wayfindingFloors]) andReturn:@[mockFloor1]];
    
    OCMExpect([mockWayfindingController hideDetailCard]);
    
    [self.wayfindingController configureDirectionCard];
    
    OCMVerifyAll(mockWayfindingController);
    
    [mockMapController stopMocking];
}

- (void)testConfigureDirectionCardMultiLevel {
    id mockFloor1 = OCMPartialMock([GGPWayfindingFloor new]);
    id mockFloor2 = OCMPartialMock([GGPWayfindingFloor new]);
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    id mockWayfindingController = OCMPartialMock(self.wayfindingController);
    
    [OCMStub([mockMapController wayfindingFloors]) andReturn:@[mockFloor1, mockFloor2]];
    
    OCMExpect([mockWayfindingController displayDetailCardForWayfindingFloor:mockFloor1]);
    
    [self.wayfindingController configureDirectionCard];
    
    OCMVerifyAll(mockWayfindingController);
    
    [mockMapController stopMocking];
}

- (void)testDidUpdateFloor {
    id mockJmapFloor = OCMPartialMock([JMapFloor new]);
    id mockWayfindingFloor = OCMPartialMock([GGPWayfindingFloor new]);
    id mockController = OCMPartialMock(self.wayfindingController);
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    id mockToast = OCMPartialMock([GGPWayfindingToast new]);
    
    [OCMStub([mockMapController wayfindingFloorForJmapFloor:mockJmapFloor]) andReturn:mockWayfindingFloor];
    [OCMStub([mockController wayfindingToast]) andReturn:mockToast];
    
    OCMExpect([mockController displayDetailCardForWayfindingFloor:mockWayfindingFloor]);
    OCMExpect([mockToast showWithText:OCMOCK_ANY]);
    
    [self.wayfindingController didUpdateFloor:mockJmapFloor];
    
    OCMVerifyAll(mockController);
    OCMVerifyAll(mockToast);
    
    [mockMapController stopMocking];
}

- (void)testDidUpdateWayfindingFloorIsNil {
    id mockController = OCMPartialMock(self.wayfindingController);
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    id mockToast = OCMPartialMock([GGPWayfindingToast new]);
    JMapFloor *mockJmapFloor = OCMPartialMock([JMapFloor new]);
    
    [OCMStub([mockMapController wayfindingFloorForJmapFloor:OCMOCK_ANY]) andReturn:nil];
    [OCMStub([mockController wayfindingToast]) andReturn:mockToast];
    
    OCMExpect([mockController hideDetailCard]);
    OCMExpect([mockToast showWithText:OCMOCK_ANY]);
    
    [self.wayfindingController didUpdateFloor:mockJmapFloor];
    
    OCMVerifyAll(mockController);
    OCMVerifyAll(mockToast);
    
    [mockMapController stopMocking];
}

@end
