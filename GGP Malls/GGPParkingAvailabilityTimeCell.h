//
//  GGPParkingAvailabilityTimeCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GGPCellData;

extern NSString *const GGPParkingAvailabilityTimeCellReuseIdentifier;
extern NSInteger const GGPParkingAvailabilityTimeCellHeight;

@interface GGPParkingAvailabilityTimeCell : UICollectionViewCell

- (void)configureWithTimeData:(GGPCellData *)timeData isLastCell:(BOOL)isLastCell isSelected:(BOOL)isSelected;

@end
