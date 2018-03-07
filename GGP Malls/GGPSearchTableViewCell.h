//
//  GGPSearchTableViewCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPMall;

extern NSString *const GGPSearchTableViewCellReuseIdentifier;

@interface GGPSearchTableViewCell : UITableViewCell

- (void)configureCellWithMall:(GGPMall *)mall andIsLastCellInSection:(BOOL)isLastCell;

@end
