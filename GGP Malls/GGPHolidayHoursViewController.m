//
//  GGPHolidayHoursViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPDateRange.h"
#import "GGPHolidayHoursViewController.h"
#import "GGPHours.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMallHourCell.h"
#import "NSArray+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSInteger kHeaderFooterHeight = 30;
static NSInteger kDaysInAWeek = 7;
static NSString *const kDateSortKey = @"self";

@interface GGPHolidayHoursViewController ()

@property (strong, nonatomic) NSDictionary *hoursDictionary;
@property (strong, nonatomic) NSArray<GGPDateRange *> *holidayHours;
@property (strong, nonatomic) NSArray<NSDate *> *dates;
@property (strong, nonatomic) NSArray *sections;

@end

@implementation GGPHolidayHoursViewController

- (GGPMall *)selectedMall {
    return [GGPMallManager shared].selectedMall;
}

- (instancetype)initWithHolidayHours:(NSArray *)holidayHours {
    self = [super init];
    if (self) {
        self.holidayHours = holidayHours;
        [self configureTableView];
    }
    return self;
}

- (void)configureTableView {
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.contentInset = UIEdgeInsetsZero;
    
    self.tableView.estimatedRowHeight = 30;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self registerCell];
    [self configureDates];
}

- (void)registerCell {
    UINib *hoursNib = [UINib nibWithNibName:@"GGPMallHourCell" bundle:nil];
    [self.tableView registerNib:hoursNib forCellReuseIdentifier:GGPMallHourCellReuseIdentifier];
}

- (void)configureDates {
    NSArray *holidayDates = [[self datesForHolidayHours] ggp_sortListAscendingForKey:kDateSortKey];
    NSDictionary *holidayHours = [self.selectedMall openHoursDictionaryForDates:holidayDates];
    [self configureWithHours:holidayHours];
}

- (NSArray *)datesForHolidayHours {
    GGPDateRange *holidayDateRange = [GGPDateRange holidayHoursDateRangeFromDateRanges:self.holidayHours];
    NSDate *holidayStartDate = [self determineStartDateFromHolidayStartDate:holidayDateRange.startDate];
    
    NSInteger numberOfHolidayDates = [NSDate ggp_daysFromDate:holidayStartDate
                                                       toDate:holidayDateRange.endDate] + 1;
    
    return [NSDate ggp_upcomingDatesForStartDate:holidayStartDate
                                 forNumberOfDays:numberOfHolidayDates];
}

- (NSDate *)determineStartDateFromHolidayStartDate:(NSDate *)holidayStartDate {
    NSDate *today = [NSDate new];
    NSDate *startOfNextWeek = [NSDate ggp_addDays:kDaysInAWeek toDate:today];
    return [holidayStartDate ggp_isOnOrBeforeDate:startOfNextWeek] ? startOfNextWeek : holidayStartDate;
}

- (void)configureWithHours:(NSDictionary *)hoursDictionary {
    self.dates = [hoursDictionary.allKeys ggp_sortListAscendingForKey:kDateSortKey];
    self.hoursDictionary = hoursDictionary;
    self.sections = [NSDate ggp_datesByMonthArrayForDates:self.dates];
    [self.tableView reloadData];
}

- (NSArray *)monthForSection:(NSInteger)section {
    return self.sections[section];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self monthForSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPMallHourCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPMallHourCellReuseIdentifier forIndexPath:indexPath];
    
    NSArray *monthDates = [self monthForSection:indexPath.section];
    NSDate *date = monthDates[indexPath.row];
    NSArray *hours = self.hoursDictionary[date];
    
    [cell configureWithHours:hours date:date isActive:NO];
    
    return cell;
}

#pragma mark - Header

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeaderFooterHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self monthNameForSection:section];
}

- (NSString *)monthNameForSection:(NSInteger)section {
    NSDate *monthDate = [self monthForSection:section].firstObject;
    return [monthDate ggp_monthString];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor blackColor];
    header.textLabel.font = [UIFont ggp_regularWithSize:18];
    header.backgroundView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Footer

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kHeaderFooterHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.backgroundView.backgroundColor = [UIColor clearColor];
}

@end
