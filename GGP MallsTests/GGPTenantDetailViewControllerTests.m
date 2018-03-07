//
//  GGPTenantDetailViewControllerTests.m
//  GGP Malls
//
//  Created by Janet Lin on 12/24/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPBrand.h"
#import "GGPCategory.h"
#import "GGPEvent.h"
#import "GGPFadedLabel.h"
#import "GGPHours.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPLogoImageView.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPShoppingDetailViewController.h"
#import "GGPTenant.h"
#import "GGPTenantDetailMapViewController.h"
#import "GGPTenantDetailRibbonCollectionViewController.h"
#import "GGPTenantDetailViewController.h"
#import "GGPTenantPromotionsTableViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UITableView+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPTenantDetailViewControllerTests : XCTestCase

@property GGPTenantDetailViewController *viewController;
@property GGPTenant *tenant;

@end

@interface GGPTenantDetailViewController (Testing) <GGPTenantPromotionsTableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *promotionsContainer;
@property (weak, nonatomic) IBOutlet GGPLogoImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIView *nowOpenContainer;
@property (weak, nonatomic) IBOutlet UIView *ribbonContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promotionsContainerHeightConstraint;

@property (weak, nonatomic) IBOutlet GGPFadedLabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionContainerViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursHeaderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hoursContainerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *hoursDownArrowImageView;

@property (weak, nonatomic) IBOutlet UIView *websiteContainer;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;

@property (weak, nonatomic) IBOutlet UIView *locationContainer;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) GGPTenant *tenant;
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) NSArray *sales;
@property (strong, nonatomic) GGPTenantPromotionsTableViewController *promotionsTableViewController;

- (void)configureControls;
- (void)configureHeader;
- (void)configureRibbon;
- (void)configureWebsite;
- (void)configureLocation;
- (void)configureMapForTenant:(GGPTenant *)tenant;
- (BOOL)shouldShowRibbon;
- (BOOL)isParentCategory:(GGPCategory *)category;
- (void)selectedSale:(GGPSale *)sale;
- (void)fetchPromotionData;
- (BOOL)shouldShowTransitionNavBarForNameFrame:(CGRect)nameFrame andTransitionBarFrame:(CGRect)transitionBarFrame;
- (void)configureHours;
- (void)configureDescriptionText;
- (void)hoursLabelTapped;
- (void)mapContainerTapped;
- (void)addMapViewToContainer;
- (IBAction)websiteButtonTapped:(id)sender;
- (NSString *)prettyPrintWesbite:(NSString *)website;
- (BOOL)shouldShowNowOpen;

@end

@implementation GGPTenantDetailViewControllerTests

static NSString *const kMockName = @"tenant name";
static NSString *const kMockPhoneNumber = @"5551005000";
static NSString *const kMockWebsiteUrl = @"http://somewebsite.com";
static NSString *const kMockDescription = @"this is a description of the tenant";

- (void)setUp {
    [super setUp];
    [self createMockTenant];
    self.viewController = [[GGPTenantDetailViewController alloc] initWithTenantDetails:self.tenant];
    [self.viewController view];
}

- (void)tearDown {
    self.viewController = nil;
    self.tenant = nil;
    [super tearDown];
}

- (void)testTabBarHidden {
    id mockTabController = OCMPartialMock([UITabBarController new]);
    id mockController = OCMPartialMock(self.viewController);
    
    [OCMStub([mockController tabBarController]) andReturn:mockTabController];
    
    [self.viewController viewWillAppear:NO];
    
    XCTAssertTrue(self.viewController.tabBarController.tabBar.hidden);
}

- (void)testConfigureHeader {
    id mockImageView = OCMPartialMock(self.viewController.logoImageView);
    OCMExpect([mockImageView setImageWithURL:OCMOCK_ANY defaultName:kMockName]);
    
    [self.viewController configureHeader];
    
    XCTAssertEqualObjects(self.viewController.nameLabel.text, kMockName);
    XCTAssertTrue(self.viewController.nowOpenContainer.hidden);
    OCMVerifyAll(mockImageView);
}

- (void)testShouldShowNowOpenTrue {
    id mockTenant = OCMPartialMock(self.viewController.tenant);
    GGPCategory *mockCategory = OCMPartialMock([GGPCategory new]);
    
    [OCMStub([mockCategory code]) andReturn:@"STORE_OPENING"];
    [OCMStub([mockCategory valueForKey:@"code"]) andReturn:@"STORE_OPENING"];
    [OCMStub([mockTenant categories]) andReturn:@[ mockCategory ]];
    
    XCTAssertTrue([self.viewController shouldShowNowOpen]);
}

