//
//  GGPWayfindingPickerViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPJmapViewcontroller+Levels.h"
#import "GGPJMapViewController+Wayfinding.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPMallManager.h"
#import "GGPMallRepository.h"
#import "GGPTenant.h"
#import "GGPTenantSearchDelegate.h"
#import "GGPTenantSearchTableViewController.h"
#import "GGPWayfindingPickerDelegate.h"
#import "GGPWayfindingPickerViewController.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

#import <JMap/JMap.h>

@interface GGPWayfindingPickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate, GGPTenantSearchDelegate>

@property (weak, nonatomic) IBOutlet UIView *fromContainer;
@property (weak, nonatomic) IBOutlet UIView *toContainer;
@property (weak, nonatomic) IBOutlet UIView *levelContainer;
@property (weak, nonatomic) IBOutlet UITextField *levelTextField;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromDestinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDestinationLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *swapButton;

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) GGPTenantSearchTableViewController *searchTableController;
@property (strong, nonatomic) UIPickerView *levelPickerView;
@property (strong, nonatomic) NSArray *tenantFloors;

@property (strong, nonatomic) GGPTenant *toTenant;
@property (strong, nonatomic) GGPTenant *fromTenant;
@property (strong, nonatomic) NSArray *allTenants;
@property (assign, nonatomic) BOOL isFromSearchActive;
@property (strong, nonatomic) JMapFloor *selectedFromFloor;
@property (strong, nonnull, readonly) GGPTenant *wayfindingStartTenant;
@property (strong, nonnull, readonly) GGPTenant *wayfindingEndTenant;

@end

@implementation GGPWayfindingPickerViewController

- (instancetype)initWithTenant:(GGPTenant *)tenant {
    self = [super init];
    if (self) {
        self.toTenant = tenant;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    [self fetchTenants];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.levelTextField resignFirstResponder];
}

- (void)configureControls {
    self.view.backgroundColor = [UIColor ggp_blue];
    [self configureSearch];
    [self configureButtons];
    [self configureFromContainer];
    [self configureToContainer];
    [self configureLevelSelection];
}

- (void)configureSearch {
    self.searchTableController = [GGPTenantSearchTableViewController new];
    self.searchTableController.searchDelegate = self;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchTableController];
    self.searchController.searchResultsUpdater = self.searchTableController;
}

- (void)configureButtons {
    [self.backButton setImage:[[UIImage imageNamed:@"ggp_back_button"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.backButton.imageView setTintColor:[UIColor whiteColor]];
    
    [self.swapButton setImage:[[UIImage imageNamed:@"ggp_icon_swap"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (void)configureFromContainer {
    self.fromContainer.backgroundColor = [UIColor whiteColor];
    self.fromContainer.layer.cornerRadius = 3;
    self.fromLabel.text = [@"WAYFINDING_FROM" ggp_toLocalized];
    self.fromLabel.textColor = [UIColor grayColor];
    self.fromLabel.font = [UIFont ggp_regularWithSize:10];
    self.fromDestinationLabel.font = [UIFont ggp_regularWithSize:13];
    
    [self configureTextStyleForLabel:self.fromDestinationLabel andTenant:self.fromTenant];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fromContainerTapped)];
    [self.fromContainer addGestureRecognizer:tapRecognizer];
}

- (void)configureToContainer {
    self.toContainer.backgroundColor = [UIColor whiteColor];
    self.toContainer.layer.cornerRadius = 3;
    self.toLabel.text = [@"WAYFINDING_TO" ggp_toLocalized];
    self.toLabel.textColor = [UIColor grayColor];
    self.toLabel.font = [UIFont ggp_regularWithSize:10];
    self.toDestinationLabel.font = [UIFont ggp_regularWithSize:13];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toContainerTapped)];
    [self.toContainer addGestureRecognizer:tapRecognizer];
}

- (void)configureLevelSelection {
    self.levelContainer.backgroundColor = [UIColor whiteColor];
    self.levelContainer.layer.cornerRadius = 3;
    self.levelLabel.text = [@"WAYFINDING_ON" ggp_toLocalized];
    self.levelLabel.textColor = [UIColor grayColor];
    self.levelLabel.font = [UIFont ggp_regularWithSize:10];
    self.levelTextField.font = [UIFont ggp_regularWithSize:13];
    self.levelTextField.textColor = [UIColor blackColor];
    self.levelTextField.tintColor = [UIColor clearColor];
    
    self.levelPickerView = [UIPickerView new];
    self.levelPickerView.backgroundColor = [UIColor ggp_colorFromHexString:@"D2D7DD"];
    self.levelPickerView.delegate = self;
    self.levelPickerView.dataSource = self;
    self.levelTextField.inputView = self.levelPickerView;
    self.levelTextField.inputAccessoryView = [self createLevelPickerToolbar];

    [self.levelContainer ggp_collapseVertically];
}

- (GGPTenant *)wayfindingStartTenant {
    return self.fromTenant.parentTenant ? self.fromTenant.parentTenant : self.fromTenant;
}

- (GGPTenant *)wayfindingEndTenant {
    return self.toTenant.parentTenant ? self.toTenant.parentTenant : self.toTenant;
}

- (UIToolbar *)createLevelPickerToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 37)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:[@"WAYFINDING_PICKER_DONE" ggp_toLocalized] style:UIBarButtonItemStylePlain target:self action:@selector(dismissPicker)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[flexibleSpace, doneButton];
    return toolbar;
}

