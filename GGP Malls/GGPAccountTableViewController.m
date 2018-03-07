//
//  GGPAccountTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccountItemTableViewCell.h"
#import "GGPAccountTableViewController.h"
#import "GGPCellData.h"

@interface GGPAccountTableViewController ()

@property (strong, nonatomic) NSArray *accountItems;

@end

@implementation GGPAccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNibs];
    self.tableView.scrollEnabled = NO;
}

- (void)registerNibs {
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPAccountItemTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:GGPAccountItemTableViewCellReuseIdentifier];
}

- (void)configureWithAccountItems:(NSArray *)accountItems {
    self.accountItems = accountItems;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accountItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GGPAccountItemTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPAccountItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPAccountItemTableViewCellReuseIdentifier forIndexPath:indexPath];
    GGPCellData *accountItem = self.accountItems[indexPath.row];
    [cell configureWithText:accountItem.title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPCellData *accountItem = self.accountItems[indexPath.row];
    if (accountItem.tapHandler) {
        accountItem.tapHandler();
    }
}

@end