- (void)testShouldShowNowOpenFalse {
    id mockTenant = OCMPartialMock(self.viewController.tenant);
    GGPCategory *mockCategory = OCMPartialMock([GGPCategory new]);
    
    [OCMStub([mockCategory code]) andReturn:@"FOOD"];
    [OCMStub([mockCategory valueForKey:@"code"]) andReturn:@"FOOD"];
    [OCMStub([mockTenant categories]) andReturn:@[ mockCategory ]];
    
    XCTAssertFalse([self.viewController shouldShowNowOpen]);
}

- (void)testDescriptionTextNoDescription {
    self.viewController.tenant = [GGPTenant new];
    [self.viewController configureDescriptionText];
    XCTAssertEqual(self.viewController.descriptionContainerViewHeightConstraint.constant, 0);
}

- (void)testConfigureHoursNoOperatingHours {
    self.viewController.tenant = [GGPTenant new];
    [self.viewController configureHours];
    XCTAssertEqual(self.viewController.hoursContainerViewHeightConstraint.constant, 0);
}

- (void)testConfigureHours {
    id mockTenant = OCMPartialMock(self.viewController.tenant);
    NSString *hoursHeader = [@"DETAILS_HOURS_HEADER_TODAY" ggp_toLocalized];
    NSString *weeklyHours = @"day1\thours1\nday2\thours2";
    
    [OCMStub([mockTenant temporarilyClosed]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockTenant formattedWeeklyHours]) andReturn:weeklyHours];
    [OCMStub([mockTenant formattedHoursHeader]) andReturn:hoursHeader];
    [OCMStub([mockTenant hasHoursForToday]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockTenant operatingHours]) andReturn:@[[GGPHours new], [GGPHours new]]];
    self.viewController.tenant = mockTenant;
    
    [self.viewController configureHours];
    XCTAssertEqual(self.viewController.hoursLabel.numberOfLines, 0);
    XCTAssertEqualObjects(self.viewController.hoursHeaderLabel.text, hoursHeader);
    XCTAssertEqualObjects(self.viewController.hoursLabel.text, weeklyHours);
    XCTAssertTrue(self.viewController.hoursHeaderLabel.userInteractionEnabled);
    XCTAssertEqual(self.viewController.hoursHeaderLabel.gestureRecognizers.count, 1);
}

- (void)testConfigureHoursSingleLine {
    id mockTenant = OCMPartialMock(self.viewController.tenant);
    
    [OCMStub([mockTenant temporarilyClosed]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockTenant formattedWeeklyHours]) andReturn:@""];
    [OCMStub([mockTenant formattedHoursHeader]) andReturn:[@"DETAILS_HOURS_HEADER_TODAY" ggp_toLocalized]];
    [OCMStub([mockTenant hasHoursForToday]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockTenant operatingHours]) andReturn:@[[GGPHours new], [GGPHours new]]];
    self.viewController.tenant = mockTenant;
    
    [self.viewController configureHours];
    XCTAssertEqual(self.viewController.hoursLabel.numberOfLines, 0);
    XCTAssertEqualObjects(self.viewController.hoursLabel.text, @"");
    XCTAssertFalse(self.viewController.hoursHeaderLabel.userInteractionEnabled);
    XCTAssertEqual(self.viewController.hoursHeaderLabel.gestureRecognizers.count, 0);
}

- (void)testConfigureHoursForClosedTenant {
    id mockTenant = OCMPartialMock(self.viewController.tenant);
    
    [OCMStub([mockTenant temporarilyClosed]) andReturnValue:OCMOCK_VALUE(YES)];
    [self.viewController configureHours];
    XCTAssertEqual(self.viewController.hoursContainerViewHeightConstraint.constant, 0);
}

- (void)testHoursLabelTapped {
    id mockTenant = OCMPartialMock(self.viewController.tenant);
    NSString *hoursHeader = @"today's hours";
    [OCMStub([mockTenant formattedHoursHeader]) andReturn:hoursHeader];
    [OCMStub([mockTenant name]) andReturn:@"name"];
    self.viewController.tenant = mockTenant;
    
    [self.viewController hoursLabelTapped];
    XCTAssertEqualObjects(self.viewController.hoursHeaderLabel.text, hoursHeader);
    XCTAssertTrue(self.viewController.hoursDownArrowImageView.hidden);
}

- (void)testConfigureRibbonShouldShow {
    id mockController = OCMPartialMock(self.viewController);
    [OCMStub([mockController shouldShowRibbon]) andReturnValue:OCMOCK_VALUE(YES)];
    OCMExpect([mockController ggp_addChildViewController:[OCMArg isKindOfClass:[GGPTenantDetailRibbonCollectionViewController class]] toPlaceholderView:self.viewController.ribbonContainer]);
    
    [self.viewController configureRibbon];
    
    OCMVerifyAll(mockController);
}

