//
//  GGPParkingAvailabilityPopoverViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingAvailabilityDateCollectionViewController.h"
#import "GGPParkingAvailabilityDateSelectionDelegate.h"
#import "GGPParkingAvailabilityPopoverViewController.h"
#import "GGPParkingAvailabilityTimeCollectionViewController.h"
#import "GGPParkingAvailabilityTimeSelectionDelegate.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPParkingAvailabilityPopoverViewController () <GGPParkingAvailabilityDateSelectionDelegate, GGPParkingAvailabilityTimeSelectionDelegate>

@property (weak, nonatomic) IBOutlet UIView *modalView;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *dateCollectionViewContainer;
@property (weak, nonatomic) IBOutlet UIView *timeCollectionViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) GGPParkingAvailabilityDateCollectionViewController *dateCollectionViewController;
@property (strong, nonatomic) GGPParkingAvailabilityTimeCollectionViewController *timeCollectionViewController;
@property (strong, nonatomic) NSDate *selectedDate;
@property (copy, nonatomic) NSString *selectedTimeString;
@property (assign, nonatomic) NSInteger arrivalTimeHour;

// calculated properties
@property (assign, nonatomic) BOOL shouldShowDateString;
@property (copy, nonatomic) NSString *arrivalDateString;
@property (copy, nonatomic) NSString *arrivalTimeString;

@end

@implementation GGPParkingAvailabilityPopoverViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedTimeString = [@"PARKING_AVAILABILITY_NOW" ggp_toLocalized];
        self.selectedDate = [NSDate new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)configureControls {
    self.view.backgroundColor = [UIColor ggp_colorFromHexString:@"000000" andAlpha:0.50];
    [self configureModalView];
    [self configureLabels];
    [self configureDateCollectionView];
    [self configureTimeCollectionView];
    [self configureDoneButton];
}

- (void)configureModalView {
    self.modalView.backgroundColor = [UIColor ggp_colorFromHexString:@"ffffff" andAlpha:0.95];
    [self.modalView ggp_addBorderWithWidth:1 andColor:[UIColor ggp_lightGray]];
    [self.modalView ggp_addShadowWithRadius:4 andOpacity:0.30];
    [self.modalView ggp_addBorderRadius:5];
}

- (void)configureLabels {
    self.headingLabel.textAlignment = NSTextAlignmentCenter;
    self.headingLabel.font = [UIFont ggp_regularWithSize:14];
    self.headingLabel.text = [@"PARKING_AVAILABILITY_ARRIVAL_TIME" ggp_toLocalized];
    
    self.arrivalTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.arrivalTimeLabel.font = [UIFont ggp_regularWithSize:19];
    [self configureArrivalTimeLabel];
}

- (void)configureArrivalTimeLabel {
    self.arrivalTimeLabel.text = self.arrivalTimeString;
    [self.popoverDelegate didUpdateDate:self.selectedDate withTime:self.selectedTimeString andArrivalTimeHour:self.arrivalTimeHour];
}

- (void)configureDateCollectionView {
    self.dateCollectionViewContainer.clipsToBounds = YES;
    self.dateCollectionViewContainer.backgroundColor = [UIColor clearColor];
    [self.dateCollectionViewContainer ggp_addBorderRadius:4];
    [self.dateCollectionViewContainer ggp_addBorderWithWidth:1 andColor:[UIColor ggp_colorFromHexString:@"999999"]];
    
    self.dateCollectionViewController = [GGPParkingAvailabilityDateCollectionViewController new];
    self.dateCollectionViewController.dateDelegate = self;
    [self ggp_addChildViewController:self.dateCollectionViewController toPlaceholderView:self.dateCollectionViewContainer];
}

- (void)configureTimeCollectionView {
    self.timeCollectionViewContainer.clipsToBounds = YES;
    self.timeCollectionViewContainer.backgroundColor = [UIColor clearColor];
    [self.timeCollectionViewContainer ggp_addBorderRadius:4];
    [self.timeCollectionViewContainer ggp_addBorderWithWidth:1 andColor:[UIColor ggp_colorFromHexString:@"999999"]];
    
    self.timeCollectionViewController = [GGPParkingAvailabilityTimeCollectionViewController new];
    self.timeCollectionViewController.timeDelegate = self;
    [self ggp_addChildViewController:self.timeCollectionViewController toPlaceholderView:self.timeCollectionViewContainer];
}

- (void)configureDoneButton {
    self.doneButton.titleLabel.font = [UIFont ggp_regularWithSize:20];
    [self.doneButton ggp_styleAsDarkActionButton];
    [self.doneButton setTitle:[@"PARKING_AVAILABILITY_DONE" ggp_toLocalized].uppercaseString
                     forState:UIControlStateNormal];
    [self.doneButton.titleLabel sizeToFit];
}

#pragma mark - Convenience Time / Date String methods

- (NSString *)arrivalTimeString {
    return self.shouldShowDateString ? [NSString stringWithFormat:[@"PARKING_AVAILABILITY_TIME_WITH_DATE" ggp_toLocalized], self.selectedTimeString, self.arrivalDateString] : [NSString stringWithFormat:@"%@", [@"PARKING_AVAILABILITY_NOW" ggp_toLocalized]];
}

- (NSString *)arrivalDateString {
    return [NSDate ggp_formatDateWithDayString:self.selectedDate includeFullDay:NO];
}

- (BOOL)shouldShowDateString {
    return ![self.selectedTimeString isEqualToString:[@"PARKING_AVAILABILITY_NOW" ggp_toLocalized]];
}

#pragma mark - Date Selection Delegate

- (void)didSelectDate:(NSDate *)date {
    self.selectedDate = date;
    [self.timeCollectionViewController configureWithSelectedDate:self.selectedDate];
    [self configureArrivalTimeLabel];
}

#pragma mark - Time Selection Delegate

- (void)didSelectTime:(NSString *)time withArrivalTimeHour:(NSInteger)arrivalTime {
    self.selectedTimeString = time;
    self.arrivalTimeHour = arrivalTime;
    [self configureArrivalTimeLabel];
}

#pragma mark - IB Actions

- (IBAction)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.popoverDelegate didTapDoneButtonWithArrivalString:self.arrivalTimeLabel.text];
}

@end
