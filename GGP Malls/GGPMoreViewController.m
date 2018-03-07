//
//  GGPMoreViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAccountViewController.h"
#import "GGPAuthenticationController.h"
#import "GGPCellData.h"
#import "GGPChangeMallViewController.h"
#import "GGPDateRange.h"
#import "GGPMall.h"
#import "GGPMallInfoViewController.h"
#import "GGPMallManager.h"
#import "GGPMallRepository.h"
#import "GGPModalViewController.h"
#import "GGPMoreTableViewController.h"
#import "GGPMoreViewController.h"
#import "GGPWebViewController.h"
#import "GGPSocialMedia.h"
#import "GGPSpinner.h"
#import "GGPTabBarController.h"
#import "GGPWebViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSString *const kFeedBackUrlParamHeader = @"&custom_var=";

@interface GGPMoreViewController () <GGPAuthenticationDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentMallDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentMallNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeMallButton;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *privacyTermsButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *instagramButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@property (strong, nonatomic) GGPMoreTableViewController *tableController;
@property (strong, nonatomic) NSArray *dateRanges;

@end

@implementation GGPMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GGPSpinner showForView:self.view];
    [self registerNotifications];
    [self fetchDateRanges];
    [self configureControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController ggp_configureWithLightText];
    self.navigationController.navigationBar.barTintColor = [UIColor ggp_navigationBar];
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenMore];
}

- (void)handleMallUpdate {
    [self configureMallNameLabel];
    [self configureHours];
    [self configureSocialIcons];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMallUpdate) name:GGPMallManagerMallUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView) name:GGPAuthenticationCompletedNotification object:nil];
}

- (void)fetchDateRanges {
    [GGPMallRepository fetchDateRangesWithCompletion:^(NSArray *dateRanges) {
        [GGPSpinner hideForView:self.view];
        self.dateRanges = dateRanges;
        [self configureTableView];
    }];
}

- (void)configureControls {
    self.navigationItem.title = [@"MORE_TITLE" ggp_toLocalized];
    
    self.currentMallDescriptionLabel.text = [@"MORE_CURRENT_MALL" ggp_toLocalized];
    self.currentMallDescriptionLabel.font = [UIFont ggp_regularWithSize:13];
    self.currentMallDescriptionLabel.textColor = [UIColor ggp_mediumGray];
    
    [self configureMallNameLabel];
    [self configureButtons];
    [self configureHours];
    [self configureSocialIcons];
}

- (void)configureMallNameLabel {
    self.currentMallNameLabel.text = self.selectedMall.name;
    self.currentMallNameLabel.font = [UIFont ggp_regularWithSize:18];
    self.currentMallNameLabel.textColor = [UIColor ggp_darkGray];
}

- (void)configureButtons {
    [self.changeMallButton ggp_styleAsDarkActionButton];
    self.changeMallButton.titleLabel.font = [UIFont ggp_mediumWithSize:10];
    [self.changeMallButton setTitle:[@"MORE_CHANGE_MALL" ggp_toLocalized]
                           forState:UIControlStateNormal];
    
    self.feedbackButton.titleLabel.font = [UIFont ggp_regularWithSize:13];
    [self.feedbackButton setTitle:[@"MORE_FEEDBACK" ggp_toLocalized]
                         forState:UIControlStateNormal];
    [self.feedbackButton setTitleColor:[UIColor ggp_blue]
                              forState:UIControlStateNormal];
    
    self.privacyTermsButton.titleLabel.font = [UIFont ggp_regularWithSize:13];
    [self.privacyTermsButton setTitle:[@"MORE_PRIVACY_TERMS" ggp_toLocalized]
                             forState:UIControlStateNormal];
    [self.privacyTermsButton setTitleColor:[UIColor ggp_blue]
                                  forState:UIControlStateNormal];
}

- (void)configureHours {
    self.hoursLabel.font = [UIFont ggp_lightWithSize:17];
    self.hoursLabel.textColor = [UIColor ggp_darkGray];
    self.hoursLabel.text = self.selectedMall.formattedTodaysHoursString;
}

