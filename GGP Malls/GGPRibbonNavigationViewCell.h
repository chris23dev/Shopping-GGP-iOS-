//
//  GGPRibbonNavigationViewCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GGPRibbonNavigationViewCellReuseIdentifier;
extern CGFloat const GGPRibbonNavigationViewCellHeight;

@interface GGPRibbonNavigationViewCell : UICollectionViewCell

- (void)configureWithTitle:(NSString *)title andIsSelected:(BOOL)isSelected;

@end
