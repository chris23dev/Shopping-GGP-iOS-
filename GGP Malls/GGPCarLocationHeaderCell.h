//
//  GGPCarLocationHeaderCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GGPCarLocationHeaderCellId;

@interface GGPCarLocationHeaderCell : UITableViewCell

- (void)configureWithSearchText:(NSString *)searchText andResultCount:(NSInteger)resultCount;

@end