- (void)configureTextStyleForLabel:(UILabel *)label andTenant:(GGPTenant *)tenant {
    if (tenant) {
        label.textColor = [UIColor blackColor];
        label.text = tenant.displayName;
    } else {
        label.textColor = [UIColor grayColor];
        label.text = label == self.toDestinationLabel ? [@"WAYFINDING_SELECT_DESTINATION" ggp_toLocalized] : [@"WAYFINDING_SELECT_NEAREST_STORE" ggp_toLocalized];
    }
}

- (void)fetchTenants {
    [GGPMallRepository fetchTenantsWithCompletion:^(NSArray *tenants) {
        self.allTenants = tenants;
        [self.searchTableController formatTenantNamesForDisplay:self.allTenants];
        [self configureToTenant];
    }];
}

- (void)configureToTenant {
    self.toTenant = [self.allTenants ggp_firstWithFilter:^BOOL(GGPTenant *tenant) {
        return tenant.tenantId == self.toTenant.tenantId;
    }];
    
    [self configureTextStyleForLabel:self.toDestinationLabel andTenant:self.toTenant];
    [[GGPJMapManager shared].mapViewController configureWayfindingEndTenant:self.wayfindingEndTenant];
}

- (void)fromContainerTapped {
    self.isFromSearchActive = YES;
    self.searchController.searchBar.placeholder = [@"WAYFINDING_SELECT_NEAREST_STORE" ggp_toLocalized];
    
    [self configureSearchListWithoutTenant:self.toTenant];
    
    [self presentViewController:self.searchController animated:YES completion:nil];
}

- (void)toContainerTapped {
    self.isFromSearchActive = NO;
    self.searchController.searchBar.placeholder = [@"WAYFINDING_SELECT_DESTINATION" ggp_toLocalized];
    
    [self configureSearchListWithoutTenant:self.fromTenant];
    
    [self presentViewController:self.searchController animated:YES completion:nil];
}

- (void)configureSearchListWithoutTenant:(GGPTenant *)tenant {
    NSMutableArray *filteredTenants = self.allTenants.mutableCopy;
    [filteredTenants removeObject:tenant];
    [self.searchTableController configureWithTenants:filteredTenants excludeUnMappedTenants:YES];
}

- (void)dismissPicker {
    [self.levelTextField resignFirstResponder];
}

