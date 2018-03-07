//
//  GGPShoppingRefineTenantSortHeaderCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GGPCellData;

extern NSString *const GGPShoppingRefineTenantSortHeaderCellReuseIdentifier;

@interface GGPShoppingRefineTenantSortHeaderCell : UITableViewCell

- (void)configureWithCellData:(GGPCellData *)cellData;

@end
