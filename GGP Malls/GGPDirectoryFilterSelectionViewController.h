//
//  GGPDirectoryFilterSelectionViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 11/1/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFilterSelectionDelegate.h"
#import <UIKit/UIKit.h>

@interface GGPDirectoryFilterSelectionViewController : UIViewController

@property (weak, nonatomic) id <GGPFilterSelectionDelegate> filterSelectionDelegate;

- (void)configureWithFilterText:(NSString *)filterText;

@end
