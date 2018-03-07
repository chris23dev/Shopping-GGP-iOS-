//
//  GGPHomeChooseFavoritesTableViewCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GGChooseFavoritesCellReuseIdentifier;

@interface GGPChooseFavoritesCell : UITableViewCell

@property (copy, nonatomic) void(^onChooseFavoritesTapped)();

- (void)configureWithTenants:(NSArray *)tenants;

@end
