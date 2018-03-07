//
//  GGPParkingAvailabilityDateCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GGPParkingAvailabilityDateCellReuseIdentifier;
extern NSInteger const GGPParkingAvailabilityDateCellWidth;
extern NSInteger const GGPParkingAvailabilityDateCellHeight;

@interface GGPParkingAvailabilityDateCell : UICollectionViewCell

- (void)configureWithDate:(NSDate *)date isLastCell:(BOOL)isLastCell isSelected:(BOOL)isSelected;

@end
