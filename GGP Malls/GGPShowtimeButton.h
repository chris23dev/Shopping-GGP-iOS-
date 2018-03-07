//
//  GGPShowtimeButton.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPMovieTheater;
@class GGPShowtime;

@interface GGPShowtimeButton : UIButton

- (instancetype)initWithTheater:(GGPMovieTheater *)theater showtime:(GGPShowtime *)showtime andFandangoId:(NSInteger)fandangoId;

@end
