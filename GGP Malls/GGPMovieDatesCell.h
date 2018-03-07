//
//  GGPMovieDatesCell.h
//  GGP Malls
//
//  Created by Janet Lin on 2/3/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const GGPMovieDatesCellWidth;
extern CGFloat const GGPMovieDatesCellHeight;
extern NSString *const GGPMovieDatesCellReuseIdentifier;

@interface GGPMovieDatesCell : UICollectionViewCell

- (void)configureWithDate:(NSDate *)date isActive:(BOOL)isActive;

@end
