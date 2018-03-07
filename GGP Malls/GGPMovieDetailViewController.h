//
//  GGPMovieDetailViewController.h
//  GGP Malls
//
//  Created by Janet Lin on 2/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GGPMallMovie;

@interface GGPMovieDetailViewController : UIViewController

- (instancetype)initWithMallMovie:(GGPMallMovie *)movie andSelectedDate:(NSDate *)selectedDate;

@end
