//
//  GGPOnboardingSearchTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/2/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPOnboardingSearchTableViewController.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

@interface GGPOnboardingSearchTableViewController ()

@end

@implementation GGPOnboardingSearchTableViewController

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.tintColor = [UIColor blackColor];
    header.textLabel.textColor = [UIColor ggp_timberWolfGray];
    header.textLabel.font = [UIFont ggp_boldWithSize:19];
}

@end
