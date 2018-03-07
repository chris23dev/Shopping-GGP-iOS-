//
//  GGPWayfindingPickerViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPJmapViewcontroller+Levels.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPMallRepository.h"
#import "GGPTenant.h"
#import "GGPTenantSearchDelegate.h"
#import "GGPTenantSearchTableViewController.h"
#import "GGPWayfindingPickerViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <JMap/JMap.h>

@interface GGPWayfindingPickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate, GGPTenantSearchDelegate>

@property (weak, nonatomic) IBOutlet UIView *fromContainer;
@property (weak, nonatomic) IBOutlet UIView *toContainer;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromDestinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDestinationLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *swapButton;
@property (weak, nonatomic) IBOutlet UIView *levelContainer;
@property (weak, nonatomic) IBOutlet UITextField *levelTextField;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) GGPTenantSearchTableViewController *searchTableController;

@property (strong, nonatomic) GGPTenant *toTenant;
@property (strong, nonatomic) GGPTenant *fromTenant;
@property (strong, nonatomic) NSArray *allTenants;
@property (assign, nonatomic) BOOL isFromSearchActive;
@property (strong, nonatomic) UIPickerView *levelPickerView;
@property (strong, nonnull, readonly) GGPTenant *wayfindingStartTenant;
@property (strong, nonnull, readonly) GGPTenant *wayfindingEndTenant;

- (void)configureControls;
- (void)configureSearch;
- (void)configureButtons;
- (void)configureFromContainer;
- (void)configureToContainer;
- (void)configureTextStyleForLabel:(UILabel *)label andTenant:(GGPTenant *)tenant;
- (void)configureLevelSelection;
- (void)fromContainerTapped;
- (void)toContainerTapped;
- (IBAction)backButtonTapped:(id)sender;
- (void)formatTenantNamesForDisplay:(NSArray *)tenants;
- (void)configureSearchListWithoutTenant:(GGPTenant *)tenant;
- (IBAction)swapButtonTapped:(id)sender;
- (void)updateLevelSelectionDisplay;

@end

@interface GGPWayfindingPickerViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPWayfindingPickerViewController *pickerController;
@property (strong, nonatomic) GGPTenant *tenant;

@end

@implementation GGPWayfindingPickerViewControllerTests

- (void)setUp {
    [super setUp];
    self.tenant = [GGPTenant new];
    self.pickerController = [[GGPWayfindingPickerViewController alloc] initWithTenant:self.tenant];
}

- (void)tearDown {
    self.tenant = nil;
    self.pickerController = nil;
    [super tearDown];
}

- (void)testInitialization {
    XCTAssertEqual(self.pickerController.toTenant, self.tenant);
}

- (void)testConfigureControls {
    id mockController = OCMPartialMock(self.pickerController);
    OCMExpect([mockController configureSearch]);
    OCMExpect([mockController configureButtons]);
    OCMExpect([mockController configureFromContainer]);
    OCMExpect([mockController configureToContainer]);
    
    [self.pickerController configureControls];
    
    OCMVerifyAll(mockController);
}

- (void)testConfigureTextStyleForLabel {
    [self.pickerController view];
    
    id mockController = OCMPartialMock(self.pickerController);
    id mockTenant = OCMPartialMock([GGPTenant new]);
    
    [OCMStub([mockTenant name]) andReturn:@"test name"];
    [OCMStub([mockController toTenant]) andReturn:mockTenant];
    
    [self.pickerController configureTextStyleForLabel:self.pickerController.toDestinationLabel andTenant:self.pickerController.toTenant];
    
    XCTAssertEqualObjects(self.pickerController.toDestinationLabel.textColor, [UIColor blackColor]);
    XCTAssertEqualObjects(self.pickerController.toDestinationLabel.text, @"test name");
}

- (void)testConfigureTextStyleForLabelNoToTenant {
    [self.pickerController view];
    
    [self.pickerController configureTextStyleForLabel:self.pickerController.toDestinationLabel andTenant:nil];
    
    XCTAssertEqualObjects(self.pickerController.toDestinationLabel.textColor, [UIColor grayColor]);
    XCTAssertEqualObjects(self.pickerController.toDestinationLabel.text, [@"WAYFINDING_SELECT_DESTINATION" ggp_toLocalized]);
}

- (void)testConfigureTextStyleForLabelNoFromTenant {
    [self.pickerController view];
    
    [self.pickerController configureTextStyleForLabel:self.pickerController.fromDestinationLabel andTenant:nil];
    
    XCTAssertEqualObjects(self.pickerController.fromDestinationLabel.textColor, [UIColor grayColor]);
    XCTAssertEqualObjects(self.pickerController.fromDestinationLabel.text, [@"WAYFINDING_SELECT_NEAREST_STORE" ggp_toLocalized]);
}
- (void)testConfigureLevelSelection {
    [self.pickerController view];
    
    [self.pickerController configureLevelSelection];
    
    XCTAssertNotNil(self.pickerController.levelPickerView);
    XCTAssertEqual(self.pickerController.levelPickerView.delegate, self.pickerController);
    XCTAssertEqual(self.pickerController.levelPickerView.dataSource, self.pickerController);
    XCTAssertTrue(self.pickerController.levelContainer.hidden);
}

- (void)testFromContainerTapped {
    id mockController = OCMPartialMock(self.pickerController);
    OCMExpect([mockController presentViewController:self.pickerController.searchController animated:YES completion:nil]);
    
    [self.pickerController fromContainerTapped];
    
    XCTAssertTrue(self.pickerController.isFromSearchActive);
    OCMVerifyAll(mockController);
}

