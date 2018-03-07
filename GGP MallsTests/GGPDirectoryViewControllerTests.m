//
//  GGPDirectoryViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/16/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPBrand.h"
#import "GGPCategory.h"
#import "GGPCellData.h"
#import "GGPMallConfig.h"
#import "GGPDirectoryViewController.h"
#import "GGPFilterItem.h"
#import "GGPFilterLandingViewController.h"
#import "GGPFilterShowcaseViewController.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPModalViewController.h"
#import "GGPProduct.h"
#import "GGPTenant.h"
#import "GGPTenantDetailViewController.h"
#import "GGPTenantTableViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <JMap/JMap.h>
#import <UIKit/UIKit.h>

@interface GGPDirectoryViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPDirectoryViewController *directoryViewController;
@property (assign, nonatomic) NSInteger mallId;

@end

@interface GGPDirectoryViewController (Testing) <GGPTenantListDelegate>

@property (weak, nonatomic) IBOutlet UIView *selectedFilterContainer;
@property (weak, nonatomic) IBOutlet UIView *filterMessageContainer;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) GGPTenantTableViewController *tableViewController;
@property (strong, nonatomic) GGPFilterLandingViewController *filterLandingViewController;
@property (assign, nonatomic) NSInteger mallId;
@property (strong, nonatomic) UIBarButtonItem *filterButton;
@property (strong, nonatomic) NSArray *tenants;
@property (strong, nonatomic) NSArray *filteredTenants;
@property (strong, nonatomic) id<GGPFilterItem> selectedFilter;
@property (assign, nonatomic) BOOL shouldShowFilterDescriptionLabel;
@property (strong, nonatomic) NSMutableArray *ribbonItems;

- (IBAction)filterSelectionClearButtonTapped:(id)sender;

- (void)configureControls;
- (void)configureRibbon;
- (void)configureFilterButton;
- (void)configureFilterSelectionView;
- (void)configureFilterShowcase;
- (void)configureTitleView;

- (void)filterButtonTapped;
- (void)updateFilterSelectionViewForFilter:(id<GGPFilterItem>)filter;
- (void)retrieveTenants;
- (void)mapTenantWasTapped:(NSString *)destinationClientId;
- (void)filterSelected:(id<GGPFilterItem>)selectedFilter;
- (void)refreshForSelectedFilter;
- (void)selectedFilterCleared;

- (NSArray *)retrieveTenantsForCategory:(GGPFilterItem *)category;
- (GGPTenant *)tenantFromDestinationId:(NSString *)destinationClientId;
- (NSArray *)tenantsForSearchText:(NSString *)searchText;

@end

@implementation GGPDirectoryViewControllerTests

- (void)setUp {
    [super setUp];
    self.mallId = 1016;
    self.directoryViewController = [GGPDirectoryViewController new];
    [self.directoryViewController view];
}

- (void)tearDown {
    self.directoryViewController = nil;
    [super tearDown];
}

- (void)testSelectedTenant {
    id mockDirectory = OCMPartialMock(self.directoryViewController);
    id mockNavController = OCMPartialMock([UINavigationController new]);
    
    [OCMStub([mockDirectory navigationController]) andReturn:mockNavController];
    OCMExpect([mockNavController pushViewController:OCMOCK_ANY animated:YES]);
    
    [self.directoryViewController selectedTenant:nil];
    
    OCMVerifyAll(mockNavController);
}

- (void)testConfigureFilterButton {
    [self.directoryViewController configureFilterButton];
    XCTAssertNotNil(self.directoryViewController.filterButton);
    XCTAssertEqualObjects(self.directoryViewController.filterButton.title, [@"FILTER_BUTTON" ggp_toLocalized]);
}

- (void)testFilterButtonTapped {
    id mockViewController = OCMPartialMock(self.directoryViewController);
    id mockModalViewController = OCMPartialMock([GGPModalViewController new]);
    
    [OCMStub([mockViewController filterLandingViewController]) andReturn:[GGPFilterLandingViewController new]];
    
    OCMExpect([mockModalViewController initWithRootViewController:self.directoryViewController.filterLandingViewController andOnClose:OCMOCK_ANY]);
    
    [self.directoryViewController filterButtonTapped];
    
    OCMVerify(mockModalViewController);
}

