//
//  GGPViewCell.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/24/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GGPViewCellId;

@interface GGPViewCell : UITableViewCell

- (void)configureWithView:(UIView *)view;

@end
