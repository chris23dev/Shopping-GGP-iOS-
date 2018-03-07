//
//  GGPDirectoryViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/16/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPJMapViewControllerDelegate.h"
#import "GGPRibbonTabNavigationController.h"
#import <UIKit/UIKit.h>

@class GGPFilterItem;

@interface GGPDirectoryViewController : GGPRibbonTabNavigationController

@property (weak, nonatomic) id<GGPJMapViewControllerDelegate> mapViewControllerDelegate;

- (instancetype)initWithSelectedFilter:(GGPFilterItem *)selectedFilter;

@end