- (void)testClearFilterSelection {
    self.directoryViewController.tenants = @[];
    id mockDirectory = OCMPartialMock(self.directoryViewController);
    id mockTableVC = OCMPartialMock([GGPTenantTableViewController new]);
    
    id mockSearchBar = OCMPartialMock(self.directoryViewController.searchBar);
    OCMExpect([mockSearchBar ggp_expandVertically]);
    
    [OCMStub([mockDirectory tableViewController]) andReturn:mockTableVC];
    
    OCMExpect([mockTableVC configureWithTenants:self.directoryViewController.tenants]);
    
    [self.directoryViewController selectedFilterCleared];
    
    XCTAssertNil(self.directoryViewController.selectedFilter);
    OCMVerifyAll(mockTableVC);
}

- (void)testShouldNotShowFilterDescriptionLabel {
    self.directoryViewController.selectedFilter = [GGPBrand new];
    self.directoryViewController.filteredTenants = @[];
    XCTAssertFalse(self.directoryViewController.shouldShowFilterDescriptionLabel);
    
    self.directoryViewController.selectedFilter = [GGPProduct new];
    self.directoryViewController.filteredTenants = @[];
    XCTAssertFalse(self.directoryViewController.shouldShowFilterDescriptionLabel);
    
    self.directoryViewController.selectedFilter = [GGPCategory new];
    self.directoryViewController.filteredTenants = @[ [GGPTenant new], [GGPTenant new] ];
    XCTAssertFalse(self.directoryViewController.shouldShowFilterDescriptionLabel);
}

