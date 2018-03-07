//
//  GGPMovieTimesCollectionDelegate.h
//  GGP Malls
//
//  Created by Janet Lin on 2/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGPShowtime.h"

@protocol GGPMovieTimesCollectionDelegate <NSObject>

- (void)selectedTime:(GGPShowtime *)time forMovieFandangoId:(NSInteger)fandangoId;

@end
