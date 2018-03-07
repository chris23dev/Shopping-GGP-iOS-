//
//  GGPShoppingRefineHeaderCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/4/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPCellData;

extern NSString *const GGPShoppingRefineHeaderReusueIdentifier;

@interface GGPShoppingRefineHeaderCell : UITableViewCell

- (void)configureWithTitle:(NSString *)title;

@end
