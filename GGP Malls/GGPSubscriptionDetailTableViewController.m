//
//  GGPSubscriptionDetailTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPSubscriptionDetailTableViewCell.h"
#import "GGPSubscriptionDetailTableViewController.h"

@interface GGPSubscriptionDetailTableViewController ()

@property (strong, nonatomic) NSArray *malls;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation GGPSubscriptionDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)configureTableView {
    [self registerCell];
    self.selectedIndex = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)registerCell {
    [self.tableView registerClass:[GGPSubscriptionDetailTableViewCell class] forCellReuseIdentifier:GGPSubscriptionDetailTableViewCellReuseIdentifier];
}

- (void)configureWithMalls:(NSArray *)malls {
    self.malls = malls;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.malls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPSubscriptionDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPSubscriptionDetailTableViewCellReuseIdentifier forIndexPath:indexPath];
    GGPMall *mall = self.malls[indexPath.row];
    [cell configureWithMall:mall];
    return cell;
}

- (NSString *)userMallIdStringFromRowIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"mallId%@", @(index + 1).stringValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    if (self.selectedIndex != indexPath.row) {
        GGPMall *tappedMall = self.malls[indexPath.row];
        [self.tableViewDelegate cellTappedWithPreferredMall:tappedMall forUserMallId:[self userMallIdStringFromRowIndex:indexPath.row]];
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
        [tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
        self.selectedIndex = indexPath.row;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.selectedIndex) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

@end
