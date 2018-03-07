//
//  GGPSearchTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMallRepository.h"
#import "GGPOnboardingMallLoadingViewController.h"
#import "GGPSearchTableViewCell.h"
#import "GGPSearchTableViewController.h"
#import "GGPSpinner.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static NSInteger kSearchResultMallsSectionIndex = 0;
static NSInteger kRecentMallsSectionIndex = 1;
static NSInteger kHeaderHeight = 30;

@interface GGPSearchTableViewController ()

@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSString *headerText;
@property (strong, nonatomic) NSArray *sections;

@end

@implementation GGPSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView.hidden = YES;
}

- (void)configureWithSearchResultMalls:(NSArray *)searchResults recentMalls:(NSArray *)recent andHeaderText:(NSString *)headerText {
    self.headerText = headerText;
    
    NSArray *searchResultsArray = searchResults ? [searchResults ggp_arrayWithFilter:^BOOL(GGPMall *mall) {
        return !mall.isDispositioned;
    }] : @[];
    NSArray *recentArray = recent.count > 0 ? recent : @[];
    
    self.sections = @[ searchResultsArray, recentArray ];
    self.tableView.backgroundView.hidden = searchResults.count > 0;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSArray *)getSectionArrayAtSectionIndex:(NSInteger)section {
    return self.sections[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getSectionArrayAtSectionIndex:section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self getSectionArrayAtSectionIndex:section].count ? kHeaderHeight : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == kSearchResultMallsSectionIndex ? self.headerText : [@"SELECT_MALL_HEADER_RECENT" ggp_toLocalized];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor ggp_gray];
    header.textLabel.font = [UIFont ggp_regularWithSize:15];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPSearchTableViewCellReuseIdentifier forIndexPath:indexPath];
    NSArray *malls = [self getSectionArrayAtSectionIndex:indexPath.section];
    BOOL isLastCell = malls.count - 1 == indexPath.row;
    GGPMall *mall = malls[indexPath.row];
    [cell configureCellWithMall:mall andIsLastCellInSection:isLastCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPMall *selectedMall = [self getSectionArrayAtSectionIndex:indexPath.section][indexPath.row];
    
    [self checkMallStatusForSelectedMallId:selectedMall.mallId];
    
    BOOL isRecentMall = indexPath.section == kRecentMallsSectionIndex;
    float distance = isRecentMall ? 0 : selectedMall.distance.floatValue;
    
    [self trackCoordinate:selectedMall.coordinates distance:distance andMallName:selectedMall.name];
}

#pragma mark - Mall Selected

- (void)checkMallStatusForSelectedMallId:(NSInteger)mallId {
    [GGPSpinner showForView:self.view];
    [GGPMallRepository fetchMallById:mallId onComplete:^(GGPMall *mall) {
        [GGPSpinner hideForView:self.view];
        [self checkMallStatus:mall];
    }];
}

- (void)checkMallStatus:(GGPMall *)mall {
    if (mall.isLegacy) {
        [self showUnavailableAlertForMall:mall];
    } else if (mall.isInactive) {
        [self showDispositioningAlertForMall:mall];
    } else if (mall) {
        [GGPMallManager shared].selectedMall = mall;
        if (self.onMallSelectionComplete) {
            self.onMallSelectionComplete();
        }
    }
}

- (void)showUnavailableAlertForMall:(GGPMall *)mall {
    NSString *title = [@"SELECT_MALL_UNAVAILABLE_TITLE" ggp_toLocalized];
    NSString *message = [NSString stringWithFormat:[@"SELECT_MALL_UNAVAILABLE_MESSAGE" ggp_toLocalized], mall.name];
    NSString *actionTitle = [@"SELECT_MALL_UNAVAILABLE_VISIT_WEBSITE" ggp_toLocalized];
    NSString *cancelTitle = [@"SELECT_MALL_UNAVAILABLE_CHANGE_MALL" ggp_toLocalized];
    [self ggp_displayAlertWithTitle:title message:message actionTitle:actionTitle actionCompletion:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mall.websiteUrl]];
    } cancelTitle:cancelTitle cancelCompletion:nil];
}

- (void)showDispositioningAlertForMall:(GGPMall *)mall {
    NSString *title = [@"SELECT_MALL_NEW_MANAGEMENT_TITLE" ggp_toLocalized];
    NSString *message = [@"SELECT_MALL_NEW_MANAGEMENT_DESCRIPTION" ggp_toLocalized];
    NSString *actionTitle = [@"SELECT_MALL_UNAVAILABLE_CHANGE_MALL" ggp_toLocalized];
    [self ggp_displayAlertWithTitle:title message:message actionTitle:actionTitle andCompletion:nil];
}

#pragma mark - Analytics

- (void)trackCoordinate:(CLLocationCoordinate2D)coordinate distance:(float)distance andMallName:(NSString *)mallName {
    NSMutableDictionary *contextData = [NSMutableDictionary dictionary];
    [contextData setObject:mallName forKey:GGPAnalyticsContextDataSelectedMallName];
    
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        NSString *coordinateDescription = [NSString stringWithFormat:@"%.1f:%.1f", coordinate.latitude, coordinate.longitude];
        [contextData setObject:coordinateDescription forKey:GGPAnalyticsContextDataSelectedMallCoordinates];
        
        if (distance > 0) {
            [contextData setObject:[NSString stringWithFormat:@"%.1f", distance] forKey:GGPAnalyticsContextDataSelectedMallDistance];
        }
    }
    
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionSelectedMall withData:contextData];
}

@end
