//
//  GGPShoppingRefineSortByCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GGPCellData;

extern NSString *const GGPShoppingRefineCellReuseIdentifier;

@interface GGPShoppingRefineCell : UITableViewCell

- (void)configureWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle;

@end
