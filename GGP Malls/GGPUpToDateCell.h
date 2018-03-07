//
//  GGPUpToDateCell.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GGPUpToDateCellId;

@interface GGPUpToDateCell : UITableViewCell

@property (copy, nonatomic) void(^onChooseFavoritesTapped)();

- (void)showChooseFavorites;
- (void)hideChooseFavorites;

@end
