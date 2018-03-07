//
//  GGPFilterTableViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPFilterTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *filterItems;

- (void)configureWithFilterItems:(NSArray *)filterItems;
- (void)configureWithFilterItems:(NSArray *)filterItems hasDisclaimerSection:(BOOL)hasDisclaimerSection;

@end
