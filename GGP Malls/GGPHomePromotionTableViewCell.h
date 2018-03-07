//
//  GGPHomePromotionTableViewCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/3/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPPromotionCellDelegate.h"
#import <UIKit/UIKit.h>

@class GGPPromotion;

extern NSString *const GGPHomePromotionTableViewCellReuseIdentifier;

@interface GGPHomePromotionTableViewCell : UITableViewCell

@property (weak, nonatomic) id<GGPPromotionCellDelegate> cellDelegate;

- (void)configureWithPromotion:(GGPPromotion *)promotion andImage:(UIImage *)image;

@end
