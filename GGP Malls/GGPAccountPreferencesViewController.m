//
//  GGPAccountPreferencesViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAccountPreferencesViewController.h"
#import "GGPBackButton.h"
#import "GGPCheckboxButton.h"
#import "GGPFormField.h"
#import "GGPMall.h"
#import "GGPMallRepository.h"
#import "GGPPreferencesToggleDelegate.h"
#import "GGPPreferencesToggleViewController.h"
#import "GGPSubscriptionDetailDelegate.h"
#import "GGPSubscriptionDetailViewController.h"
#import "GGPUser.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPAccountPreferencesViewController () <GGPPreferencesToggleDelegate, GGPSubscriptionDetailDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UIView *toggleContainer;
@property (weak, nonatomic) IBOutlet UIView *subscriptionDetailsContainer;

@property (strong, nonatomic) GGPPreferencesToggleViewController *preferencesToggleViewController;
@property (assign, nonatomic) BOOL userHasChanges;
@property (assign, nonatomic) BOOL didOptInForEmail;
@property (assign, nonatomic) BOOL didOptInForSms;

@property (strong, nonatomic) GGPMall *formerPreferredMall;
@property (strong, nonatomic) GGPMall *updatedPreferredMall;
@property (strong, nonatomic) NSString *updatedPreferredMallUserMallId;

@end

@implementation GGPAccountPreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)configureControls {
    self.title = [@"ACCOUNT_PREFERENCES_TITLE" ggp_toLocalized];
    self.view.backgroundColor = [UIColor ggp_lightGray];
    self.containerView.backgroundColor = [UIColor ggp_lightGray];
    [self configureNavigationBar];
    [self configureToggleViewController];
    [self configurePreferencesDetailViewController];
}

- (void)configureNavigationBar {
    __weak typeof(self) weakSelf = self;
    [self.navigationController ggp_configureWithDarkText];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[GGPBackButton alloc] initWithTapHandler:^{
        [weakSelf ggp_accountBackButtonPressedForState:self.userHasChanges];
    }];
}

- (void)configureToggleViewController {
    self.toggleContainer.backgroundColor = [UIColor clearColor];
    self.preferencesToggleViewController = [GGPPreferencesToggleViewController new];
    self.preferencesToggleViewController.toggleDelegate = self;
    [self ggp_addChildViewController:self.preferencesToggleViewController toPlaceholderView:self.toggleContainer];
}

- (void)configurePreferencesDetailViewController {
    GGPSubscriptionDetailViewController *subscriptionDetailViewController = [GGPSubscriptionDetailViewController new];
    subscriptionDetailViewController.subscriptionDetailDelegate = self;
    [self ggp_addChildViewController:subscriptionDetailViewController toPlaceholderView:self.subscriptionDetailsContainer];
}

- (void)setUserHasChanges:(BOOL)userHasChanges {
    _userHasChanges = userHasChanges;
    self.navigationItem.rightBarButtonItem = self.userHasChanges ? [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped)] : nil;
}

- (void)trackAnalytics {
    NSDictionary *data = @{ GGPAnalyticsContextDataAccountEmailOptIn: self.didOptInForEmail ? @"true" : @"false",
                            GGPAnalyticsContextDataAccountTextOptIn : self.didOptInForSms ? @"true" : @"false" };
    
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionAccountChangeSettings withData:data];
}

#pragma mark - GGPPreferencesToggleDelegate

- (void)toggleValueChanged {
    self.userHasChanges = YES;
}

#pragma mark - GGPSubscriptionDetailDelegate

- (void)didUpdatePreferredMall:(GGPMall *)newPreferredMall toReplaceMall:(GGPMall *)formerPreferredMall forUserMallIdString:(NSString *)userMallIdString {
    self.updatedPreferredMall = newPreferredMall;
    self.formerPreferredMall = formerPreferredMall;
    self.updatedPreferredMallUserMallId = userMallIdString;
    self.userHasChanges = YES;
}

#pragma mark - User update

- (void)saveButtonTapped {
    [self.preferencesToggleViewController.smsField validatePhoneNumberForSelectedState:self.preferencesToggleViewController.smsCheckbox.isSelected];
    BOOL isValid = self.preferencesToggleViewController.smsField.isValid;
    
    if (isValid) {
        [self savePreferences];
    }
}

- (void)savePreferences {
    __weak typeof(self) weakSelf = self;
    self.userHasChanges = NO;
    
    self.didOptInForEmail = self.preferencesToggleViewController.emailCheckbox.isSelected && ![GGPAccount shared].currentUser.isEmailSubscribed;
    self.didOptInForSms = self.preferencesToggleViewController.smsCheckbox.isSelected && ![GGPAccount shared].currentUser.isSmsSubscribed;
    
    [GGPAccount updateAccountInfoWithParameters:[[self updatedUserFromFormValues] userDataDictionary] andCompletion:^(NSError *error) {
        [weakSelf onUpdateComplete:error];
    }];
}

- (BOOL)hasPreferredMallUpdates {
    return self.updatedPreferredMall != nil;
}

- (GGPUser *)updatedUserFromFormValues {
    GGPUser *updatedUser = [[GGPAccount shared].currentUser cloneUser];
    updatedUser.isSmsSubscribed = self.preferencesToggleViewController.smsCheckbox.isSelected;
    updatedUser.isEmailSubscribed = self.preferencesToggleViewController.emailCheckbox.isSelected;
    updatedUser.mobilePhone = self.preferencesToggleViewController.smsField.text;
    
    if (self.hasPreferredMallUpdates) {
        updatedUser.mallId1 = @(self.updatedPreferredMall.mallId).stringValue;
        [updatedUser setValue:@(self.formerPreferredMall.mallId).stringValue
                       forKey:self.updatedPreferredMallUserMallId];
    }
    
    return updatedUser;
}

- (void)onUpdateComplete:(NSError *)error {
    if (!error) {
        [self trackAnalytics];
        [self ggp_displayAlertWithTitle:nil andMessage:[@"ACCOUNT_PREFERENCES_SUCCESS" ggp_toLocalized]];
    } else {
        self.userHasChanges = YES;
        [self ggp_displayAlertWithTitle:nil andMessage:[@"ALERT_GENERIC_ERROR_MESSAGE" ggp_toLocalized]];
    }
}

@end
