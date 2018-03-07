//
//  GGPShoppingRefineActionCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/4/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GGPCellData;

extern NSString *const GGPShoppingRefineActionReusueIdentifier;

@interface GGPShoppingRefineActionCell : UITableViewCell

- (void)configureWithCellData:(GGPCellData *)cellData;
- (void)configureWithCellData:(GGPCellData *)cellData isClearAllCell:(BOOL)isClearAllCell;

@end
