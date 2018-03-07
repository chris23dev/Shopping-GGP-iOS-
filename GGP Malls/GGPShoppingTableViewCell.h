//
//  GGPSalesTableCellTableViewCell.h
//  GGP Malls
//
//  Created by Janet Lin on 1/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPSale.h"

@interface GGPShoppingTableViewCell : UITableViewCell

extern NSString* const GGPShoppingTableViewCellReuseIdentifier;

- (void)configureCellWithSale:(GGPSale *)sale;

@end
