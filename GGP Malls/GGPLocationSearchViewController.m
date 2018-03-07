//
//  GGPLocationSearchViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPClient.h"
#import "GGPLocationSearchViewController.h"
#import "GGPMallSearchNoResultsDelegate.h"
#import "GGPMallSearchNoResultsView.h"
#import "GGPNameSearchViewController.h"
#import "GGPSearchTableViewCell.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSString *const kSortKey = @"distance";
static NSString *const kInvalidCharacters = @"\\/?%*:\"<>()&;|^";

@interface GGPLocationSearchViewController () <CLLocationManagerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *searchFailMessageLabelContainerView;
@property (weak, nonatomic) IBOutlet UILabel *searchFailMessageLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *tableContainer;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) GGPSearchTableViewController *tableViewController;
@property (strong, nonatomic) NSArray *malls;
@property (strong, nonatomic) NSArray *searchResults;

@end

@implementation GGPLocationSearchViewController

- (instancetype)init {
    self = [self initWithNibName:@"GGPLocationSearchViewController" bundle:nil];
    if (self) {
        self.title = [@"SEARCH_LOCATION_TITLE" ggp_toLocalized];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    [self styleControls];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureLocationManager];
}

#pragma mark - Configuration

- (void)configureControls {
    self.searchBar.delegate = self;
    self.searchBar.placeholder = [@"SEARCH_LOCATION_DEFAULT_PLACEHOLDER" ggp_toLocalized];
    [self configureSearchFailMessage];
    [self configureTableView];
}

- (void)styleControls {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.searchFailMessageLabelContainerView.backgroundColor = [UIColor whiteColor];
    self.searchFailMessageLabel.textColor = [UIColor ggp_darkGray];
    self.searchFailMessageLabel.font = [UIFont ggp_regularWithSize:14];
    
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.layoutMargins = UIEdgeInsetsZero;
    
    self.tableContainer.backgroundColor = [UIColor whiteColor];
}

- (void)configureSearchFailMessage {
    self.searchFailMessageLabel.numberOfLines = 0;
    self.searchFailMessageLabel.textAlignment = NSTextAlignmentCenter;
    self.searchFailMessageLabel.text = [@"SELECT_MALL_RETRIEVE_LOCATION_FAIL_LABEL" ggp_toLocalized];
    [self hideError];
}

- (void)configureTableView {
    self.tableViewController = [GGPSearchTableViewController new];
    
    __weak typeof(self) weakSelf = self;
    self.tableViewController.onMallSelectionComplete = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self registerTableViewCell];
    [self ggp_addChildViewController:self.tableViewController toPlaceholderView:self.tableContainer];
}

- (void)registerTableViewCell {
    UINib *cellNib = [UINib nibWithNibName:@"GGPSearchTableViewCell" bundle:[NSBundle mainBundle]];
    
    [self.tableViewController.tableView registerNib:cellNib forCellReuseIdentifier:GGPSearchTableViewCellReuseIdentifier];
    
    GGPMallSearchNoResultsView *noResultsView = [GGPMallSearchNoResultsView new];
    [noResultsView configureWithLabelText:[@"SEARCH_LOCATION_NO_RESULTS" ggp_toLocalized] textColor:[UIColor ggp_mediumGray]
                            andButtonText:nil];
    
    self.tableViewController.tableView.backgroundView = noResultsView;
    self.tableViewController.tableView.backgroundView.hidden = YES;
}

#pragma mark - CLLocation

- (BOOL)shouldCreateNewLocationManager {
    return [CLLocationManager locationServicesEnabled];
}

- (void)configureLocationManager {
    if ([self shouldCreateNewLocationManager]) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        [self showError:[@"SELECT_MALL_RETRIEVE_LOCATION_FAIL_LABEL" ggp_toLocalized]];
    }
}

- (void)startUpdatingLocationIfAuthorized {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    } else {
        [self showError:[@"SELECT_MALL_RETRIEVE_LOCATION_FAIL_LABEL" ggp_toLocalized]];
    }
}

#pragma mark - Search Fail Message

