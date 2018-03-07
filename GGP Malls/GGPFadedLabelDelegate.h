//
//  GGPFadedLabelDelegate.h
//  GGP Malls
//
//  Created by Janet Lin on 2/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGPFadedLabel;

@protocol GGPFadedLabelDelegate <NSObject>

- (void)fadedLabelTapped:(GGPFadedLabel *)label;

@end
