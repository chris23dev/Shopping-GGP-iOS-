//
//  GGPBrandSearchTableViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPBrandSearchDelegate.h"
#import <UIKit/UIKit.h>

@interface GGPBrandSearchTableViewController : UITableViewController <UISearchResultsUpdating>

@property (weak, nonatomic) id <GGPBrandSearchDelegate> searchDelegate;
- (void)configureWithBrandItems:(NSArray *)brands;

@end
