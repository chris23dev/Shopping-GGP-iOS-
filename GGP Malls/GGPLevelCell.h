//
//  GGPLevelCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

@class JMapFloor;
#import <UIKit/UIKit.h>

extern NSString *const GGPLevelCellReuseIdentifier;
extern CGFloat const GGPLevelCellHeight;
extern NSInteger const GGPLevelCellMaxStringLength;

@interface GGPLevelCell : UICollectionViewCell

- (void)configureCellWithFloor:(JMapFloor *)floor filterText:(NSString *)filterText isActive:(BOOL)isActive andIsBottomCell:(BOOL)isBottomCell;
+ (CGFloat)determineCellWidthForDescriptionLength:(NSInteger)length;

@end
