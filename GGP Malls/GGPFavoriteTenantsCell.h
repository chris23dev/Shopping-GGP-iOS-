//
//  GGPFavoriteTenantsCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/7/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPTenant;

extern NSString *const GGPFavoriteTenantsCellReuseIdentifier;

@interface GGPFavoriteTenantsCell : UITableViewCell

- (void)configureWithTenant:(GGPTenant *)tenant;

@end
