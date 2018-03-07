//
//  GGPShoppingTableHeaderCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GGPShoppingTableHeaderCellReuseIdentifier;

@interface GGPShoppingTableHeaderCell : UITableViewCell

- (void)configureWithCategoryName:(NSString *)name tenantCount:(NSInteger)tenantCount andCount:(NSInteger)count;

@end
