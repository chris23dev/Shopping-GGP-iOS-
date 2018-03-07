//
//  ShoppingTableViewController.h
//  GGP Malls
//
//  Created by Janet Lin on 1/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPCategory;

@interface GGPShoppingTableViewController : UITableViewController

- (instancetype)initWithCategory:(GGPCategory *)category;

@end
