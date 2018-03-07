//
//  GGPMoreTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMoreTableViewController.h"
#import "GGPCellData.h"
#import "GGPMoreTableViewCell.h"

@interface GGPMoreTableViewController ()

@property (strong, nonatomic) NSArray *tableItems;

@end

@implementation GGPMoreTableViewController

- (void)configureWithTableItems:(NSArray *)tableItems {
    self.tableItems = tableItems;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCells];
    [self configureTableView];
}

- (void)registerCells {
    [self.tableView registerClass:GGPMoreTableViewCell.class forCellReuseIdentifier:GGPMoreTableViewCellReuseIdentifier];
}

- (void)configureTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1/[UIScreen mainScreen].scale)];
    line.backgroundColor = self.tableView.separatorColor;
    self.tableView.tableHeaderView = line;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPMoreTableViewCellReuseIdentifier];
    
    GGPCellData *cellData = self.tableItems[indexPath.row];
    
    [cell configureWithTitle:cellData.title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPCellData *cellData = self.tableItems[indexPath.row];
    if (cellData.tapHandler) {
        cellData.tapHandler();
    }
}

@end