- (void)testConfigureFilterShowcaseNotSeenProductEnabled {
    id mockDefaults = OCMClassMock([NSUserDefaults class]);
    [OCMStub([mockDefaults standardUserDefaults]) andReturn:mockDefaults];
    [OCMStub([mockDefaults boolForKey:@"GGPHasViewedFilterShowcase"]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    id mockMallManager = OCMClassMock([GGPMallManager class]);
    
    [OCMStub([mockMallManager shared]) andReturn:mockMallManager];
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    [OCMStub([mockMall config]) andReturn:mockConfig];
    [OCMStub([mockConfig productEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockController = OCMPartialMock(self.directoryViewController);
    OCMExpect([mockController ggp_addChildViewController:[OCMArg isKindOfClass:[GGPFilterShowcaseViewController class]] toPlaceholderView:OCMOCK_ANY]);
    
    [self.directoryViewController configureFilterShowcase];
    
    OCMVerifyAll(mockController);
    
    [mockDefaults stopMocking];
    [mockMallManager stopMocking];
}

- (void)testConfigureFilterShowcaseHasSeenProductEnabled {
    id mockDefaults = OCMClassMock([NSUserDefaults class]);
    [OCMStub([mockDefaults standardUserDefaults]) andReturn:mockDefaults];
    [OCMStub([mockDefaults boolForKey:@"GGPHasViewedFilterShowcase"]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    id mockMallManager = OCMClassMock([GGPMallManager class]);
    
    [OCMStub([mockMallManager shared]) andReturn:mockMallManager];
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    [OCMStub([mockMall config]) andReturn:mockConfig];
    [OCMStub([mockConfig productEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockController = OCMPartialMock(self.directoryViewController);
    OCMReject([mockController ggp_addChildViewController:[OCMArg isKindOfClass:[GGPFilterShowcaseViewController class]] toPlaceholderView:OCMOCK_ANY]);
    
    [self.directoryViewController configureFilterShowcase];
    
    OCMVerifyAll(mockController);
    
    [mockDefaults stopMocking];
    [mockMallManager stopMocking];
}

- (void)testConfigureFilterShowcaseNotSeenProductNotEnabled {
    id mockDefaults = OCMClassMock([NSUserDefaults class]);
    [OCMStub([mockDefaults standardUserDefaults]) andReturn:mockDefaults];
    [OCMStub([mockDefaults boolForKey:@"GGPHasViewedFilterShowcase"]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    id mockMallManager = OCMClassMock([GGPMallManager class]);
    
    [OCMStub([mockMallManager shared]) andReturn:mockMallManager];
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    [OCMStub([mockMall config]) andReturn:mockConfig];
    [OCMStub([mockConfig productEnabled]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockController = OCMPartialMock(self.directoryViewController);
    OCMReject([mockController ggp_addChildViewController:[OCMArg isKindOfClass:[GGPFilterShowcaseViewController class]] toPlaceholderView:OCMOCK_ANY]);
    
    [self.directoryViewController configureFilterShowcase];
    
    OCMVerifyAll(mockController);
    
    [mockDefaults stopMocking];
    [mockMallManager stopMocking];
}

- (void)testConfigureFilterShowcaseHasSeenProductNotEnabled {
    id mockDefaults = OCMClassMock([NSUserDefaults class]);
    [OCMStub([mockDefaults standardUserDefaults]) andReturn:mockDefaults];
    [OCMStub([mockDefaults boolForKey:@"GGPHasViewedFilterShowcase"]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    id mockMallManager = OCMClassMock([GGPMallManager class]);
    
    [OCMStub([mockMallManager shared]) andReturn:mockMallManager];
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    [OCMStub([mockMall config]) andReturn:mockConfig];
    [OCMStub([mockConfig productEnabled]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockController = OCMPartialMock(self.directoryViewController);
    OCMReject([mockController ggp_addChildViewController:[OCMArg isKindOfClass:[GGPFilterShowcaseViewController class]] toPlaceholderView:OCMOCK_ANY]);
    
    [self.directoryViewController configureFilterShowcase];
    
    OCMVerifyAll(mockController);
    
    [mockDefaults stopMocking];
    [mockMallManager stopMocking];
}

- (void)testFilterSelected {
    self.directoryViewController.searchBar.text = @"i searched";
    [self.directoryViewController filterSelected:[GGPBrand new]];
    XCTAssertEqual(0, self.directoryViewController.searchBar.text.length);
}

- (void)testListRibbonItemWithoutFilter {
    id mockSearchBar = OCMPartialMock(self.directoryViewController.searchBar);
    OCMExpect([mockSearchBar ggp_expandVertically]);
    
    GGPCellData *listItem = self.directoryViewController.ribbonItems[0];
    listItem.tapHandler();
    OCMVerifyAll(mockSearchBar);
}

- (void)testListRibbonItemWithFilter {
    id mockSearchBar = OCMPartialMock(self.directoryViewController.searchBar);
    OCMReject([mockSearchBar ggp_expandVertically]);
    
    self.directoryViewController.selectedFilter = [GGPBrand new];
    
    GGPCellData *listItem = self.directoryViewController.ribbonItems[0];
    listItem.tapHandler();
    OCMVerifyAll(mockSearchBar);
}

- (void)testMapRibbonItem {
    id mockSearchBar = OCMPartialMock(self.directoryViewController.searchBar);
    OCMExpect([mockSearchBar ggp_collapseVertically]);
    
    GGPCellData *mapItem = self.directoryViewController.ribbonItems[1];
    mapItem.tapHandler();
    OCMVerifyAll(mockSearchBar);
}

- (void)testTenantsForSearchText {
    GGPTenant *tenant1 = OCMPartialMock([GGPTenant new]);
    GGPTenant *tenant2 = OCMPartialMock([GGPTenant new]);
    [OCMStub(tenant1.name) andReturn:@"one"];
    [OCMStub(tenant2.name) andReturn:@"two"];
    
    self.directoryViewController.tenants = @[tenant1, tenant2];
    
    NSArray *tenants = [self.directoryViewController tenantsForSearchText:nil];
    XCTAssertEqual(self.directoryViewController.tenants, tenants);
    
    tenants = [self.directoryViewController tenantsForSearchText:@""];
    XCTAssertEqual(self.directoryViewController.tenants, tenants);
    
    tenants = [self.directoryViewController tenantsForSearchText:@"o"];
    XCTAssertEqual(2, tenants.count);
    XCTAssertTrue([tenants containsObject:tenant1]);
    XCTAssertTrue([tenants containsObject:tenant2]);
    
    tenants = [self.directoryViewController tenantsForSearchText:@"on"];
    XCTAssertEqual(1, tenants.count);
    XCTAssertTrue([tenants containsObject:tenant1]);
    
    tenants = [self.directoryViewController tenantsForSearchText:@"w"];
    XCTAssertEqual(1, tenants.count);
    XCTAssertTrue([tenants containsObject:tenant2]);
}

@end