- (void)configureTableView {
    self.tableController = [GGPMoreTableViewController new];
    [self ggp_addChildViewController:self.tableController toPlaceholderView:self.tableViewContainer];
    [self updateTableView];
}

- (void)updateTableView {
    [self.tableController configureWithTableItems:[self createTableItems]];
    self.tableViewHeightConstraint.constant = self.tableController.tableView.contentSize.height;
}

- (NSArray *)createTableItems {
    NSMutableArray *tableItems = [NSMutableArray new];
    
    [tableItems addObject:[self createMallInfoTableItem]];
    
    if ([GGPDateRange hasBlackFridayHoursFromDateRanges:self.dateRanges]) {
        [tableItems addObject:[self createBlackFridayTableItem]];
    }

    if ([GGPAccount isLoggedIn]) {
        [tableItems addObjectsFromArray:[self createAuthenticatedTableItems]];
    } else {
        [tableItems addObjectsFromArray:[self createUnauthenticatedTableItems]];
    }
    
    return tableItems;
}

- (GGPCellData *)createMallInfoTableItem {
    __weak typeof(self) weakSelf = self;
    
    BOOL hasHolidayHours = [GGPDateRange hasHolidayHoursFromDateRanges:self.dateRanges];
    NSString *mallInfoTitle = hasHolidayHours ? [@"MORE_MALL_INFO_HOLIDAY_HOURS" ggp_toLocalized] : [@"MORE_MALL_INFO" ggp_toLocalized];
    
    GGPMallInfoViewController *mallInfoViewController = [[GGPMallInfoViewController alloc] initWithHolidayHours:self.dateRanges];
    
    return [[GGPCellData alloc] initWithTitle:mallInfoTitle andTapHandler:^{
        [weakSelf.navigationController pushViewController:mallInfoViewController animated:YES];
    }];
}

- (GGPCellData *)createBlackFridayTableItem {
    NSString *blackFridayTitle = [@"MORE_MALL_INFO_BLACK_FRIDAY" ggp_toLocalized];
    
    GGPDateRange *blackFridayDate = [GGPDateRange blackFridayDateRangeFromDateRanges:self.dateRanges];
    
    GGPWebViewController *webViewController = [[GGPWebViewController alloc] initWithTitle:blackFridayTitle urlString:blackFridayDate.hoursUrl andAnalyticsConst:nil];
    
    GGPModalViewController *modalViewController = [[GGPModalViewController alloc] initWithRootViewController:webViewController andOnClose:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    return [[GGPCellData alloc] initWithTitle:blackFridayTitle andTapHandler:^{
        [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
    }];
}

- (NSArray *)createAuthenticatedTableItems {
    __weak typeof(self) weakSelf = self;
    return @[[[GGPCellData alloc] initWithTitle:[@"MORE_ACCOUNT" ggp_toLocalized] andTapHandler:^{
        [weakSelf.navigationController pushViewController:[GGPAccountViewController new] animated:YES];
    }]];
}

- (NSArray *)createUnauthenticatedTableItems {
    NSMutableArray *tableItems = [NSMutableArray new];
    
    __weak typeof(self) weakSelf = self;
    [tableItems addObject:[[GGPCellData alloc] initWithTitle:[@"MORE_LOGIN" ggp_toLocalized] andTapHandler:^{
        [weakSelf loginItemTapped];
    }]];
    
    [tableItems addObject:[[GGPCellData alloc] initWithTitle:[@"MORE_CREATE_ACCOUNT" ggp_toLocalized] andTapHandler:^{
        [weakSelf accountItemTapped];
    }]];
    
    return tableItems;
}

- (void)configureSocialIcons {
    if (!self.selectedMall.socialMedia.twitterUrl.scheme) {
        [self.twitterButton ggp_collapseHorizontally];
    } else {
        [self.twitterButton ggp_expandHorizontally];
    }
    
    if (!self.selectedMall.socialMedia.instagramUrl.scheme) {
        [self.instagramButton ggp_collapseHorizontally];
    } else {
        [self.instagramButton ggp_expandHorizontally];
    }
    
    if (!self.selectedMall.socialMedia.facebookUrl.scheme) {
        [self.facebookButton ggp_collapseHorizontally];
    } else {
        [self.facebookButton ggp_expandHorizontally];
    }
}

#pragma mark - Selected Mall

- (GGPMall *)selectedMall {
    return [GGPMallManager shared].selectedMall;
}

#pragma mark - IBActions

- (IBAction)changeMallTapped:(id)sender {
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionNavigationChangeMall withData:nil];
    
    GGPChangeMallViewController *changeMallViewController = [GGPChangeMallViewController new];
    GGPModalViewController *modalViewController = [[GGPModalViewController alloc] initWithRootViewController:changeMallViewController andOnClose:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:modalViewController animated:YES completion:nil];
}

- (IBAction)twitterButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:self.selectedMall.socialMedia.twitterUrl];
    [self trackSocialNetwork:GGPAnalyticsContextDataSocialNetworkTypeTwitter];
}

