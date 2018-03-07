//
//  GGPShowtimeStackView.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPMallMovie;

@interface GGPShowtimeStackView : UIStackView

- (void)configureWithMallMovie:(GGPMallMovie *)mallMovie andSelectedDate:(NSDate *)selectedDate;

@end
