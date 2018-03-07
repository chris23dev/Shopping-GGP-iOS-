//
//  GGPShoppingRefineViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/4/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPRefineFilterDelegate.h"
#import <UIKit/UIKit.h>
@class GGPRefineOptions;

@interface GGPShoppingRefineViewController : UITableViewController

@property (weak, nonatomic) id<GGPRefineFilterDelegate> refineFilterDelegate;

- (instancetype)initWithSales:(NSArray *)sales;
- (void)configureWithRefineOptions:(GGPRefineOptions *)refineOptions;

@end
