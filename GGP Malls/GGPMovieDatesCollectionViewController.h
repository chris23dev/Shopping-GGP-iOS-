//
//  GGPMovieDatesCollectionViewController.h
//  GGP Malls
//
//  Created by Janet Lin on 2/3/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPMovieDatesCollectionDelegate.h"

@interface GGPMovieDatesCollectionViewController : UICollectionViewController

@property id<GGPMovieDatesCollectionDelegate> dateCollectionDelegate;

- (instancetype)initWithShowtimeDates:(NSArray *)showtimeDates andSelectedDate:(NSDate *)selectedDate;

@end
