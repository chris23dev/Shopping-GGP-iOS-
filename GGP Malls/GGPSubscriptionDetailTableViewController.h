//
//  GGPSubscriptionDetailTableViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPSubscriptionDetailTableViewDelegate.h"
#import <UIKit/UIKit.h>

@interface GGPSubscriptionDetailTableViewController : UITableViewController

@property (weak, nonatomic) id<GGPSubscriptionDetailTableViewDelegate> tableViewDelegate;

- (void)configureWithMalls:(NSArray *)malls;

@end
