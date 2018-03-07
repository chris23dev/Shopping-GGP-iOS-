//
//  GGPShoppingRefineSortViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPRefineOptionsDelegate.h"
#import "GGPRefineSortType.h"
#import <UIKit/UIKit.h>

@interface GGPShoppingRefineSortViewController : UITableViewController

@property (weak, nonatomic) id<GGPRefineOptionsDelegate> refineDelegate;

- (instancetype)initWithRefineSortType:(GGPRefineSortType)sortType;

@end
