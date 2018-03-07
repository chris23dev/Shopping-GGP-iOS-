//
//  GGPFadedLabel.h
//  GGP Malls
//
//  Created by Janet Lin on 2/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPFadedLabelDelegate.h"

@interface GGPFadedLabel : UILabel

@property id<GGPFadedLabelDelegate> labelDelegate;

- (void)addWhiteFadeAtBottomYOffset:(NSInteger)bottomOffset;

@end