- (IBAction)instagramButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:self.selectedMall.socialMedia.instagramUrl];
    [self trackSocialNetwork:GGPAnalyticsContextDataSocialNetworkTypeInstagram];
}

- (IBAction)facebookButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:self.selectedMall.socialMedia.facebookUrl];
    [self trackSocialNetwork:GGPAnalyticsContextDataSocialNetworkTypeFacebook];
}

- (IBAction)feedbackTapped:(id)sender {
    NSString *urlAllowedMallName = [self.selectedMall.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *feedbackUrl = [NSString stringWithFormat:@"%@%@%@", [@"FEEDBACK_URL" ggp_toLocalized], kFeedBackUrlParamHeader, urlAllowedMallName];
    
    GGPWebViewController *webViewController = [[GGPWebViewController alloc] initWithTitle:[@"FEEDBACK_TITLE" ggp_toLocalized] urlString:feedbackUrl andAnalyticsConst:GGPAnalyticsScreenFeedback];
    
    GGPModalViewController *modalController = [[GGPModalViewController alloc] initWithRootViewController:webViewController andOnClose:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.navigationController presentViewController:modalController animated:YES completion:nil];
}

- (IBAction)privacyTermsTapped:(id)sender {
    GGPWebViewController *webViewController = [[GGPWebViewController alloc] initWithTitle:[@"PRIVACY_TERMS_TITLE" ggp_toLocalized] urlString:[@"TERMS_AND_CONDITIONS_URL" ggp_toLocalized] andAnalyticsConst:GGPAnalyticsScreenTermsConditions];
    
    GGPModalViewController *modalController = [[GGPModalViewController alloc] initWithRootViewController:webViewController andOnClose:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.navigationController presentViewController:modalController animated:YES completion:nil];
    
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionNavTermsAndConditions withData:nil];
}

#pragma mark - Tap Handlers

- (void)loginItemTapped {
    GGPAuthenticationController *loginController = [GGPAuthenticationController authenticationControllerForLogin];
    [self presentViewController:loginController animated:YES completion:nil];
    loginController.authenticationDelegate = self;
}

- (void)accountItemTapped {
    GGPAuthenticationController *createAccountController = [GGPAuthenticationController authenticationControllerForRegistration];
    [self presentViewController:createAccountController animated:YES completion:nil];
    createAccountController.authenticationDelegate = self;
}

#pragma mark - Analytics

- (void)trackSocialNetwork:(NSString *)socialNetwork {
    NSDictionary *data = @{ GGPAnalyticsContextDataMallSocialNetwork : socialNetwork };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionNavSocialBadge withData:data];
}

#pragma mark GGPAuthenticationDelegate

- (void)authenticationCompleted {
    [((GGPTabBarController *)self.tabBarController) reloadControllers];
}

@end