- (IBAction)backButtonTapped:(id)sender {
    [[GGPJMapManager shared].mapViewController resetWayfindingData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)swapButtonTapped:(id)sender {
    [[GGPJMapManager shared].mapViewController resetWayfindingData];
    
    GGPTenant *tempTenant = self.toTenant;
    self.toTenant = self.fromTenant;
    self.fromTenant = tempTenant;
    
    [[GGPJMapManager shared].mapViewController configureWayfindingEndTenant:self.wayfindingEndTenant];
    [self updateTenantSelection];
    [self.wayfindingPickerDelegate didSelectFromTenant:self.fromTenant andToTenant:self.toTenant];
}

- (void)updateTenantSelection {
    [self configureTextStyleForLabel:self.toDestinationLabel andTenant:self.toTenant];
    [self configureTextStyleForLabel:self.fromDestinationLabel andTenant:self.fromTenant];
    [self updateLevelSelectionDisplay];
}

- (void)updateLevelSelectionDisplay {
    self.tenantFloors = [[GGPJMapManager shared].mapViewController floorsForTenant:self.wayfindingStartTenant];
    [self.levelPickerView reloadAllComponents];
    self.selectedFromFloor = self.tenantFloors.count ? self.tenantFloors[0] : nil;
    [[GGPJMapManager shared].mapViewController configureWayfindingStartTenant:self.wayfindingStartTenant onFloor:self.selectedFromFloor];
    
    if (self.tenantFloors.count > 1) {
        self.levelTextField.text = self.selectedFromFloor.name;
        [self.levelContainer ggp_expandVertically];
    } else {
        [self.levelContainer ggp_collapseVertically];
    }
}

- (void)displayAlmostThereAlertForTenant:(GGPTenant *)tenant {
    GGPTenant *selectedToFromTenant = self.isFromSearchActive ? self.toTenant : self.fromTenant;
    GGPTenant *child = tenant.isChildTenant ? tenant : selectedToFromTenant;
    GGPTenant *parent = !tenant.isChildTenant ? tenant : selectedToFromTenant;
    
    NSString *title = [@"WAYFINDING_ALMOST_THERE_TITLE" ggp_toLocalized];
    NSString *message = [NSString stringWithFormat:@"%@ %@ %@", child.name, [@"WAYFINDING_LOCATED_INSIDE" ggp_toLocalized], parent.name];
    
    [self ggp_displayAlertWithTitle:title andMessage:message];
}

#pragma mark UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.tenantFloors.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    JMapFloor *floor = self.tenantFloors[row];
    return floor.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedFromFloor = self.tenantFloors[row];
    self.levelTextField.text = self.selectedFromFloor.name;
    [[GGPJMapManager shared].mapViewController configureWayfindingStartTenant:self.wayfindingStartTenant onFloor:self.selectedFromFloor];
    
    if (self.fromTenant && self.toTenant) {
        [self.wayfindingPickerDelegate didUpdateLevelSelection];
    }
}

#pragma mark GGPTenantSearchDelegate

- (void)didSelectTenant:(GGPTenant *)tenant {
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
    
    GGPTenant *compareTenant = self.isFromSearchActive ? self.toTenant : self.fromTenant;
    if ([tenant isRelatedToTenant:compareTenant]) {
        [self displayAlmostThereAlertForTenant:tenant];
        return;
    }
    
    if (self.isFromSearchActive) {
        self.fromTenant = tenant;
        [self updateLevelSelectionDisplay];
        [[GGPJMapManager shared].mapViewController configureWayfindingStartTenant:self.wayfindingStartTenant onFloor:self.selectedFromFloor];
    } else {
        self.toTenant = tenant;
        [[GGPJMapManager shared].mapViewController configureWayfindingEndTenant:self.wayfindingEndTenant];
    }
    
    [self updateTenantSelection];

    if (self.fromTenant && self.toTenant) {
        [self.wayfindingPickerDelegate didSelectFromTenant:self.fromTenant andToTenant:self.toTenant];
    }
}

@end