- (void)testToContainerTapped {
    id mockController = OCMPartialMock(self.pickerController);
    OCMExpect([mockController presentViewController:self.pickerController.searchController animated:YES completion:nil]);
    
    [self.pickerController toContainerTapped];
    
    XCTAssertFalse(self.pickerController.isFromSearchActive);
    OCMVerifyAll(mockController);
}

- (void)testDidSelectFromTenant {
    [self.pickerController view];
    
    id mockSearchController = OCMPartialMock(self.pickerController.searchController);
    id mockController = OCMPartialMock(self.pickerController);
    id mockTenant = OCMPartialMock([GGPTenant new]);
    
    OCMExpect([mockSearchController dismissViewControllerAnimated:YES completion:nil]);
    OCMExpect([mockController configureTextStyleForLabel:self.pickerController.fromDestinationLabel andTenant:mockTenant]);
    self.pickerController.isFromSearchActive = YES;
    
    [self.pickerController didSelectTenant:mockTenant];
    
    OCMVerifyAll(mockSearchController);
    OCMVerifyAll(mockController);
    XCTAssertEqual(self.pickerController.fromTenant, mockTenant);
}

- (void)testDidSelectToTenant {
    [self.pickerController view];
    
    id mockSearchController = OCMPartialMock(self.pickerController.searchController);
    id mockController = OCMPartialMock(self.pickerController);
    id mockTenant = OCMPartialMock([GGPTenant new]);
    OCMExpect([mockSearchController dismissViewControllerAnimated:YES completion:nil]);
    OCMExpect([mockController configureTextStyleForLabel:self.pickerController.toDestinationLabel andTenant:mockTenant]);
    self.pickerController.isFromSearchActive = NO;
    
    [self.pickerController didSelectTenant:mockTenant];
    
    OCMVerifyAll(mockSearchController);
    OCMVerifyAll(mockController);
    XCTAssertEqual(self.pickerController.toTenant, mockTenant);
}

- (void)testBackButtonTapped {
    id mockNavController = OCMPartialMock([UINavigationController new]);
    id mockController = OCMPartialMock(self.pickerController);
    [OCMStub([mockController navigationController]) andReturn:mockNavController];
    OCMExpect([mockNavController popViewControllerAnimated:YES]);
    
    [self.pickerController backButtonTapped:nil];
    
    OCMVerifyAll(mockNavController);
}

- (void)testConfigureSearchListWithoutTenant {
    id mockTenant1 = OCMPartialMock([GGPTenant new]);
    id mockTenant2 = OCMPartialMock([GGPTenant new]);
    self.pickerController.allTenants = @[ mockTenant1, mockTenant2 ];
    
    id mockTableController = OCMPartialMock([GGPTenantSearchTableViewController new]);
    
    OCMExpect([mockTableController configureWithTenants:@[ mockTenant2 ] excludeUnMappedTenants:YES]);
    
    self.pickerController.searchTableController = mockTableController;
    [self.pickerController configureSearchListWithoutTenant:mockTenant1];
    
    OCMVerifyAll(mockTableController);
}

- (void)testSwapButtonTapped {
    id mockTenant1 = OCMPartialMock([GGPTenant new]);
    id mockTenant2 = OCMPartialMock([GGPTenant new]);
    
    self.pickerController.fromTenant = mockTenant1;
    self.pickerController.toTenant = mockTenant2;
    
    [self.pickerController swapButtonTapped:nil];
    
    XCTAssertEqual(self.pickerController.fromTenant, mockTenant2);
    XCTAssertEqual(self.pickerController.toTenant, mockTenant1);
}

- (void)testUpdateLevelSelectionDisplaySingleLevel {
    [self.pickerController view];
    
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    [OCMStub([mockMapController floorsForTenant:OCMOCK_ANY]) andReturn:@[[JMapFloor new]]];
    
    id mockLevelContainer = OCMPartialMock(self.pickerController.levelContainer);
    OCMExpect([mockLevelContainer ggp_collapseVertically]);
    
    [self.pickerController updateLevelSelectionDisplay];
    
    OCMVerifyAll(mockLevelContainer);
}

- (void)testUpdateLevelSelectionDisplayMultipleLevels {
    [self.pickerController view];
    
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    [OCMStub([mockMapController floorsForTenant:OCMOCK_ANY]) andReturn:@[[JMapFloor new], [JMapFloor new]]];
    
    id mockLevelContainer = OCMPartialMock(self.pickerController.levelContainer);
    OCMExpect([mockLevelContainer ggp_expandVertically]);
    
    [self.pickerController updateLevelSelectionDisplay];
    
    OCMVerifyAll(mockLevelContainer);
}

- (void)testWayfindingStartTenant {
    GGPTenant *tenant = [GGPTenant new];
    self.pickerController.fromTenant = tenant;
    XCTAssertEqual(tenant, self.pickerController.wayfindingStartTenant);

    GGPTenant *parent = [GGPTenant new];
    self.pickerController.fromTenant.parentTenant = parent;
    XCTAssertEqual(parent, self.pickerController.wayfindingStartTenant);
}

- (void)testWayfindingEndTenant {
    GGPTenant *tenant = [GGPTenant new];
    self.pickerController.toTenant = tenant;
    XCTAssertEqual(tenant, self.pickerController.wayfindingEndTenant);
    
    GGPTenant *parent = [GGPTenant new];
    self.pickerController.toTenant.parentTenant = parent;
    XCTAssertEqual(parent, self.pickerController.wayfindingEndTenant);
}

@end