- (void)testConfigureRibbonShouldNotShow {
    id mockController = OCMPartialMock(self.viewController);
    [OCMStub([mockController shouldShowRibbon]) andReturnValue:OCMOCK_VALUE(NO)];
    [[mockController reject] ggp_addChildViewController:[OCMArg isKindOfClass:[GGPTenantDetailRibbonCollectionViewController class]] toPlaceholderView:self.viewController.ribbonContainer];
    
    [self.viewController configureRibbon];
    
    OCMVerify(mockController);
}

- (void)testShouldShowRibbonHasPhoneHasWayfinding {
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockTenant = OCMClassMock([GGPTenant class]);
    [OCMStub([mockTenant phoneNumber]) andReturn:@"123-456-7890"];
    
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    self.viewController.tenant = mockTenant;
    
    XCTAssertTrue([self.viewController shouldShowRibbon]);
    
    [mockMallManager stopMocking];
}

- (void)testShouldShowRibbonHasPhoneNoWayfinding {
    id mockTenant = OCMClassMock([GGPTenant class]);
    [OCMStub([mockTenant phoneNumber]) andReturn:@"123-456-7890"];
    
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    self.viewController.tenant = mockTenant;
    
    XCTAssertTrue([self.viewController shouldShowRibbon]);
    
    [mockMallManager stopMocking];
}

- (void)testShouldShowRibbonNoPhoneHasWayfinding {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    id mockJMapManager = OCMPartialMock([GGPJMapManager shared]);
    [OCMStub([mockTenant phoneNumber]) andReturn:@""];
    [OCMStub([mockJMapManager wayfindingAvailableForTenant:OCMOCK_ANY]) andReturnValue:@YES];
    
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    self.viewController.tenant = mockTenant;
    
    XCTAssertTrue([self.viewController shouldShowRibbon]);
    
    [mockJMapManager stopMocking];
    [mockMallManager stopMocking];
}

- (void)testShouldShowRibbonNoPhoneNoWayfinding {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant phoneNumber]) andReturn:@""];
    
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    self.viewController.tenant = mockTenant;
    
    XCTAssertFalse([self.viewController shouldShowRibbon]);
    
    [mockMallManager stopMocking];
}

- (void)testConfigureWebsite {
    id mockTenant = OCMClassMock([GGPTenant class]);
    [OCMStub([mockTenant websiteUrl]) andReturn:@"http://www.apple.com"];
    self.viewController.tenant = mockTenant;
    
    [self.viewController configureWebsite];
    
    XCTAssertFalse(self.viewController.websiteContainer.hidden);
    XCTAssertEqualObjects(self.viewController.websiteButton.currentTitle, @"apple.com");
}

- (void)testConfigureWebsiteEmptyWebsite {
    id mockTenant = OCMClassMock([GGPTenant class]);
    [OCMStub([mockTenant websiteUrl]) andReturn:@""];
    id mockContainer = OCMPartialMock(self.viewController.websiteContainer);
    OCMExpect([mockContainer ggp_collapseVertically]);
    self.viewController.tenant = mockTenant;
    
    [self.viewController configureWebsite];
    
    OCMVerify(mockContainer);
}

- (void)testConfigureWebsiteNilWebsite {
    id mockTenant = OCMClassMock([GGPTenant class]);
    [OCMStub([mockTenant websiteUrl]) andReturn:nil];
    id mockContainer = OCMPartialMock(self.viewController.websiteContainer);
    OCMExpect([mockContainer ggp_collapseVertically]);
    self.viewController.tenant = mockTenant;
    
    [self.viewController configureWebsite];
    
    OCMVerify(mockContainer);
}

- (void)testPrettyPrintWebsite {
    XCTAssertEqualObjects([self.viewController prettyPrintWesbite:@"http://www.google.com"], @"google.com");
    XCTAssertEqualObjects([self.viewController prettyPrintWesbite:@"http://tenantlocations.ae.com"], @"tenantlocations.ae.com");
    XCTAssertEqualObjects([self.viewController prettyPrintWesbite:@"http://us.blogspot.pizza"], @"us.blogspot.pizza");
    XCTAssertEqualObjects([self.viewController prettyPrintWesbite:@"http://www.ae.co.uk"], @"ae.co.uk");
}

- (void)testWebsiteButtonTapped {
    id mockTenant = OCMClassMock([GGPTenant class]);
    [OCMStub([mockTenant websiteUrl]) andReturn:@"http://www.apple.com"];
    id mockApplication = OCMPartialMock([UIApplication sharedApplication]);
    
    self.viewController.tenant = mockTenant;
    
    NSURL *url = [NSURL URLWithString:@"http://www.apple.com"];
    OCMExpect([mockApplication openURL:url]);
    
    [self.viewController websiteButtonTapped:nil];
    OCMVerifyAll(mockApplication);
    [mockApplication stopMocking];
}

