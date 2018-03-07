//
//  GGPTenantDetailRibbonCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

@class GGPTenantDetailRibbonCellData;
#import <UIKit/UIKit.h>

extern NSString *const GGPTenantDetailRibbonCellReuseIdentifier;
extern CGFloat const GGPTenantDetailRibbonCellHeight;

@interface GGPTenantDetailRibbonCell : UICollectionViewCell

- (void)configureCellWithCellData:(GGPTenantDetailRibbonCellData *)cellData isLastCell:(BOOL)isLastCell;

@end
