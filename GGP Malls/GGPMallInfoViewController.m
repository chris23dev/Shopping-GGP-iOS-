//
//  GGPMallInfoViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAddress.h"
#import "GGPChangeMallViewController.h"
#import "GGPDateRange.h"
#import "GGPHolidayHoursViewController.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMallInfoHoursTableViewController.h"
#import "GGPMallInfoViewController.h"
#import "GGPModalViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSString *const kAppleMapsURL = @"http://maps.apple.com/?q=%@,+%@";

@interface GGPMallInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *hoursTableViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *changeMallButton;
@property (weak, nonatomic) IBOutlet UIView *holidayHoursLabelContainer;
@property (weak, nonatomic) IBOutlet UIImageView *holidayHoursCaret;
@property (weak, nonatomic) IBOutlet UILabel *holidayHoursLabel;
@property (weak, nonatomic) IBOutlet UIView *holidayHoursViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holidayHoursHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mallHoursHeightConstraint;

@property (strong, nonatomic, readonly) GGPMall *mall;
@property (strong, nonatomic) GGPMallInfoHoursTableViewController *hoursTableViewController;
@property (strong, nonatomic) GGPHolidayHoursViewController *holidayHoursViewController;

@property (strong, nonatomic) NSArray *holidayHours;
@property (assign, nonatomic) BOOL holidayHoursAreVisible;

@end

@implementation GGPMallInfoViewController

- (instancetype)initWithHolidayHours:(NSArray *)holidayHours {
    self = [super init];
    if (self) {
        self.holidayHours = holidayHours;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    self.title = [@"MALL_INFO_TITLE" ggp_toLocalized];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(configureMallInfo)
                                                 name:GGPMallManagerMallUpdatedNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
    [self configureDefaultHolidayHoursState];
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenMallInfo];
}

- (GGPMall *)mall {
    return [GGPMallManager shared].selectedMall;
}

#pragma mark - Configuration

- (void)configureControls {
    [self configureHeadingLabel];
    [self configureAddressLabel];
    [self configurePhoneLabel];
    [self configureMallHoursSection];
    [self configureChangeMallButton];
    [self configureMallInfo];
    [self configureHolidayHours];
}

- (void)configureHeadingLabel {
    self.headingLabel.numberOfLines = 0;
    self.headingLabel.font = [UIFont ggp_regularWithSize:22];
    self.headingLabel.textColor = [UIColor ggp_darkGray];
}

- (void)configureAddressLabel {
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.userInteractionEnabled = YES;
    self.addressLabel.font = [UIFont ggp_regularWithSize:14];
    self.addressLabel.textColor = [UIColor ggp_blue];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressLabelTapped)];
    [self.addressLabel addGestureRecognizer:tap];
}

- (void)configurePhoneLabel {
    self.phoneLabel.numberOfLines = 0;
    self.phoneLabel.userInteractionEnabled = YES;
    self.phoneLabel.font = [UIFont ggp_regularWithSize:14];
    self.phoneLabel.textColor = [UIColor ggp_blue];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneLabelTapped)];
    [self.phoneLabel addGestureRecognizer:tap];
}

- (void)configureMallHoursSection {
    self.hoursHeadingLabel.font = [UIFont ggp_regularWithSize:18];
    self.hoursHeadingLabel.textColor = [UIColor ggp_darkGray];
    self.hoursHeadingLabel.text = [@"MALL_INFO_HOURS" ggp_toLocalized];
    
    self.hoursDescriptionLabel.numberOfLines = 0;
    self.hoursDescriptionLabel.font = [UIFont ggp_regularWithSize:14];
    self.hoursDescriptionLabel.textColor = [UIColor ggp_mediumGray];
    self.hoursDescriptionLabel.text = [@"MALL_INFO_HOURS_DISCLAIMER" ggp_toLocalized];
    
    self.hoursTableViewContainer.backgroundColor = [UIColor clearColor];
    self.hoursTableViewController = [GGPMallInfoHoursTableViewController new];
    [self ggp_addChildViewController:self.hoursTableViewController
                   toPlaceholderView:self.hoursTableViewContainer];
}

- (void)configureChangeMallButton {
    [self.changeMallButton ggp_styleAsDarkActionButton];
    [self.changeMallButton setTitle:[@"MALL_INFO_CHANGE_MALL" ggp_toLocalized]
                           forState:UIControlStateNormal];
}

- (void)configureNavigationBar {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController ggp_configureWithDarkText];
}

- (void)configureMallInfo {
    self.headingLabel.text = self.mall.name;
    self.addressLabel.text = self.mall.address.fullAddress;
    self.phoneLabel.text = [NSString ggp_prettyPrintPhoneNumber:self.mall.phoneNumber];
    
    [self.hoursTableViewController configureWithMall:self.mall];
    self.mallHoursHeightConstraint.constant = 10000;
    [self.hoursTableViewContainer layoutIfNeeded];
    self.mallHoursHeightConstraint.constant = self.hoursTableViewController.tableView.contentSize.height;
}

#pragma mark - Holiday Hours

- (void)configureHolidayHours {
    if (![GGPDateRange hasHolidayHoursFromDateRanges:self.holidayHours]) {
        [self.holidayHoursLabelContainer ggp_collapseVertically];
        [self.holidayHoursViewContainer ggp_collapseVertically];
        return;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(holidayHoursLabelTapped)];
    
    self.holidayHoursLabel.userInteractionEnabled = YES;
    self.holidayHoursLabel.font = [UIFont ggp_regularWithSize:16];
    self.holidayHoursLabel.textColor = [UIColor ggp_blue];
    [self configureHolidayHoursLabelForVisibility];
    [self.holidayHoursLabel addGestureRecognizer:tap];
    
    self.holidayHoursViewContainer.backgroundColor = [UIColor clearColor];
    self.holidayHoursViewController = [[GGPHolidayHoursViewController alloc]
                                       initWithHolidayHours:self.holidayHours];
    
    [self ggp_addChildViewController:self.holidayHoursViewController
                   toPlaceholderView:self.holidayHoursViewContainer];
}

- (void)configureHolidayHoursLabelForVisibility {
    self.holidayHoursLabel.text = self.holidayHoursAreVisible ?
    [@"MALL_INFO_HOLIDAY_HOURS_HIDE" ggp_toLocalized] :
    [@"MALL_INFO_HOLIDAY_HOURS_SHOW" ggp_toLocalized];
}

- (void)configureDefaultHolidayHoursState {
    self.holidayHoursAreVisible = NO;
    [self configureHolidayHoursLabelForVisibility];
    self.holidayHoursHeightConstraint.constant = 0;
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

#pragma mark - Tap Handlers

- (void)addressLabelTapped {
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionNavDirections withData:nil];
    NSString *urlString = [[NSString alloc] initWithFormat:kAppleMapsURL, self.mall.latitude, self.mall.longitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlString]];
}

- (void)phoneLabelTapped {
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionNavCall
                              withData:@{ GGPAnalyticsContextDataMallPhoneNumber: self.phoneLabel.text }];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",self.mall.phoneNumber]]];
}

- (void)holidayHoursLabelTapped {
    self.holidayHoursAreVisible = !self.holidayHoursAreVisible;
    
    [self configureHolidayHoursLabelForVisibility];
    
    if (self.holidayHoursAreVisible) {
        self.holidayHoursHeightConstraint.constant = 10000;
        [self.holidayHoursViewContainer layoutIfNeeded];
    }

    self.holidayHoursHeightConstraint.constant = self.holidayHoursAreVisible ?
        self.holidayHoursViewController.tableView.contentSize.height :
        0;
}

@end
