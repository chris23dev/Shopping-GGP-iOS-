//
//  UIImage+GGPAdditions.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/21/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPPromotion;

@interface UIImage (GGPAdditions)

+ (UIImage *)ggp_imageFromColor:(UIColor *)color;
+ (UIImage *)ggp_imageForJmapMoverType:(NSString *)moverType;
+ (UIImage *)ggp_imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (void)ggp_fetchImageWithUrl:(NSURL *)url completion:(void(^)(UIImage *image))completion;
+ (void)ggp_fetchImagesForPromotions:(NSArray<GGPPromotion *> *)promotions intoLookup:(NSMutableDictionary *)lookup completion:(void(^)())completion;
+ (UIImage *)ggp_drawImage:(UIImage *)fgImage inImage:(UIImage *)bgImage atPoint:(CGPoint)point;

@end
