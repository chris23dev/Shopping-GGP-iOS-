//
//  GGPTenantTableCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/17/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import <UIKit/UIKit.h>

@class GGPTenant;

extern NSString* const GGPTenantTableCellReuseIdentifier;
extern CGFloat const GGPTenantTableCellHeight;

@interface GGPTenantTableCell : MGSwipeTableCell

- (void)configureCellWithTenant:(GGPTenant *)tenant;

@property (copy, nonatomic) void(^onGuideMeTapped)(GGPTenant *tenant);

@end
