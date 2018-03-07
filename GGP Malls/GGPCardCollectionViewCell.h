//
//  GGPCardCollectionViewCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPPromotion;
@class GGPTenant;

extern NSString *const GGPCardCollectionViewCellReuseIdentifier;
extern CGFloat const GGPCardCollectionViewCellHeight;

@interface GGPCardCollectionViewCell : UICollectionViewCell

@property (copy, nonatomic) void(^onWayfindingTapped)(GGPTenant *tenant);

- (void)configureWithPromotion:(GGPPromotion *)promotion;
- (void)configureWithTenant:(GGPTenant *)tenant;

@end
