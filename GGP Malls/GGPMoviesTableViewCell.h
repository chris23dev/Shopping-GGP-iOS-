//
//  GGPMovieTableViewCell.h
//  GGP Malls
//
//  Created by Janet Lin on 12/10/15.
//  Copyright (c) 2015 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPMallMovie;

extern NSString *const GGPMoviesCellReuseIdentifier;
extern CGFloat const GGPEstimatedMovieCellHeight;

@interface GGPMoviesTableViewCell : UITableViewCell

- (void)configureWithMallMovie:(GGPMallMovie *)mallMovie andSelectedDate:(NSDate *)selectedDate;

@end
