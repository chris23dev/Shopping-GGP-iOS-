//
//  GGPLevelSelectorCollectionViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPLevelSelectorDelegate.h"
#import <UIKit/UIKit.h>

@class JMapFloor;

@interface GGPLevelSelectorCollectionViewController : UICollectionViewController

@property (strong, nonatomic) id<GGPLevelSelectorDelegate> levelSelectorDelegate;
@property (readonly, nonatomic) CGFloat cellWidth;

- (instancetype)initWithFloors:(NSArray *)mallFloors selectedIndex:(NSInteger)selectedIndex;
- (void)updateWithFloors:(NSArray *)mallFloors selectedIndex:(NSInteger)selectedIndex;
- (void)updateWithSelectedFloor:(JMapFloor *)floor;

@end
