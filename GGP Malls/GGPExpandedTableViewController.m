//
//  GGPExpandedTableViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPExpandedTableViewController.h"
#import "GGPExpandedTableView.h"

@implementation GGPExpandedTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableView = [GGPExpandedTableView new];
    }
    return self;
}

@end
