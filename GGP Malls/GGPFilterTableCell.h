//
//  GGPFilterTableCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/22/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPFilterItem.h"
#import <UIKit/UIKit.h>
@class GGPFilterTableCellData;

extern NSString *const GGPFilterCellReuseIdentifier;

@interface GGPFilterTableCell : UITableViewCell

- (void)configureWithCellData:(GGPFilterTableCellData *)cellData;

@end
