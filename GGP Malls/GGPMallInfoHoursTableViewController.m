//
//  GGPMallInfoHoursTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPHours.h"
#import "GGPMall.h"
#import "GGPMallInfoHoursTableViewController.h"
#import "NSArray+GGPAdditions.h"
#import "GGPMallHourCell.h"
#import "NSDate+GGPAdditions.h"

@interface GGPMallInfoHoursTableViewController ()

@property (strong, nonatomic) NSDictionary *hoursDictionary;
@property (strong, nonatomic) NSArray<NSDate *> *dates;
@property (strong, nonatomic) GGPMall *mall;

@end

@implementation GGPMallInfoHoursTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureTableView];
    }
    return self;
}

- (void)configureWithMall:(GGPMall *)mall {
    self.mall = mall;
    [self configureDates];
    [self.tableView reloadData];
}

- (void)configureDates {
    NSArray *weeklyDates = [NSDate ggp_upcomingWeekDatesForStartDate:[NSDate new]];
    self.hoursDictionary = [self.mall openHoursDictionaryForDates:weeklyDates];
    self.dates = [self.hoursDictionary.allKeys ggp_sortListAscendingForKey:@"self"];
}

- (void)configureTableView {
    self.tableView.scrollEnabled = NO;
    self.tableView.allowsSelection = NO;
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.contentInset = UIEdgeInsetsZero;
    
    self.tableView.estimatedRowHeight = 28;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerCell];
}

- (void)registerCell {
    UINib *hoursNib = [UINib nibWithNibName:@"GGPMallHourCell" bundle:NSBundle.mainBundle];
    [self.tableView registerNib:hoursNib forCellReuseIdentifier:GGPMallHourCellReuseIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hoursDictionary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPMallHourCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPMallHourCellReuseIdentifier forIndexPath:indexPath];
    
    NSDate *date = self.dates[indexPath.row];
    NSArray *hours = self.hoursDictionary[date];
    BOOL isActive = indexPath.row == 0;
    
    [cell configureWithHours:hours date:date isActive:isActive];
    
    return cell;
}

@end
