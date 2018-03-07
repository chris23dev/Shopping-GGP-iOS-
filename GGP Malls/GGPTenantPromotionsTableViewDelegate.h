//
//  GGPTenantPromotionsTableViewDelegate.h
//  GGP Malls
//
//  Created by Janet Lin on 1/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGPPromotion.h"

@protocol GGPTenantPromotionsTableViewDelegate <NSObject>

- (void)selectedPromotion:(GGPPromotion *)promotion;

@end
