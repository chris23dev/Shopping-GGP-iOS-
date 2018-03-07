//
//  GGPWayfindingRouteDetailTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenant.h"
#import "GGPWayfindingRouteDetailHeaderFooterView.h"
#import "GGPWayfindingRouteDetailTableViewCell.h"
#import "GGPWayfindingRouteDetailTableViewController.h"
#import "UIColor+GGPAdditions.h"
#import <JMap/JMap.h>

@interface GGPWayfindingRouteDetailTableViewController ()

@property (strong, nonatomic) GGPWayfindingRouteDetailHeaderFooterView *headerView;
@property (strong, nonatomic) GGPWayfindingRouteDetailHeaderFooterView *footerView;
@property (strong, nonatomic) NSArray *directionsList;
@property (strong, nonatomic) GGPTenant *fromTenant;
@property (strong, nonatomic) GGPTenant *toTenant;

@end

@implementation GGPWayfindingRouteDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNibs];
}

- (void)configureWithDirections:(NSArray *)directions fromTenant:(GGPTenant *)fromTenant toTenant:(GGPTenant *)toTenant {
    self.directionsList = directions;
    self.fromTenant = fromTenant;
    self.toTenant = toTenant;
    [self configureHeaderFooterViews];
    [self.tableView reloadData];
}

- (void)registerNibs {
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPWayfindingRouteDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:GGPWayfindingRouteDetailTableViewCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPWayfindingRouteDetailHeaderFooterView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:GGPWayfindingRouteDetailHeaderFooterViewReuseIdentifier];
}

- (void)configureHeaderFooterViews {
    self.headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:GGPWayfindingRouteDetailHeaderFooterViewReuseIdentifier];
    [self.headerView configureWithTenant:self.fromTenant isFooterView:NO];
    self.tableView.tableHeaderView = self.headerView;
    
    self.footerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:GGPWayfindingRouteDetailHeaderFooterViewReuseIdentifier];
    [self.footerView configureWithTenant:self.toTenant isFooterView:YES];
    self.tableView.tableFooterView = self.footerView;
}

- (UIView *)createSeparatorView {
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor clearColor];
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.tableView.frame.size.width - 15, 0.5f)];
    separator.backgroundColor = [UIColor ggp_divider];
    [backgroundView addSubview:separator];
    return backgroundView;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.directionsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self createSeparatorView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self createSeparatorView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GGPWayfindingRouteDetailTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPWayfindingRouteDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPWayfindingRouteDetailTableViewCellReuseIdentifier forIndexPath:indexPath];
    JMapTextDirectionInstruction *directionInstruction = self.directionsList[indexPath.row];
    [cell configureCellWithDirectionInstruction:directionInstruction];
    return cell;
}

@end
