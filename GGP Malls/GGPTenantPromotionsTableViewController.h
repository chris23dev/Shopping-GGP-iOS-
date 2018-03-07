//
//  GGPTenantPromotionsTableViewControllerId.h
//  GGP Malls
//
//  Created by Janet Lin on 1/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPTenantPromotionsTableViewDelegate.h"

@interface GGPTenantPromotionsTableViewController : UITableViewController

@property (weak, nonatomic) id<GGPTenantPromotionsTableViewDelegate> tenantPromotionsDelegate;
- (void)configureWithSales:(NSArray *)sales andEvents:(NSArray *)events;

@end
