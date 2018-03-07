//
//  GGPParkingTenantPickerViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMallRepository.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPMallManager.h"
#import "GGPParkingTenantPickerViewController.h"
#import "GGPTenant.h"
#import "GGPTenantDetailMapViewController.h"
#import "GGPTenantDetailViewController.h"
#import "GGPTenantSearchDelegate.h"
#import "GGPTenantSearchTableViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPDirections.h"

@interface GGPParkingTenantPickerViewController () <GGPTenantSearchDelegate, UISearchControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectTenantButton;
@property (weak, nonatomic) IBOutlet UIView *tenantTextFieldContainerView;
@property (weak, nonatomic) IBOutlet UIView *tenantDetailContainerView;
@property (weak, nonatomic) IBOutlet UIButton *tenantNameButton;
@property (weak, nonatomic) IBOutlet UILabel *tenantLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *getDirectionsButton;

@property (strong, nonatomic) GGPTenant *selectedTenant;
@property (strong, nonatomic) GGPTenantSearchTableViewController *searchTableController;
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation GGPParkingTenantPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchStores];
    [self configureControls];
}

- (void)configureControls {
    self.tenantNameButton.titleLabel.font = [UIFont ggp_boldWithSize:14];
    [self.tenantNameButton setTitleColor:[UIColor ggp_blue] forState:UIControlStateNormal];
    [self.tenantNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    
    self.tenantLocationLabel.font = [UIFont ggp_regularWithSize:14];
    self.parkingLocationLabel.font = [UIFont ggp_regularWithSize:14];
    
    self.getDirectionsButton.titleLabel.font = [UIFont ggp_boldWithSize:14];
    [self.getDirectionsButton setTitle:[@"DETAILS_DIRECTIONS_NON_PROXIMITY" ggp_toLocalized] forState:UIControlStateNormal];
    [self.getDirectionsButton setTitleColor:[UIColor ggp_blue] forState:UIControlStateNormal];
    
    [self configureSearch];
    [self configureSelectStoreButton];
}

- (void)setAllowLinks:(BOOL)allowLinks {
    self.tenantNameButton.enabled = allowLinks;
}

- (void)configureSelectStoreButton {
    self.selectTenantButton.titleLabel.font = [UIFont ggp_regularWithSize:14];
    [self.selectTenantButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.tenantTextFieldContainerView.layer.borderColor = [UIColor ggp_lightGray].CGColor;
    self.tenantTextFieldContainerView.layer.borderWidth = 1;
    
    [self configureTenantDetailViewAsVisible:NO];
}

- (void)configureSearch {
    self.searchTableController = [GGPTenantSearchTableViewController new];
    self.searchTableController.searchDelegate = self;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchTableController];
    self.searchController.searchResultsUpdater = self.searchTableController;
    self.searchController.searchBar.placeholder = [@"PARKING_INFO_SELECT_STORE" ggp_toLocalized];
    self.searchController.delegate = self;
}

- (void)configureTenantDetailViewAsVisible:(BOOL)isVisible {
    NSString *tenantDisplayName = self.selectedTenant.parentTenant ? self.selectedTenant.nameIncludingParent : self.selectedTenant.name;
    NSString *titleText = isVisible ? tenantDisplayName : [@"PARKING_INFO_SELECT_STORE" ggp_toLocalized];
    [self.selectTenantButton setTitle:titleText forState:UIControlStateNormal];
    
    if (isVisible) {
        [self.tenantDetailContainerView ggp_expandVertically];
    } else {
        [self.tenantDetailContainerView ggp_collapseVertically];
    }
}

- (void)fetchStores {
    [GGPMallRepository fetchTenantsWithCompletion:^(NSArray *tenants) {
        [self.searchTableController formatTenantNamesForDisplay:tenants];
        [self.searchTableController configureWithTenants:tenants];
    }];
}

- (void)updateSelectedTenant:(GGPTenant *)tenant {
    self.selectedTenant = tenant;
    [self configureTenantDetailViewAsVisible:YES];
    
    NSString *storeName = tenant.parentTenant ? tenant.nameIncludingParent : tenant.name;
    [self.tenantNameButton setTitle:storeName forState:UIControlStateNormal];
    [self.tenantNameButton sizeToFit];
    
    self.tenantLocationLabel.text = tenant.parentTenant ? [NSString stringWithFormat:@"%@ %@", [@"WAYFINDING_INSIDE" ggp_toLocalized], tenant.parentTenant.name] : [[GGPJMapManager shared].mapViewController locationDescriptionForTenant:tenant];
    [self.tenantLocationLabel sizeToFit];
    
    self.parkingLocationLabel.text = tenant.parentTenant ? [NSString stringWithFormat:@"%@ %@", [@"PARKING_PARK_NEAR" ggp_toLocalized], tenant.parentTenant.name] : [[GGPJMapManager shared].mapViewController parkingLocationDescriptionForTenant:tenant];
    [self.parkingLocationLabel sizeToFit];
    
    NSDictionary *data = @{ GGPAnalyticsContextDataParkingTenant : tenant.name };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionParkingForTenant withData:data andTenant:tenant.name];
}

- (IBAction)selectTenantButtonTapped:(id)sender {
    self.navigationController.navigationBar.translucent = YES;
    [self presentViewController:self.searchController animated:YES completion:nil];
}

- (IBAction)tenantNameButtonTapped:(id)sender {
    [self.navigationController pushViewController:[[GGPTenantDetailViewController alloc] initWithTenantDetails:self.selectedTenant] animated:YES];
}

- (IBAction)getDirectionsTapped:(id)sender {
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionParkingGetDirections withData:nil andTenant:self.selectedTenant.name];
    
    GGPTenant *tenantForDirections = self.selectedTenant.parentTenant ? self.selectedTenant.parentTenant : self.selectedTenant;
    [self ggp_getDirectionsForTenant:tenantForDirections];
}

#pragma mark GGPTenantSearchDelegate

- (void)didSelectTenant:(GGPTenant *)tenant {
    self.navigationController.navigationBar.translucent = NO;
    [self.searchTableController dismissViewControllerAnimated:YES completion:nil];
    [self updateSelectedTenant:tenant];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    self.navigationController.navigationBar.translucent = NO;
}

@end
