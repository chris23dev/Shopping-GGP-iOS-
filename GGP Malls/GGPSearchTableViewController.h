//
//  GGPSearchTableViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPSearchTableViewController : UITableViewController

@property (copy, nonatomic) void(^onMallSelectionComplete)();

- (void)configureWithSearchResultMalls:(NSArray *)searchResult recentMalls:(NSArray *)recent andHeaderText:(NSString *)headerText;

@end
