//
//  GGPRibbonNavigationViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPRibbonNavigationViewController : UICollectionViewController

@property (assign, nonatomic) UIEdgeInsets sectionInset;

- (void)configureWithRibbonItems:(NSArray *)ribbonItems;

@end
