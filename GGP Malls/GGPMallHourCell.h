//
//  GGPHolidayHoursCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GGPMallHourCellReuseIdentifier;

@interface GGPMallHourCell : UITableViewCell

- (void)configureWithHours:(NSArray *)hours date:(NSDate *)date isActive:(BOOL)isActive;

@end