- (void)testConfigureLocation {
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    id mockContainer = OCMPartialMock(self.viewController.locationContainer);
    
    [OCMStub([mockMapController locationDescriptionForTenant:OCMOCK_ANY]) andReturn:@"Level 1, near Macy's"];
    [[mockContainer reject] ggp_collapseVertically];
    
    [self.viewController configureLocation];
    
    OCMVerifyAll(mockContainer);
    XCTAssertEqualObjects(self.viewController.locationLabel.text, @"Level 1, near Macy's");
    [mockMapController stopMocking];
    [mockContainer stopMocking];
}

- (void)testConfigureLocationEmptyLocation {
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    id mockContainer = OCMPartialMock(self.viewController.locationContainer);
    
    [OCMStub([mockMapController locationDescriptionForTenant:OCMOCK_ANY]) andReturn:@""];
    OCMExpect([mockContainer ggp_collapseVertically]);
    
    [self.viewController configureLocation];
    
    OCMVerifyAll(mockContainer);
    [mockMapController stopMocking];
}

- (void)testConfigureLocationNilLocation {
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    id mockContainer = OCMPartialMock(self.viewController.locationContainer);
    
    [OCMStub([mockMapController locationDescriptionForTenant:OCMOCK_ANY]) andReturn:nil];
    OCMExpect([mockContainer ggp_collapseVertically]);
    
    [self.viewController configureLocation];
    
    OCMVerifyAll(mockContainer);
    [mockMapController stopMocking];
}

- (void)testConfigureMap {
    GGPTenant *mockTenant = OCMClassMock([GGPTenant class]);
    self.viewController.tenant = mockTenant;
    id mockMapVC = OCMPartialMock([GGPJMapManager shared].mapViewController);
    
    OCMExpect([[mockMapVC ignoringNonObjectArgs] zoomToTenant:mockTenant withIcons:NO]);
    [self.viewController configureMapForTenant:mockTenant];
    
    XCTAssertEqual([GGPJMapManager shared].mapViewController.showIcons, NO);
    
    OCMVerify(mockMapVC);
    [mockMapVC stopMocking];
}

- (void)testMapContainerTapped {
    id mockDetailVC = OCMPartialMock(self.viewController);
    id mockNavController = OCMClassMock([UINavigationController class]);
    [OCMStub([mockDetailVC navigationController]) andReturn:mockNavController];
    OCMExpect([mockNavController pushViewController:[OCMArg isKindOfClass:[GGPTenantDetailMapViewController class]] animated:YES]);
    
    [self.viewController mapContainerTapped];
    
    OCMVerify(mockNavController);
}

- (void)testSelectedSale {
    id mockDetailVC = OCMPartialMock(self.viewController);
    id mockNavController = OCMClassMock([UINavigationController class]);
    [OCMStub([mockDetailVC navigationController]) andReturn:mockNavController];
    OCMExpect([mockNavController pushViewController:OCMOCK_ANY animated:YES]);
    
    [self.viewController selectedPromotion:nil];
    
    OCMVerify(mockNavController);
}

- (void)testShouldShowTransitionNavBar {
    CGRect nameFrame = CGRectMake(0, 50, 0, 49);
    CGRect navBarFrame = CGRectMake(0, 0, 0, 100);
    XCTAssertTrue([self.viewController shouldShowTransitionNavBarForNameFrame:nameFrame andTransitionBarFrame:navBarFrame]);
    
    nameFrame = CGRectMake(0, 50, 0, 51);
    navBarFrame = CGRectMake(0, 0, 0, 100);
    XCTAssertFalse([self.viewController shouldShowTransitionNavBarForNameFrame:nameFrame andTransitionBarFrame:navBarFrame]);
}

- (GGPTenant *)createMockTenantWithPhoneNumber:(NSString *)phoneNumber andWebsiteUrl:(NSString *)websiteUrl {
    id mockTenant = OCMClassMock([GGPTenant class]);
    [OCMStub([mockTenant phoneNumber]) andReturn:phoneNumber];
    [OCMStub([mockTenant websiteUrl]) andReturn:websiteUrl];
    return mockTenant;
}

- (void)createMockTenant {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant name]) andReturn:kMockName];
    [OCMStub([mockTenant phoneNumber]) andReturn:kMockPhoneNumber];
    [OCMStub([mockTenant websiteUrl]) andReturn:kMockWebsiteUrl];
    [OCMStub([mockTenant tenantDescription]) andReturn:kMockDescription];
    self.tenant = mockTenant;
}

@end
