//
//  GGPTenantPromotionCell.h
//  GGP Malls
//
//  Created by Janet Lin on 1/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPSale.h"
#import "GGPPromotion.h"

extern NSString *const GGPTenantPromotionCellReuseIdentifier;
extern CGFloat const GGPTenantPromotionCellRowHeight;

@interface GGPTenantPromotionCell : UITableViewCell
- (void)configureCellWithPromotion:(GGPPromotion *)promo isFirstCell:(BOOL)isFirstCell;

@end
