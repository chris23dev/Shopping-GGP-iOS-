//
//  GGPParkingTenantPickerViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPMallRepository.h"
#import "GGPParkingTenantPickerViewController.h"
#import "GGPTenant.h"
#import "GGPTenantDetailMapViewController.h"
#import "GGPTenantSearchDelegate.h"
#import "GGPTenantSearchTableViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"

@interface GGPParkingTenantPickerViewController () <GGPTenantSearchDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectTenantButton;
@property (weak, nonatomic) IBOutlet UIView *tenantTextFieldContainerView;
@property (weak, nonatomic) IBOutlet UIView *tenantDetailContainerView;
@property (weak, nonatomic) IBOutlet UIButton *tenantNameButton;
@property (weak, nonatomic) IBOutlet UILabel *tenantLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewTenantButton;
@property (strong, nonatomic) GGPTenant *selectedTenant;
@property (strong, nonatomic) GGPTenantSearchTableViewController *searchTableController;
@property (strong, nonatomic) UISearchController *searchController;

- (void)configureSearch;
- (void)updateSelectedTenant:(GGPTenant *)tenant;
- (void)configureTenantDetailViewAsVisible:(BOOL)isVisible;

@end

@interface GGPParkingTenantPickerViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPParkingTenantPickerViewController *pickerController;

@end

@implementation GGPParkingTenantPickerViewControllerTests

- (void)setUp {
    [super setUp];
    self.pickerController = [GGPParkingTenantPickerViewController new];
    [self.pickerController view];
}

- (void)tearDown {
    self.pickerController = nil;
    [super tearDown];
}

- (void)testConfigureSearch {
    [self.pickerController configureSearch];
    
    XCTAssertNotNil(self.pickerController.searchTableController);
    XCTAssertNotNil(self.pickerController.searchController);
    XCTAssertEqual(self.pickerController.searchTableController.searchDelegate, self.pickerController);
    XCTAssertEqual(self.pickerController.searchController.searchResultsUpdater, self.pickerController.searchTableController);
    XCTAssertEqualObjects(self.pickerController.searchController.searchBar.placeholder, [@"PARKING_INFO_SELECT_STORE" ggp_toLocalized]);
}

- (void)testHideTenantDetailView {
    id mockContainer = OCMPartialMock(self.pickerController.tenantDetailContainerView);
    OCMExpect([mockContainer ggp_collapseVertically]);
    
    [self.pickerController configureTenantDetailViewAsVisible:NO];
    
    XCTAssertEqualObjects(self.pickerController.selectTenantButton.currentTitle, [@"PARKING_INFO_SELECT_STORE" ggp_toLocalized]);
    
    OCMVerifyAll(mockContainer);
}

- (void)testShowTenantDetailView {
    id mockContainer = OCMPartialMock(self.pickerController.tenantDetailContainerView);
    OCMExpect([mockContainer ggp_expandVertically]);
    
    [self.pickerController configureTenantDetailViewAsVisible:YES];
    
    OCMVerifyAll(mockContainer);
}

- (void)testUpdateSelectedTenant {
    id mockTenant = OCMClassMock([GGPTenant class]);
    [OCMStub([mockTenant name]) andReturn:@"mock name"];
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    [OCMStub([mockMapController locationDescriptionForTenant:OCMOCK_ANY]) andReturn:@"mock location"];
    [OCMStub([mockMapController parkingLocationDescriptionForTenant:OCMOCK_ANY]) andReturn:@"mock parking location"];
    
    [self.pickerController updateSelectedTenant:mockTenant];
    
    XCTAssertEqualObjects(self.pickerController.selectedTenant, mockTenant);
    XCTAssertEqualObjects(self.pickerController.tenantNameButton.currentTitle, @"mock name");
    XCTAssertEqualObjects(self.pickerController.tenantLocationLabel.text, @"mock location");
    XCTAssertEqualObjects(self.pickerController.parkingLocationLabel.text, @"mock parking location");
}

- (void)testUpdateSelectedChildTenant {
    GGPTenant *mockParent = OCMPartialMock([GGPTenant new]);
    [OCMStub(mockParent.name) andReturn:@"Parent"];
    
    GGPTenant *mockChild = OCMPartialMock([GGPTenant new]);
    [OCMStub(mockChild.name) andReturn:@"Child"];
    mockChild.parentTenant = mockParent;
    
    [self.pickerController updateSelectedTenant:mockChild];
    
    XCTAssertEqualObjects(self.pickerController.selectedTenant, mockChild);
    XCTAssertEqualObjects(self.pickerController.tenantNameButton.currentTitle, @"Child - inside Parent");
    XCTAssertEqualObjects(self.pickerController.tenantLocationLabel.text, @"Inside Parent");
    XCTAssertEqualObjects(self.pickerController.parkingLocationLabel.text, @"Park near Parent");
}

@end
