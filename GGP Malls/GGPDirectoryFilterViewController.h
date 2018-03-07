//
//  GGPDirectoryFilterViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 11/1/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFilterItem.h"
#import "GGPFilterSelectionDelegate.h"
#import <UIKit/UIKit.h>

@interface GGPDirectoryFilterViewController : UIViewController

- (instancetype)initWithFilterSelectionDelegate:(id<GGPFilterSelectionDelegate>)filterSelectionDelegate;

- (void)configureWithFilter:(id<GGPFilterItem>)filter;
- (void)clearStackView;

@end
