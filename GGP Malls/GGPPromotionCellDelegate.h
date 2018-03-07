//
//  GGPPromotionCellDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/17/16.
//  Copyright © 2016 GGP. All rights reserved.
//

@class GGPPromotion;

@protocol GGPPromotionCellDelegate <NSObject>

- (void)didTapPostOptionsWithPromotion:(GGPPromotion *)promotion;

@end
