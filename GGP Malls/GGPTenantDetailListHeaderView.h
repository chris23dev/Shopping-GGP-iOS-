//
//  GGPTenantDetailListHeaderView.h
//  GGP Malls
//
//  Created by Janet Lin on 1/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const GGPTenantDetailListHeaderViewId;
extern CGFloat const GGPTenantDetailListHeaderViewHeight;

@interface GGPTenantDetailListHeaderView : UITableViewHeaderFooterView

- (void)configureWithTitle:(NSString *)title;

@end