- (void)showError:(NSString *)text {
    self.searchFailMessageLabel.text = text;
    CGFloat paddingHeight = 16;
    CGSize textSize = CGSizeMake(self.searchFailMessageLabel.frame.size.width, CGFLOAT_MAX);
    CGFloat textHeight = [self.searchFailMessageLabel sizeThatFits:textSize].height;
    [self.searchFailMessageLabelContainerView ggp_expandVerticallyWithHeight:textHeight + paddingHeight];
}

- (void)hideError {
    [self.searchFailMessageLabelContainerView ggp_collapseVertically];
}

#pragma mark - UISearchbar

- (BOOL)isValidCharacter:(unichar)character {
    NSCharacterSet *invalidCharacters = [NSCharacterSet characterSetWithCharactersInString:kInvalidCharacters];
    return ![invalidCharacters characterIsMember:character];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return text.length == 0 || [self isValidCharacter:[text characterAtIndex:0]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder geocodeAddressString:searchBar.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = placemarks.firstObject;
        [self searchWithLocation:placemark.location locationName:placemark.name andSearch:searchBar.text];
    }];
}

#pragma mark - Searching

- (void)searchWithLocation:(CLLocation *)location {
    NSString *coordinates = [NSString stringWithFormat:@"%.1f:%.1f", location.coordinate.latitude, location.coordinate.longitude];
    
    [self searchWithLocation:location
                locationName:[@"SELECT_MALL_HEADER_NEARBY_LOCATION_NAME_DEFAULT" ggp_toLocalized]
                   andSearch:coordinates];
}

- (void)searchWithLocation:(CLLocation *)location locationName:(NSString *)locationName andSearch:(NSString *)search {
    if (location) {
        [[GGPClient sharedInstance] fetchMallsFromLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude withCompletion:^(NSArray *malls, NSError *error) {
            [self onFetchMallsFromLatLongCompleteWithMalls:malls search:search locationName:locationName andError:error];
        }];
    } else {
        self.searchResults = nil;
        [self updateTableViewWithResults:self.searchResults andHeaderText:nil];
    }
}

- (void)onFetchMallsFromLatLongCompleteWithMalls:(NSArray *)malls search:(NSString *)search locationName:(NSString *)locationName andError:(NSError *)error {
    if (!error) {
        self.searchResults = [malls ggp_sortListAscendingForKey:kSortKey];
        NSString *headerText = [NSString stringWithFormat:[@"SELECT_MALL_HEADER_NEARBY" ggp_toLocalized], locationName];
        [self updateTableViewWithResults:self.searchResults andHeaderText:headerText];
        [self trackSearch:search withSearchTotal:malls.count andSearchType:GGPAnalyticsActionSearchByLocation];
    } else {
        GGPLogError(@"Unable to fetch malls for location. Error: %@", error.localizedDescription);
    }
}

#pragma mark - CLLocationManagerDelgate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];

    // stopUpdatingLocation may not be immediate, so set location manager to nil to avoid duplicate calls
    self.locationManager = nil;
    self.location = locations.lastObject;
    [self searchWithLocation:self.location];
    
    [self hideError];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self showError:[@"SELECT_MALL_RETRIEVE_LOCATION_FAIL_LABEL" ggp_toLocalized]];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self startUpdatingLocationIfAuthorized];
}

#pragma mark - Tableview Updates

- (void)updateTableViewWithResults:(NSArray *)results andHeaderText:(NSString *)headerText {
    [self.tableViewController configureWithSearchResultMalls:results recentMalls:nil andHeaderText:headerText];
}

#pragma mark - Tracking

- (void)trackSearch:(NSString *)search withSearchTotal:(NSInteger)searchTotal andSearchType:(NSString *)searchType {
    if (search) {
        NSDictionary *contextData = @{ GGPAnalyticsContextDataSearchMallKeyword: search,
                                       GGPAnalyticsContextDataSearchMallCount: [NSString stringWithFormat:@"%ld", (long)searchTotal]
                                       };
        [[GGPAnalytics shared] trackAction:searchType withData:contextData];
    }
}

@end
